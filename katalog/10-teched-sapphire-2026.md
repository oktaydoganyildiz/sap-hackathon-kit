# Sapphire 2026 ve TechEd 2026: agent tarafındaki önemli duyurular

2026-11-05 araştırması. Sapphire ve TechEd'in Innovation News Guide sayfaları (HTTP 403) açılmadı; maddeler SAP News, SAP çalışanlarının Community yazıları ve sektör basınından alındı. "doğrulanmadı" yazanlar tek ya da ikincil kaynaktan.

## Sapphire 2026 (Orlando, 12 Mayıs)

Kaynak: https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/

- **Çatı vizyon "The Autonomous Enterprise":**
  - **SAP Business AI Platform:** BTP, Business Data Cloud ve Business AI tek bir yönetilen ortamda birleşiyor.
  - **SAP Autonomous Suite.**
  - **Joule Work:** Kullanıcı uygulama açmak yerine istediği sonucu söylüyor. Masaüstü, mobil ve ses üzerinden çalışıyor, SAP dışı sistemleri de kapsıyor.
- **SAP Knowledge Graph:** Agent'lara iş varlıklarının, süreçlerin ve aralarındaki ilişkilerin yapılandırılmış haritasını veriyor.
- **Sayılar:** 50'den fazla domain Joule Assistant, 200'den fazla uzman agent'ı yönetiyor. Örnek: Autonomous Close Assistant.
- **Partnerlere 100 milyon €'luk fon:** SAP agent'larının devreye alınması ve Joule Studio üzerinde partner agent'ları için.
- **Ortaklıklar:**
  - Anthropic: Claude, Joule agent'larında kullanılan modeller arasında.
  - Google Cloud ve Microsoft: iki yönlü agent'tan agent'a birlikte çalışma.
  - n8n: Joule Studio içinde görsel workflow.
  - NVIDIA OpenShell: Joule Studio'nun güvenli runtime'ı.
  - Mistral ve Cohere: veri egemenliği (sovereign) gerektiren model seçenekleri.
- **Yeni Joule Studio** (https://news.sap.com/2026/05/new-joule-studio-enterprise-scale-agentic-development/):
  - Niyetten yola çıkan akış: niyet, ardından gereksinim dokümanı (PRD), spec, kod, test ve canlı önizleme.
  - Pro-code framework'leri: LangChain, Pydantic AI, LlamaIndex.
  - Managed runtime: her agent kendi NVIDIA OpenShell sandbox'ında çalışıyor, uzun vadeli hafızası HANA Cloud'da duruyor.
  - **Tasarım tarafı (design-time) 2026 sonuna kadar müşteri ve partnerlere ücretsiz** (makul kullanım şartıyla).
- **Sektörel AI çözümleri:** 7 çözüm duyuruldu (Asset Management, Adaptive Production, Commodity Management, Project Delivery, Regulated Manufacturing, Revenue Growth Management, Unified Commerce). Ayrıntı ve boşluklar: `11-hazir-agentlar.md`.
  - **RWE örneği:** Açık deniz rüzgâr türbini arızalarında agent geçmiş olayları inceliyor, olası kök nedeni buluyor ve iş emrini önceden doldurulmuş olarak açıyor. Sektörel AI anlatısının vitrin örneği bu.

## TechEd 2026 (Berlin ve Virtual, ~27 Ekim)

- **Joule Studio GA aşamalı olarak açılıyor**, müşteri segmentine ve bölgeye göre genişliyor. Kaynak: CPO blogu (30 Ekim) https://community.sap.com/t5/technology-blog-posts-by-sap/joule-studio-empowers-teams-to-build-trusted-custom-agentic-solutions/ba-p/14493943
  - **IBD altı adım:** niyet (hızlı ya da adım adım), PRD, spec, çözüm, test ve eval, tek adımda deploy.
  - **Spec adımı:** Knowledge Graph üzerinden API buluyor, mevcut MCP server'ları tekrar kullanıyor.
  - **Web arayüzü ve CLI** aynı adımlardan geçiyor.
  - **Desteklenen araçlar:** VS Code, Claude Code, Cline ve GitHub. Framework olarak LangGraph, AutoGen ve LlamaIndex.
  - **Deploy:** agent otomatik olarak SAP AI Agent Hub'a ve Joule Work'e kaydoluyor.
  - **Yerleşik eval iki boyutlu:** teknik doğruluk ve iş değeri.
  - **Hazır agent'ları genişletme:** bugün sadece talimat eklenebiliyor. MCP tool'ları ve n8n hook'ları "yakında".
  - **Yol haritası:** Signavio ve BDC verisi Q4 2026'da, n8n ve SAP Domain Models Q1 2027'de.
  - **Erişim uyarısı:** Bazı tenant'larda Joule Studio hâlâ sadece Early Adopter Care (EAC) katılımcılarına açık. Hackathon ortamının buna takılıp takılmayacağı belirsiz.
- **`jl` CLI:** pro-code'un terminal yolu. İlk adımlar: https://community.sap.com/t5/technology-blog-posts-by-sap/unboxing-joule-studio-exploring-the-jl-cli-your-first-steps/ba-p/14495029 · SAP-RPT'yi IBD içinde karar modeli olarak kullanma: https://community.sap.com/t5/technology-blog-posts-by-sap/sap-rpt-as-the-decision-model-for-intent-based-development-in-joule-studio/ba-p/14509411
- **SAP Agent Memory Service GA:**
  - İki tür kayıt tutuyor: hafıza (anlamsal, vector search ile aranıyor) ve mesajlar (denetim logu). Her ikisi de agent ID ile çağıranın ID'si eşleşmesine göre ayrılıyor.
  - OData REST API var, Python için SAP Cloud SDK istemcisi isteğe bağlı.
  - Kendi HANA Cloud'unu getiriyorsun: `hana-agent-memory` planı, NLP açık olmalı.
  - Plan: tam yönetilen sürüm 2026 sonunda, Joule Studio entegrasyonu 2027'ye doğru.
  - https://community.sap.com/t5/technology-blog-posts-by-sap/give-your-ai-agents-long-term-memory-sap-agent-memory-service-is-now/ba-p/14510374
- **SAP Enterprise AI Gateway** (premium):
  - A2A, MCP, model çağrıları ve API'ler için tek bir kontrol katmanı.
  - Agent'ları ve MCP tool'larını AI Agent Hub'a karşı doğruluyor, model çağrısından önce kişisel veriyi (PII) maskeliyor.
  - Integration Suite ve API Management üzerine kurulu. Basına göre Q1 2027.
  - https://community.sap.com/t5/technology-blog-posts-by-sap/introducing-sap-enterprise-ai-gateway-control-and-visibility-across-agents/ba-p/14510567
- **Basından (ikincil kaynak, https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/):**
  - Dış agent'ların Joule agent'larını çağırabileceği bir giriş kapısı (agent gateway), tarih verilmemiş.
  - Runtime, seçili müşterilere Aralık 2026'ya kadar ücretsiz.
  - SAP-RPT-TS GA.
  - SAP-RPT-2.0 (anomali tespiti) ve Knowledge Graph'ın müşteri verisiyle kullanımı Q1 2027.
  - BDC Ontology Manager beta.
- **SAP-RPT-1.6, tabular orchestration ve RPT Playground API kullanılabilir:** https://community.sap.com/t5/artificial-intelligence-blogs-posts/sap-rpt-1-6-tabular-orchestration-and-rpt-playground-api-now-available/ba-p/14476066
- **Ücretsiz C_JSD sertifikası** (SAP Certified – Joule Studio Developer): 31 Aralık 2026'ya kadar bir deneme ücretsiz. Senaryo tabanlı, 2 saat, geçme notu %60. https://learning.sap.com/certifications/sap-certified-joule-studio-developer
- **Fiyat** (https://www.sap.com/products/artificial-intelligence/pricing.html):
  - Base AI ücretsiz.
  - SAP'nin hazır agent'ları 2026'da işlem başına 0,02 AI Unit.
  - Joule Studio runtime'ındaki özel agent'lar 2026 sonuna kadar ücretsiz.
  - Unit başına ~7 € rakamı doğrulanmadı.
- **SAP AI Agent Hub** (LeanIX tabanlı): agent, LLM ve MCP server kaydı tutuyor, trace ve karar logu gösteriyor. "Q3 2026'da GA" bilgisi doğrulanmadı.
- **Doğrulanmayanlar:** "SAP Company Memory" (sadece BT162 preview oturumu var). SAP MCP server'larının resmi tam listesi bulunamadı, sadece ABAP ADT MCP doğrulandı.

## Sunumda kullanılacak dil (jüri SAP'nin kendi kelimelerini duymak ister)

- **"Autonomous Enterprise":** SAP'nin kendi terimi. "AI-first" yerine bunu kullan.
- **"Almost right isn't good enough"** (Christian Klein): doğruluk ve güven, gösterişten önce gelir.
- **"Context is the moat":** agent'ın SAP bağlamına dayanması. Kaynaklar: Knowledge Graph, Signavio süreç modelleri, LeanIX mimari bağlamı, Domain Models, BDC verisi.
- **"Joule as the front door":** agent'ın son kullanıcıya Joule Work üzerinden ulaşması.
- **"Governed by design":** AI Agent Hub kaydı, iki boyutlu eval, Enterprise AI Gateway, sandbox'lı runtime, kullanıcının yetkisiyle çalışma (principal propagation).
- **"Open but governed":** A2A ve MCP ile birlikte çalışma, kendi framework'ünü getirme, n8n.
- **"Extend, don't modify":** clean core. Hazır agent'a hook ile eklenir, kendisi değiştirilmez.
- **İzlenebilirlik zinciri:** niyet, PRD, spec, kod, eval, deploy. Bu zinciri sunumda göster.

Jüri tahmini (çıkarım, kaynak yok): gerçek bir sektör süreci, SAP verisine dayanma, ölçülebilir KPI, eval ve guardrail, human-in-the-loop, Joule ile A2A ya da MCP üzerinden birlikte çalışma, managed runtime ve AI Agent Hub'a giden net bir yol.

## TechEd 2026 hands-on repoları (agent ile ilgili)

Hepsi `https://github.com/SAP-samples/teched2026-<KOD>` adresinde. Toplam 78 repo var. **Bize en yakın olanlar: AD161, AD263, XP268, AD262, DA263, XP269, AD164.**

| Grup | Kodlar |
|---|---|
| Joule Studio ile agent kurma | **AD161** (kur ve işlet), **AD263** (ilk pro-code agent), **AD164** (n8n), DA161 (data product) |
| Pro-code, A2A, MCP, gateway | **AD262** (Agentic CAP + MCP), **XP268** (Agent Gateway ile güvenli A2A), IN261 (governed MCP), XP270 (orkestrasyon ve izleme), XP266 (Kyma'da sandbox'lı ops agent) |
| Bağlam, hafıza, veri | XP267 (agent'a bağlam), **DA263** (Knowledge Graph ve hafıza), BT162 (Company Memory), DA164 (HANA Cloud), AS263 (doğal dille veri), DA260, DA160 |
| Tabular AI ve dokümanlar | **XP269** (agent içinde tabular model), RA162 (SAP-RPT-1), DA262, RA160, RA164 (Document AI) |
| Joule ve Joule Work | JW160, JW260 (ilk skill), JW261, JW161, JW163, JW164, AD266, AD264, AD265 |
| Yönetişim ve platform | BT160 (LeanIX MCP), BT161, XP262 (IAM), XP163, XP161 (FinOps), XP162 |
| İş alanı agent'ları | AS260 (Financial Closing), AS261 (Autonomous CX), AS262, AS264 (Sourcing), AD163 (Process Consulting), TM261, TM266, TM267 |
