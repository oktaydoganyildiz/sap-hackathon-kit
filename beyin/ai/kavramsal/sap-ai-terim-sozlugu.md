---
tur: konu
alan: ai
kategori: kavramsal
urun_surumu: "2026-10"
tarih: 2026-10-26
guven: topluluk
gozden_gecir: 2027-04-26
---

# SAP AI terim sözlüğü (Ekim 2026)

## Özet
SAP'nin yeni AI terimlerinin her biri 2-3 cümleyle. Kaynak çoğunlukla topluluk blogu (zequance.ai) ve SAP Help;
"(doğrulanmadı)" işaretli satırlar resmi dokümanla teyit edilmedi. Ürün adları hızlı değişiyor, `gozden_gecir`
tarihinde yeniden bak.

## Vizyon ve şemsiye terimler
- **SAP Business AI:** SAP'nin bütün yapay zeka ürünlerinin pazarlama çatısı. Joule, gömülü AI özellikleri ve AI
  servisleri bunun altında.
- **Autonomous Enterprise:** SAP'nin hedef tablosu: insan yönü verir, Joule niyeti anlar, ajanlar işi SAP verisi ve
  onay kurallarıyla yürütür. İnsan yalnız kritik adımda onaylar.
- **SAP Autonomous Suite:** Vizyonun uygulama tarafı. Finance, Spend, SCM, HCM ve CX alanlarında assistant'lar işi
  koordine eder, agent'lar yürütür.
- **SAP Business AI Platform:** BTP + Business Data Cloud + AI servisleri tek çatı. Amacı: build, contextualize,
  reason, govern.
- **Industry AI:** Sektöre özel süreç, veri modeli ve mevzuat bilgisi gömülü AI (Utilities gibi dikeyler —
  doğrulanmadı).
- **RISE / GROW with SAP:** Buluta geçiş paketleri; RISE mevcut müşteri, GROW yeni başlayan için. Artık geçişi
  hızlandırmak için ajan da kullanıyorlar.

## Joule ailesi
- **Joule:** SAP'nin sohbet asistanı, sistemlere giriş kapısı. S/4'ün içinde değil BTP'de çalışır; S/4'e bağlanmak
  için Work Zone ve Cloud Identity Services gerekir.
- **Joule Skill:** Adımları sabit, her seferinde aynı sırayla çalışan iş. Kontrol listesi takip eden yardımcı.
- **Joule Agent:** Hedef verilir, adımları kendisi planlar, tool çağırır, duruma göre yön değiştirir. Muhakeme
  gerektiren iş için.
- **Joule Studio (classic):** SAP Build içinde skill ve agent'ı sürükle-bırak kurma ortamı. MCP server bağlanabilir
  ama principal propagation yok (teknik kullanıcı). Ücretsiz trial yok, SAP Build lisansı şart.
- **Yeni Joule Studio (Intent-Based Development):** Low-code tarayıcı + pro-code (`jl` CLI, Claude Code/OpenCode,
  MCP). SAP-managed runtime'a deploy.
- **Bring Your Own Agent / A2A:** Kendi kodunla yazılmış ajanı A2A protokolüyle Joule'e bağlarsın, Joule işi ona
  devreder.
- **Joule for Developers:** Geliştirici asistanı. SAP Build Code'da tek cümleden CAP + Fiori elements iskeleti
  (`/fiori-gen-spec-app`), ADT'de ABAP kod tamamlama ve unit test üretimi.
- **ABAP AI SDK (ISLM):** ABAP kodunun içinden Generative AI Hub modellerini çağırma kütüphanesi; ABAP programına
  LLM gömmek için.

## AI altyapısı (BTP)
- **AI Foundation:** BTP'deki AI servislerinin toplu adı: AI Core, AI Launchpad, Generative AI Hub, hazır AI
  servisleri.
- **SAP AI Core:** Modelleri çalıştıran motor. Planlar: `free`, `standard`, `extended`; Generative AI Hub yalnız
  `extended`'da.
- **SAP AI Launchpad:** AI Core'un yönetim ekranı: model deploy, prompt deneme, kullanım izleme.
- **Generative AI Hub:** Tek (harmonized) API'den Claude, GPT, Gemini, Llama ve SAP modelleri. Model değişince kod
  değişmez; ücret AI unit'ten.
- **Orchestration:** Modele giden isteği tek çağrıda boru hattından geçirir: grounding, templating, translation,
  data masking, content filtering. Regüle sektörde AI'ı güvenli kılan katman.
- **Grounding:** Model cevabını şirket verisine/dokümanına dayandırmak; SAP'deki RAG karşılığı.
- **Data Masking:** Müşteri adı, IBAN gibi alanları modele gitmeden anonimleştirir/pseudonimleştirir; pseudonim
  cevapta otomatik geri açılır.
- **Prompt Registry / Prompt Optimizer:** Registry prompt'ları merkezi sürümler. Optimizer bir modele yazılmış
  prompt'u başka modele otomatik uyarlar (Not Diamond ortaklığı).
- **SAP-RPT-1:** Tablo verisinden tahmin yapan model (Relational Pretrained Transformer). Eğitim yok; örnek satır
  verip `[PREDICT]` ile işaretlersin. small: 8.000 satır / 64 kolon, large: 64.000 satır / 256 kolon
  (doğrulanmadı); 2.000 rastgele satır çoğu zaman yeter. Ön şart AI Core `extended`.

## Veri tarafı
- **SAP Business Data Cloud (BDC):** Datasphere + SAP Databricks + SAC + hazır data product'lar; AI'ın beslendiği
  veri katmanı.
- **HANA Cloud Vector Engine:** Metni/dokümanı embedding olarak saklar, anlama göre arar; RAG'in depo kısmı.
- **HANA Knowledge Graph Engine:** Veriyi ilişki grafiği olarak tutar (RDF/SPARQL, SQL ile birlikte). AI'ın iş
  nesneleri arası ilişki üzerinden akıl yürütmesi için.
- **SAP Knowledge Graph:** SAP iş nesneleri ve ilişkilerinden hazır graf; Joule ve ajanlar bağlamı buradan alır
  (doğrulanmadı).

## Hazır AI servisleri
- **Document Information Extraction:** Fatura, sipariş, sözleşmeden alan çıkarır. Şemayı sen tanımlarsın
  (header + item alanları), yapılandırılmış veri döner.

## İlgili
- [[ai/kavramsal/joule-agent-katalogu-ve-bosluklar]]
- [[araclar/joule-pro-code-a2a]]
- [[ai/baglanti/joule-studio-custom-mcp-destination-auth]]
- [[dersler/2026-10-15-sap-ai-core-extended-plan-kurulu-ama-model-durumu-icin-servi]]

## Kaynaklar
- https://zequance.ai/sap-autonomous-enterprise-explained/
- https://zequance.ai/unlock-cutting-edge-ai-techniques-with-sap-joule-studios-debut/
- https://zequance.ai/generative-ai-on-sap-btp-the-architecture-choices-you-need-to-understand/
- https://zequance.ai/sap-rpt-1-explained-saps-ai-model-for-predicting-outcomes-from-structured-business-data/
- https://zequance.ai/sap-joule-integration-s4hana/
- https://zequance.ai/sap-joule-brings-ai-power-to-abap-development-a-game-changing-update/
- https://zequance.ai/sap-joule-for-developers/
- https://zequance.ai/saps-bold-move-no-more-painful-prompt-engineering-for-new-models/
- https://help.sap.com/docs/AI_CORE/2d6c5984063c40a59eda62f4a9135bee/c7244c6a7e3b4ffc928a2564c216e7c7.html
- https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/3d9dfad0bc39468292d508f0808a12fe.html
