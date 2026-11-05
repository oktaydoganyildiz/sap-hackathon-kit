# Agent tasarım ve fikir seçimi rehberi

2026-11-05 araştırması. `egitim/10-hackathon-stratejisi.md` ve `11-hackathon-arastirma.md`'nin tekrarı değil, onları tamamlar: jüri kriterleri, geçmiş kazananlar, 7 Industry AI alanı ve 4 günlük plan o dosyalarda.

## 1. SAP'nin resmi tasarım kuralları

**Mimari referanslar**

| Ref-arch | Ne diyor |
|---|---|
| **Agentic AI** (98efa0, 2026-10-26) https://architecture.learning.sap.com/docs/ref-arch/98efa0 | Agent = LLM + tool + hafıza + akıl yürütme. Katmanlar: Joule Work → Assistants → Agents; agent'tan agent'a A2A, tool için MCP. **Dikkat:** Agent Gateway'in 3. taraf agent'larla iki yönlü trafiği henüz desteklenmiyor. Joule agent'ının sana geri çağrı yaptığı bir demo kurma. |
| **Yetki** (140bdb) https://architecture.learning.sap.com/docs/ref-arch/140bdb | Etkin yetki = kullanıcının yetkisi ∩ agent'ın yetkisi, her adımda. İki model: agent kullanıcı adına çalışır ya da kendi teknik kimliği ve denetim izi olan otonom agent. Agent ile tool arasındaki politika kontrolü H2/2026'da. |
| **Joule Studio** (d2ba1e) https://architecture.learning.sap.com/docs/ref-arch/d2ba1e | Üç asset türü: Agent, Agent Extension, MCP Server. Altı faz; 5. fazda unit test ve AI eval var. |
| **Bring Your Own Agent** (7b6426) https://architecture.learning.sap.com/docs/ref-arch/7b6426 | Ne zaman pro-code: karmaşık koşullu akış, özel entegrasyon, belli bir framework, prompt ve cache üzerinde ince kontrol. Güvenlik: orchestration data masking ve I/O filtering. |
| **Datasphere üzerinde yapılandırılmış veri agent'ı** (b6c158) https://architecture.learning.sap.com/docs/ref-arch/b6c158 | **Oktay'ın güçlü olduğu alan.** |
| **MCP / tool tasarımı** (d2e34e) https://architecture.learning.sap.com/docs/ref-arch/d2e34e | Tool açıklaması net ve eylem odaklı olsun. Önce salt okunur, sonra yazma. Servis hesabı yerine kullanıcı adına OAuth. |
| **Gözlemlenebilirlik** (137800) https://architecture.learning.sap.com/docs/ref-arch/137800 | Her tool çağrısını logla: kim çağırdı, parametreler (PII maskeli), süre. |

**Yap / Yapma** (talimat yazımı: https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/880eb67d649247cf9c127dd37d168855.html)

- **YAP:** Prompt'u şu sırayla yaz:
  1. Uzmanlık: agent kim.
  2. Talimatlar: ne yapacak, pazarlıksız.
  3. Ek bağlam: kurallar, eğer/ise durumları.
  4. Tool açıklamaları: hangi tool ne zaman kullanılır.
- **YAP:** Adım adım mantık kur, her adım bir eylemle (çoğunlukla tool çağrısı) bitsin. Kural önceliğini açıkça yaz. Talimatları ve tool açıklamalarını **İngilizce** yaz.
- **YAPMA:** Agent'a fazla tool verme. SAP'nin ifadesi: "Restrict the toolset".
- **YAP:** Yazma işi yapan her tool'da kullanıcı onayı iste ("require user confirmation"). Eksik girdi varsa agent kullanıcıya sorsun. https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/e1d5bd4898654a09b82f991755108bd1.html
- **YAP:** Belirsizlik normal, iterasyon yap. Bazı işler için SAP'nin kendisi "Joule skill daha uygun olabilir" diyor.
- **Etik, SAP Global AI Ethics Policy 3.0** (2026-09-23, https://news.sap.com/?p=247755):
  - Kritik kararlarda kontrol insanda kalır.
  - Agent'ın her eylemi loglanır ve izlenebilir.
  - Her use case zorunlu etik etki değerlendirmesinden geçer, risk skoru alır.
  - Bu maddeler SAP'nin politika hakkındaki makalesinden; PDF'in kendisi okunmadı.

## 2. Agent mi, düz otomasyon mu?

| **Skill / workflow / RAG yeter** | **Agent gerekir** |
|---|---|
| Tek işlem, sabit girdi ve çıktı | Çok adımlı, duruma uyum sağlayan, hedefe yönelik |
| Sık tekrarlanan, kurala dayalı, deterministik olmalı | Tool'u kendisi seçer, ReAct döngüsü kurar, alt agent çağırabilir |
| Ucuz | Daha pahalı (her adımda LLM) |

Kaynak: https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/6ee21fccdf2c44aca11d46f672aaf9fe.html. SAP'nin CPO'suna göre ideal alan: "klasik otomasyon için fazla dinamik, her seferinde insan ilgisi için fazla tekrarlı".

**5 soruluk hızlı test.** Biri "hayır" ise fikri gözden geçir:
1. Bir sonraki adım, önceki adımda bulunana bağlı mı? Değilse workflow yeter.
2. Agent'ın seçmesi gereken 2 ya da daha fazla tool veya veri kaynağı var mı?
3. İnsanın onaylayıp düzeltebileceği bir muhakeme var mı (eşleştir, açıkla, öner)?
4. Değiştirdiği tek bir KPI'ın adını koyabiliyor musun?
5. İş "sadece bul getir" mi? Öyleyse jüri bunu RAG ya da chatbot olarak görür.

## 3. Mimari kontrol listesi

- [ ] **Veriye dayanma (grounding):** Tek bir yetkili yapılandırılmış kaynak (S/4 API, Datasphere view veya HANA Cloud). İsteğe bağlı olarak GenAI Hub orchestration ile doküman RAG. Knowledge Graph tasarım anında API keşfi için kullanılıyor; brifing sunmadıkça çalışma anında KG muhakemesi vaat etme.
- [ ] **Tool'lar:** MCP üzerinden. Seçenekler: Joule Studio'nun OData'dan ürettiği MCP server, Integration Suite MCP Gateway ya da CF üzerinde kendi MCP'n. 3-6 tool, açıklamaları net, önce salt okunur.
- [ ] **Kimlik:** Agent kullanıcı adına çalışsın, principal propagation olsun. Yazma işlerinde ortak teknik kullanıcı kullanma. Ayrıntı: `egitim/04-kimlik-ias.md`.
- [ ] **HITL (insan onayı):** Yazma işi bir ara alana düşsün, kullanıcı orada onaylasın ya da `input-required` ile onay istensin (`egitim/01-a2a.md`).
- [ ] **Guardrail:** Orchestration'da data masking ve girdi/çıktı içerik filtresi aç. Ucuz ama slaytta güven verir.
- [ ] **Eval:** 10-20 altın test sorusu ve her birinin beklenen tool çağrısı. Başarı oranını göster. Joule Studio test fazında eval'i kendisi üretiyor.
- [ ] **Gözlemlenebilirlik:** Joule Studio agent'ı AI Agent Hub'a kendiliğinden kaydolur ve trace tutar; kullanım ve maliyet Cloud ALM'de. Pro-code'da her tool çağrısını logla.
- [ ] **Maliyet:** Joule Studio runtime'ı 2026 sonuna kadar ücretsiz. Sunumda "vaka başına yaklaşık N adım × adım ücreti" hesabı yeterli. Adım başına AI Unit oranları doğrulanmadı.

## 4. SAP hackathonlarında ne kazanıyor

- **SAP EMEA Business AI Agent Hackathon 2026, ikinci olan proje: fatura mutabakatı.** https://community.sap.com/t5/artificial-intelligence-blogs-posts/sap-emea-business-ai-agent-hackathon-2026-our-runners-up-medal-winning-sap/ba-p/14469875
  - Sorun sayıyla anlatıldı: "2 kişi × 5 gün", 7-10 pazarda ~30 bin satır.
  - Çıktı: güven skoru ve gerekçesiyle eşleşme önerisi.
  - Düşük güvenli vakalar insana gidiyor.
  - **Agent SAP'ye doğrudan kayıt atmıyor.** Sonuç CAP + HANA'da bir ara alana düşüyor, kullanıcı onaylıyor, reddediyor ya da düzeltiyor.
  - Teknik: AI Core doküman hattı, CF üzerinde MCP server.
  - Canlıya geçiş yol haritası var. 2-3 günde yapıldı.
- **Hack2Build 2026, Avvale (2.):** "erken ödeme asistanı". Finans ekibinin yerine geçmek değil, onu güçlendirmek olarak anlatıldı. https://sapinsider.org/articles/the-agentic-edge-avvales-early-payment-assistant/
- **2026 agent hackathonları için resmi puanlama tablosu bulunamadı.**

**Kazananların ortak yanları:**
1. Finans ya da operasyonda bir istisna süreci, adam/gün sayısıyla anlatılmış.
2. Otonom kayıt yerine öneri + güven skoru + açıklama.
3. İnsan onayı arayüzde gerçek bir adım.
4. İnandırıcı bir canlıya geçiş yolu.

**Demoda göster:**
- Ekranda güven skoru ve gerekçe.
- İnsana yönlendirilen bir düşük güvenli vaka.
- Trace ya da eval başarı oranı (yönetişim kanıtı).
- Son slayt: "bu nasıl canlıya gider".

## 5. Fikir üretme çerçevesi (Pazartesi öğleden sonra, ~45 dk)

1. **Alan:** Brifingdeki konuyu 7 Industry AI alanından birine eşle (`egitim/11-hackathon-arastirma.md` §3.2).
2. **İstisnayı bul:** O alanın standart sürecinde insanların SAP'den çıktığı yer: Excel, e-posta ile kovalama, mutabakat, "X neden saptı" sorusu. 5 soruluk testten geçir.
3. **SAP zaten yapıyor mu?** `11-hazir-agentlar.md`'ye ve https://www.sap.com/products/artificial-intelligence/ai-agents.html'e bak. Bir hazır agent işin çoğunu yapıyorsa fikri onun üzerine extension ya da hook olarak çevir. Extension'da GA kısıtına dikkat: şu an sadece talimat eklenebiliyor.
4. **KPI:** "X'ten Y'ye" (efor, süre ya da hata) + hacim. Başlangıç rakamı varsayım olabilir, varsayım olduğunu söyle.
5. **En küçük mimari:** 1 veri kaynağı, 3-6 tool, 1 insan onayı kapısı, masking açık, 10-20 eval. Yol A (Joule Studio) mı Yol B (A2A) mı, 7b6426'daki kriterlerle seç.
6. **Demo hikâyesi:**
   - Persona ve sorunun sayısı.
   - Bir sorunsuz vaka, bir de insana yönlendirilen istisna.
   - Onay, ardından eylem.
   - Trace ve eval skoru.
   - KPI değişimi.
   - Canlıya geçiş yolu.
7. **Risk kontrolü:** Fikir kişileri etkiliyorsa (İK, insanları puanlama), etik etkiyi ve insan denetimi modelini açıkça yaz (Policy 3.0).

**Oktay'a uygun desen (tahmin, brifing gelince netleşir):** Datasphere/BDC verisi üzerinde sapmayı açıklayıp düzeltme öneren, eylemleri onaya bağlı bir agent. b6c158 deseni, `egitim/10`'daki "KPI Bekçisi" fikri ve EMEA ikincisinin yapısıyla örtüşüyor.
