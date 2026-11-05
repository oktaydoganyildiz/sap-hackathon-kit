---
tur: tarif
alan: btp
kategori: guvenlik
urun_surumu: ""
tarih: 2026-10-26
guven: resmi
gozden_gecir: 2027-04-26
---

# BTP Role Collection → IAS Group Mapping'i REST API ile Otomatikleştirme

## Use case
BTP subaccount'ta çok sayıda role collection'ı IAS (Identity Authentication Service) user group'larına tek tek cockpit üzerinden (Security → Trust Configuration → Role Collection Mappings) elle maplemek yerine, SAP Authorization and Trust Management Service (XSUAA) REST API'si ile bu işlemi scriptleştirip toplu/çoklu ortamda otomatikleştirmek.

## Varyantlar

### BTP CLI credential + XSUAA REST API + Node.js toplu script
Adımlar:
1. **BTP CLI ile API credential al** (service instance/service key gerekmez, deprecated `apiaccess` XSUAA plan'ının yerini alan güncel yöntem):
```bash
btp login --sso
btp target --subaccount <SUBACCOUNT_ID>
btp create security/api-credential --name my-credential
```
Dönen JSON'dan şu 4 değeri sakla: `clientid`, `clientsecret`, `url` (token endpoint), `apiurl` (API base URL).

2. **OAuth token al** (client credentials flow):
```bash
curl --request POST \
  --url <url> \
  --header 'accept: application/json' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data 'client_id=<clientid>' \
  --data 'client_secret=<clientsecret>' \
  --data 'grant_type=client_credentials' \
  --data 'response_type=token'
```
`access_token` değerini sonraki isteklerde Bearer token olarak kullan.

3. **Mevcut mapping'leri kontrol et (opsiyonel, önerilir)**. IAS Origin Key, BTP cockpit → Security → Trust Configuration → IAS trust detayında görünür (`<something>.accounts.ondemand.com` formatında):
```bash
curl --request GET \
  --url <apiurl>/sap/rest/authorization/v2/identity-providers/<IAS_ORIGIN_KEY>/attributes \
  --header 'accept: application/json' \
  --header 'authorization: Bearer <access_token>'
```

4. **Tek bir mapping oluştur** (toplu script'ten önce doğrulama için):
```bash
curl --request POST \
  --url <apiurl>/sap/rest/authorization/v2/identity-providers/<IAS_ORIGIN_KEY>/attributes \
  --header 'accept: application/json' \
  --header 'authorization: Bearer <access_token>' \
  --header 'content-type: application/json' \
  --data '{
    "attributeName": "Groups",
    "attributeValue": "<IAS_Group_Name>",
    "operator": "equals",
    "roleCollectionName": "<BTP_Role_Collection_Name>"
  }'
```
Başarılı çağrı HTTP 201 döner. Doğrulama: BTP Cockpit → Security → Role Collections → ilgili collection → User Groups sekmesinde IAS grubu görünmeli.

5. **Node.js ile toplu otomasyon**. Proje yapısı: `.env` (credential'lar), `mappings.json` (grup↔role collection listesi), `map-roles.mjs` (script).

`.env`:
```
TOKEN_URL=https://<subdomain>.authentication.<region>.hana.ondemand.com/oauth/token
CLIENT_ID=<your-client-id>
CLIENT_SECRET=<your-client-secret>
API_URL=https://api.authentication.<region>.hana.ondemand.com
IAS_ORIGIN_KEY=<your-ias-origin-key>
```

`mappings.json`:
```json
[
  { "iasGroup": "BTP_ADMINS",     "roleCollection": "Subaccount Administrator" },
  { "iasGroup": "BTP_DEVELOPERS", "roleCollection": "Extension Developer" },
  { "iasGroup": "CPI_OPERATORS",  "roleCollection": "PI Business Expert" }
]
```

`map-roles.mjs`:
```js
import { readFileSync } from 'fs';
import 'dotenv/config';

const { TOKEN_URL, CLIENT_ID, CLIENT_SECRET, API_URL, IAS_ORIGIN_KEY } = process.env;

async function getToken() {
  const params = new URLSearchParams({
    grant_type: 'client_credentials',
    response_type: 'token',
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET
  });
  const res = await fetch(TOKEN_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params
  });
  const { access_token } = await res.json();
  return access_token;
}

async function mapRoleCollection(token, iasGroup, roleCollection) {
  const url = `${API_URL}/sap/rest/authorization/v2/identity-providers/${IAS_ORIGIN_KEY}/attributes`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
      Accept: 'application/json'
    },
    body: JSON.stringify({
      attributeName: 'Groups',
      attributeValue: iasGroup,
      operator: 'equals',
      roleCollectionName: roleCollection
    })
  });

  if (res.status === 409) { console.log(`Already mapped: "${iasGroup}" → "${roleCollection}"`); return; }
  if (res.status === 404) { console.error(`Not found (check name): "${iasGroup}" → "${roleCollection}"`); return; }
  if (!res.ok) { console.error(`Failed (${res.status}): "${iasGroup}" → "${roleCollection}"`); return; }
  console.log(`Mapped: "${iasGroup}" → "${roleCollection}"`);
}

const mappings = JSON.parse(readFileSync('./mappings.json', 'utf-8'));
const token = await getToken();

for (const { iasGroup, roleCollection } of mappings) {
  await mapRoleCollection(token, iasGroup, roleCollection);
}
```

Çalıştır:
```bash
npm install dotenv
node map-roles.mjs
```
Her satır için başarı / zaten-var (409) / bulunamadı (404) / diğer hata net şekilde loglanır.

6. **Çoklu ortam (dev/QA/prod) için tekrar kullanım**: Her subaccount için CLI target'ı değiştirip yeni credential üret, `.env`'i güncelle, script'i tekrar çalıştır:
```bash
btp target --subaccount <DEV_ID>
btp create security/api-credential --name my-credential
# .env güncelle, sonra:
node map-roles.mjs

btp target --subaccount <QA_ID>
btp create security/api-credential --name my-credential
# .env güncelle, sonra:
node map-roles.mjs
```

Ne zaman seçilir: Onlarca/yüzlerce role collection → IAS group mapping'i tek tek cockpit'te yapmak yerine, tekrarlanabilir, auditable ve çoklu ortamda (dev/QA/prod) tutarlı şekilde kurmak gerektiğinde. Birkaç mapping için cockpit elle yeterli olabilir; proje ölçeği büyüdükçe bu yöntem zaman kazandırır. ([[kaynaklar/2026-10-26-role-collection-ias-mapping-rest-api-automation]])

## Tuzaklar
- **attributeName case-sensitive**: Alan tam olarak `"Groups"` (büyük G) olmalı; yanlış yazılırsa istek anlamlı bir hata mesajı vermeden başarısız olur — ilk kontrol edilmesi gereken şey budur.
- **apiaccess planı deprecated**: Eski tutorial'larda görülen `cf create-service xsuaa apiaccess` hâlâ çalışıyor olsa da kullanımdan kaldırılıyor; güncel yöntem `btp create security/api-credential` komutudur (service instance/service key gerektirmez).
- **attributeValue grup adı, grup ID değil**: IAS tarafında grup adı tam olarak eşleşmeli.
- **roleCollectionName tam eşleşmeli**: BTP cockpit'teki role collection adıyla birebir aynı olmalı, yoksa 404 dönebilir.
- **IAS Origin Key'i doğru bulmak gerekir**: BTP cockpit → Security → Trust Configuration → IAS trust detay panelinde görünür (`<something>.accounts.ondemand.com` formatında); yanlış origin key tüm çağrıların başarısız olmasına yol açar.
- **Credential'lar koda/versiyon kontrolüne commit edilmemeli**: `.env` dosyası `.gitignore`'a eklenmeli, client secret paylaşılmamalı.
- **409/404 ayrımı script'te ele alınmalı**: 409 (zaten eşleşmiş) hata değildir, script bunu başarı gibi loglamalı; 404 ise isim hatasına işaret eder ve araştırılmalı.

## Cevapladığı sorular
- BTP'de role collection mapping'i REST API ile nasıl otomatikleştirilir?
- BTP CLI ile XSUAA REST API için credential nasıl alınır (apiaccess planı yerine)?
- Role collection'ı IAS user group'una REST API ile nasıl maplenir?
- attributeName alanında hangi case-sensitivity tuzağına dikkat edilmeli?
- Çoklu BTP subaccount (dev/QA/prod) için role collection mapping script'i nasıl tekrar kullanılır?

## İlgili
- ([[btp/guvenlik/cap-xsuaa-role-collection-kurulum|CAP servisine XSUAA ile rol bazlı güvenlik ve role collection kurulumu]])
- ([[btp/guvenlik/mcp-server-application-router-xsuaa|BTP'de MCP Server/AI Uygulamasını Application Router + XSUAA ile Güvenli Hale Getirme]])
