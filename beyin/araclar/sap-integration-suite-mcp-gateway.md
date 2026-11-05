---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# SAP Integration Suite MCP Gateway (composed API → MCP server)

## Ne yapar
SAP Integration Suite'in **API Composition** ve **MCP Gateway** yetenekleriyle, birden fazla backend API'yi (ör. Business Partner, Plant, Material, 3. parti Risk Analytics) tek bir "Business Data Graph" halinde birleştirip, bunu bir **MCP server** olarak paketler ve expose eder. Böylece AI ajanlar, standart, güvenli ve governed bir arayüzle (API Management katmanı korumasıyla) enterprise business context'e MCP tool çağrısı üzerinden erişebilir — business context parçalanmadan. Repo, SAP-samples altında resmi bir **hands-on tutorial**: BestRun firması örneği üzerinden tedarikçi risk değerlendirme senaryosu, iki egzersizle (composed API inşası + MCP server oluşturma/deploy/test) anlatılıyor. Kullanılan API'ler eğitim amaçlı public mock API'lerdir.

## Bende durumu
yeni. Envanterde doğrudan karşılığı yok. En yakın ilişkili öğe `sap-btp-integration-suite` (sap-skills plugin, 1 skill) — ama o bir Claude *skill*'i (geliştirici asistanı/dokümantasyon rehberi), bu repo ise SAP Integration Suite'in kendi ürün özelliği olan MCP Gateway'i uçtan uca kurup kullanmayı gösteren bağımsız bir tutorial/örnek proje. Kurulu plugin'lerden hiçbiri bu MCP Gateway kurulumunu otomatikleştirmiyor; `sap-btp-integration-suite` skill'i bu tutorial'ı uygularken yardımcı danışman olarak kullanılabilir.

## Agentic BI'a katkısı
SAC/Joule tarzı agentic BI senaryolarında ajanların S/4-arkası iş verisine (stok, tedarikçi, risk, lojistik) erişimi genelde ayrı ayrı API'ler ve kimlik doğrulama gerektirir. Bu yaklaşım, birden fazla backend API'yi **tek bir governed MCP tool** haline getirerek ajan tarafındaki tool sayısını azaltır ve API Management katmanının (rate limit, auth, audit) korumasını MCP çağrılarına da taşır — yani hem analitik hem transaksiyonel (procurement, tedarikçi seçimi gibi) agentic iş akışları için güvenli bir köprü örneği sunuyor.

## Kurulum
Resmi tek komutlu kurulum yok; bu bir SAP BTP Integration Suite tenant + hands-on egzersiz reposu: `git clone https://github.com/SAP-samples/integration-mcp-gateway` sonrası `tutorials/composed-mcp-server/exercises/ex1` ve `ex2` klasörlerindeki README adımları SAP Integration Suite tenant'ında uygulanır; test için MCP Inspector (MCP client) kullanılır.

## Dikkat
- Apache-2.0 lisans, son push 2026-09-27 — aktif bakımda, SAP resmi (SAP-samples) repo.
- Gerçek bir prod-ready MCP server paketi değil: **hands-on eğitim** materyali; mock/public API'ler üzerine kurulu, prod'a taşırken kendi API composition ve MCP Gateway konfigürasyonunu kurman gerekir.
- SAP Integration Suite tenant'ı, API Management/API Composition lisansı ve yetkilendirmesi ön koşul.
- Üçüncü taraf bir MCP server değil (SAP resmi), yine de prod'da MCP Gateway'e expose edilen tool'ların hangi kimlik bilgileriyle backend'e eriştiğine (destinations, OAuth) dikkat edilmeli — composed API governance katmanı bunun için var.

## Benzerleri
- [[araclar/cds-mcp|cds-mcp (CAP MCP server)]]
- [[araclar/hana-mcp-server|hana-mcp-server]]
- `sap-btp-integration-suite` skill (sap-skills plugin) — danışmanlık/dokümantasyon tarafı

([[kaynaklar/2026-10-09-integration-mcp-gateway]])
