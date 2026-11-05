# 11 · Hackathon Araştırması: Etkinlik, İnsanlar, SAP'nin Industry AI Yönü

> **Tek cümle:** Bu hackathonun kendisi hakkında internette hiçbir şey yok; ama organizatör ekibin (Office of the CTO for Industry AI) ne iş yaptığı, SAP'nin 2026'da hangi sektörlere agent koyduğu ve geçmiş SAP hackathonlarında jürinin neye puan verdiği belli, strateji bunun üstüne kurulur.

Araştırma tarihi: 2026-11-04. Etkinlik bilgileri için tek kaynak hâlâ davet maili ve PDF'ler (bkz. `../NOTLAR.md`).

---

## 1. Etkinliğin kendisi: kamuya açık bir şey yok

"SAP Industry AI Hackathon", "SAP Partner Hackathon", Münih Kasım 2026, MUE03 aramalarının hiçbiri bu etkinliğe çıkmadı. Ne SAP events sayfası, ne SAP Community yazısı, ne LinkedIn gönderisi var. Davetli ve kapalı bir etkinlik gibi duruyor.

**Elimizdeki tek doğrulanmış bilgi davet mailinden:** 9–12 Kasım, SAP Labs Munich Campus, Industry AI CTO ekibi düzenliyor, ilk gün Christian Wolf ve ekibi görevi anlatıyor, Perşembe sunum.

Karıştırılmaması gereken benzer etkinlikler (bizimki **değil**):

| Etkinlik | Ne | Kaynak |
|---|---|---|
| "Business meets AI" hackathon serisi | Müşteri kendi use case'ini getirir, 5 günde MVP. Zürih, Garching, Berlin, Viyana | https://news.sap.com/germany/?p=187513 |
| SAP Services Industries AI Hackathon (Garching) | Allianz, Munich Airport, Munich Re, Bechtle, DZ Bank ile 3 gün (tarih belirsiz, doğrulanmadı) | https://de.linkedin.com/in/svenhora |
| SAP BTP Hackathon 2026 (Japonya) | 54 şirket, 70 takım, 3 Temmuz 2026 final | https://news.sap.com/japan/?p=29072 |
| Hack2Build | SAP'nin partner hackathon programı, 7 günlük sprint | https://events.sap.com/hack2build/en_us/home.html |
| SAP Hackathon Zürih, 14.09.2026 | Business meets AI'ın İsviçre ayağı | https://www.sap.com/swiss/events/2026-09-14-ch-hackathon-business-meets-ai.html |

**Benzetme:** Bizimki "kapalı kapı antrenmanı", diğerleri "seyircili maç". Kurallarını Pazartesi soyunma odasında öğreneceğiz.

---

## 2. Organizatörler ve kişiler

### 2.1 Office of the CTO for Industry AI (oCTO)

İlk elden bir SAP sayfası bulamadım, ama SAP'nin iş ilanları bu ofisi şöyle tarif ediyor: SAP Business AI Platform (BAIP), Industry Product & Engineering, LoB uygulama ekipleri ve **stratejik müşterilerle yürüyen FDE (Forward Deployed Engineering) işlerinin kesiştiği yer**. İlan metnine göre "SAP's AI strategy comes to life" denen yer burası (ilan sayfası şu an 404, arama özetinden; doğrulanmadı).

- İlan: "Chief AI Product Expert for oCTO Industry AI". https://flexa.careers/jobs/sap-chief-ai-product-expert-for-octo-industry-ai-m-f-d-6acca13e82c05027d7cce684
- Ayrıca "Industry AI Product Strategy & Incubation" adında, S&O altında yeni bir birim var (arama özeti, doğrulanmadı). https://www.jobstairs.de/jobview/stellenangebot-internal-strategic-consulting-chief-expert-fmd-industry-ai-sap--2405450.html
- SAP'nin CTO'su ve Chief AI Officer'ı Philipp Herzig. https://falling-walls.com/foundation/people/philipp-herzig

**Bundan çıkan:** Prerequisite PDF'inin altbilgisi "FDE Enablement for AI Agents" diyordu. Yani bu ekip normalde **SAP'nin kendi Forward Deployed Engineer'larını** müşteri sahasına agent yazmaya hazırlıyor, aynı eğitimi şimdi partnerlere açıyor. Görev büyük ihtimalle "gerçek bir müşteri/sektör problemine hızlıca çalışan agent kur" tipinde olacak (doğrulanmadı).

### 2.2 FDE (Forward Deployed Engineer) rolü

SAP'nin ABD'de "Forward Deployed AI Engineer (Agent Engineering)" ilanı var: müşteri ve product manager'la birlikte **üretim seviyesinde agent sistemleri** tasarlayıp deploy etmek.
- https://www.theladders.com/job/forward-deployed-ai-engineer-agent-engineering-sap-palo-alto-ca_87212626
- SAP'de "Forward Deployed Data Engineer" ilanları da var, yani veri tarafı da bu modelin parçası. https://www.hirebase.org/company/sap/jobs/forward-deployed-data-engineer-expert-bf9a7d2d

**Benzetme:** FDE, müşterinin yanına giden "saha cerrahı". Slayt değil, çalışan agent bırakır. Jüri büyük ihtimalle bu gözle bakacak.

### 2.3 Kişiler

| Kişi | Kamuya açık bilgi |
|---|---|
| Christian Wolf | Kamuya açık bir SAP/Industry AI bağlantısı **bulunamadı**. Aramalar CEO Christian Klein'a çıkıyor, karıştırma. |
| Rui Nogueira | Eski SAP HANA Cloud Platform ürün yöneticisi, openSAP eğitmeni (2016). 2021 civarı "VP Intelligent Enterprise & Cross Architecture", BTP ile Intelligent Suite entegrasyonu odaklı. 2026 rolü bulunamadı. https://cfsummiteu2016.sched.org/speaker/rui.nogueira · https://podcast.opensap.info/cloud-platform/?p=328 |
| Rebecca Muelberger, Arjun Kumar Rao, Aarthi Jayabal, Ayca Tacyildiz | Hackathonla ilişkilendirilebilecek kamuya açık içerik bulunamadı. |

Rui Nogueira'nın geçmişi "BTP + uygulama entegrasyonu + geliştirici eğitimi" olduğu için, BTP üstünde düzgün mimari (destination, IAS, CF) jürinin bir kısmına önemli görünecektir (çıkarım, doğrulanmadı).

---

## 3. SAP'nin 2026 Industry AI yönü

### 3.1 Sapphire 2026 (Mayıs): "Autonomous Enterprise"

- **SAP Business AI Platform:** BTP + Business Data Cloud (BDC) + Business AI tek ortamda birleşti. https://www.techzine.eu/blogs/applications/141310/sap-launches-the-autonomous-enterprise-at-sapphire-2026/
- **SAP Knowledge Graph:** müşterinin SAP ortamındaki iş nesnelerini, süreçleri ve ilişkileri tutan harita; agent'lara bağlam veriyor. (aynı kaynak)
- **Autonomous Suite:** 50+ Joule Assistant, 200+ uzman agent'ı yönetiyor. (aynı kaynak)
- **Claude (Anthropic)** Joule agent'larının temel modellerinden biri olacak. (aynı kaynak)
- **Joule Studio:** niyetten (doğal dil) PRD, kod iskeleti ve test üretiyor; yönetilen runtime (NVIDIA OpenShell sandbox), HANA Cloud tabanlı kalıcı hafıza, LangChain / Pydantic AI / LlamaIndex ile pro-code, gömülü n8n. Partner ve müşterilere 2026 sonuna kadar design-time ücretsiz. https://news.sap.com/2026/05/new-joule-studio-enterprise-scale-agentic-development/
- **Partnerlere 100 milyon € fon:** Joule Studio ile agent kurmaları için (birden fazla ikincil kaynak). https://reworked.co/digital-workplace/sap-unveils-autonomous-enterprise-100m-ai-fund/

### 3.2 Industry AI: yedi senaryo

Techzine'e göre Sapphire'da açıklanan yedi Industry AI alanı:

| Alan | Sektör |
|---|---|
| Asset Management | Petrol, gaz, enerji |
| Adaptive Production | Endüstriyel üretim |
| Commodity Management | Tarım ticareti (agribusiness) |
| Project Delivery | Profesyonel hizmetler |
| Regulated Manufacturing | Life sciences (ilaç) |
| Revenue Growth Management | Tüketim ürünleri (consumer goods) |
| Unified Commerce | Perakende (keynote demosu H&M) |

Kaynak: https://www.techzine.eu/blogs/applications/141310/sap-launches-the-autonomous-enterprise-at-sapphire-2026/

- Diğer kaynaklar listede farklılık gösteriyor; Digital Applied 5'ini sayıyor, "7–8" diyor (doğrulanmadı). https://www.digitalapplied.com/blog/sap-autonomous-enterprise-200-agents-sapphire
- SAPinsider, ilaç üretiminde **tam otomatik batch release**'in Industry AI senaryosu olarak gösterildiğini yazıyor. https://sapinsider.org/blogs/sap-industry-ai-what-business-data-models-and-agent-controls-have-to-deliver/
- **Utilities** yedi senaryoda yok; en yakını enerji varlıkları için Asset Management.

**Bundan çıkan:** Industry AI CTO ekibinin görevi büyük ihtimalle bu yedi alandan birine oturacak (doğrulanmadı). Bu yediye hazırlıklı gitmek mantıklı.

### 3.3 TechEd 2026 (Berlin, 27 Ekim): son durum

- **Joule Work:** A2A ve MCP kullanan, çok adımlı süreçleri planlayıp yürüten orkestrasyon katmanı. https://www.techzine.eu/blogs/applications/145290/major-sap-joule-update-prepares-agents-for-complex-processes/
- **Governed agent gateway:** dışarıdaki agent'lar Joule Agent'larını erişim kontrolüyle çağırabiliyor (zamanlama belirtilmemiş). (aynı kaynak) Ayrıntı: `09-agent-gateway-inbound.md`.
- **Joule Studio:** 70+ modele erişim; custom agent'ları SAP'nin runtime'ında çalıştırmak seçili müşterilere Aralık 2026'ya kadar ücretsiz. Studio'da kurulan agent'lar AI Agent Hub ve Joule Work'te görünüyor. https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/
- **Veri tarafı (bizim alan):** SAP Knowledge Graph SAP dışı kaynaklardan veri çekecek (Q1 2027), **BDC Ontology Manager** beta (Q1 2027), Dremio tabanlı BDC lakehouse (Iceberg, Polaris; GA Q1 2027), **Joule + Databricks Genie entegrasyonu** duyuruldu (tarih yok). (aynı kaynak)
- **Tabular AI:** SAP-RPT-TS (IBP'de talep tahmini) GA; SAP-RPT-2.0 anomali/outlier tespitiyle Q1 2027. Prior Labs (TabPFN) Temmuz'dan beri SAP'nin. (erp.today ve techzine)
- **Enterprise AI Gateway:** tüm AI trafiği için auth, policy, izleme (Q1 2027). (erp.today)

**Benzetme:** SAP şu an "veri + bağlam + agent" üçlüsünü satıyor. Bizim Datasphere/BW/BDC bilgimiz bu üçlünün tam ilk ayağı.

---

## 4. Geçmiş SAP hackathonlarında jüri neye baktı

| Hackathon | Kriterler | Kaynak |
|---|---|---|
| SAP BTP Hackathon 2026 (Japonya) | Business impact, innovation, usability, technical completeness, market deployability | https://news.sap.com/japan/?p=29072 |
| Business meets AI (Zürih/Garching/Berlin) | Süre içinde yapılabilir mi? Ölçülebilir iş değeri var mı? Standart SAP'de zaten yok mu? Zürih ödülleri: Real World Impact, Technology Factor, Wow Factor, CTO Award | https://news.sap.com/germany/?p=187513 |
| Hack2Build Business AI (Ekim 2024) | Teknik yapılabilirlik ve müşteri alaka düzeyi; resmi puan tablosu yayınlanmamış | https://community.sap.com/t5/technology-blogs-by-sap/partners-innovate-with-ai-solutions-using-sap-business-ai-and-sap-btp/bc-p/13925974 |
| SAP hackathon katılım rozeti | Pitch + BTP üstünde **çalışan prototip** sunmak | https://www.credly.com/org/sap/badge/hackathon-participation-award |

### 4.1 Kazanan örnekleri (bize yakın olanlar)

- **Japonya büyük ödül, TISI "Joule Autonomous Enterprise Navigator":** Joule'yü yönetim kararı ortağı yapıyor. BDC'deki ERP verisini dış piyasa verisiyle birleştirip KPI'ları sürekli izliyor; bozulma olunca kök neden, senaryo ve seçenek üretiyor; yönetici onaylayınca workflow tetikliyor. Teknoloji: Joule Studio, AI Core, Build Process Automation, CAP, BDC, HANA Cloud knowledge graph. Birden çok AI "persona" sonucu çapraz kontrol ediyor. İddia: KPI bozulmasına ilk tepki 5 iş gününden 15 dakikaya. https://news.sap.com/japan/?p=29072
- **Business meets AI kazananları:** Clariant (faturada vergi kodu, hata %45 → %4), Deutsche Bahn (yılda 500.000 mail sınıflandıran agent), **Schwarz IT (BDC ile mağaza planlamasını birleştirip tahmin doğruluğunu artırma)**, Sto (ihale dokümanı işleme, yılda ~2.000 saat tasarruf). Ortak nokta: **somut sayı** ve gerçek süreç. https://news.sap.com/germany/?p=187513

### 4.2 Bundan çıkan dersler

1. **Sayı söyle.** Kazananların hepsinde "X'ten Y'ye" var (hata oranı, süre, saat). Pitch'te bir tane sağlam sayı şart.
2. **Çalışan prototip, slayt değil.** Hem rozet kriteri hem FDE kültürü bunu istiyor.
3. **Standart SAP'de olmayanı yap.** "Joule zaten bunu yapıyor" denirse puan gider. 200+ hazır agent'la çakışmamaya dikkat.
4. **Veri + karar + aksiyon döngüsü kazanıyor.** Japonya kazananı tam olarak bizim alan: BDC verisi üstünde KPI izleme, kök neden, insan onayı, aksiyon.
5. **Human-in-the-loop** ve güven/doğrulama mekanizması (çoklu persona, kaynak gösterme) artı puan. Bkz. `01-a2a.md` §3.3 (`input-required`).
6. **Ödül kategorileri ayrı ayrı oynanabilir:** Real World Impact, Technology, Wow, CTO Award. CTO ekibi düzenlediği için "CTO Award" tipi bir teknik vizyon ödülü olabilir (doğrulanmadı).

---

## 5. Neleri bilmen lazım (kontrol listesi)

- [ ] Etkinlik hakkında kamuya açık bilgi yok; her şeyi Pazartesi brifingden öğreneceğiz.
- [ ] oCTO Industry AI ne yapar? (BAIP + industry ürün ekipleri + FDE'nin kesişimi)
- [ ] FDE ne demek, jüriyi nasıl etkiler? (çalışan, müşteri sahasına konabilir agent)
- [ ] Yedi Industry AI alanını sayabiliyor musun?
- [ ] Business AI Platform hangi üç şeyi birleştirdi? (BTP, BDC, Business AI)
- [ ] Knowledge Graph ve BDC'nin agent'lar için rolü ne?
- [ ] Geçmiş hackathonların ortak jüri kriterleri neler? (iş değeri, yapılabilirlik, yenilik, teknik bütünlük, standartta olmaması)
- [ ] Japonya kazananı ne yaptı, bizim fikrimiz ondan nasıl ayrışıyor?

Strateji ve senaryolar: `10-hackathon-stratejisi.md`. Yol haritası: `00-yol-haritasi.md`.

---

## Kaynaklar

- SAP News (DE), KI-Hackathons als Innovationsmotor, 28.05.2026. https://news.sap.com/germany/?p=187513
- SAP News (JP), SAP BTP Hackathon 2026 sonuçları. https://news.sap.com/japan/?p=29072
- SAP News, New Joule Studio for enterprise-scale agentic development, Mayıs 2026. https://news.sap.com/2026/05/new-joule-studio-enterprise-scale-agentic-development/
- Techzine, SAP launches the Autonomous Enterprise at Sapphire 2026. https://www.techzine.eu/blogs/applications/141310/sap-launches-the-autonomous-enterprise-at-sapphire-2026/
- Techzine, Major SAP Joule update prepares agents for complex processes (TechEd 2026). https://www.techzine.eu/blogs/applications/145290/major-sap-joule-update-prepares-agents-for-complex-processes/
- ERP Today, SAP TechEd 2026: What's Rolling Out and What's Planned Through 2027. https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/
- SAPinsider, SAP Industry AI: business data models and agent controls. https://sapinsider.org/blogs/sap-industry-ai-what-business-data-models-and-agent-controls-have-to-deliver/
- Digital Applied, SAP Autonomous Enterprise: 200 agents. https://www.digitalapplied.com/blog/sap-autonomous-enterprise-200-agents-sapphire
- Reworked, SAP unveils Autonomous Enterprise, 100M AI fund. https://reworked.co/digital-workplace/sap-unveils-autonomous-enterprise-100m-ai-fund/
- İlan, Chief AI Product Expert for oCTO Industry AI (sayfa 404, arama özeti). https://flexa.careers/jobs/sap-chief-ai-product-expert-for-octo-industry-ai-m-f-d-6acca13e82c05027d7cce684
- İlan, Internal Strategic Consulting Chief Expert Industry AI. https://www.jobstairs.de/jobview/stellenangebot-internal-strategic-consulting-chief-expert-fmd-industry-ai-sap--2405450.html
- İlan, Forward Deployed AI Engineer (Agent Engineering). https://www.theladders.com/job/forward-deployed-ai-engineer-agent-engineering-sap-palo-alto-ca_87212626
- İlan, Forward Deployed Data Engineer Expert. https://www.hirebase.org/company/sap/jobs/forward-deployed-data-engineer-expert-bf9a7d2d
- Philipp Herzig profili. https://falling-walls.com/foundation/people/philipp-herzig
- Rui Nogueira, CF Summit EU 2016. https://cfsummiteu2016.sched.org/speaker/rui.nogueira
- Rui Nogueira, openSAP podcast. https://podcast.opensap.info/cloud-platform/?p=328
- Sven Hora LinkedIn (Services Industries AI Hackathon Garching, arama özeti). https://de.linkedin.com/in/svenhora
- Hack2Build Business AI blog. https://community.sap.com/t5/technology-blogs-by-sap/partners-innovate-with-ai-solutions-using-sap-business-ai-and-sap-btp/bc-p/13925974
- Credly, SAP Hackathon Participation Award. https://www.credly.com/org/sap/badge/hackathon-participation-award
- apsolut, Joule Agent Hackathon flyer (partnerin 5 günlük sprint formatı: kapsam → iskelet → tool'lar → test → deploy). https://www.ap-solut.com/files/apsolut2025/dateien/jouleagenthackathon-flyer-de.pdf
