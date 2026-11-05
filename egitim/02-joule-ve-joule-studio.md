# 02 · Joule ve Joule Studio

> **Tek cümle:** Joule, kullanıcının konuştuğu tek kapıdır ve isteği doğru skill'e ya da agent'a dağıtır. Joule Studio ise bu skill ve agent'ları tıklayarak (low-code) veya kodla (pro-code) ürettiğin atölyedir.

---

## 1. Joule ne iş yapar? (orkestra şefi)

Joule, SAP'nin AI asistanı. Kullanıcı S/4HANA'da, SuccessFactors'ta, BTP cockpit'te sağ üstteki Joule penceresine yazar. Joule kendisi her işi bilmez. İşi kimin yapacağına karar verir.

**Benzetme:** Joule bir otelin **resepsiyonu**. Misafir "odama havlu lazım" der. Resepsiyon havluyu kendisi getirmez, kat görevlisine iletir. "Restoranda yer ayırt" derse restorana iletir. Misafir kat görevlisini tanımak zorunda değildir.

```
Kullanıcı: "Geciken faturalarımı göster ve kaybettiğim iskontoyu hesapla"
   │
   ▼
 Joule (planlama motoru)
   │  1. İsteği anla
   │  2. Elindeki listeden en uygun olanı seç:
   │       - SAP'nin hazır skill'leri / agent'ları
   │       - Senin Joule Studio'da yaptığın skill / agent
   │       - Senin dışarıda yazdığın agent (A2A, BYOA)
   ▼
 Seçilen skill / agent işi yapar  ──►  Sonuç Joule'ye döner  ──►  Kullanıcıya gösterilir
```

Joule'nin içindeki terimler (detay `08-joule-cli-capability.md`'de):

| Terim | Ne demek |
|---|---|
| **Digital assistant (DA)** | Joule'nin bir kopyası. Üretimdeki adı `sap_digital_assistant`. Sen test için kendi adınla bir tane daha açabilirsin. |
| **Capability** | Bir iş paketi. İçinde birkaç scenario ve function vardır. |
| **Scenario** | "Kullanıcı şunu sorarsa beni çağır" tarifi. Joule bu açıklamaya bakarak seçim yapar. |
| **Function (dialog function)** | Scenario seçilince çalışan adımlar: API çağır, agent çağır, mesaj göster. |
| **Skill** | Kural tabanlı, tekrar eden iş yapan küçük birim. Belirli bir API'yi çağırır, hep aynı şekilde davranır. |
| **Agent** | Kendi kafasıyla plan yapan, gerekirse birden fazla tool çağıran birim. |

**Akılda tutma cümlesi:** *Skill bir tarif kartıdır, agent ise aşçıdır. Kart hep aynı yemeği çıkarır; aşçı elindeki malzemeye bakıp karar verir.*

---

## 2. SAP'nin hazır agent kataloğu (önce "SAP zaten yapıyor mu?" diye bak)

SAP kendi Joule agent'larını hazır veriyor. Hiyerarşi şöyle: bir **Joule Assistant**, birden çok **Joule Agent**'ı yönetir.

- sap.com'daki katalogda **67 assistant** var (Ekim 2026 sayımı).
- Sapphire 2026'da **224 agent, 51 assistant** açıklandı. Yıl sonu hedefi "400+ agent" (ikincil kaynak, doğrulanmadı).
- Kapsanan alanlar: Finance (AR, AP, closing, consolidation…), Governance (SoD, GRC), Spend, Supply Chain, HR, CX, ESG, Migration (custom code, test, data quality).

**Hackathon için kritik boşluk:** Katalogda **Data & Analytics** alanında hiç assistant yok. Şu işleri yapan hazır agent yok:
- S/4 ile BW/Datasphere/SAC arasında "rakamlar tutmuyor" teşhisi (mutabakat)
- Aynı KPI'ın BW query, analytic model ve SAC story'deki tanım farkı
- Process chain / task chain / replication flow hatasında kök neden bulma
- BTP / Datasphere tüketim (FinOps) takibi

Bu, senin uzmanlık alanın. Fikir seçerken bu listeye bak (`10-hackathon-stratejisi.md`).

⚠️ "SAP'de yok" demeden önce ilgili assistant sayfasının agent listesine bak. Liste her ay büyüyor.

---

## 3. İki tane "Joule Studio" var (kafa karışıklığının kaynağı)

Ekim 2026 itibarıyla SAP iki ayrı ürünü aynı isimle anıyor. Dokümanda hangisine baktığını kontrol et.

| | **Joule Studio, classic edition** | **Joule Studio (yeni, IBD)** |
|---|---|---|
| Nerede durur | SAP Build içinde (Control Tower, Lobby) | SAP Business AI Platform, ayrı arayüz |
| Nasıl çalışır | Formlarla skill ve agent tanımlarsın | Niyetini yazarsın, AI sırayla PRD → spec → kod → test → deploy üretir |
| Low-code | Görsel editör (skill builder + agent builder) | Tarayıcıdaki Joule Studio builder |
| Pro-code | `joule` CLI (YAML capability) | `jl` CLI + Claude Code veya OpenCode |
| Nerede çalışır | Joule'nin içinde (SAP yönetir) | SAP-managed runtime (SAP yönetir) |
| Durum | Yaygın, belgeli. Generative AI özellikleri (vibe coding) **Ocak 2027'de kalkıyor** | Yeni. Mimari sayfası 26 Ekim 2026 tarihli |

**IBD (Intent-Based Development)** altı adımdan oluşuyor: Intent → Requirements (PRD) → Specification → Solution (kod üretimi) → Testing (unit test + AI eval) → Deployment. Hem low-code hem pro-code yolu aynı adımlardan geçer ve sonunda Joule'ye otomatik kayıt olan aynı tür çıktı üretir.

Yeni Joule Studio'da üretilen bir agent'ın içi şöyle: `main.py` (Agent Card, skill'ler, A2A server ayarı) ve `agent.py` (system prompt, LangGraph akışı, LLM çağrısı LiteLLM ile). Yani yeni Joule Studio da altta A2A konuşan bir Python agent'ı üretiyor (`01-a2a.md`).

⚠️ **Hackathon notu:** Ön koşul listesinde hem "joule CLI" hem "Claude Code via Hyperspace" var. `@sap/joule-studio-cli` paketi kurulunca iki komut birden gelir: `joule` (classic, YAML capability) ve `jl` (yeni Joule Studio, Claude Code ile çalışır). Organizatörün hangisini kullandıracağı belli değil (doğrulanmadı). İkisine de hazırlıklı ol: `08-joule-cli-capability.md` `joule`'yi, bu dosyanın 5.3 bölümü `jl`'yi anlatıyor.

---

## 4. Low-code: Joule Studio classic'te skill ve agent

### 4.1 Joule Skill (skill builder)

Skill, deterministik bir iş yapar: bir input alır, bir API'yi çağırır, sonucu döner. API bağlantısı **SAP Build Actions** ile kurulur: API spec'ini (OpenAPI, OData) yüklersin ya da action'ı sıfırdan tanımlarsın. Arkasında BTP **destination** durur.

Örnek: "Sipariş numarası ver, durumunu getir." Hep aynı API, hep aynı sonuç.

⚠️ SAP Build Actions dinamik çıktıyı tam desteklemiyor. Her sorguda yapısı değişen bir sonuç (örn. serbest SQL sonucu) dönersen takla atman gerekir (topluluk kaynağı, workaround tarif edilmemiş).

### 4.2 Joule Agent (agent builder)

Agent'ı bir formla tanımlarsın:

| Alan | Ne yazarsın |
|---|---|
| **Name / Description** | Joule seçim yaparken buna bakar. Anahtar kelimeleri koy. |
| **Expertise** | Rolü. "Sen bir alacak hesapları uzmanısın." Kısa tut. |
| **Instructions** | Her zaman ne yapacağı. Doldurursan agent sadece bunu yapar. Sohbet eden agent istiyorsan boş bırak. |
| **Additional Context** | `##` ile başlayan ek kurallar. "Soru X ise şu tool'u tercih et." |
| **Model Settings** | Base Model (cevabı yazan), Advanced Model (planı yapan ve tool seçen), isteğe bağlı Backup LLM |
| **Execution Steps** | En fazla kaç "düşünme adımı". Ön işlem (planlama) ve son işlem (cevabı toparlama) açılıp kapanır. |
| **Tools** | Document grounding, Calculator, Joule skill. Ayrıca aynı projedeki başka agent'lar subagent olarak eklenir. |
| **MCP servers** | Dış uygulamaya bağlanmak için MCP server eklenebilir |
| **Output format** | Text, Markdown, JSON, Data Type. Text/Markdown'da "Joule yorumlasın" seçeneği var. |

**Benzetme:** Agent builder bir **iş ilanı formu** gibi. Pozisyonu (expertise), görev tanımını (instructions), kullanacağı aletleri (tools) yazarsın. Mülakat yok, işe başlar.

Agent builder EU10 dahil 10 data center'da çalışıyor. Tarayıcı olarak yalnız Chrome ve Edge destekleniyor.

### 4.3 Document grounding (agent'a doküman okutmak)

Agent'ın senin dokümanlarına (PDF, SharePoint sayfası) dayanarak cevap vermesi. Arkada **AI Core'daki grounding servisi** (RAG) çalışır: dokümanları parçalara böler, vektöre çevirir, soru gelince en alakalı parçaları bulur.

```
SharePoint / doküman deposu
        │  (pipeline: parçala → vektöre çevir)
        ▼
 AI Core Document Grounding
        ▲
        │  "Global Health Safety hakkında ne diyor?"
 Joule Agent (tool: Document grounding)
```

- **Low-code'da:** agent'a "Document grounding" tool'unu eklemen yeter.
- **Pro-code'da:** `api-request` action'ı ile `system_alias: JOULE_GLOBAL_DOC_GROUNDING`, path `/retrieval/search`. Bu alias için destination açmana gerek yok, sabit bir değer (`08-joule-cli-capability.md`).

Topluluk örneği (text-to-SQL agent): Agent'a document grounding ile tablo şemasını, örnek SQL'leri ve iş bağlamını vermişler. Agent soruyu SQL'e çeviriyor, ayrı bir skill SQL'i çalıştırıyor. SQL kalitesi tamamen grounding dokümanlarının kalitesine bağlı.

### 4.4 Low-code ne zaman yeter?

Yeter:
- İş birkaç API çağrısından oluşuyorsa (sipariş durumu, onay akışı)
- Agent'ın tool'ları SAP Build Actions, MCP veya document grounding ile bağlanabiliyorsa
- Hız önemliyse ve kodun içini göstermek gerekmiyorsa

Yetmez:
- Kendi framework'ünü (LangGraph, CrewAI) veya kendi algoritmanı (tahmin modeli, optimizasyon) kullanmak istiyorsan
- Python kütüphanesi lazımsa (pandas, hana-ml, SAP-RPT-1)
- Agent'ın iç akışını adım adım kontrol etmek istiyorsan (Human-in-the-Loop, özel hafıza)
- Dinamik yapıda büyük veri dönüyorsa

---

## 5. Pro-code: üç yol

### 5.1 `joule` CLI ile YAML capability

Joule'nin içine YAML dosyalarıyla scenario ve function yazarsın. Kod değil, tarif yazarsın. Tamamı `08-joule-cli-capability.md`'de.

### 5.2 BYOA (Bring Your Own Agent), A2A ile ⭐ hackathon varsayımı

Agent'ı kendin yazarsın (Python, LangGraph), BTP'de kendi subaccount'unda çalıştırırsın (Cloud Foundry veya Kyma). Joule'ye bağlantı, 5.1'deki YAML içindeki `agent-request` action'ı ile kurulur.

```
Joule ──(capability: scenario → function → agent-request)──► Destination ──A2A──► Senin agent'ın (CF/Kyma)
```

Detay: `01-a2a.md` (protokol), `07-pro-code-agent.md` (agent kodu), `08-joule-cli-capability.md` (Joule tarafı).

### 5.3 Yeni Joule Studio, `jl` CLI + Claude Code

`jl init claude` komutu proje klasörüne Joule Studio skill'lerini ve MCP ayarını (`.mcp.json`) yazar. Claude Code içinde `/` yazınca IBD skill'leri görünür. Agent'ı Claude Code'la birlikte yazarsın, `jl solution deploy` ile SAP-managed runtime'a gider ve Joule'ye otomatik kayıt olur.

- `jl` için Node.js 24+ gerekiyor.
- Login: Joule Studio'da kullanıcı ikonu → Settings → Develop → "CLI Authentication setup" altındaki Sign-in URL'yi kopyala, `jl login "<url>"`.

⚠️ Joule Studio'ya erişim hesabı ve landscape'i organizasyondan alınıyor. Hackathon'da verilip verilmeyeceği belli değil (doğrulanmadı).

---

## 6. Karar tablosu: low-code mu, pro-code (BYOA) mu?

| Soru | Low-code (Joule Studio classic) | Pro-code BYOA (A2A) |
|---|---|---|
| Kim yapar | İş analisti, citizen developer | Geliştirici |
| Agent mantığı nerede | SAP'nin agent motorunda | Senin kodunda (LangGraph vb.) |
| Nerede çalışır | SAP yönetir | Senin BTP subaccount'un (CF/Kyma) |
| Tool bağlama | SAP Build Actions, MCP, document grounding, Joule skill | İstediğin her şey: MCP, Python kütüphanesi, AI Core, HANA |
| LLM seçimi | Formdan seçersin | AI Core / Generative AI Hub'dan istediğin model |
| Uzun iş | SAP motoru yönetir | Senkron 60 sn sınırı, sonra asenkron push notification |
| Hız (ilk demo) | Saatler | 1-2 gün |
| Jüriye "teknik derinlik" | Düşük | Yüksek |
| Hata ayıklama | Sınırlı, arayüzden | `cf logs` ile her adımı görürsün |
| Lisans | SAP Build build-default + Joule | Joule + AI Core + CF/Kyma |

**Akılda tutma cümlesi:** *Kutudaki parçalar yetiyorsa low-code; kendi algoritmanı göstermek istiyorsan pro-code.*

Hackathon için önerim: Asıl agent pro-code (BYOA). Joule tarafında tek bir capability. Vakit kalırsa Joule Studio'da küçük bir skill ekleyip "ikisi birlikte çalışıyor" göster.

---

## 7. Lisans, entitlement ve roller

### 7.1 Joule'nin kendisi

- Subaccount'ta **Joule** uygulaması (`das-application`) **Standard** plan ile Instances and Subscriptions altında olmalı. API URL buradan alınır.
- Lisans: **Joule Base** (SKU 8019544) veya **Joule Premium** (SKU 8019164, AI Unit içerir).
- ⚠️ "Joule for Consultants" ve "Joule for Developers" farklı lisanslardır, Joule Studio'yu açmaz.
- Kimlik: Joule IAS (SAP Cloud Identity Services) ile çalışır. Detay `04-kimlik-ias.md`.

### 7.2 Joule Studio, classic edition

- **SAP Build** aboneliği, plan **build-default**, ve aktif kullanıcı (developer) lisansı. Başka plan desteklenmiyor.
- Joule ile **SAP Build Process Automation** aynı landscape'te, IAS ile kurulmuş olmalı. Sonra BTP cockpit'te **formation** ile Joule Studio otomatik açılır (ya da booster çalıştırılır).
- Agent builder için SAP Build Control Tower'da "AI Agent Builder Activation" kutucuğu açılmalı.
- Partner için: TDD Joule Base (SKU 8020592) + PAYG for TDD (SKU 8009282).

### 7.3 Pro-code (CLI) için roller

| Rol | Ne için |
|---|---|
| `end_user` | Joule ile konuşmak. Geliştirme için yetmez. |
| `extensibility_developer` | Kendi assistant'ını deploy etmek |
| `capability_admin` | Capability yönetimi (SAP Beyni notu) |
| `das_developer` + `das_release_admin` | `joule deploy` ile deploy (SAP Help) |

### 7.4 BTP trial'da durum

- **Joule BTP trial hesaplarında açık değil.** (Kaynak: SAP Help'teki bir ürün SSS sayfası, dolaylı kaynak.)
- SAP Build trial'ı var ama build-default plan + Joule lisansı olmadan Joule Studio classic açılmıyor. Trial'da açılıp açılmadığı doğrudan test edilmedi (doğrulanmadı).
- Sonuç: Trial hesabında agent'ını CF'ye deploy edebilir, A2A'yı test edebilirsin. Joule tarafı için hackathon'un verdiği tenant gerekecek (doğrulanmadı).
- Trial'da kontrol: `btp list accounts/entitlement` ve `btp list accounts/subscription` ile `das-application` görünüyor mu bak (`03-btp-temelleri.md`). Global account'taki entitlement subaccount'a otomatik atanmaz.

---

## 8. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| Joule Studio Lobby'de hiç görünmüyor | SAP Build build-default planı yok veya Joule ile formation kurulmamış |
| "Create Joule Agent" menüsü yok | Control Tower'da AI Agent Builder aktif edilmemiş veya data center desteklenmiyor |
| Joule kendi agent'ımı seçmiyor | Scenario/agent açıklaması zayıf, anahtar kelime yok |
| Agent tool'u hiç çağırmıyor | Instructions çok katı veya tool açıklaması belirsiz |
| Document grounding boş dönüyor | Pipeline'daki metadata ile sorgudaki filtre uyuşmuyor |
| CLI'da 403 `FF_RETRIEVE_STATUS_ERROR` | Kullanıcıda sadece `end_user` rolü var |
| Trial'da Joule servisi yok | Joule trial'da açık değil |
| Doküman okuyorum ama komut çalışmıyor | Classic (`joule`) ile yeni Joule Studio (`jl`) dokümanını karıştırdın |

---

## 9. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] Joule neden "orkestra şefi" deniyor, kendi başına neyi yapmaz?
- [ ] Skill ile agent arasındaki fark nedir?
- [ ] Joule Studio classic ile yeni Joule Studio (IBD) arasındaki fark nedir, hangisi `joule`, hangisi `jl` kullanır?
- [ ] Agent builder'da bir agent'a hangi tool'lar eklenebilir?
- [ ] Document grounding nedir, arkada hangi servis çalışır?
- [ ] Low-code ne zaman yeter, ne zaman BYOA'ya geçersin?
- [ ] Joule Studio classic için hangi plan ve lisans gerekir?
- [ ] SAP'nin hazır agent kataloğunda hangi alan boş, neden bizim için fırsat?

---

## Kaynaklar

- SAP Architecture Center: Building AI Agents with SAP Joule Studio (yeni, IBD). https://architecture.learning.sap.com/docs/ref-arch/219c07
- SAP Architecture Center: Extend Joule with Joule Studio Classic in SAP Build. https://architecture.learning.sap.com/docs/ref-arch/ff07b1
- SAP Architecture Center: Integrating AI Agents with Joule (Outbound A2A). https://architecture.learning.sap.com/docs/ref-arch/ae6821
- SAP Help, Joule Studio classic: Initial Setup and Prerequisites. https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/b323c5a639a5428eb05fdafcca9bc9df.html
- SAP Help, Joule Studio classic: Create a Joule Agent. https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/193461e9d8494995bab4889b22afac93.html
- SAP Help, Joule Studio classic: Creating Agents with Vibe Coding, Capabilities and Limitations. https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/2d4d197a43d94898addda12e8bb5c7ff.html
- SAP Help, Joule Studio: Agents. https://help.sap.com/docs/JOULESTUDIO/7e496fe6f81f4975aec07d9c1cbd2aef/76f0cd16bec844ca8a7a220e200628c0.html
- SAP Help, Joule Studio: Pro-Code Setup (`jl`). https://help.sap.com/docs/JOULESTUDIO/7e496fe6f81f4975aec07d9c1cbd2aef/7bdd9ed4141a428597a41ce50cdca49e.html
- SAP Help, Joule Development Guide: Using an API Request Action for Document Retrieval. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/e204050912284ca698f3fc6634cf6b20.html
- SAP Help, Joule Development Guide: Code-Based Agents (Bring Your Own Agent). https://help.sap.com/docs/joule/joule-development-guide-ba88d1ec6a1b442098863d577c19b0c0/code-based-agents-bring-your-own-agent
- SAP Help: Trial Accounts and Free Tier. https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/046f127f2a614438b616ccfc575fdb16.html
- SAP Help, SAP Incentive Management starter edition FAQ ("Joule is not currently enabled on BTP Trial accounts"). https://help.sap.com/docs/SAP_IM_StarterEdition/cfcf1700052145d584415cbc4e7b62ba/f71fc48b60aa4d0d832dc4e2bc630c42.html
- Joule Assistant kataloğu. https://www.sap.com/products/artificial-intelligence/ai-assistant.html
- SAP Beyni notları: `ai/kavramsal/joule-agent-katalogu-ve-bosluklar.md`, `ai/diger/joule-studio-text-to-sql-agent.md`, `ai/baglanti/joule-studio-custom-mcp-destination-auth.md`, `araclar/joule-pro-code-a2a.md`, `dersler/2026-10-13-btp-ai-subaccount-unda-generative-ai-hub-ve-joule-entitlemen.md`
