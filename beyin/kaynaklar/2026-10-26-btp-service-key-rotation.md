---
tur: kaynak
alan: btp
tarih: 2026-10-26
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/the-hidden-security-habit-every-sap-btp-admin-must-master-service-key/ba-p/14510539
gozden_gecir: 2027-04-26
---

# The Hidden Security Habit Every SAP BTP Admin Must Master: Service Key Rotation

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/the-hidden-security-habit-every-sap-btp-admin-must-master-service-key/ba-p/14510539

Yazı türü: tarif

## Özet
- Service key, BTP dışından (local makine, CI pipeline, n8n gibi low-code araç) bir service instance'a (XSUAA, Destination, Object Store, AI Core vb.) erişmek için üretilen client ID + secret veya sertifikadır; hiç süresi dolmaz ve sahibi genelde belirsizleşir.
- Credential type seçimi rotasyon zorluğunu belirler: client secret (varsayılan, kolay sızar), X.509 sertifika (validity ile otomatik sona erer, mTLS), instance secret (tek secret, geniş blast radius).
- Zero-downtime rotasyon deseni: overlap → switch → retire. Eski key silinmeden önce yeni key'in tüm tüketicilerde çalıştığı doğrulanmalı; bir grace period sonrası eski key silinir.
- `cf` CLI (Cloud Foundry) ve `btp` CLI / Service Manager (Kyma, ServiceBinding) üzerinden adım adım key oluşturma, credential okuma (`cf curl .../details`), eski key silme komutları veriliyor.
- Hazır bir bash otomasyon scripti: yeni key oluşturur, secret store'a gönderir (placeholder), grace period'u geçen eski key'leri prefix bazlı siler.
- Tuzaklar: switch'ten önce silme, unutulmuş tüketiciler (cron, notebook, local default-env.json), tek key'i birden fazla tüketicinin paylaşması, cache'lenmiş token/client'ların restart gerektirmesi, geniş scope'lu key'in rotasyonla gerçek riski azaltmaması, izlemenin olmaması.
- Checklist: her key'in sahibi/amaç/tarih içeren adı olmalı, tüketici başına tek key, otomatik rotasyon aralığı (ör. 90 gün), secret manager kullanımı, sabit grace period sonrası silme, rotasyon job hatasında alarm, mümkünse kısa ömürlü X.509 veya OIDC federasyonu.

## Beslediği sayfalar
- [[btp/guvenlik/service-key-rotation]]
