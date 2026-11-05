---
tur: tarif
alan: ai
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-26
guven: topluluk
gozden_gecir: 2027-04-26
---

# UI5 App'ten SAP BTP Agent'ını Invoke API ile Çağırma

## Use case
Var olan bir UI5 app'in, arka planda ayrı bir CAP app/agent kodlamadan, bir buton tetiklemesiyle BTP'de zaten yapılandırılmış bir ajanı (ör. fiş görselinden draft expense oluşturan ajan) çağırıp, dönen yapılandırılmış sonuçla (ör. yeni kaydın id'si) kendi ekranını güncellemesi gerektiği senaryo.

## Varyantlar

### Invoke API: admin UI'de expose + OAuth2UserTokenExchange destination + FormData/polling

Ne zaman seçilir: Ajan zaten bir "agent app" (admin UI'de yapılandırılan, OData servisleri ve kimlikleri tanımlı bir multi-agent BTP uygulaması) içinde tanımlıysa ve amacın ayrı bir CAP app yazmadan mevcut UI5 app'ten bu ajanı tetiklemekse.

**1. Ajanı invoke API'ye aç (admin UI)**

Ajanın ayarlarında bir API slug tanımla (ör. `expense-expert`), "Expose to the invoke API"yi aç, ajanın dönmesi gereken sonucu JSON Schema olarak tanımla:

```json
{
  "type": "object",
  "properties": {
    "expense_id": { "type": "string" },
    "status": { "type": "string", "enum": ["draft"] }
  },
  "required": ["expense_id", "status"],
  "additionalProperties": false
}
```

Ajan bu run için otomatik bir `submit_result` tool'u alır; şemaya uymayan obje modele geri gönderilip düzelttirilir. Run yalnız metinle biterse `no_result` ile fail eder — app hiçbir zaman sadece "modelin anlattığı" bir sonucu okumaz. Dosya kısıtları (tip, boyut — varsayılan 10 MB, dosya sayısı — varsayılan 5, PDF sayfa sayısı — varsayılan 20) ajan bazında ayarlanır.

**2. Rolü ata**

API `invoke` scope'u arkasındadır. UI5 app kullanıcılarına **Agent Invoker** rol koleksiyonunu ata. Run kullanıcının kimliğiyle çalışır: ajan SAP'a signed-in user olarak, OData servisleri üzerinden yazar.

**3. Destination ve route**

Aynı subaccount'taki agent app'e `OAuth2UserTokenExchange` destination:

```properties
Name=agent-invoke
Type=HTTP
URL=https://<agent-backend-host>
ProxyType=Internet
Authentication=OAuth2UserTokenExchange
clientId=<agent app xsuaa clientid>
clientSecret=<agent app xsuaa clientsecret>
tokenServiceURL=https://<subdomain>.authentication.<region>.hana.ondemand.com/oauth/token
```

Farklı subaccount'taki bir agent app için `OAuth2SAMLBearerAssertion` + iki subaccount arası trust kullanılır.

`xs-app.json`'da UI5 app tarafında route:

```json
{
  "source": "^/agent/(.*)$",
  "target": "/api/invoke/$1",
  "destination": "agent-invoke",
  "authenticationType": "xsuaa",
  "csrfProtection": true
}
```

**4. UI5 tarafı çağrı**

```xml
<u:FileUploader id="receipt" change=".onFileChange" fileType="png,jpg,jpeg,pdf" />
<Button text="Create expense from receipt" press=".onCreateFromReceipt" />
```

```javascript
onFileChange: function (oEvent) {
    this._files = Array.from(oEvent.getParameter("files") || []);
},

onCreateFromReceipt: async function () {
    const sBase = this.getOwnerComponent().getManifestObject().resolveUri("agent/");
    const oForm = new FormData();
    oForm.append("input", "Create a draft expense from this receipt.");
    (this._files || []).forEach((oFile) => oForm.append("files", oFile, oFile.name));

    this.getView().setBusy(true);
    try {
        const oRun = await this._invoke(sBase, "expense-expert", oForm);
        this._handleRun(oRun);
    } catch (oError) {
        MessageBox.error(oError.message);
    } finally {
        this.getView().setBusy(false);
    }
},

_invoke: async function (sBase, sSlug, oForm) {
    const sToken = await this._csrfToken(sBase);
    // wait up to 20 seconds, a quick run answers right away
    const oRes = await fetch(sBase + encodeURIComponent(sSlug) + "?wait=20", {
        method: "POST",
        headers: { "X-CSRF-Token": sToken },
        body: oForm
    });
    const oBody = await oRes.json().catch(() => ({}));
    if (oRes.status === 200) { return oBody; }                 // finished in time
    if (oRes.status === 202) { return this._poll(sBase, oBody.run_id); }
    if (oRes.status === 409 && oBody.run_id) {                  // already running for this user
        return this._poll(sBase, oBody.run_id);
    }
    throw new Error(oBody.detail || "The agent could not be started");
},

_poll: async function (sBase, sRunId) {
    for (;;) {
        await new Promise((resolve) => setTimeout(resolve, 3000));
        const oRun = await (await fetch(sBase + "runs/" + encodeURIComponent(sRunId))).json();
        if (oRun.status !== "running") { return oRun; }
    }
},

_csrfToken: async function (sBase) {
    const oRes = await fetch(sBase, { method: "HEAD", headers: { "X-CSRF-Token": "Fetch" } });
    return oRes.headers.get("X-CSRF-Token");
}
```

Not: `Content-Type` elle set edilmez; multipart boundary'yi tarayıcı FormData'dan otomatik ekler.

**5. Sonucu kullan**

Dönen gövde:

```json
{
  "status": "completed",
  "result": { "expense_id": "4711", "status": "draft" },
  "writes": [
    { "service": "expenses", "entity_set": "ExpenseReports", "operation": "create",
      "key": { "ExpenseId": "4711" }, "outcome": "ok" }
  ],
  "text": null,
  "activity": [ "..." ],
  "error": null
}
```

`result` tanımlanan şemaya uyar; `writes` OData servislerinin audit log'undan gelir (anahtar modelin uydurduğu değil, SAP'nin döndürdüğü gerçek anahtardır); `activity` run'daki her tool çağrısını tutar, polling sırasında bile gösterilebilir.

```javascript
_handleRun: function (oRun) {
    if (oRun.status !== "completed") {
        MessageBox.error("The agent could not finish: " + (oRun.error || oRun.status));
        return;
    }
    this.getView().getModel().refresh();
    this.getOwnerComponent().getRouter().navTo("expense", { id: oRun.result.expense_id });
}
```

Kaynak: ([[kaynaklar/2026-10-26-btp-agent-invoke-ui5]])

## Tuzaklar
- Kullanıcı+ajan başına aynı anda yalnız tek run çalışır; ikinci çağrı 409 ile mevcut `run_id`'yi döner — bunu yeni hata değil, mevcut run'a katılma (polling) olarak ele al.
- App instance başına en çok 8 eşzamanlı run (429) sınırı var; yoğun kullanımda bunu hesaba kat.
- Run 5 dakikayı geçerse `timeout` ile biter; uzun süren ajan görevleri için `wait` parametresini düşük tutup polling'e güvenmek gerekir.
- Dosyalar yalnız run süresince bellekte tutulur, hiç loglanmaz veya saklanmaz; dosya tipi uzantıdan değil içerikten doğrulanır — yanlış uzantılı dosya reddedilebilir.
- Run, ajan sonucu teslim ettikten sonra bir adımda hata alırsa bile elindeki `result` korunur ve `error` alanıyla birlikte döner — app tarafında yalnız `status === "completed"` kontrolü yeterli değil, kısmi/hata senaryosu da ele alınmalı.
- Yalnız metinle biten (şemaya uyan `submit_result` çağrılmamış) bir run `no_result` ile fail eder; bu, ajanın tool kullanmadan sohbet cevabı verdiği durumları app tarafına sızdırmaz.
- Farklı subaccount'taki agent app için `OAuth2UserTokenExchange` yerine `OAuth2SAMLBearerAssertion` + trust kurulmalı; aynı subaccount varsayımıyla ilerlemek bağlantı hatasına yol açar.

## Cevapladığı sorular
- UI5 app'ten SAP BTP agent'ını invoke API ile nasıl çağırırız?
- Bir ajanı çağırmak için her use case'de ayrı CAP app yazmak gerekir mi?
- Agent'tan structured (JSON schema'ya uyan) sonuç nasıl garanti edilir?
- UI5'ten multipart (dosya + metin) agent çağrısı nasıl yapılır, polling nasıl kurulur?
- Agent'ın SAP'de yaptığı yazmaları (writes/audit) UI5 app'e nasıl geri bildiririz?

## İlgili
- [[araclar/cap-agent-ui5-webui]] (CAP tabanlı ajan için hazır SAPUI5 chat arayüzü — burada anlatılan invoke API ise chat yerine yapılandırılmış form/buton entegrasyonu sağlar)
