---
tur: tarif
alan: btp
kategori: guvenlik
urun_surumu: ""
tarih: 2026-10-26
guven: topluluk
gozden_gecir: 2027-04-26
---

# BTP'de MCP Server/AI Uygulamasını Application Router + XSUAA ile Güvenli Hale Getirme

## Use case
SAP S/4HANA verisini bir MCP server üzerinden AI client'lara (veya bir UI'a) açan BTP, Cloud Foundry uygulamasını kurumsal SSO ile kimlik doğrulamaya ve role-based scope kontrolüyle yetkilendirmeye tabi tutmak. Hedef: yalnız geçerli kurumsal kimliği olan kullanıcıların erişmesi, her kullanıcının yalnız kendine atanmış fonksiyonlara ulaşması ve yetkilendirme kararının sunucuda (tarayıcıda değil) verilmesi.

## Varyantlar

### Application Router + XSUAA ile SSO ve Role-Based Access
Adımlar:
1. **xs-security.json tanımla** — scope, role-template ve role-collection üçlü modelini kur. Scope = uygulamanın kontrol ettiği tek izin; role-template = scope'ları gruplayan fonksiyonel rol (geliştirici tanımlar); role-collection = kullanıcıya/gruba atanan paket (yönetici BTP cockpit'te atar). Örnek:
```json
{
  "xsappname": "my-ui-app",
  "tenant-mode": "dedicated",
  "scopes": [
    { "name": "$XSAPPNAME.Display", "description": "Use the application" },
    { "name": "$XSAPPNAME.Monitor", "description": "Use the monitoring functions" }
  ],
  "role-templates": [
    { "name": "Viewer",         "scope-references": ["$XSAPPNAME.Display"] },
    { "name": "MonitoringUser", "scope-references": ["$XSAPPNAME.Display", "$XSAPPNAME.Monitor"] }
  ],
  "role-collections": [
    { "name": "App Viewers",      "role-template-references": ["$XSAPPNAME.Viewer"] },
    { "name": "Monitoring Users", "role-template-references": ["$XSAPPNAME.MonitoringUser"] }
  ],
  "oauth2-configuration": {
    "redirect-uris": ["https://<approuter-host>.cfapps.<region>.hana.ondemand.com/**"]
  }
}
```
2. **XSUAA servis instance'ı oluştur**, sonraki değişiklikleri aynı instance'a uygula:
```bash
cf create-service xsuaa application my-xsuaa -c xs-security.json
cf update-service my-xsuaa -c xs-security.json
```
3. **Application Router'ı kur** (@sap/approuter tabanlı küçük Node.js uygulaması), üç dosya:
   - `package.json`: `"dependencies": { "@sap/approuter": "^20" }`
   - `xs-app.json`: her route XSUAA login ister, UI uygulamasına forward edilir:
```json
{
  "welcomeFile": "/",
  "authenticationMethod": "route",
  "logout": { "logoutEndpoint": "/logout" },
  "routes": [
    {
      "source": "^/(.*)$",
      "target": "/$1",
      "destination": "ui-app",
      "authenticationType": "xsuaa",
      "csrfProtection": false
    }
  ]
}
```
   - `manifest.yml`: destination `ui-app` UI uygulamasını gösterir, `forwardAuthToken: true` kullanıcının token'ını iletir:
```yaml
applications:
  - name: my-approuter
    memory: 256M
    services:
      - my-xsuaa
    env:
      destinations: >
        [ { "name": "ui-app",
            "url": "https://<ui-app-host>.cfapps.<region>.hana.ondemand.com",
            "forwardAuthToken": true } ]
```
   `csrfProtection`'ı uygulamanın kendi CSRF korumasına göre ayarla; UI kendi korumasını yapıyorsa router'da kapatılabilir.
4. **XSUAA'yı UI uygulamasına bind et** (token doğrulaması için aynı instance gerekir):
```yaml
applications:
  - name: my-ui-app
    services:
      - my-xsuaa
```
```bash
cf push my-ui-app
cf push my-approuter
```
5. **Trust ve rol ataması**: BTP cockpit → Security → Trust Configuration'da identity provider ile trust kur; Security → Role Collections altında role collection'ları (tercihen kullanıcı gruplarına) ata. CLI ile de scriptlenebilir:
```bash
btp assign security/role-collection "Monitoring Users" --to-user <user@example.com>
```
6. **Sunucu tarafı yetkilendirme kontrolü** — Node.js/Express örneği, @sap/xssec ve @sap/xsenv ile:
```js
const express = require("express");
const xsenv = require("@sap/xsenv");
const { XsuaaService, createSecurityContext } = require("@sap/xssec");

const xsuaa = new XsuaaService(xsenv.getServices({ xsuaa: { tag: "xsuaa" } }).xsuaa);
const app = express();

// 1. Her istekte token doğrula
app.use(async (req, res, next) => {
  try {
    req.authInfo = await createSecurityContext(xsuaa, { req });
    next();
  } catch (e) {
    res.status(401).json({ error: "Not authenticated" });
  }
});

// 2. Korumalı fonksiyon için scope zorunlu kıl
const requireScope = (scope) => (req, res, next) =>
  req.authInfo.checkLocalScope(scope) ? next() : res.status(403).json({ error: "Not authorized" });

app.get("/api/monitoring", requireScope("Monitor"), (req, res) => {
  res.json({ status: "ok" });   // yalnız Monitor scope'u olan erişir
});

app.listen(process.env.PORT || 8080);
```
Java uygulamaları için aynı işlevi SAP Cloud Security Services Integration Library (java-security) sağlar.

Ne zaman seçilir: MCP server/AI uygulaması bir UI üzerinden kurumsal kullanıcılara açılıyorsa ve standart SAP BTP güvenlik modeli (SSO + scope bazlı yetkilendirme) uygulanacaksa. ([[kaynaklar/2026-10-26-securing-ai-powered-sap-apps-btp-sso-rbac]])

### Backend bağlantısı: Teknik user (Cloud Connector) vs Principal Propagation
Kullanıcı authentication'ı (Application Router + XSUAA) ile uygulamanın S/4HANA'ya bağlantısı **ayrı** konulardır:
1. **Teknik user ile bağlantı (PoC için uygun)**: Uygulama ile S/4HANA arasındaki iletişim bir BTP destination ve SAP Cloud Connector üzerinden, teknik bir kullanıcı ile kurulur. S/4HANA bu durumda bireysel son kullanıcıyı değil, teknik kullanıcıyı yetkilendirir — tüm AI/MCP istekleri aynı teknik kullanıcının S/4HANA yetkileriyle çalışır.
2. **Principal propagation (production için önerilir)**: Son kullanıcının kendi SAP yetkilerinin backend'de de uygulanması isteniyorsa, destination/Cloud Connector seviyesinde principal propagation yapılandırılır; böylece her kullanıcı S/4HANA'da kendi authorization'larıyla sorgu çalıştırır.

Ne zaman seçilir: Teknik user yaklaşımı hızlı PoC/demo için yeterlidir; productive kullanımda row-level/obje bazlı S/4HANA yetkilerinin kullanıcıya göre değişmesi gerekiyorsa principal propagation'a geçilmelidir. ([[kaynaklar/2026-10-26-securing-ai-powered-sap-apps-btp-sso-rbac]])

## Tuzaklar
- **Role değişikliği anında etkili olmaz**: Scope'lar login anında token'a yazılır. Bir role collection kullanıcıya atandığında veya kaldırıldığında, değişikliğin etkili olması için kullanıcının **tekrar login olması** gerekir.
- **Session expiry'de arka plan istekleri sessizce başarısız olur**: Application Router session'ı süresi dolunca, fetch gibi background request'ler interactive login akışını tamamlayamaz; 401 veya login redirect döner. Çözüm: 401/olmayan JSON cevabında sayfayı reload ederek Application Router'ın login akışını yeniden başlatmasına izin vermek.
```js
async function callApi(url, options) {
  const res = await fetch(url, { credentials: "include", ...options });
  const isJson = (res.headers.get("content-type") || "").includes("application/json");
  if (res.status === 401 || !isJson) {
    window.location.reload();        // Application Router login'e yönlendirir
    return null;
  }
  return res.json();
}
```
- **Servis güncellemeleri doğrulanmalı**: xs-security.json değişikliklerini `cf update-service` ile uyguladıktan sonra, BTP cockpit'te oluşan rollerin beklenen şekilde güncellendiği kontrol edilmeli.
- **Client-side gizleme yetkilendirme yerine geçmez**: UI'da bir fonksiyonu gizlemek sunucu tarafı yetkilendirme kontrolünün yerini tutmaz; API doğrudan çağrılarak bypass edilebilir.
- **Credential'lar koda/env variable'a yazılmamalı**: API key gibi teknik credential'lar service binding üzerinden sağlanmalı, environment variable veya kaynak koda gömülmemeli.
- **Kullanıcı authentication'ı ile backend bağlantısı karıştırılmamalı**: Application Router + XSUAA yalnız uygulamaya erişimi kontrol eder; uygulamanın S/4HANA'ya bağlantısı (teknik user veya principal propagation) ayrı bir güvenlik katmanıdır.

## Cevapladığı sorular
- MCP server ile S/4HANA verisini expose eden BTP uygulamasında XSUAA ve Application Router ile authentication/authorization nasıl kurulur?
- xs-security.json'da scope, role-template ve role-collection nasıl tanımlanır?
- Role collection kullanıcıya atandıktan sonra neden hemen etkili olmuyor?
- Application Router session'ı dolunca arka plan istekleri nasıl ele alınmalı?
- MCP/AI uygulamasının S/4HANA backend'ine teknik user ile mi yoksa principal propagation ile mi bağlanması gerekir?
- Node.js'te @sap/xssec ile gelen token'dan scope nasıl kontrol edilir?

## İlgili
(yok)
