---
tur: arac
alan: ai
tarih: 2026-10-13
guven: topluluk
gozden_gecir: 2027-04-13
---
# BTP Dynamic Multi-Agent App — Runtime'da Konfigüre Edilen Orkestratör

## Ne yapar
Cloud Foundry üzerinde çalışan bir orkestratör + specialist-agent uygulaması. Agent'lar (isim, talimat, bağlı MCP server'lar) veritabanında birer satır olarak tutulur (`agent_configs`); admin UI'dan (/admin veya /ui5admin) eklenir, düzenlenir ve "Reload" ile yeniden yüklenir — kod değişikliği veya redeploy gerekmez. Bir agent'a birden fazla MCP server bağlanabilir, her biri kendi auth modu ile (jwt, oauth2, none; ayrıca client-credentials, BTP destination, browser session). oauth2 modunda Dynamic Client Registration (RFC 7591) desteklenir: ilk kullanımda kullanıcı bir Authorize linkiyle tek seferlik giriş yapar, token kullanıcı başına saklanır ve her çağrıda iletilir. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])

Runtime düz Pydantic AI'dır, model sağlayıcı SAP AI Core'dur; bu kısım kod olarak kalır. Ajanı ayırt eden her şey konfigürasyondur. Yapılandırma alanları:

- **General:** name, description, instructions. `description` dokümantasyon değil yönlendirmedir: orchestrator tüm specialist açıklamalarını okuyup birini seçer, bu yüzden "X için bunu kullan" biçiminde yazılmalıdır. Ayrıca ajan başına `model` alanı vardır. Varsayılan global aktif modeldir, alan bunu ajan bazında ezer (ucuz bir okuyucu ile pahalı bir akıl yürütücüyü aynı zincirde kullanmak için). ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Skills:** ad + açıklama + içerik olarak bir kez tanımlanır, istenen kadar ajana bağlanır. System prompt'ta yalnız ad ve açıklama listelenir, tam içerik `load_skill` aracıyla ihtiyaç olunca çekilir. Uzun bir sorun giderme prosedürü, ajan ihtiyaç duyana kadar tek satıra mal olur. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Toolsets:** çoğu MCP endpoint'i. `builtin:gmail`, `builtin:jira`, `builtin:sapnotes` gibi pseudo-URL'ler MCP yerine registry tarafından süreç içinde sunulur. Gerekçe: bir üreticinin kendi barındırdığı MCP server'ı kendi kaydettiğiniz OAuth client ile her zaman kullanılamaz, alttaki REST API'de bu sorun yoktur. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Auth modları (toolset başına):** ilk üçü chat ajanı içindir: kullanıcı JWT'sini iletme, kullanıcı başına OAuth2, public. Diğer üçü gözetimsiz çalışma içindir (örn. gece 03:00'te oturum açmış kullanıcı yoktur, kimliği başka bir şey taşımalıdır). Yazarın favorisi BTP destination: credential destination'da durur, ajan konfigürasyonunda hiç secret saklanmaz. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Peers:** ajan, doğrudan danışabileceği diğer ajanları listeler. Her peer o ajanda bir delegation tool olur; zincir orchestrator'a dönmeden specialist'ten specialist'e akar. Az kullanılmalı, her peer araç listesine bir araç daha ekler. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Exposure:** "Available in chat" ajanı orchestrator'ın delegation listesinde tutar; "Expose as an API-triggered job" ona bir run endpoint'i verir. İkisi bağımsızdır: gece kontrolü yalnız run olarak açılıp chat'te hiç görünmeyebilir, ya da ikisi birden açılabilir. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Reload ve export:** kaydet, sonra Settings > Lifecycle panelinde Reload. Orchestrator bellekte yeniden kurulur, yeni specialist bir sonraki mesajdan itibaren chat'tedir. Doğrulama: soru sor, cevapta specialist'in adımlarının göründüğünü kontrol et. Tüm yapılandırma tek JSON olarak export/import edilir (birleştir veya değiştir). DEV'den PROD'a taşıma: export, import, reload; transport veya pipeline gerekmez. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Deep agent pattern (planning + scratchpad + sub-agents):** agent formunda bir panel olarak, her alt özellik ayrı ayrı açılıp kapatılabilir. Amaç: büyük tool çıktısı, çok adımlı sıralı iş ve paralelleştirilebilir alt-görevlerle context window'un dolmasını önlemek. `write_todos`/`read_todos` ile model işe başlamadan plan yazar, adımları işaretler, öğrendikçe planı revize eder. Scratchpad, çalışma süresince var olan in-memory dosya ağacıdır (`ls`, `read_file`, `write_file`, `edit_file`); büyük tool çıktıları ve taslaklar oraya yazılır, model yalnız ihtiyacı olan kısmı geri okur — kullanıcıya gösterilmez. `task(description)` aracı, parent'ın toolset'leri ve taze bir context ile ephemeral bir Pydantic AI ajanı başlatır, final metnini döndürür; bir turda birden çok kez çağrılırsa paralel çalışırlar. Sub-agent; peer (delegation ile ulaşılan kayıtlı ajan) ve workflow adımından (kayıtlı, deklare edilmiş sıradaki ajan) farklıdır: hiçbir yerde kayıtlı değildir, orchestrator ve peer'lara görünmez, run bitince kaybolur, ve en önemlisi parent'ın state'ini (plan + scratchpad) dependency olarak devralır — bu yüzden büyük bir sonucu dosyaya yazıp parent'a yalnız dosya yolunu içeren tek satırlık özet döndürebilir. Peer bunu yapamaz, kendi run'ı ve scratchpad'i vardır. Konfigürasyon agent JSON'una şu blok olarak eklenir: `{"deep": {"enabled": true, "planning": true, "scratchpad": true, "subagents": true, "max_subagents": 5, "subagent_max_depth": 1, "subagent_instructions": ""}}`; export/import ve seed dosyasında taşınır, bundle'da "deep" anahtarı yoksa mevcut ayar korunur, bilinmeyen anahtar 422 ile reddedilir (config modeli unknown key kabul etmez). ([[kaynaklar/2026-10-13-btp-deep-agent-pattern]])

Yazar, bunu Joule Studio'ya benzer ama code-based bir yapı olarak konumluyor: UI'ın kapsamadığı şeyler kodla eklenebilir (Gmail, Outlook, Jira bağlayıcıları böyle doğmuş). Kullanıcı JWT'si iletildiği için ajanlar ile BTP'deki MCP server'lar arasında tam SSO çalışır; yazar, Joule'un önceki sürümlerinin bunu desteklemediğini söylüyor. Ajanlar A2A ile birbirine de bağlanabilir. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])

## Bende durumu
yeni (ENVANTER'de benzer dinamik ajan orkestratörü yok; mevcut MCP'ler ve skill'ler tek ajan kullanımına yönelik).

## Agentic BI'a katkısı
Herhangi bir MCP server (SAP dokümantasyon, ADT/ABAP sistemi, vb.) "veritabanında bir satır" eklenerek specialist agent'a dönüştürülebilir. Bu, SAP ekosisteminde kendi "Joule for Consultants" benzeri çok-agent'lı asistanı, kullanıcı bazlı lisans maliyeti olmadan, yalnızca LLM token tüketimine göre (SAP AI Core Generative AI Hub üzerinden) kurmayı sağlar. Agent tanımları JSON olarak export/import edilebilir (agents.seed.json). ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])

Ek katkılar: kod bilmeyen bir danışman form doldurup yeni uzman ajan ekleyebilir. Uzun prosedürler skill olarak ayrılıp token maliyeti düşürülür. Aynı tanım chat'te de gözetimsiz job olarak da çalışabilir. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])

Deep agent pattern özellikle çok adımlı araştırma/karşılaştırma tipi agentic BI görevlerinde (ör. birden çok sistemde kırk nesneyi okuyup rapor yazmak) devreye girer: workflow bilinen adımları takip ettirir, deep agent ise ajanın adımları kendi keşfetmesi gerektiği durumda context'i boğulmadan bitirmesini sağlar — aynı instructions, aynı toolset, aynı kimlik doğrulama; tek fark ne kadar uzun bir göreve devam edebildiğidir. ([[kaynaklar/2026-10-13-btp-deep-agent-pattern]])

## Kurulum
GitHub reposundan (https://github.com/lemaiwo/btp-dynamic-multiagent-app) Cloud Foundry'ye deploy edilir; bileşenler: python app + approuter, PostgreSQL, HTML5 application repository (UI5 admin), LLM erişimi için SAP AI Core Generative AI Hub.

```
git clone https://github.com/lemaiwo/btp-dynamic-multiagent-app
```

([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])

## Dikkat
- Topluluk projesi, resmi SAP ürünü değil; bakım tek bir yazara bağlı. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])
- **MCP_URL_ALLOWLIST tuzağı:** authenticated modlarda varsayılan olarak yalnız `*.hana.ondemand.com` üzerindeki HTTPS URL'leri kaydedilebilir. Kendi barındırdığınız server'lar (ör. ARC-1) için URL'yi `MCP_URL_ALLOWLIST` env değişkenine ekleyin, yoksa register edilemez. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]], [[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- Kullanıcı kimlik bilgileri (XSUAA JWT / OAuth2 token) bağlı MCP server'lara iletilir; üçüncü taraf/topluluk MCP server'larına prod kimlik bilgisi akıtmadan önce güvenlik değerlendirmesi yapın. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])
- Gözetimsiz çalışmada kimlik: oturum açmış kullanıcı yoktur, JWT iletme modu çalışmaz. BTP destination modunu tercih edin, secret konfigürasyonda tutulmaz. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- Peers'i az kullanın: her peer ajanın araç listesine bir delegation tool ekler. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- `description` alanı yönlendirme için okunur; kötü yazılırsa orchestrator yanlış specialist'i seçer. ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- Workflows ve scheduled job runs mevcut ama ilk senaryoda kullanılmadı. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]], [[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- **Deep agent limitleri:** Pydantic AI varsayılan model-request limiti 50'dir ve sub-agent'lar bu bütçeyi parent ile paylaşır — 5 sub-agent × 10 çağrı, parent hiçbir şey yapmadan limiti doldurur. Uygulama bunu `AGENT_REQUEST_LIMIT` ile (varsayılan 200) aşıyor; kendi kurulumunuzda bu env değişkenini kontrol edin. Semaphore derinlik başınadır (run başına değil) — aksi halde grandchild spawn eden tam set sub-agent, tek bir semaphore üzerinde kilitlenebilir (yazarın "zor yoldan bulduğu" hata). `subagent_max_depth=1` iken çocuğa `task` aracı hiç verilmez. Dosya/karakter tavanları (200 dosya, 256 KB/dosya, 4 MB toplam, satır okuma 2.000 karakter) scratchpad'in kendisinin context'i boğmasını önlemek için konmuştur — minify edilmiş büyük bir JSON'u scratchpad'e yazıp bütünüyle geri okumak bu tavanlara takılır. ([[kaynaklar/2026-10-13-btp-deep-agent-pattern]])

## Cevapladığı sorular
- BTP'de kod deploy etmeden veritabanı satırıyla ajan tanımlayıp MCP toolset ve auth modunu nasıl yapılandırırım? ([[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]])
- BTP'de Pydantic AI agent'ının context overflow'unu planning, scratchpad ve sub-agent'larla nasıl çözerim? ([[kaynaklar/2026-10-13-btp-deep-agent-pattern]])

## Benzerleri
Joule for Consultants (lisanslı, SAP resmi, kendi sisteminize bağlanamaz); Joule Studio (UI ile ajan ve skill oluşturma; bu uygulama code-based olduğu için UI'ın kapsamadığı eklentiler kodla yapılabilir); LangChain'in deepagents pattern'i (github.com/langchain-ai/deepagents — bu uygulamadaki planning/scratchpad/sub-agent tasarımının ilham kaynağı, Claude Code'un çalışma biçimine benzetiliyor); genel amaçlı agent orkestrasyon framework'leri. ([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]], [[kaynaklar/2026-10-11-agentic-ai-btp-configuring-code-based-agents-on-the-fly]], [[kaynaklar/2026-10-13-btp-deep-agent-pattern]])
