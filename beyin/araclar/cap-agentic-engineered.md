---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# cap-agentic-engineered (SAP MCP-Grounded CAP Referans Uygulaması)

## Ne yapar
SAP'in resmi örnek deposu (SAP-samples). AI coding agent'ların (Claude Code, Cursor, Copilot gibi MCP destekli araçlar) SAP MCP server'larına (CAP MCP, Fiori MCP, UI5 MCP) bağlanarak nasıl daha doğru/güncel SAP kodu ürettiğini gösteren bir metodoloji + somut kanıt sunar:

- Reusable `AGENTS.md`: hangi SAP artefaktı için hangi MCP server'ın sorgulanacağını tanımlayan yönlendirme kuralları (CDS modeli → CAP MCP, Fiori annotation → Fiori MCP, UI5 controller → UI5 MCP).
- `skills/` klasörü: dosya pattern'ine göre otomatik tetiklenen Claude skill'leri (ör. `srv/**/*.cds` dokunulduğunda ilgili skill devreye girip ajanı doğru MCP server'ı sorgulamaya zorluyor).
- Kanıt olarak çalışan bir uygulama: "Financial Risk Analyzer" — GL transaction'larını 24 mühendislik özelliğiyle normal/anomali sınıflandıran CDS modeli, unbound OData action (`analyzeRisks`) ile toplu ML çıkarımı, SAP AI Core entegrasyonu (XGBoost, mock predictor ile lokal çalışabiliyor), Fiori Elements List Report (kritiklik vurgulama, custom toolbar action), rol bazlı erişim kontrolü (RiskAnalyst rolü).
- `spec/` klasörü: GSD (spec-driven development) ile üretilmiş roadmap, aşamalı gereksinimler, başarı kriterleri ve çalıştırma logları — "ajan nasıl spec'ten koda gitti" sürecinin izlenebilir kaydı.
- Test paketi: servis davranışı, annotation doğruluğu, i18n, manifest, feature engineering ve risk etiketleme için unit/integration testleri.

## Bende durumu
yeni — envanterde eşleniği yok; Oktay'ın CAP/Fiori geliştirmelerinde Claude Code ile birlikte kullanılabilecek doğrudan uygulanabilir bir metodoloji + AGENTS.md/skills şablonu.

## Agentic BI'a katkısı
Doğrudan BI değil ama agentic engineering için örnek teşkil ediyor: Datasphere/BW4/SAC tarafında benzer bir yapı kurulabilir — "hangi artefakt için hangi MCP/skill tetiklenir" mantığı CDS view, analytic model veya SAC story geliştirirken de uygulanabilir bir desen. AGENTS.md + skills yaklaşımı, Oktay'ın kendi SAP Beyni/ajan mimarisine (dosya pattern'ine göre otomatik skill tetikleme) ilham kaynağı olabilir.

## Kurulum
```bash
git clone https://github.com/SAP-samples/cap-agentic-engineered.git && cd cap-agentic-engineered && npm ci && cds watch
```
Ar­dından http://localhost:4004/risk/webapp/index.html — giriş: `test-analyst` / `pass`. SAP AI Core ile canlı tahmin için `.env.example` → `.env` kopyalanıp BTP service key girilir; varsayılan `AI_CORE_MOCK=true` ile dış servis gerekmeden mock predictor kullanılır.

Kendi CAP + Fiori Elements projesine taşımak için: `AGENTS.md` ve `skills/` klasörünü kopyala, `.claude/settings.json` içinde MCP server'ları yapılandır (talimatlar dosya içinde).

## Dikkat
- Apache-2.0 lisanslı, SAP-samples altında resmi ama "as-is" sağlanıyor; destek SAP Community üzerinden, resmi SAP destek kanalı değil.
- Son push: 2026-05-27 — küçük bir repo (13 yıldız), bakım sürekliliği garanti değil; production-ready değil, sadece lokal geliştirme/metodoloji referansı olarak tasarlanmış.
- `.env` içine SAP AI Core BTP service key girilecekse üçüncü taraf/yerel ortamda saklama riskine dikkat — kimlik bilgilerini repo'ya commit etmemek gerekir (`.env.example` şablon olarak var, `.env` gitignore'da olmalı).
- Kapsamlı BTP deploy/HANA/XSUAA/draft/composition senaryoları için bu repo yetersiz; onun için SAP-samples/cap-sflight'a yönlendiriliyor.

## Benzerleri
- SAP-samples/cap-sflight (daha kapsamlı CAP referansı: BTP, HANA, XSUAA, draft editing)
- GSD (spec-driven development tool, bu projede spec üretimi için kullanılmış)
