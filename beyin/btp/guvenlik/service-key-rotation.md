---
tur: tarif
alan: btp
kategori: guvenlik
urun_surumu: ""
tarih: 2026-10-26
guven: resmi
gozden_gecir: 2027-04-26
---

# BTP service key rotasyonu: overlap-switch-retire deseni

## Use case
BTP'de bir service instance'a (XSUAA, Destination, Object Store, AI Core vb.) dışarıdan (local dev makine, CI pipeline, n8n gibi low-code araç) bağlanmak için üretilen service key'leri, tüketicilerde downtime yaratmadan ve sızıntı riskini sınırlı tutacak şekilde periyodik olarak rotate etmek.

## Varyantlar

### Cloud Foundry (cf CLI) ile overlap-switch-retire
Adımlar:
1. Mevcut key'leri envanterle: `cf service-keys my-xsuaa`
2. Yeni key'i versiyonlu/tarihli isimle oluştur ve credential'ları API üzerinden oku (formatlanmış CLI çıktısından daha güvenilir):
```bash
NEW_KEY="n8n-prod-$(date +%Y-%m)"
cf create-service-key my-xsuaa "$NEW_KEY"

GUID=$(cf service-key my-xsuaa "$NEW_KEY" --guid)
cf curl "/v3/service_credential_bindings/$GUID/details" | jq '.credentials'
```
3. Yeni credential'ları secret store'a veya CI secret'ına dağıt (bkz. aşağıdaki "Nereye yazılmalı" notu).
4. Tüketicileri yeni key'e geçir: redeploy et, restart et veya secret'ı yeniden okumasını sağla. App ise rolling restart ile downtime'sız geçiş:
```bash
cf restart my-app --strategy rolling
```
5. Yeni key'in token aldığını ve hata oranının artmadığını doğrula.
6. Bir grace period bekle (ör. 14 gün) — yavaş tüketiciler (gece job'ları, bir meslektaşın laptop'ı) bu sürede sessizce değil, gürültülü şekilde hata vermeye başlar.
7. Eski key'i sil — sızıntıyı gerçekten kapatan adım budur:
```bash
cf delete-service-key my-xsuaa n8n-prod-2026-09 -f
```

X.509 credential type ile key oluşturma (kısa ömürlü, mTLS):
```bash
cf create-service-key my-xsuaa key-x509 -c '{
  "credential-type": "x509",
  "x509": { "key-length": 2048, "validity": 7, "validity-type": "DAYS" }
}'
```
Desteklenen parametreler servise göre değişir, SAP Help Portal'daki ilgili servis dokümanı kontrol edilmeli.

Ne zaman seçilir: Cloud Foundry ortamında, service key veya service binding ile dış sistemlere bağlanan bir instance rotate edilecekse. ([[kaynaklar/2026-10-26-btp-service-key-rotation]])

### btp CLI / Service Manager ile (Kyma ve diğer non-CF ortamlar)
Adımlar:
1. Kyma'da key'ler "binding" olarak adlandırılır ve Service Manager üzerinden yönetilir.
2. Mevcut binding'leri listele:
```bash
btp list services/binding
```
3. Yeni binding oluştur:
```bash
btp create services/binding --name ci-2026-10 --service-instance my-xsuaa
```
4. Tüketicileri yeni binding'e geçir, doğrula, grace period bekle.
5. Eski binding'i sil:
```bash
btp delete services/binding --name ci-2026-09 --confirm
```
6. Kyma'da eşdeğeri: yeni bir ServiceBinding kaynağı oluşturup workload'ı yeni Kubernetes secret'a yönlendirmek, aynı overlap deseniyle çalışır.

Ne zaman seçilir: Kyma ortamında veya Service Manager üzerinden yönetilen binding'ler rotate edilecekse. CLI flag'leri versiyon arası değişebilir, scriptlemeden önce `btp help` ile doğrulanmalı. ([[kaynaklar/2026-10-26-btp-service-key-rotation]])

### Otomasyon scripti (planlı job)
Manuel rotasyon bir kez işe yarar; planlı bir job her seferinde işe yarar. Script yeni key oluşturur, secret store'a iletir (placeholder), grace period'u geçen prefix'li eski key'leri siler. Doğrudan production'a sürülecek bir ürün değildir — secret store çağrısı adapte edilmeli ve önce production-dışı bir instance'ta test edilmelidir:
```bash
#!/usr/bin/env bash
set -euo pipefail

INSTANCE="$1"            # service instance adı
PREFIX="$2"              # key adı prefix'i, ör. n8n-prod
GRACE_DAYS="${3:-14}"    # eski key'lerin ne kadar yaşayacağı

NEW_KEY="${PREFIX}-$(date +%Y%m%d)"
cf create-service-key "$INSTANCE" "$NEW_KEY"

GUID=$(cf service-key "$INSTANCE" "$NEW_KEY" --guid)
CREDS=$(cf curl "/v3/service_credential_bindings/$GUID/details" | jq -c '.credentials')

# 1. Secret store'a yaz (CREDS'i asla echo/log etme)
#    ör. vault kv put secret/btp/$PREFIX value="$CREDS"

# 2. Bu prefix'e ait, grace period'u geçmiş eski key'leri sil
INST_GUID=$(cf service "$INSTANCE" --guid)
CUTOFF=$(date -u -d "-${GRACE_DAYS} days" +%Y-%m-%dT%H:%M:%SZ)

cf curl "/v3/service_credential_bindings?type=key&service_instance_guids=${INST_GUID}" \
  | jq -r --arg p "$PREFIX" --arg c "$CUTOFF" --arg n "$NEW_KEY" \
    '.resources[] | select((.name|startswith($p)) and .name != $n and .created_at < $c) | .name' \
  | while read -r OLD; do
      echo "Deleting expired key: $OLD"
      cf delete-service-key "$INSTANCE" "$OLD" -f
    done
```
Yeni credential'ların yazılması gereken yerler: dedike bir secret manager (HashiCorp Vault, Azure Key Vault, AWS Secrets Manager, SAP Credential Store), veya CI/CD secret'ları (GitHub Actions, GitLab CI, Jenkins credentials — API üzerinden güncellenir). Git'e, image'a veya chat'e asla yazılmamalı, düz environment variable olarak container image'a gömülmemeli.

Job'ı periyodik çalıştır (ör. 60-90 günde bir), grace period'u bu aralıktan kısa tut, rotasyon hata verirse alarm kur — sessiz bir başarısızlık, otomasyon olmamasından daha kötüdür çünkü sorunun çözülmüş olduğu yanlış izlenimini yaratır. Uzun vadede en temiz çözüm paylaşılan secret'ı tamamen kaldırmaktır: servis destekliyorsa kısa ömürlü X.509 veya CI sağlayıcısı ile BTP arasında OIDC trust (identity federasyonu) tercih edilmeli.

Ne zaman seçilir: Rotasyonun insan hatırlamasına bağlı kalmaması, düzenli ve denetlenebilir olması gerektiğinde. ([[kaynaklar/2026-10-26-btp-service-key-rotation]])

## Tuzaklar
- Switch'ten önce silme: eski key'i, yeni key'in production'da çalıştığı görülmeden silmek doğrudan outage'a yol açar.
- Unutulmuş tüketiciler: cron job'lar, notebook'lar, bir meslektaşın local `default-env.json`'ı — grace period olmadan silme bunları sessizce kırar.
- Tek key'i birden fazla tüketicinin paylaşması: rotasyonu koordineli bir "big-bang" değişikliğe çevirir ve kimin hangi key'i kullandığını gizler. Tüketici başına ayrı key verilmeli.
- Cache'lenmiş token/client: secret'ı sadece başlangıçta okuyan uygulamalar, yeni değeri almak için restart veya reload mekanizması gerektirir.
- Key'i rotate edip etrafındaki erişimi (scope) değiştirmemek: aynı geniş scope'lu yeni key sadece sızıntı süresini kısaltır, riski ortadan kaldırmaz — least-privilege scope ve role collection ile birleştirilmeli.
- İzleme eksikliği: her rotasyondan sonra audit log ve kimlik doğrulama hataları kontrol edilmeli; SAP Audit Log service, service instance üzerindeki yönetim operasyonlarını kaydeder.
- Service key hiçbir zaman kendiliğinden süresi dolmaz (X.509 validity seçilmediyse); bu yüzden rotasyon olmadan geçen her gün sızıntı riskini artırır, ama bu durum fark edilmez.

## Cevapladığı sorular
- BTP'de service key rotation sırasında downtime olmadan tüketicileri nasıl değiştirilir?

## İlgili
- ([[btp/guvenlik/cap-xsuaa-role-collection-kurulum|CAP servisine XSUAA ile rol bazlı güvenlik ve role collection kurulumu]])
