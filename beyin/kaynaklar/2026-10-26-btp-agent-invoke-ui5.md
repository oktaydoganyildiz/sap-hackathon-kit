---
tur: kaynak
alan: ai
tarih: 2026-10-26
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-calling-an-agent-from-your-ui5-app/ba-p/14510571
gozden_gecir: 2027-04-26
---

# Agentic AI on BTP: Calling an Agent from Your UI5 App

Link: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-calling-an-agent-from-your-ui5-app/ba-p/14510571

Yazı türü: tarif

Serinin 6. yazısı; yazarın kendi multi-agent BTP uygulamasına yeni bir "invoke API" eklendiğini anlatıyor. Amaç: var olan bir UI5 app'in, yeni bir CAP app yazmadan, agent app'teki bir ajanı iki API çağrısıyla (POST /api/invoke/{slug} ve GET /api/invoke/runs/{run_id}) çağırabilmesi. Ajan admin UI'de bir API slug'a bağlanır, "Expose to the invoke API" açılır ve ajanın dönmesi gereken sonuç bir JSON Schema ile tanımlanır (submit_result tool'u otomatik eklenir, şema uymazsa model düzeltmeye zorlanır, yalnız metinle biten run no_result ile fail eder). Erişim "invoke" scope'u arkasında, Agent Invoker rol koleksiyonu ile verilir; run kullanıcının kimliğiyle çalışır (OData servisleri signed-in user olarak çağrılır). UI5 app ile agent app aynı subaccount'taysa OAuth2UserTokenExchange destination (farklı subaccount'ta OAuth2SAMLBearerAssertion + trust) kullanılır, xs-app.json'da `agent/` altına gelen her şey `/api/invoke/` hedefine route edilir (csrfProtection: true). İstemci tarafı: dosya seçimi (FileUploader), CSRF token alma (HEAD + X-CSRF-Token: Fetch), FormData ile multipart POST (`input` metni + `files`), `?wait=20` ile kısa süren run'larda senkron yanıt, 202/409 durumlarında run_id ile polling (GET runs/{id}, status != running oluncaya kadar 3 sn aralıkla). Sonuç: şemaya uyan `result`, OData audit log'undan gelen `writes` (gerçek anahtarla), `activity` (her tool call), hata durumunda `error`. Kısıtlar: kullanıcı+ajan başına tek eşzamanlı run (ikincisi 409 + mevcut run_id döner), app instance başına en çok 8 run (429), 5 dakika timeout, dosyalar yalnız bellekte tutulur/loglanmaz, dosya tipi içerikten doğrulanır (uzantıdan değil), başarısızlıkta bile varsa önceki result korunur.

## Beslediği sayfalar
- [[ai/baglanti/btp-agent-invoke-ui5-call]]
