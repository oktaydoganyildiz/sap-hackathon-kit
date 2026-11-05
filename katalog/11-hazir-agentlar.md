# SAP'nin hazır (prebuilt) Joule agent'ları ve boşluklar

2026-11-05 araştırması. Amaç: SAP'nin zaten yaptığı agent'ı tekrar yapmamak; ya genişletmek ya da boşluğa girmek. GA/beta durumları SAP Business AI release highlights'tan; "doğrulanmadı" işaretliler ikincil kaynak.

## Nerede listeleniyor

| Link | Ne |
|---|---|
| https://www.sap.com/products/artificial-intelligence/ai-assistant.html | Joule Assistant kataloğu (detay sayfaları `sap.com/use-cases/joule-assistant/<slug>`, JS ile açılır) |
| https://www.sap.com/products/artificial-intelligence/ai-agents/agent-use-cases.html | Joule Agents use case sayfası |
| https://news.sap.com/2026/04/sap-business-ai-release-highlights-q1-2026/ | Q1 2026 release highlights — GA/beta durumu için en iyi kaynak |
| https://news.sap.com/2026/07/sap-business-ai-release-highlights-q2-2026/ | Q2 2026 release highlights (Q3 henüz yok) |
| https://help.sap.com/docs/JOULESTUDIO/7e496fe6f81f4975aec07d9c1cbd2aef/6f4334f303484c798df6158e4b3b8356.html | **Joule Studio Agent Catalog** — hangi agent genişletilebilir, extension point'leri. Yetkili kaynak. |
| https://www.leanix.net/en/blog/sap-leanix-announces-launch-of-ai-agent-hub-and-key-industry-partnerships | SAP AI Agent Hub (LeanIX): SAP + SAP dışı agent ve MCP envanteri (GA mı değil mi belirsiz) |

## Alan bazında hazır agent'lar

- **Finance:** Financial Closing agent'ları (Accruals — genişletilebilir, Journal Entry Verification, Intercompany Matching, Asset Accounting Anomaly, Receivables/Payables Clearing); Dispute Resolution (beta Q1); Cash Management (GA Q1, doğrulanmadı); Project Billing Price Verification (beta Q2); GRC asistanları. https://www.sap.com/use-cases/joule-assistant/financial-closing-ai
- **Spend / Procurement:** Expense Report Validation (GA), Expense Automation (GA Q2), Ariba Sourcing Negotiation ve RFx Builder (genişletilebilir), Bid Analysis, AP Invoice Agent (extension tutorial'ı: https://developers.sap.com/tutorials/joule-studio-agent-extension.html).
- **Supply chain / üretim / varlık:** Supply Chain Planning (Exception Management, Inventory Investment Allocation, Supply Plan Explainability); Asset Operations'ta 12 agent (bakım talebi, planlama, teknisyen brifingi, iş kapanışı) https://www.sap.com/use-cases/joule-assistant/asset-operations-ai; Project Setup (beta). SAP Connect 2026'da tasarım, tedarikçi, planlama, üretim, lojistik agent'ları duyuruldu, çoğu EAC 2027 Q1 (doğrulanmadı).
- **HR:** ~14 asistan (işe alım, payroll, eğitim, HR servis). 2026'da yeni HR agent'ı yok.
- **CX:** Catalog Optimization (Commerce, GA), Order Reliability (beta Q2), Case Classification (Service Cloud 2.0).
- **IT / platform:** S/4HANA custom code migration (GA Q2), Process Consulting (GA Q2), LeanIX Enterprise Content Research (GA Q2), Datasphere Tenant Health Check (EAC).
- **Sektörler:**
  - **Utilities:** Customer Self-Service Agent (GA, Q4 2025). Planlanan 4 meter-to-cash agent (ASUG, 27.05.2026, https://www.asug.com/insights/sap-bets-on-ai-agents-to-tame-utilities-most-complex-workflow): Billing Document (hedef Q3 2026), **Implausible Meter Reading Resolution**, **Outsorted Invoicing Document Resolution**, Utilities Tariff (PoC). BPEM agent konfigürasyon rehberi NDA (doğrulanmadı).
  - **Tender Analysis Agent** (GA Q1, hangi sektör belli değil).
  - **Sapphire 2026 "Industry AI" — 7 otonom senaryo** (sadece duyuru): Asset Management (oil/gas/energy), Adaptive Production (industrial manufacturing), Commodity Management (agribusiness), Project Delivery (professional services), Regulated Manufacturing (life sciences), Revenue Growth Management (consumer products), Unified Commerce (retail). https://www.techzine.eu/blogs/applications/141310/sap-launches-the-autonomous-enterprise-at-sapphire-2026/

## SAP agent'ını genişletme (Agent Extension)

Kaynak: https://help.sap.com/docs/JOULESTUDIO/7e496fe6f81f4975aec07d9c1cbd2aef/2773637bdbd74e54a7059e271910c7df.html · kurs: https://learning.sap.com/courses/introducing-joule-studio/extending-a-standard-agent-using-joule-studio_fa8fe90b-a044-48e2-aed8-5c52df401f35

- Akış: Joule Work → Joule Studio → New → Extension → Agent Catalog'dan agent seç → niyet yaz → spec → YAML extension → admin Agent Extension Runtime'a deploy eder. Ana agent değişmez.
- Üç yapı taşı: **Instructions** (prompt'a eklenir), **Tools** (MCP server, ör. S/4HANA MCP), **Hooks** (agent öncesi/sonrası n8n workflow).
- **GA kısıtları (hackathon için kritik):** sadece Instructions çalışıyor, Tools ve Hooks feature flag arkasında "coming soon" → sahada aktif mi sor. Extension CLI'dan (`jl`) yapılamıyor, sadece web UI. Agent başına tek extension. Tüm kullanıcılara uygulanır. Joule Studio Administrator rolü gerekir.
- **Sonuç:** sadece talimat ekleyen extension demoda zayıf kalır. Fikir tool/hook gerektiriyorsa özel agent (Yol A `jl` agent asset veya Yol B A2A) daha güvenli.

## Boşluklar (hackathon fırsatı)

- **Public sector:** SAP agent'ı bulunamadı.
- **Healthcare:** SAP'den yok (sadece partner). Life sciences'ta sadece clinical supply.
- **Automotive:** basında geçiyor, isimli agent yok.
- **Retail:** Unified Commerce senaryo seviyesinde; mağaza operasyonu, replenishment, markdown/fiyatlama açık. Catalog Optimization ve Order Reliability ile çakışmaya dikkat.
- **Utilities:** meter-to-cash SAP'nin yol haritasında (billing, outsorting, implausible reading, tariff) → **buraya girme**. Açık alanlar: şebeke/varlık operasyonu, enerji ticareti/settlement arayüzü, korunmalı müşteri kurallı kesme/ihtar (dunning), regülasyon raporlaması.
- **Oil/gas/energy, EC&O:** sadece senaryo duyurusu.
- **Sektörler arası:** analitik katman (BW/Datasphere/SAC) ile kaynak sistem mutabakatı, araçlar arası KPI tanım tutarlılığı, lineage tabanlı etki analizi, task chain / process chain hatası kök neden analizi, AI Unit / capacity unit FinOps, analitik regresyon testi.

İlgili kit dosyası: `beyin/ai/kavramsal/joule-agent-katalogu-ve-bosluklar.md` (Ekim notu; extension GA kısıtı ve yukarıdaki yeni agent'lar o notta yok).
