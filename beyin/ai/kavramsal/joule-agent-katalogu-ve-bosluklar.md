---
tur: konu
alan: ai
kategori: kavramsal
urun_surumu: "2026-10"
tarih: 2026-10-13
guven: resmi
gozden_gecir: 2027-04-13
---

# Joule Agent / Joule Assistant kataloğu ve boşluklar (Ekim 2026)

## Özet
SAP'nin hazır agent kataloğu finance, spend, supply chain, HR ve CX alanlarını, 2026'da da governance/SoD, ESG, clean core, test ve migration alanlarını büyük ölçüde kapladı. Belirgin boşluk **data & analytics engineering** katmanında: Datasphere/BW/SAC operasyonu, lineage, KPI semantiği, analitik katman ile kaynak arasındaki mutabakat ve BTP maliyeti. Katalogdaki 67 assistant'ın hiçbiri "Data & Analytics" alanında değil. Agentic AI use case seçerken bu sayfayı "SAP zaten yapıyor mu?" kontrol listesi olarak kullan.

## Ne zaman kullanılır
- Yeni bir agent fikrinin SAP'nin hazır kataloğuyla çakışıp çakışmadığını kontrol ederken
- Müşteriye "bunu Joule Studio ile mi yapalım, hazır Joule Agent var mı?" sorusunu cevaplarken
- Agentic BI / data engineering tarafında farklılaşan bir use case ararken

## Katalog yapısı ve sayılar
- Hiyerarşi şöyle: **Joule Assistant**, birden çok **Joule Agent**'ı yönetir. Agent'lar MCP ve A2A ile SAP dışı sistemlere de uzanır.
- Kataloğun ana kaynağı `sap.com/products/artificial-intelligence/ai-assistant.html`. Ülke sürümleri (ör. `/turkey/...`) aynı listeyi gösterir. **Bu sayfada 67 assistant var, 200 değil.**
- "200+ agent" sayısı, bu assistant'ların içindeki agent'lardan gelir. Her assistant sayfası 4–12 agent listeler. Sapphire 2026'da 224 agent ve 51 assistant açıklandı, sayının her ay artacağı söylendi. SAP Connect'te (Ekim 2026) yıl sonu için "400+ agent" hedefi verildi; bu son rakam ikincil kaynaktan, doğrulanmadı.
- Her assistant'ın detay sayfası `sap.com/use-cases/joule-assistant/<slug>` adresinde. Bu sayfalar görevleri, örnek use case'leri ve kullanılan agent'ları listeler. Liste JavaScript ile yüklendiği için düz fetch ile okunmaz; tarayıcı tabanlı fetch gerekir.

| Alan | Assistant'lar ve öne çıkan agent'lar |
|---|---|
| Finance | **Assistant'lar:** AR, AP, Billing, Cash & Treasury, Financial Closing, Financial Consolidation, Financial Planning, Overhead Accounting, Revenue Recognition, Tax & Compliance, Invoicing, Expense, Recurring Receivables. **Financial Closing agent'ları:** Accounting Accruals, Journal Entry / Journal Entry Verification, Intercompany Matching & Reconciliation, Asset Accounting Anomaly Detection, Financial Consistency Analysis, Analytical Business Insights, Receivables & Payables Clearing. **AR agent'ları:** Dispute Creation, Dispute Resolution, Collection Account Preparation, Collections Email Outreach, Dunning Insights |
| Governance (Finance altında) | **Governance Assistant:** Continuous Control Monitoring, GRC Audit, GRC Risk Identification, Integrity Screening, Internal Control Compliance. **Access Governance & Security Assistant:** SoD conflict, Firefighter review, AI agent erişiminin izlenmesi, NIS2/DORA/SOX/EU AI Act audit kanıtı |
| Spend | Sourcing (bid analysis), Procurement Contract, Requisition, Purchasing, Receiving, Supplier Management, Category Management, Services Procurement, Spend Analytics, Business Network, Contingent Workforce, Travel |
| Supply chain | **Assistant'lar:** Supply Chain Planning, Manufacturing, Logistics, Product Design, International Trade, Order Management. **Supply Chain Planning agent'ları:** Exception Management, Inventory Investment Allocation, Footprint Optimization, Supply Plan Explainability. **Asset Operations:** 12 agent, örneğin Maintenance Request Screening/Initiation, Operational Maintenance Planning, Technician Briefing, Maintenance Job Debrief |
| HR | Recruiting, Onboarding, Payroll, Compensation, Incentive Compensation, Performance & Goals, Career & Talent Development, Learning, Workforce Management, Workforce Upskilling, HR Service, HR Operations, HR System, People Intelligence |
| CX | Sales, Sales Operations, Deal Qualification, Deal Closing, Quoting, Pricing, Campaign, Content, Merchandising, Shopping, Self-Service, Case Management, Service Optimization |
| Migration & modernization (Cloud ALM üzerinde) | **Custom Code Assistant:** ATC toplu düzeltme, decommission, Dynpro'dan RAP'e geçiş. **Data Management Assistant:** "Transition Data Quality" agent'ları. Ayrıca Test Management, Business Configuration, ALM Project Management. Kapsam şimdilik ECC'den SAP Cloud ERP Private'a geçiş |
| ESG | Regulatory Readiness Agent (CSRD), Footprint Optimization Agent, Packaging Compliance, Workplace Safety |
| Data & analytics | Katalogda assistant yok. **Datasphere içindeki Joule:** NL ile data product, analytic model ve planning yapısı oluşturuyor, SAC story üretiyor (Sapphire 2026). **Tenant Health Check Agent:** EAC aşamasında, GA yıl sonu; yalnız disk, memory ve audit log retention'a bakıyor. **BW Query Template Generator ve Data Product Generator:** bunlar araç, agent değil |

## Tuzaklar
- "SAP'de yok" demeden önce assistant sayfasının agent listesine bak. Governance, ESG, custom code ve test 2026'da kapandı.
- Data Management Assistant'ı genel veri kalitesi aracı sanma. Agent'ları "Transition" odaklı, yani migration için veri kalitesine bakıyor; Datasphere/BDC'de sürekli data quality için değil.
- Custom Code Assistant ECC'den Cloud ERP Private'a geçiş kapsamında. BW transformation/routine ABAP'ı kapsamıyor.
- Finance'teki reconciliation agent'ları (intercompany, GR/IR, clearing) ERP içinde çalışıyor. S/4 ile BW/Datasphere/SAC arasındaki rakam farkına bakmıyorlar.
- Duyuru tarihleri ile GA tarihleri sık sık farklı. Bir çok kalem Early Adopter Care ile başlıyor, GA Q4 2026 – Q1 2027'ye kayıyor.

## Gerçek boşluklar (Ekim 2026 itibarıyla katalogda karşılığı yok)
1. **Analitik katmanın kaynakla mutabakatı:** S/4 ile BW/Datasphere/SAC arasında "rakamlar tutmuyor" teşhisi.
2. **KPI / metric semantiği:** Aynı KPI'ın BW query, Datasphere analytic model ve SAC story'deki tanım farkı; calculated measure ve restricted measure tutarlılığı.
3. **Lineage temelli etki analizi ve değişiklik riski:** Datasphere'de bunun için yalnız runtime metrics özelliği var.
4. **Analytics DataOps:** process chain, task chain ve replication flow hatalarında kök neden bulup düzeltme önerisi.
5. **BW'den Datasphere/BDC'ye agentic migration orkestrasyonu:** Bugün yalnız QTG ve DPG araçları var.
6. **FinOps:** BTP capacity unit, AI Unit ve Datasphere tüketiminin takibi ve optimizasyonu.
7. **Analitik regresyon testi:** model değişince SAC story çıktısını doğrulama; Test Management S/4 odaklı.
8. **Datasphere'de veri seviyesinde governance:** DAC, row-level security, data product sahipliği.

## Enabling tech durumu (2026)
- **Joule Studio (managed):** Low-code ve pro-code; Cursor, Claude Code, AutoGen ve LlamaIndex destekli; managed runtime var. GA Q3 2026 planlı.
- **SAP AI Agent Hub:** SAP ve SAP dışı agent'ları ve MCP server'ları envanterleyip yönetiyor (governance).
- **A2A:** Çift yönlü A2A için GA Q4 2026 hedefleniyor.
- **Integration Suite:** Integration Cell üzerinde OpenAPI 3.0 spec'inden kod yazmadan MCP server oluşturuluyor (PIR auth ile).
- **HANA Cloud:** MCP desteği var; vector engine ve metadata'dan knowledge graph üretimi var; agentic memory yolda.
- **Geliştirici MCP'leri:** Fiori, UI5, CAP ve MDK için açık kaynak sunucular var. Resmi bir ABAP MCP'si ve resmi bir Datasphere/BDC MCP'si yok; yalnız topluluk sunucuları var.
- **SAP-RPT-1.6 GA:** AI Core model library'den sunuluyor. Tabular orchestration için GA "late 2026" veriliyor.

## Kaynaklar
- https://www.sap.com/products/artificial-intelligence/ai-assistant.html
- https://www.sap.com/turkey/products/artificial-intelligence/ai-assistant.html
- https://www.sap.com/use-cases/joule-assistant/financial-closing-ai
- https://www.sap.com/use-cases/joule-assistant/grc-ai
- https://www.sap.com/use-cases/joule-assistant/access-governance-ai
- https://www.sap.com/use-cases/joule-assistant/data-management-assistant
- https://www.sap.com/use-cases/joule-assistant/custom-code-assistant
- https://www.sap.com/use-cases/joule-assistant/test-management-assistant
- https://www.sap.com/use-cases/joule-assistant/supply-chain-planning-ai
- https://www.sap.com/use-cases/joule-assistant/asset-operations-ai
- https://erp.today/will-sap-be-a-software-company-in-the-future-sapphire-2026-keynote-maps-saps-new-erp-stack/
- https://news.sap.com/2026/05/future-enterprise-autonomous/
- https://news.sap.com/2025/11/new-agentic-capabilities-sap-btp-supercharge-developers/
- https://community.sap.com/t5/technology-blog-posts-by-sap/sap-business-data-cloud-and-datasphere-news-in-may/ba-p/14408387
- https://community.sap.com/t5/data-and-ai-professionals-blog-posts/sap-business-data-cloud-and-datasphere-news-in-august/ba-p/14480924
- https://community.sap.com/t5/technology-blog-posts-by-sap/building-an-mcp-server-on-integration-cell-part-of-sap-integration-suite/ba-p/14496867
- https://www.sap.com/products/artificial-intelligence/sap-rpt.html
- https://thenewstack.io/sap-joule-studio-managed-agents/

## Sürüm notu
Ekim 2026'daki katalog durumunu yansıtır. Katalog her ay büyüyor; 6 ay sonra assistant listesini yeniden say ve boşluk listesini güncelle.
