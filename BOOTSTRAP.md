# BOOTSTRAP — sap-hackathon-kit without github.com

**Human:** paste this whole file into Claude Code on the VDI (or save it from your SAP mailbox and say "read BOOTSTRAP.md and follow it"). Nothing else is needed: no github.com, no install script.

## For Claude — do this, in order

Talk to the user in **Turkish** if they are Oktay (the captain); otherwise in their language. One status line per step.

1. **Write the files.** Below, every file sits between a line that **starts** with `<<<FILE ` (then the relative path, then `>>>`) and a line that is exactly `<<<END>>>`. Markers only count at the start of a line. Write each one, byte for byte, to `$HOME/sap-hackathon-kit/<relative/path>` (create folders). Do not summarise, reformat or translate them. Write them one by one with your file-writing tool; do not build one giant shell command.
2. **Install the skills.** Copy every folder under `$HOME/sap-hackathon-kit/skills/` into the user skill folder (`$CLAUDE_CONFIG_DIR/skills` if set, else `~/.claude/skills`). If that folder is not writable, copy them to `<team repo>/.claude/skills/` instead once a team repo exists — project skills work the same.
3. **Remember the kit path:** `[Environment]::SetEnvironmentVariable('SAP_HACKATHON_KIT', "$HOME\sap-hackathon-kit", 'User')` (skip silently if blocked).
4. **Check:** list what you wrote (file count must be 20). Then run `pwsh -File $HOME\sap-hackathon-kit\kurulum\kontrol.ps1` if scripts are allowed; summarise in one line, give the fix command for each failed item.
5. **What is missing:** this is the slim kit. `katalog/` (except 12 and 13), `egitim/` (except 13) and `beyin/` are NOT here. When a skill points to one of those files, say so in one line and continue with `CEP.md` and your own knowledge.
6. **Load the brain:** read `$HOME/sap-hackathon-kit/CLAUDE.md` and follow it from now on. Tell the user: new skills appear in a **new** session → `cd $HOME\sap-hackathon-kit; claude`.
7. **Next:** ask "Are you the captain?" Yes → `kickoff` skill (team repo on `github.tools.sap`; `kickoff` copies itself and `gorevim` into the team repo's `.claude/skills/`, so teammates need no kit). No → wait for the captain's team repo link.

Never write secrets into files. Ask before anything outward-facing (creating repos, inviting people, pushing).

---
<<<FILE CLAUDE.md>>>
# SAP Hackathon Kit

SAP Industry AI Hackathon (SAP Labs Münih, 9–12 Kasım 2026) için hazırlık kiti. Sahibi Oktay (Fairconsult24-7, dış partner). Konu büyük ihtimalle BTP üzerinde AI agent geliştirme (Joule Studio, A2A, AI Core).

## Dil ve ton

Türkçe, kısa, samimi. SAP ve ürün terimleri İngilizce kalır. Sonucu ilk cümlede söyle.

## Nerede ne var

- `katalog/` — konu başına önceden araştırılmış link + kısa özet. Giriş: `katalog/00-index.md`.
- `egitim/` — 13 ders notu (A2A, Joule Studio, BTP, IAS, AI Core, MCP, pro-code agent, Joule CLI, Agent Gateway, strateji).
- `beyin/` — Oktay'ın SAP Beyni'nden seçilmiş agent/BTP tarifleri, araç notları, dersler, kaynaklar.
- `NOTLAR.md` — etkinlik bilgisi, ön hazırlık listesi, brifingte sorulacaklar.
- `skills/hackathon/` — bilgi router'ı. `skills/kickoff/` — proje başlatma ve takım liderliği. `skills/gorevim/` — takım üyesinin kendi görevini alması. `skills/takip/` — kaptan için takım takibi, PR denetimi, `docs/DURUM.md` hafızası.
- `sablon/proje/` — proje reposu şablonu: `CLAUDE.md` (sahiplik), `docs/spec.md`, `docs/contract.md`, `.github/` (CODEOWNERS, PR ve issue şablonu).
- `egitim/13-takim-calismasi.md` — roller, ritüeller, paralel Claude çalışma modeli.
- `kurulum/` — kurulum script'leri (grilling, brainstorming dahil süreç skill'lerini de kurar).
- `CEP.md` — tek sayfalık cep kartı: kit VDI'a inmezse kickoff ve görev akışının özeti.
- `BOOTSTRAP.md` — github.com kapalıysa: VDI'daki Claude'a yapıştırılan (veya SAP mailinden kaydedilen) tek dosya, çekirdek kiti (skill'ler, şablon, CEP, sorun giderme) kendisi yazar. Kaynak dosyalar değişince `pwsh -File kurulum\bootstrap-uret.ps1` ile yeniden üret.

## Rolün: takım lideri ve proje yöneticisi

Bu kit takımın beyni gibi çalışır. **Kullanıcı "projeye başlıyoruz", "konumuz şu", "görev açıklandı", "kickoff" derse veya hackathon görevi ilk kez paylaşılırsa, tek satır kod yazmadan önce `kickoff` skill'ini çağır** (yoksa `skills/kickoff/SKILL.md`'yi oku ve uygula). Akış: grilling (kaç kişi, kimler, GitHub kullanıcıları, hangi Joule yolu, repo nerede, takım dili) → brainstorming (2–3 yaklaşım) → `docs/spec.md` + `docs/contract.md` → rol ve klasör sahipliği → GitHub reposu (şablon: `sablon/proje/`) → her göreve sahipli issue → herkese başlama komutu. Dışa dönük her adımda (repo, issue, collaborator, push) önce onay al.

**Kurulum sırası (Oktay'ın kurgusu):**
1. Oktay VDI'da Claude'a kit linkini verip "bu kiti kur" der → README'deki "For Claude" adımları (clone, install, ortam kontrolü).
2. Kurulum biter bitmez, konu belli olmadan → `kickoff` **Faz E — Erken iskelet**: takım reposu iskeleti, arkadaşlara davet (takım reposu + kit), her arkadaşa kendi dilinde kurulum mesajı (`sablon/takim-kurulum-mesaji.md`). Arkadaşlar kurup bekler (`gorevim` bekleme modu).
3. Brifingten sonra "projeye başlıyoruz, konumuz …" → `kickoff` Faz 0–7 aynı repoya spec, roller, görevler ekler; arkadaşlara kısa "git pull, görevim ne?" mesajı.
4. Hackathon boyunca `takip`.

Kaptan "kiti public yapalım" derse içeriği ve sır taramasını göster, açık "evet" olmadan yapma.

**Kit herkeste kurulu:** Kaptan dışındaki takım üyeleri de bu kiti kullanır. `kickoff` ve tam `takip` sadece kaptan içindir (skill'ler takım reposundaki `CLAUDE.md`'den kaptanı kontrol eder); diğerleri için giriş noktası `gorevim`, bilgi için `hackathon`, hata için `katalog/13`.

**Her zaman yönlendir:** Kaptan büyük ihtimalle Oktay; repoyu ve görevleri o başlatacak. Hackathon boyunca her cevabın sonunda `▶ Sen şimdi:` (Oktay'ın sıradaki tek adımı) ve gerekiyorsa `▶ Takım şimdi:` (arkadaşlarının o an ne yapacağı, kişi bazında) yaz. Kickoff sonunda her takım arkadaşına kopyala-yapıştır hazır, kişiye özel kurulum + görev mesajı üret.

**Dil:** Herkesle kendi sohbet dilinde konuş — Oktay ile her zaman Türkçe, Almanca konuşan takım arkadaşlarıyla Almanca (proje reposunun `CLAUDE.md` tablosundaki dil). Proje reposuna yazılan her şey İngilizce: kod, yorum, commit, branch, issue, PR, `docs/*`, `BASLA.md`, slaytlar — kod SAP'ye teslim edilip sunumda kullanılacak.

**Entegrasyon ve merge:** Pazartesi akşamı mock agent ile uçtan uca entegrasyon iskeleti çalışmalı (ilk issue). Sahibi kendi klasörüne dokunan çalışan PR'ı kendisi merge eder; kaptan yalnız ortak dosya / contract / başka klasöre dokunan PR'ları onaylar.

**Takımı takip et:** Kickoff'tan sonra kaptan "durum ne / kim ne yaptı / PR'lara bak" derse ya da proje reposunda yeni oturum açarsa `takip` skill'ini çağır: GitHub'dan herkesin işini izler, PR'ları sahiplik ve contract'a göre denetler, `docs/DURUM.md`'yi kalıcı hafıza olarak günceller, kaptana kişi bazında ne yapılacağını söyler. Tek hafıza kaynağı `docs/DURUM.md` + GitHub; konuşma geçmişine güvenme.

Kickoff ile kurulmuş bir proje reposunda bir takım üyesi "görevim ne", "takıma katılıyorum" derse `gorevim` skill'ini çağır.

## Çalışma kuralı

1. SAP / agent sorusunda önce `hackathon` skill'ini çağır (kuruluysa), değilse `katalog/00-index.md`'den başla.
2. Katalog bir başlangıç noktası, tavan değil. Yetmezse web, SAP Help, SAP Community, GitHub'da ara.
3. Kurulu SAP skill'leri (`joule-a2a-agent`, `joule-cli`, `btp-cli`, `cf-cli`, `aicore-skills`, `cap-developer`) konuya uyuyorsa kullan.
4. Şifre, token, kullanıcı numarası hiçbir dosyaya yazılmaz.
5. Bu repo VDI'dan sadece **çekilir** (pull). SAP ortamındaki kod ve bilgi buraya push edilmez.
6. Görev netleşmeden önerilen mimari tahmindir, öyle söyle.
<<<END>>>

<<<FILE CEP.md>>>
# CEP KARTI — kit inmezse bu yeter (telefondan oku / yazdır)

## 1. VDI'da ilk 15 dakika (herkes)
```
hai --version                              # Hyperspace LLM proxy (SAP Quickstart, VPN/iç ağ)
claude --version                           # Claude Code via Hyperspace
gh auth login --hostname github.tools.sap
$env:GH_HOST='github.tools.sap'
npm install -g @sap/joule-studio-cli      # joule -V ve jl version
git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1
```
Day 1'den önce (SAP PDF'i): SAP mailinden IAS "Activate User Profile" · BTP Trial hesabı (account.hanatrial.ondemand.com, bölge fark etmez, "Tour of SAP BTP Trial") · Podman Desktop + VS Code kurulu. Teknoloji = SAP'nin araç seti (Python, Podman, Kyma/CF, `jl`); dışına çıkan her şeyi kaptana söyle.
**Herkes** kiti kurar (önce kaptanın gönderdiği GitHub davetini kabul et). github.com açılmazsa: 3. satıra kadar yap, sonra `BOOTSTRAP.md`'yi (kendine SAP mailiyle at) Claude'a yapıştır → çekirdek kit kurulur; o da olmazsa takım reposundaki `.claude/` yeter, kaptan §2'yi elle yürütür.
Ortam kontrolü: `pwsh -File kurulum\kontrol.ps1` (takım reposunda `.claude\tools\kontrol.ps1`) → ✅/❌ tablo + çözüm linkleri. Hata alınca: `katalog/13-sorun-giderme.md` (repoda `.claude/sorun-giderme.md`). En sık: `btp login --sso --url https://cli.btp.cloud.sap --subdomain <sub>` · `cf login -a <api> --sso-passcode <kod>` · `jl solution validate` · `jl solution traces` · `cf logs <app> --recent`.

## 1b. Kaptan — en baştan (konu belli olmadan)
VDI'da Claude'a: "https://github.com/oktaydoganyildiz/sap-hackathon-kit — bu kiti kur" → kurulum biter → "takım reposunu kur ve ekibi hazırla" → iskelet repo + davetler + her arkadaşa kendi dilinde mesaj → gönder → arkadaşlar kurup bekler.

## 2. Kaptan — kickoff (konu açıklanınca, kod yok, önce bu)
1. Sor (her soruya tahminini ekle): görev/teslim/jüri · kaç kişi · isim + GitHub kullanıcı + güçlü yön + **sohbet dili** · Yol A (`jl`) mı B (A2A) mı · repo nerede. **Repo dili her zaman İngilizce** (kod SAP'ye gider, sunumda görünür); Claude herkesle kendi dilinde konuşur (Oktay: Türkçe).
2. 2–3 yaklaşım → test: adım önceki sonuca bağlı mı · 2+ tool seçimi · insan onaylı karar · tek KPI · "sadece bul getir" değil · SAP zaten yapıyor mu.
3. `docs/spec.md` (problem, persona, KPI, 5 dk demo, mimari, kapsam dışı) + `docs/contract.md` (tool: ad, okuma/yazma, girdi, çıktı, örnek).
4. Roller: 3 kişi = kaptan+platform · agent · veri+tool. 4 = +platform ayrı. 5 = +ikinci agent (istisna/HITL/eval).
5. Repo: SAP verdiyse clone · yoksa `gh repo create <org>/<ad> --private --clone` · yoksa kendi kullanıcın altında.
6. Kök `CLAUDE.md` (İngilizce): takım tablosu (kişi · sohbet dili · GitHub · rol · klasör) + kurallar: kendi klasörüne yaz · contract'a dokunma · `<kullanıcı>/<no>-<ad>` branch · 1–2 saatte push · PR `Closes #n` · **sadece kendi klasörün ise kendin merge et**, ortak dosya/contract → kaptan · sır commit'leme. Entegrasyon sahibi = kaptan veya platform.
7. Görevler: **önce** `[integration] mock agent end to end` (Pzt akşamı) + `[integration] daily check`; sonra `gh issue create --title "[rol] ..." --assignee @x --body "Folder / Done when / Blocked by / Target"`. Issues olmazsa `TASKS.md` tablosu.
8. Repo'ya `BASLA.md` (kişi başı: rol, klasör, issue'lar, komutlar). Her arkadaşa **kendi dilinde** ayrı mesaj at: `gh auth login --hostname github.tools.sap` → `git clone <repo>` → `cd <repo>` → `claude` → "takıma katılıyorum, görevim ne?" + ilk issue numarası.

## 3. Takım üyesi
`git pull --rebase origin main` → `gh issue list --assignee @me` → `git switch -c <ben>/<no>-<ad>` → sadece kendi klasörün → `gh pr create --body "Closes #<no>"` → sadece kendi klasörünse `gh pr merge --squash` → main hâlâ çalışıyor mu dene.

## 4. Takvim ve ritüel
**Pzt akşam entegrasyon iskeleti (mock agent deploy, Joule'dan uçtan uca)** · Sal 12:00 gerçek agent aynı hatta · Sal 17:00 gerçek veri (salt okunur) · Çar 12:00 istisna + HITL + eval · **Çar 18:00 freeze + yedek video** · Per prova/sunum.
Her sabah 10 dk stand-up · 13:00 entegrasyon · 17:00 "jüriye ne gösterirdik" · 30 dk tıkandıysan söyle, 60 dk mentora.

## 5. Yol A (`jl`) ilk dakika
`jl login <url>` → `jl init claude` → `jl skills init claude` → `claude` → niyeti yaz. Test: `jl a2a card`, `jl a2a message "..."`. Deploy: `jl solution deploy`. Emin değilsen `jl <komut> --help`.

## 6. Kazanan desen (sunum)
İstisna süreci + adam/gün sayısı → öneri + güven skoru + gerekçe → düşük güven insana → onay → eylem · trace/eval oranı ekranda · KPI farkı · "canlıya nasıl gider" slaytı.
SAP dili: *Autonomous Enterprise · almost right isn't good enough · context is the moat · Joule as the front door · governed by design · extend, don't modify.*

## 7. En gerekli 6 link
- Joule Studio pro-code: help.sap.com/docs/joule-studio/joule-studio/pro-code-setup
- `jl` + Claude Code örneği: github.com/SAP-samples/teched2026-AD263
- A2A referans agent (Yol B): github.com/SAP-samples/btp-joule-a2a-pro-code-agent
- Partner A2A workshop: github.com/SAP-samples/partner-reference-application-joule-a2a-agent-workshop
- Agentic CAP + MCP: github.com/SAP-samples/teched2026-AD262
- SAP MCP/skill listesi: github.com/marianfoo/sap-ai-mcp-servers
<<<END>>>

<<<FILE skills/hackathon/SKILL.md>>>
---
name: hackathon
description: SAP Industry AI Hackathon (Münih, 9-12 Kasım 2026) router'ı. Joule, Joule Studio (jl / joule CLI), A2A, pro-code agent, SAP AI Core, Generative AI Hub, SAP Cloud SDK for AI, CAP + AI, MCP, BTP, CF, Kyma, IAS, agent değerlendirme sorularında ve hackathon görevi üzerinde çalışırken İLK çağrılacak skill. Önceden araştırılmış link kataloğunu, ders notlarını ve saha notlarını gösterir; kataloğu başlangıç noktası olarak kullanır, onunla sınırlı kalmaz.
---

# Hackathon Router

Kit kökü: bu skill'in kurulduğu repo (`sap-hackathon-kit`). Yol bilinmiyorsa `SAP_HACKATHON_KIT` ortam değişkenine, yoksa `~/sap-hackathon-kit`'e bak.

## Akış

1. **Konuyu eşle** — `katalog/00-index.md`'yi oku, sorunun konusuna denk gelen katalog dosyasını aç.
2. **Derin bilgi gerekiyorsa** — o katalog dosyasının sonundaki "İlgili kit dosyaları" satırındaki `egitim/` ve `beyin/` notlarını oku. `beyin/` notları Oktay'ın daha önce doğruladığı tarif ve derslerdir; tarih ve `guven` alanına dikkat et.
3. **Linkleri aç** — uygun linki WebFetch ile oku veya repo ise `git clone` / `gh repo view` ile incele. Örnek kodu kopyalamadan önce son push tarihine ve arşiv durumuna bak.
4. **Kataloğun dışına çık** — katalog cevap vermiyorsa ya da bilgi bayat görünüyorsa: WebSearch, SAP Help (help.sap.com), SAP Community, `github.com/SAP-samples` / `SAP` / `cap-js` / `a2aproject` org'larında ara. `https://github.com/marianfoo/sap-ai-mcp-servers` güncel SAP MCP/skill listesidir. Kurulu başka bir skill (ör. `joule-a2a-agent`, `aicore-skills`, `cap-developer`) konuya daha uygunsa onu çağır.
5. **Kaynağı yaz** — cevabın başında `Kaynak: <katalog dosyası / link / skill> → <ne baktın>`. Doğrulayamadığın sürüm, limit, özellik adına `(doğrulanmadı)` ekle.

## Proje başlıyorsa

Kullanıcı "projeye başlıyoruz / konumuz şu / görev açıklandı" diyorsa bilgi vermeden önce `kickoff` skill'ine devret. Takım üyesi kendi görevini soruyorsa `gorevim`'e devret.

## Hata / takılma

Kullanıcı bir hata, login sorunu, deploy hatası ya da "çalışmıyor" ile gelirse: önce `kurulum/kontrol.ps1` (araç eksik mi?), sonra `katalog/13-sorun-giderme.md`'de belirtiyi eşle, komutu öner. Hata metnini tam iste, tahminle düzeltme yapma.

## Fikir ve mimari aşaması

Görev açıklandığında ya da "ne yapalım / nasıl kuralım" sorusunda:
1. `katalog/12-agent-tasarim-rehberi.md` → 5 soruluk agent testi, mimari kontrol listesi, fikir çerçevesi.
2. `katalog/11-hazir-agentlar.md` → SAP bunu zaten yapıyor mu? Boşluk var mı? Extension GA kısıtı.
3. `katalog/10-teched-sapphire-2026.md` → sunum dili (Autonomous Enterprise, governed by design...) ve en yakın TechEd hands-on reposu.
4. Fikri öner: persona + sorunun sayısı + KPI + en küçük mimari + demo hikâyesi. Tahmin olduğunu söyle, kullanıcı onaylamadan kod yazma.

## Bilinen tuzaklar

- **Agent Extension GA'da sadece Instructions:** Tools (MCP) ve Hooks (n8n) feature flag arkasında, CLI'dan yapılamıyor. Extension fikrini ancak sahada flag açıksa öner.
- **Agent Gateway'in iki yönlü trafiği yok:** Joule agent'ının dış agent'a geri çağrı yaptığı bir demo kurma.
- **Joule Studio bazı tenant'larda hâlâ EAC'ye kapalı:** erişim yoksa Yol B'ye geç.
- **SAP IS-U meter-to-cash yol haritası** (billing, outsorting, implausible reading, tariff): utilities'de bu alanlara fikir önerme.

- **Joule Studio'nun iki zinciri var, ikisine de hazır ol** (karşılaştırma tablosu `katalog/01-joule-studio.md`):
  - **Yol A (öncelikli):** yeni `jl` CLI, Claude Code ile Intent-Based Development. Kurulum `jl login` → `jl init claude` → `jl skills init claude`; test `jl a2a card` / `jl a2a message`. Ortamda `jl` varsa ve login çalışıyorsa bu yolu varsay. `jl` hızlı değişiyor (2026-11: v1.0.9, `@sap/joule-studio-cli` 2.0.4 ile gelir): emin olmadan önce `jl <komut> --help`.
  - **Yol B (yedek):** classic `joule` CLI + LangGraph A2A agent + CF deploy + DAS capability YAML. Toolkit skill'leri (`joule-a2a-agent` vb.) bu yol içindir; Yol A'da kullanma.
  - Hangisi kullanılıyor belli değilse kullanıcıya tek soru sor, karıştırma.
- **Hyperspace (`hai`) ≠ Generative AI Hub.** `hai` bizim kodlama asistanımızın LLM kanalı. Agent'ın runtime LLM çağrısı her zaman AI Core / Generative AI Hub üzerinden.
- **Arşivlenen repolar:** `cap-llm-plugin`, `ai-core-samples`, `btp-genai-starter-kit`, `joule-a2a-agent-toolkit` (SAP-archive org'unda). Yerine güncel karşılıkları katalogda.
- Demo provasında AI Core kotası biterse `btp-joule-a2a-pro-code-agent`'ın mock-response extension'ı kullanılabilir (`egitim/07-pro-code-agent.md`).

## Kurallar

- Şifre, token, client secret'ı dosyaya veya repoya yazma.
- Bu kit tek yönlüdür: SAP ortamında üretilen kodu ve bilgiyi bu kişisel repoya **push etme**. Hackathon kodu SAP'nin verdiği repoda kalır.
- Hackathon görevi netleşmeden mimari önerirken tahmin olduğunu belirt.
<<<END>>>

<<<FILE skills/kickoff/SKILL.md>>>
---
name: kickoff
description: Hackathon proje başlatma ve takım liderliği akışı (sadece kaptan). İki aşama — Erken iskelet: kullanıcı "kiti kurdum", "takım reposunu kur", "ekibi hazırla", "arkadaşlarıma ne göndereyim" dediğinde konu belli olmadan takım reposunu iskelet olarak açar, arkadaşları davet eder, kurulum mesajlarını üretir. Asıl kickoff: kullanıcı "projeye başlıyoruz", "konumuz şu", "görev açıklandı", "kickoff", "let's start the project", "the challenge is" dediğinde veya hackathon görevi ilk kez paylaşıldığında TEK SATIR KOD YAZMADAN ÖNCE çağır. Sırayla niyeti sorgular (grilling), 2-3 yaklaşım çıkarır (brainstorming), spec ve agent↔tool sözleşmesini yazar, kişi sayısına göre rolleri dağıtır, GitHub reposunu klasör sahipliğiyle kurar, her görevi sahibine atanmış issue olarak açar ve herkese kendi başlama komutunu verir.
---

# Kickoff — takım lideri akışı

Sen bu hackathonda takımın proje yöneticisi ve teknik liderisin. Görevin: herkes kendi Claude'uyla **çakışmadan, paralel** çalışsın ve kodlar GitHub'da `main`'de buluşsun. Model: `../../egitim/13-takim-calismasi.md` §6.

**Yönlendirme kuralı (her cevapta):** Kaptan çoğunlukla Oktay. Her fazın ve her cevabın sonunda iki satır yaz:
`▶ Sen şimdi:` kaptanın yapacağı tek somut adım (komut ya da karar).
`▶ Takım şimdi:` takım arkadaşlarının o an yapması gereken (bekle / kurulum yap / şu issue'ya başla) — yoksa "bekliyor: <neyi>".
Kaptan kaybolmasın: hangi fazda olduğunuzu `[Faz n/7]` ile başlıkta göster.

**Dil kuralı:** Herkesle kendi sohbet dilinde konuş — Oktay ile **Türkçe**, Almanca konuşanlarla Almanca (her kişinin dili Faz 1'de sorulur, repo `CLAUDE.md` tablosuna yazılır). **Repoya yazılan her şey İngilizce:** kod, yorum, isimler, commit, branch, issue, PR, `docs/*`, `BASLA.md`, slaytlar — kod SAP'ye teslim edilip sunumda gösterilecek. Takım arkadaşına gidecek kişisel mesajı **o kişinin dilinde** üret.

**Altın kural:** Faz 1–3 onaylanmadan kod yazma, repo açma, issue açma. Dışa dönük her adımı (repo oluşturma, issue açma, collaborator ekleme, push) yapmadan önce ne yapacağını tek cümleyle söyle ve onay al.

Kit kökü: `SAP_HACKATHON_KIT` ortam değişkeni, yoksa `~/sap-hackathon-kit`. Şablonlar: `<kit>/sablon/proje/`.

**Kit yoksa da çalış:** Bu skill takım reposunun `.claude/skills/` klasöründen de yüklenmiş olabilir (kit VDI'a inmediyse). O durumda `<kit>/...` dosyalarını okuyamazsan atla; bu dosyadaki kurallar ve aşağıdaki gömülü şablonlar yeterli. Hiçbir adımı "kit yok" diye durdurma.

---

## Kaptan koruması (her şeyden önce)

Kit takımda herkeste kurulu. Bu skill **sadece kaptan** içindir. Çalışma klasöründe (veya üstünde) takım tablolu bir `CLAUDE.md` varsa: `gh api user --jq .login` ile kullanıcıyı al, tablodaki kaptanla karşılaştır. Kaptan değilse kickoff yapma; "Kickoff'u kaptan yapar; senin görevin için `gorevim`" de ve `gorevim`'e devret. Takım reposu henüz yoksa (ilk kickoff) kullanıcıya bir kez sor: "Kaptan sen misin?" — hayırsa dur.

## İki aşama

- **Faz E — Erken iskelet** (konu belli olmadan; kit kurulur kurulmaz, ideal Pazartesi sabahı brifingten önce): takım reposunu boş iskelet olarak aç, arkadaşları davet et, kurulumlarını yaptır. Herkes hazır beklesin.
- **Faz 0–7 — Asıl kickoff** (konu açıklanınca): aynı repoya spec, sözleşme, roller ve görevler eklenir; arkadaşlar `git pull` ile alır.

Kullanıcı "kiti kurdum", "repoyu kur", "ekibi hazırla" derse Faz E; "projeye başlıyoruz / konumuz" derse Faz 0. Repo zaten iskeletse (kökte `CLAUDE.md` takım tablosu + `BASLA.md` "waiting for kickoff") Faz 0–7 onu kullanır, yeni repo açmaz; Faz 1'de tabloda olan bilgileri tekrar sorma.

## Faz E — Erken iskelet

1. **Ortam:** Faz 0'daki kontrolü çalıştır (`kontrol.ps1`), eksikleri çözdür.
2. **Sor (tek tur, her soruya tahmin):** takımda kimler · her kişinin sohbet dili · github.tools.sap kullanıcısı · github.com kullanıcısı (kit için) · güçlü yönü (henüz rol değil) · repo nerede (SAP org'u / kendi kullanıcın; SAP brifingte repo verecekse "sonra taşırız"). Kapsam/rol/görev sorma — konu belli değil.
3. **Repo (onaylı):** Faz 5 §1'deki sırayla repoyu aç veya clone'la. İçine koy:
   - `CLAUDE.md` (şablon `sablon/proje/CLAUDE.md`): takım tablosu dolu (kişi, dil, GitHub, güçlü yön); **Role / Owns sütunları `TBD at kickoff`**; dil, workflow, merge, milestone kuralları aynen.
   - `BASLA.md`: "Waiting for kickoff — the captain will add your role and first task after the briefing. Until then: finish setup, run `.claude/tools/kontrol.ps1`, `git pull` from time to time."
   - `docs/DURUM.md` (şablon), `.github/` (CODEOWNERS boş bırak — sahiplik kickoff'ta), `.claude/` (skills: `gorevim`, `kickoff`; tools: `kontrol.ps1/.sh`; `sorun-giderme.md`).
   - Etiketler: `rol:*` henüz değil; `integration`, `blocked` oluştur.
   - Commit `chore: team repo skeleton` + push.
4. **Davet (onaylı):** takım reposuna collaborator (write) ve kite (read) — listeyi göster, onay al, Faz 5 §4 komutlarıyla.
5. **Mesajlar:** `sablon/takim-kurulum-mesaji.md` → her arkadaşa kendi dilinde: kit kurulumu + takım reposu clone + kontrol script'i + "görevini bekle; kaptan haber verince `git pull` ve 'görevim ne?'".
6. `docs/DURUM.md`'ye "Skeleton ready, waiting for kickoff" + kim kurulumu doğruladı tablosu. `▶ Sen şimdi: mesajları gönder, brifingi dinle; konu açıklanınca 'projeye başlıyoruz, konumuz …' de.`

## Faz 0 — Bağlamı yükle (soru sormadan)

1. `<kit>/NOTLAR.md`, `<kit>/katalog/12-agent-tasarim-rehberi.md`, `<kit>/katalog/11-hazir-agentlar.md`'yi oku.
2. Ortamı kontrol et: `pwsh -File <kit>/kurulum/kontrol.ps1` (Mac/Linux: `bash <kit>/kurulum/kontrol.sh`; kit yoksa `jl version`, `joule -V`, `gh auth status --hostname github.tools.sap`, `git --version`, `node -v` tek tek). Sonucu tek satırda söyle, eksikleri `▶ Sen şimdi` ile çözdür. Bu bir soru değil, olgu.
3. Uyumluluk hatırlatması (tek satır): SAP VDI'ına onaysız VS Code eklentisi / MCP server kurma; kurulumlar Software Hub'dan, VS Code telemetry kapalı.

## Faz 1 — Niyet sorgusu (grilling)

`grilling` skill'i kuruluysa onun formatını kullan; değilse aynısını uygula: soruları **tur tur** sor, her turda o an cevaplanabilecek bütün soruları numaralı ver, **her soruya kendi önerini** `➡️` ile iliştir, cevabı bekle. Açılışta hipotezini ve güven yüzdesini yaz.

İlk tur en az şunları kapsar:

1. **Görev özeti:** brifingte ne istendi, teslim ne (demo/kod/sunum), jüri kriterleri, sunum süresi.
2. **Kaç kişi kodlayacak?** (3, 4, 5…) — rol tablosu buna göre değişir.
3. **Kimler:** isim, GitHub kullanıcı adı (SAP repo'sundaki **ve** github.com — kit için), güçlü yönü (kod / BTP-Basis / veri / sunum).
4. **Joule yolu:** Yol A (`jl`, Joule Studio managed runtime) mı Yol B (kendi agent + A2A) mı? Brifing ne derse o. Brifing açık bırakırsa varsayılan tahminin SAP'nin Prerequisites PDF'indeki araç setinden gelir (aşağıda "SAP araç seti"): Python + Podman + `kubectl`/`kyma` + `cf` + `joule`/`jl` → **pro-code agent** (Python, container, Kyma veya CF'ye deploy, Joule'a bağlanır). Tahmini böyle yaz, `jl` ile managed runtime'ı alternatif olarak sun.
5. **Repo nerede:** SAP'nin verdiği org (`github.tools.sap/<org>`) mı, mevcut bir repo mu, yeni repo mu açılacak? Issues açık mı?
6. **Her kişinin sohbet dili:** Claude onunla hangi dilde konuşsun? (Oktay: Türkçe; öneri: Almanca konuşanlarla Almanca.) Repo dili sorulmaz, her zaman İngilizce.

Sonraki turlar: veri kaynağı, SAP sistem erişimi, HITL noktası, KPI, demo personası. Koddan/ortamdan bulunabilen olguyu sorma, bak.

Durma şartı: ~%95 güven ve sonraki 3 sorunun cevabını tahmin edebiliyorsun. Kapanış özeti zorunlu: **Sonuç / Kim için / KPI / Kısıt / Kapsam dışı**. Açık "evet" bekle.

## Faz 2 — Fikir ve yaklaşım (brainstorming)

`superpowers:brainstorming` kuruluysa çağır ama sadece **2–3 yaklaşım + tradeoff** üretmek için; soru sorma işi Faz 1'de bitti.

**SAP araç seti (kısıt, öneri değil):** SAP hackathon için şu araçları istedi (Prerequisites PDF, "Day 1: Foundations & First Agent"): Claude Code via Hyperspace (`hai`), VS Code, Python 3 + pip, Podman Desktop, `git` + `gh` (`github.tools.sap`), `btp`, `cf`, Joule Studio CLI (`joule`, `jl`), `kubectl`, `kyma` (opsiyonel), BTP Trial. Yaklaşımları **sadece bu araçlarla** kur; dil Python (CAP/Node ancak brifing veya `jl` şablonu öyle isterse). Listede olmayan bir araç/servis gerekiyorsa (başka dil, başka DB, dış SaaS, n8n…) açıkça "SAP araç setinin dışında" diye işaretle ve neden şart olduğunu yaz. Agent'ın runtime LLM'i AI Core / Generative AI Hub; `hai` sadece bizim kodlama asistanımızın kanalı.

Her yaklaşımı şu süzgeçten geçir (`katalog/12` §2 ve §5):
- SAP araç setine sığıyor mu? (deploy yolu: Podman image → Kyma/`kubectl` veya `cf push`)
- 5 soruluk "agent mı otomasyon mu" testi
- SAP zaten yapıyor mu? (`katalog/11`) — yapıyorsa extension mı, boşluk mu
- En küçük mimari: 1 veri kaynağı, 3–6 tool, 1 HITL kapısı, masking, 10–20 eval
- Demo hikâyesi: persona + acı sayısı → mutlu yol → istisna insana → onay → trace/eval → KPI farkı → canlıya yol

Önerini söyle, kullanıcı seçsin. Onay bekle.

## Faz 3 — Spec ve sözleşme

Seçilen yaklaşımla iki dosya hazırla (şablonlar `sablon/proje/docs/`):
- `docs/spec.md` — problem, persona, KPI, demo senaryosu (adım adım), mimari şema, kapsam dışı, riskler.
- `docs/contract.md` — agent ↔ tool arayüzü: her tool'un adı, girdi/çıktı şeması, örnek cevap, salt okunur mu yazma mı. Agent geliştirici gerçek tool hazır olmadan buna göre mock'la ilerler.

Kullanıcıya göster, onay al.

## Faz 4 — Rol dağıtımı

Kişi sayısına göre (`egitim/13` §2):

| Kişi | Roller |
|---|---|
| 2 | **Kaptan + platform + MCP tool + entegrasyon sahibi** · **Agent** (happy path + istisna + eval) |
| 3 | **Kaptan + platform/deploy** · **Agent** (happy path + HITL + eval) · **Veri + MCP tool** |
| 4 | Kaptan + sunum · Agent · Veri + MCP tool · Platform + kimlik + deploy |
| 5 | Kaptan + sunum · Agent (happy path) · Agent (istisna/HITL/eval) · Veri + MCP tool · Platform + kimlik + deploy |

Her role **klasör sahipliği** ver. Yol A'da `jl` asset klasörleri doğal sınırdır (`jl asset --help` ile güncel türleri gör: `agent`, `mcp-server`, `cap-app`, `base-ui`…). Yol B'de: `agent/`, `agent/eval/`, `mcp-server/`, `deploy/`. Ortak dosyalar (`CLAUDE.md`, `docs/contract.md`, manifest/`mta.yaml`, `package.json`, `.env.example`) tek sahipli: kaptan veya platform.

**Entegrasyon bir roldür:** kaptan veya platform kişisi "entegrasyon sahibi" olur; parçaların birleşmesinden o sorumludur (hackathonların en sık çöktüğü yer). Roller esnek: kaptan görev ve kişi değiştirebilir.

Tabloyu göster, onay al.

## Faz 5 — Repo kurulumu (onaylı)


**Onay paketi (sürtünmeyi azalt):** Faz 4 onaylanınca Faz 5 ve Faz 6'yı ayrı ayrı onaya bölme. Tek tabloda sun: *repoya yazılacak dosyalar · açılacak etiketler · açılacak issue'lar (Faz 6 tablosu) · push edilecek branch*. Kaptan tek "evet" derse hepsini sırayla yap. Altın kural geçerli: dışa dönük her şeyi önce göster. Ama Faz 1–4 onayları ayrı kalır; paket sadece Faz 5+6 içindir. Collaborator daveti paketin dışında, ayrı onaylanır.
**Faz E iskeleti varsa:** repo açma; `git pull`, `CLAUDE.md` tablosuna Role/Owns sütunlarını doldur, CODEOWNERS'ı yaz, sahip klasörlerini ve `docs/spec.md` + `docs/contract.md`'yi ekle, `BASLA.md`'yi kişi bölümleriyle yeniden yaz. Aşağıdaki adımlardan sadece eksik olanları yap. SAP brifingte ayrı bir repo verdiyse iskelet dosyalarını oraya kopyala, arkadaşlara yeni repo linkini ver.

1. Repo: kullanıcının Faz 1'de söylediği yerde. Enterprise ise `export GH_HOST=github.tools.sap` (PowerShell: `$env:GH_HOST='github.tools.sap'`). Sırayla dene, ilk çalışanı kullan:
   - **Yol A ise önce:** Joule Studio solution'ları Git tabanlı. `jl solution list` → solution zaten varsa `jl solution clone <ad>`; yoksa yeni repoda `jl solution create`. Takım reposu bu solution reposu olur (ayrı repo açma).
   - SAP hazır repo verdiyse: `gh repo clone <org>/<ad>` (repo açma).
   - Org'da yetki varsa: `gh repo create <org>/<ad> --private --clone`.
   - İkisi de yoksa: kaptanın kendi kullanıcısı altında `gh repo create <ad> --private --clone`, sonra collaborator ekle.
   - `gh` hiç çalışmıyorsa: tarayıcıdan repo açtır, `git clone <url>` ile devam et.
2. Yol A ise repo kökünde `jl init claude` ve `jl skills init claude` (önce `jl login` gerekiyorsa söyle).
3. `sablon/proje/` içeriğini kopyala ve doldur:
   - `CLAUDE.md` → takım tablosu (kişi, sohbet dili, GitHub kullanıcı, rol, sahip olduğu klasörler), akış ve merge kuralları, milestone'lar. İngilizce.
   - `.github/CODEOWNERS` → klasör → `@kullanıcı`.
   - `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/gorev.md`.
   - `docs/spec.md`, `docs/contract.md` (Faz 3'ten).
   - Her sahip klasörüne boş bir `README.md` (klasörün amacı + sahibi).
- Kök dosyalar: `.gitattributes` (LF satır sonu, CRLF uyarısını önler), `.gitignore` (`.claude/ben.md` yerel kimlik dosyası git'e girmesin). Şablondan aynen kopyala.
   - **Takım araçlarını repoya göm:** `<kit>/kurulum/kontrol.ps1` ve `kontrol.sh` → `<repo>/.claude/tools/`; `<kit>/katalog/13-sorun-giderme.md` → `<repo>/.claude/sorun-giderme.md`. `.claude/` ekibin araç klasörüdür, SAP'ye teslim edilen ürün değildir; İngilizce kuralı ürün dosyaları içindir.
   - **Takım skill'lerini repoya göm:** `<kit>/skills/gorevim/` ve `<kit>/skills/kickoff/` → `<repo>/.claude/skills/`. Böylece takım üyelerinin kiti kurmasına gerek kalmaz; repoyu clone'layıp `claude` açınca `gorevim` hazırdır. (Kit yoksa ve bu skill zaten `.claude/skills/`'ten geliyorsa atla.)
   - Kit'te `sablon/proje/` yoksa (kit inmediyse) şablonları bu dosyadaki tanımlardan sıfırdan yaz: sahiplik tablosu + 5 akış kuralı (`CLAUDE.md`), spec başlıkları (Problem, Persona, KPI, Demo story, Architecture, Out of scope, Risks), contract (tool başına: kind, owner, description, input, output, example, errors).
4. Commit + push `main`. Collaborator eklemek gerekiyorsa listeyi göster, onayla, `gh api -X PUT repos/<org>/<ad>/collaborators/<kullanıcı>`.
   **Kit erişimi:** Kit private (`github.com/oktaydoganyildiz/sap-hackathon-kit`). Takım arkadaşlarının github.com kullanıcılarını collaborator (read) olarak ekle — onayla, sonra `GH_HOST=github.com gh api -X PUT repos/oktaydoganyildiz/sap-hackathon-kit/collaborators/<kullanıcı> -f permission=pull`. Davet e-postayla gider, kişinin kabul etmesi gerekir.
5. Etiketler: `gh label create rol:agent`, `rol:veri`, `rol:platform`, `rol:kaptan`, `blocked`.

## Faz 6 — Görevleri böl ve ata (issue)

Spec'i dikey, uçtan uca dilimlere böl. **İlk iki issue her zaman:**
1. `[integration] Integration skeleton: mock agent deployed, called once end to end` — sahip: entegrasyon sahibi, hedef **Pazartesi akşamı**. Mock agent sabit cevap döner, mock tool `docs/contract.md`'deki örnek cevabı döner; amaç deploy/kimlik/Joule bağlantısını ilk gün çözmek. Diğer herkes bu hat üzerine kendi parçasını takar.
2. `[integration] Daily integration check` — sahip: entegrasyon sahibi, açık kalır; her gün 13:00'te parçalar main'de birlikte çalışıyor mu, yorum olarak not düşülür.

Sonra rol başına issue'lar. Her issue (İngilizce):

```
Başlık: [rol] kısa fiil cümlesi
Sahip (assignee): @kullanıcı
Klasör: <sadece bu klasöre yazılır>
Bitti tanımı: <gözle kontrol edilebilir 1–3 madde>
Bağımlılık: Blocked by #<no> (varsa)
Hedef: Mon evening / Tue 12:00 / Tue 17:00 / Wed 12:00 / Wed 18:00 (freeze)
```

`gh issue create --title ... --body ... --assignee ... --label ...` ile aç. Önce listeyi tablo olarak göster, onay al, sonra toplu aç. Etiketlere `integration` ekle. Milestone kullanacaksan: `mon-integration-skeleton`, `tue-real-agent`, `wed-freeze`.

**Issues kullanılamıyorsa** (repo'da kapalı, `gh` erişimi yok, assignee eklenemiyor): görevleri repo kökünde `TASKS.md` tablosuna yaz — `| # | Görev | Sahip | Klasör | Bitti tanımı | Blocked by | Hedef | Durum |`. Sadece kaptan bu dosyayı düzenler; üyeler okur, durumu PR açıklamasında bildirir. `gorevim` skill'i bu dosyayı da okur.

## Faz 7 — Herkesi başlat (kaptan dağıtır)

1. Repo kökünde `BASLA.md` oluştur ve commit'le (İngilizce): her kişi için bir bölüm (ad, sohbet dili, rol, sahip olduğu klasörler, atanmış issue numaraları/başlıkları, kurulum komutları, Claude'a söyleyeceği cümle).
   Faz E yapıldıysa arkadaşlar zaten kurulu: mesaj kısa olur — "Kickoff bitti. `git pull`, `claude`, 'görevim ne?'. Rolün: …, klasörün: …, ilk görevin: #… (hedef …)."
2. Faz E yapılmadıysa kaptana **her takım arkadaşı için ayrı, kopyala-yapıştır hazır mesaj** ver (Teams/WhatsApp'a atacak), **o kişinin dilinde** (aşağıdaki Türkçe şablonu çevir; komutlar aynı kalır). Şablon:

   ```
   Merhaba <ad> 👋  Rolün: <rol>. Senin klasörün: <klasör>. İlk görevin: #<no> <başlık> (hedef: <saat>).
   VDI'da sırayla çalıştır:
     # 1) Kit (GitHub davetini kabul ettikten sonra; github.com açılmıyorsa bu bloğu atla)
     gh auth login --hostname github.com
     git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
     pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1
     # 2) Takım reposu
     gh auth login --hostname github.tools.sap
     $env:GH_HOST='github.tools.sap'
     npm install -g @sap/joule-studio-cli          # sadece joule/jl yoksa
     git clone <repo-url> $HOME\<repo>
     cd $HOME\<repo>
     pwsh -File .claude\tools\kontrol.ps1     # eksik araç varsa önce onu çöz
     claude
   Claude açılınca yaz:  takıma katılıyorum, görevim ne?
   Kurallar: sadece kendi klasörüne yaz, docs/contract.md'ye dokunma, 1-2 saatte bir push,
   iş bitince PR (Closes #<no>) — sadece kendi klasörün ise kendin merge et. Repoya her şey İngilizce.
   Takıldıysan 30 dk sonra grupta yaz.
   ```
   Yol A ise ilgili kişiye `jl login <url>` satırını da ekle. Kit kurulamazsa sorun değil: `gorevim`, kontrol script'i ve sorun giderme kartı repo içindeki `.claude/`'dan gelir.
3. Kaptana kendi sıradaki işini söyle (genelde: ortak dosyalar, ilk issue'su, 13:00 entegrasyon kontrolü).
4. Ritüelleri hatırlat: **bu akşam entegrasyon iskeleti (mock agent uçtan uca)**, sabah 10 dk stand-up, 13:00 entegrasyon, 17:00 "jüriye ne gösterirdik", 30/60 dk tıkanma kuralı, Çarşamba 18:00 freeze (`egitim/13` §3).

## Sonra — kaptan modu

Faz 5'te repoya `docs/DURUM.md`'yi de koy (`takip` skill'i §5 biçimi) ve kickoff kararlarını oraya yaz. Kickoff bitince takımı izleme işi **`takip` skill'ine** geçer: kullanıcı "durum ne", "stand-up", "PR'lara bak", "kim ne yaptı" derse ya da kaptan yeni oturum açarsa onu çağır. `takip` ayrıca repoya `.claude/skills/` altına kopyalanmaz (sadece kaptanın kitinde); kaptan kitsizse bu dosyanın aşağıdaki kurallarını uygula.

Kısa yedek (takip skill'i yoksa): `gh issue list --state all --json number,title,assignees,state,labels`, `gh pr list` → kim neyi bitirdi, ne bloke, hangi hedef risk altında; 5 satırı geçmeyen özet + gerekiyorsa kapsam kesme önerisi. Sonunda yine `▶ Sen şimdi` / `▶ Takım şimdi` (kişi bazında: "<ad>: PR #12'yi merge'e hazırla", "<ad>: #15'e geç").

Saat bazlı hatırlatma: kullanıcı saati söylerse ya da sistem saatine göre milestone yaklaşıyorsa (Pzt akşam entegrasyon iskeleti, Sal 12:00, Sal 17:00, Çar 12:00, Çar 18:00 freeze) proaktif uyar: neyin hazır olması gerektiği, ne riskte, ne kesilebilir.

Yeni görev çıkarsa (bug, eksik tool, istek): issue aç (onayla), sahibini sahiplik tablosundan seç, kaptana o kişiye atılacak tek satırlık mesajı ver.

## Görev devri (devret)

Kaptan "#5'i Ali'den Ayşe'ye ver", "Ali'nin işini Ayşe alsın", "bunu ben alayım" dediğinde tek hamlede yap (onayla, sonra uygula):
1. `gh issue edit <no> --add-assignee <yeni> --remove-assignee <eski>`
2. Etiket: `--remove-label kisi:<eski> --add-label kisi:<yeni>` (rol etiketi de değişecekse onu da).
3. Issue yorumu (İngilizce): `Reassigned from <eski> to <yeni>. Branch/PR to continue from: <varsa branch veya PR no>.`
4. Yeni sahip başka birinin klasörüne yazacaksa: ya `CLAUDE.md` Owns + `CODEOWNERS` güncelle ya da issue'ya "bu issue için <klasör> altına yazabilir" yorumu.
5. `docs/DURUM.md` People tablosunu ve Decisions satırını (tarihli) güncelle.
6. Kaptana iki tek satırlık mesaj ver: eski sahibe ("#<no> artık <yeni>'de, dur") ve yeni sahibe ("#<no> sende, <branch/PR> üzerinden devam et"), her biri kendi dilinde. `gorevim` skill'i eski sahibin oturumunda bunu zaten kendisi fark edip durur ama oturumu boştaysa kaptanın söylemesi gerekir.
<<<END>>>

<<<FILE skills/gorevim/SKILL.md>>>
---
name: gorevim
description: Hackathon takım üyesinin kendi görevini alıp çakışmadan çalışması. Kullanıcı "takıma katılıyorum", "görevim ne", "sıradaki işim", "my task", "what should I work on", "PR açalım", "işim bitti" dediğinde veya kickoff ile kurulmuş bir hackathon reposunda (kökünde sahiplik tablolu CLAUDE.md ve docs/contract.md var) iş başlarken çağır.
---

# Görevim — takım üyesi akışı

Repo kökündeki `CLAUDE.md` takım kurallarıdır, önce onu oku. Sahiplik tablosu ve `docs/contract.md` bağlayıcıdır.

**Yönlendirme:** Her cevabın sonunda `▶ Sen şimdi:` (İngilizce: `▶ You now:`, Almanca: `▶ Du jetzt:`) ile kullanıcının yapacağı tek somut adımı yaz. Repo kökünde `BASLA.md` varsa önce oradaki kişinin bölümünü oku.

**Dil:** Kullanıcıyla `CLAUDE.md` takım tablosundaki **sohbet dilinde** konuş (Türkçe, Almanca…). Repoya yazdığın her şey **İngilizce**: kod, yorum, isimler, commit, branch, issue yorumu, PR.

## Henüz görev yoksa (bekleme modu)

`BASLA.md` "Waiting for kickoff" diyorsa veya sana atanmış görev yoksa: "Kaptan henüz görevleri dağıtmadı" de. Bu arada şunları yaptır: `.claude/tools/kontrol.ps1` temiz mi, `gh auth status --hostname github.tools.sap` girişli mi, Yol A için `jl version`, kit kuruluysa `katalog/12-agent-tasarim-rehberi.md`'yi okumasını öner. Kurulum tamamsa kaptana "kurulumum hazır" demesini söyle (kaptan `DURUM.md`'de işaretler). `▶ Sen şimdi: bekle; kaptan haber verince git pull → "görevim ne?"`.

## Başlarken

1. `git pull --rebase origin main`
2. Kimsin (sırayla dene, ilk net olanı kullan):
   a. `.claude/ben.md` varsa içindeki kişi adını kullan (bir kez yazılır, git'e girmez).
   b. `gh api user --jq .login` → `CLAUDE.md` takım tablosunda **tek** satırın GitHub sütunuyla eşleşiyorsa o kişisin.
   c. Eşleşme yoksa ya da **birden fazla satır aynı GitHub hesabını** gösteriyorsa (prova, paylaşılan hesap) tahmin etme, sor: "Tablodaki hangi kişisin: <adlar>?" Cevabı `.claude/ben.md` dosyasına tek satır olarak yaz (`Ali`). Kullanıcı "ben Ali'yim" diye kendini söylediyse (a–b'den önce) onu kabul et ve aynı dosyaya yaz.
   Sonra tabloda o satırın klasörlerini ve sohbet dilini al. Görevleri **adınla** süz: assignee sen + `kisi:<ad>` etiketi (varsa) senin adın.
3. Görevlerin: `gh issue list --assignee @me --state open` (enterprise ise önce `GH_HOST=github.tools.sap`). `gh` çalışmıyor ya da repoda `TASKS.md` varsa oradan, `Sahip` sütununda sen olan satırları oku. Bloke olmayan ve hedef saati en yakın olanı öner, kullanıcıya onaylat.
4. Başla: `gh issue comment <no> --body "Başladım"`, branch `git switch -c <ad>/<no>-<kısa-ad>` (`<ad>` = tablodaki küçük harfli ilk adın, örn. `ali`).

## Çalışırken

- **Sadece kendi klasörüne yaz.** Başka klasörde değişiklik gerekiyorsa yazma; `gh issue create` ile sahibine aç, kullanıcıya söyle, kendi işine dön.
- **Sözleşmeye uy.** `docs/contract.md`'deki tool adı/girdi/çıktıyı değiştirme. Karşı taraf hazır değilse sözleşmeye göre mock kullan. Sözleşme yanlışsa kaptana issue aç.
- **Ortak dosyalara dokunma** (`CLAUDE.md`, `docs/contract.md`, manifest, `package.json`, `.env.example`) — sahibi değilsen issue aç.
- Küçük ve sık commit. Şifre/token commit'leme.
- Hata/login/deploy sorununda önce `.claude/sorun-giderme.md`'de belirtiyi eşle (araç eksikse `.claude/tools/kontrol.ps1`). Hata metnini tam iste, tahminle düzeltme.
- 30 dakika tıkandıysan kullanıcıya söyle; 60 dakikaysa mentora gitmesini öner.
- **Kaptan seni GitHub'dan takip ediyor, görünür ol:** her 1–2 saatte bir push et (draft PR açık olabilir: `gh pr create --draft`). Tıkanınca issue'ya yorum + etiket: `gh issue comment <no> --body "Blocked: <neden, kime ihtiyaç var>"` ve `gh issue edit <no> --add-label blocked`. Çözülünce etiketi kaldır.
- **Görev el değiştirebilir — kaptan issue'yu başkasına verebilir.** Bir issue'ya başlamadan, her yeni oturumun başında, her push'tan ve PR açmadan önce `gh issue view <no> --json assignees,labels` ile sahibini yeniden kontrol et. Issue senin sayılır sadece: assignee sensin **ve** `kisi:<ad>` etiketi varsa o senin adın. Atama veya `kisi:` etiketi başkasına geçtiyse: **dur** — push etme, PR açma, o issue'nun dosyalarına dokunma; kullanıcıya tek cümleyle "#<no> artık <kişi>'de" de, issue'ya `gh issue comment <no> --body "Reassigned, stopping my work on this"` yaz, yarım kalan branch'in adını yorumda yeni sahibe bırak ve Başlarken §3'e dönüp sıradaki görevini al. Kaptana sormadan geri alma. Provada herkes aynı GitHub hesabını kullanıyorsa sahibi ayıran tek şey `kisi:` etiketidir.

## Bitirirken

1. `git pull --rebase origin main`, test/çalıştırma kontrolü.
2. `git push -u origin HEAD` → `gh pr create --fill --body "Closes #<no>"` (şablonu doldur: ne yapıldı, nasıl denenir, ekran görüntüsü). `gh` yoksa push'tan sonra PR'ı tarayıcıdan açması için linki kullanıcıya ver; `TASKS.md` kullanılıyorsa görev numarasını PR başlığına yaz.
3. **Merge:** PR sadece senin klasörlerine dokunuyor ve çalışıyorsa kendin merge et: `gh pr merge <no> --squash --delete-branch`. Ortak dosyalara, `docs/contract.md`'ye veya başkasının klasörüne dokunuyorsa merge etme, kaptandan onay iste. Çarşamba 18:00 freeze'den sonra sadece kaptan merge eder.
4. Merge sonrası entegrasyon hattı (main) hâlâ çalışıyor mu, hızlıca dene; bozulduysa hemen entegrasyon issue'suna yaz.
5. Sıradaki görevi öner (Başlarken §3).
<<<END>>>

<<<FILE skills/takip/SKILL.md>>>
---
name: takip
description: Kaptanın Claude'u için takım takibi — takım arkadaşlarının ne yaptığını GitHub'dan (issue, PR, commit, branch) izler, PR'ları sahiplik ve docs/contract.md'ye göre denetler, riskleri ve tıkanmaları bulur, docs/DURUM.md'yi güncel tutar ve kaptana kişi bazında ne yapılacağını söyler. Kullanıcı "durum ne", "stand-up", "neredeyiz", "takımı kontrol et", "PR'lara bak", "kim ne yaptı", "check the team", "status" dediğinde veya kickoff ile kurulmuş repoda kaptan yeni oturum açtığında çağır.
---

# Takip — kitin beyni

Sen takımın hafızası ve kontrol kulesisin. Takım arkadaşları kendi bilgisayarlarında kendi Claude'larıyla çalışır; sen onların işini **GitHub üzerinden** görürsün. Kaptan (çoğunlukla Oktay) her şeyi seninle yürütür.

**Dil:** Kaptana (Oktay) raporu **Türkçe** ver; takım arkadaşlarına önerdiğin mesajları **o kişinin sohbet dilinde** yaz (`CLAUDE.md` takım tablosu). Repoya yazdığın her şey (`docs/DURUM.md`, PR yorumları, issue'lar) **İngilizce**.

Repo kökünde `CLAUDE.md` (sahiplik tablosu), `docs/contract.md`, `docs/spec.md`, `BASLA.md`, `docs/DURUM.md` olmalı. Enterprise GitHub ise `GH_HOST=github.tools.sap`.

**Kaptan koruması:** Kit takımda herkeste kurulu. `gh api user --jq .login` ≠ `CLAUDE.md` tablosundaki kaptan ise tam takip yapma: kullanıcıya sadece kendi işlerinin durumunu göster (`gorevim` gibi), `docs/DURUM.md`'ye yazma, başkasının PR'ına yorum/merge önerme. Takım durumunu okuyup özetlemek serbest.

## 0. Hafızayı yükle (her oturum başında, sormadan)

`docs/DURUM.md`'yi oku: son durum, kararlar, açık riskler, en son ne zaman bakıldı. Yoksa oluştur (şablon: aşağıda §5). Konuşma geçmişine güvenme; tek kaynak bu dosya + GitHub.

## 1. Veriyi topla

```
git fetch --all --prune
gh issue list --state all --limit 100 --json number,title,assignees,state,labels,updatedAt,comments
gh pr list --state all --limit 50 --json number,title,author,state,isDraft,mergeable,reviewDecision,headRefName,files,updatedAt,closingIssuesReferences
git log origin/main --since="<DURUM.md'deki son bakış>" --pretty="%h %an %ar %s"
git for-each-ref --sort=-committerdate refs/remotes/origin --format="%(refname:short) %(authorname) %(committerdate:relative)"
```
`gh` yoksa: `TASKS.md` + `git log` + branch listesiyle aynı analizi yap.

## 2. Kişi bazında analiz

Her takım üyesi için (sahiplik tablosundan):
- **Ne bitti:** merge olmuş PR'lar, kapanan issue'lar (son bakıştan beri).
- **Ne üzerinde:** açık branch / draft PR / "Başladım" yorumlu issue.
- **Sinyaller:**
  - 🟥 **Tıkanmış:** issue'da "blocked" etiketi/yorumu, ya da 2 saattir commit/yorum yok ama issue açık.
  - 🟧 **Sahiplik ihlali:** PR, sahibinin klasörü dışındaki dosyalara dokunuyor (`files` ↔ sahiplik tablosu). Ortak dosyalara (`CLAUDE.md`, `docs/contract.md`, manifest, `package.json`) sahibi olmayan dokunmuş.
  - 🟧 **Sözleşme ihlali:** tool adı/girdi/çıktı `docs/contract.md`'den farklı (PR diff'ine bak: `gh pr diff <no>`).
  - 🟨 **Bayat branch:** yarım günden eski, `main`'den çok geride → rebase hatırlat.
  - 🟨 **Merge bekleyen:** onaylanmış ama merge olmamış PR; çakışmalı (`mergeable: CONFLICTING`) PR.
- **Milestone riski:** bugünkü hedefe (Pzt akşam entegrasyon iskeleti — mock agent uçtan uca, Sal 12:00 gerçek agent aynı hatta, Sal 17:00 gerçek veri, Çar 12:00 HITL+eval, Çar 18:00 freeze) yetişmeyecek issue'lar.
- **Entegrasyon sağlığı (her takipte, en önemli sinyal):** `integration` etiketli issue'lardaki son yorum; main son merge'den sonra uçtan uca çalışıyor mu? Bilinmiyorsa entegrasyon sahibine "main'i dene" mesajı öner. Pazartesi akşamı iskelet çalışmıyorsa 🟥 — diğer her şeyin önüne koy.

## 3. PR denetimi (kaptan "PR'lara bak" derse veya yeni PR varsa)

Merge kuralı: sahibi kendi klasörüne dokunan PR'ı kendisi merge eder; kaptanın onayı yalnızca ortak dosyalara, `docs/contract.md`'ye ya da başkasının klasörüne dokunan PR'lar için gerekir. Bu yüzden önceliğin: (1) onay bekleyen PR'lar, (2) kendi kendine merge edilmiş ama ihlal içeren PR'lar (geri alma/düzeltme öner), (3) İngilizce olmayan kod/commit/yorum (düzelt öner).

Her açık PR için `gh pr view <no>` + `gh pr diff <no>`:
1. Sahiplik ve sözleşme kontrolü (yukarıdaki sinyaller).
2. Issue'yu kapatıyor mu (`Closes #`), bitti tanımını karşılıyor mu?
3. Sır sızıntısı: token, şifre, `.env` içeriği → 🟥, merge etme.
4. Hüküm: **merge edilebilir / küçük düzeltme / geri gönder**. Yorum taslağını kaptana göster; onaylarsa `gh pr review <no> --comment|--approve|--request-changes --body "..."`, merge için `gh pr merge <no> --squash` (freeze sonrası sadece kaptan). Kaptanın onayı olmadan yorum atma, merge etme.

## 4. Kaptana rapor (kısa, her zaman bu biçim)

```
[Takip — <saat>]  Hedef: <sıradaki milestone> · durum: 🟢/🟨/🟥
<ad>: ✅ <biten> · ⏳ <üzerinde> · <sinyal varsa>
<ad>: ...
Riskler: <en fazla 3 madde>
▶ Sen şimdi: <tek adım — ör. "PR #14'ü onayla", "Dilan'a contract değişikliğini sor", "#9'u kes, slayta taşı">
▶ Takım şimdi: <ad>: <tek satır mesaj, kopyala-yapıştır> · <ad>: ...
```
Kapsam kesme önerisi kaptanındır; sen sadece öner ve gerekçe ver.

## 5. `docs/DURUM.md` — kalıcı hafıza (her takipten sonra güncelle, commit'le)

Sadece kaptan ya da kaptanın Claude'u yazar. Biçim:

İngilizce yazılır (şablon: kit `sablon/proje/docs/DURUM.md`):

```markdown
# Status
Last check: <date time>
Next milestone: <...> — <🟢/🟨/🟥>
Integration (main end to end): <works / broken since … / unknown>

## People
| Person | Role | Done | Working on | Signal |
|---|---|---|---|---|

## Decisions (dated, newest first)
- <time> · <decision> · <why>

## Risks / open questions
- ...

## Cut (goes to the "roadmap" slide)
- ...
```
Commit: `docs: status <time>` — doğrudan `main`'e (bu dosya kaptanın).

## 6. Sürekli takip

Kaptan isterse Claude Code'da periyodik takip başlat: `/loop 30m takımı kontrol et` (loop desteklenmiyorsa her stand-up'ta ve 13:00 / 17:00'de elle "durum ne"). Milestone'a 1 saat kala proaktif uyar.
<<<END>>>

<<<FILE sablon/takim-kurulum-mesaji.md>>>
# Template — setup message for teammates (captain sends)

Claude fills this in during **Faz E (early skeleton)**, after the captain installed the kit and the team repo skeleton exists. Write it in each teammate's chat language (Deutsch / Türkçe / English); commands stay as they are. Check kit visibility first:
`GH_HOST=github.com gh repo view oktaydoganyildiz/sap-hackathon-kit --json visibility --jq .visibility`

---

Hi <name>, please get ready for the hackathon in your VDI (≈10 min). You don't need to build anything yet.

1. Accept the two GitHub invitations: our team repo `<org>/<team-repo>` on github.tools.sap and the kit `oktaydoganyildiz/sap-hackathon-kit` on github.com. *(Skip the kit invitation if the kit is public.)*
2. In PowerShell:
   ```
   # kit (skip this block if github.com is blocked in the VDI)
   gh auth login --hostname github.com
   git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
   pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1

   # team repo
   gh auth login --hostname github.tools.sap
   $env:GH_HOST='github.tools.sap'
   git clone <team-repo-url> $HOME\<team-repo>
   cd $HOME\<team-repo>
   pwsh -File .claude\tools\kontrol.ps1
   ```
3. Fix anything marked `[--]` / `[!!]` (the hint is shown), then reply "setup ready" in our group.
4. Wait for my message after the briefing. Then: `git pull` → `claude` → "I'm joining the team, what's my task?" (in your language). Claude will talk to you in <language>; everything written into the repo is English.

---

## What Claude does around this message

- Before inviting: show the list of usernames (team repo: write; kit: read), get approval, then
  - team repo: `GH_HOST=github.tools.sap gh api -X PUT repos/<org>/<team-repo>/collaborators/<user> -f permission=push`
  - kit: `GH_HOST=github.com gh api -X PUT repos/oktaydoganyildiz/sap-hackathon-kit/collaborators/<user> -f permission=pull`
- Before making the kit public (only if the captain asks): list what's inside (`katalog/`, `egitim/`, `beyin/` = the captain's personal SAP notes, `NOTLAR.md`, `skills/`), run a secrets scan (emails, S/P-user IDs, tokens), wait for an explicit "yes". Then `GH_HOST=github.com gh repo edit oktaydoganyildiz/sap-hackathon-kit --visibility public --accept-visibility-change-consequences`. Say clearly: going public is effectively irreversible (forks, caches).
- After sending: track who replied "setup ready" in `docs/DURUM.md` and remind the captain about the rest.
<<<END>>>

<<<FILE katalog/12-agent-tasarim-rehberi.md>>>
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
<<<END>>>

<<<FILE katalog/13-sorun-giderme.md>>>
# Sorun giderme kartı (belirti → olası neden → komut)

Hackathonda en çok zaman giriş, deploy ve log okumaya gider. Önce `kurulum\kontrol.ps1` çalıştır; araç eksikse burası değil, kurulum sorunu.

Komutlardaki `<...>` yerleri ortamdan doldur. Emin değilsen `<araç> <komut> --help`. "doğrulanmadı" işaretli satırlar sahada kontrol edilecek.

## 1. Giriş (login)

| Belirti | Olası neden | Ne yap |
|---|---|---|
| `btp login --sso` "CLI server URL" sorusunda takılıyor, `Reading input failed: EOF` | Claude'un içinden (etkileşimsiz) çalıştırıldı | URL'yi ver: `btp login --sso --url https://cli.btp.cloud.sap --subdomain <global-account-subdomain>`; çıkan linki tarayıcıda tamamla. Ya da komutu kendi terminalinde çalıştır. (SAP Beyni dersi, btp CLI 2.116) |
| `btp` "Unknown session" | Oturum düştü | Aynı `btp login --sso --url ... --subdomain ...` |
| `cf login --sso` "Unable to authenticate" (Claude içinden) | Passcode etkileşimli soruluyor | Tarayıcıda `https://login.cf.<region>.hana.ondemand.com/passcode` → kodu al → `cf login -a https://api.cf.<region>.hana.ondemand.com --sso-passcode <KOD>`. Kod tek kullanımlık. (SAP Beyni dersi) |
| `cf target` org/space yok | Doğru subaccount'a / space'e yetki yok | `cf orgs`, `cf spaces`; yoksa kaptana / SAP mentora space rolü sor |
| `jl` komutları "not logged in" | Backend oturumu yok | `jl login <url>` (URL SAP'den gelir, ya da `JL_URL`); kontrol `jl info` |
| `joule deploy` yetki hatası | IAS'ta `Cli2Joule` client / App2App rolü eksik | `egitim/08-joule-cli-capability.md`, `beyin/ai/baglanti/joule-cli-login-sorunlari.md` |
| `gh` github.tools.sap'ta "not logged in" | Enterprise host ayrı oturum ister | `gh auth login --hostname github.tools.sap`; PowerShell: `$env:GH_HOST='github.tools.sap'` |
| `git push` 403 | Repoya yazma yetkin yok / yanlış hesap | `gh auth status --hostname github.tools.sap`; kaptana collaborator eklet |

## 2. Deploy

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Yol A: `jl solution deploy` hata veriyor | `solution.yaml` / asset tanımı geçersiz | Önce `jl solution validate` (otomatik düzeltme seçeneği var); sonra deploy |
| Yol A: hangi solution'lar var bilinmiyor | — | `jl solution list`; takım reposu solution'ın Git reposuysa `jl solution clone <ad>` |
| Yol B: `cf push` / `cf deploy` "staging failed" | Buildpack, Node/Python sürümü, eksik bağımlılık | `cf logs <app> --recent`; manifest'te `buildpacks` ve `memory`; Node 20.12–24 |
| Yol B: `.mtar` deploy edilmiyor | MTA plugin yok | `cf install-plugin multiapps`; build: `mbt build` |
| Servis bağlanmıyor (AI Core, destination) | Entitlement subaccount'a atanmamış | `btp list accounts/entitlement --subaccount <id>`; global account'ta olup subaccount'ta olmayan kullanılamaz (SAP Beyni dersi) |
| AI Core'da model / kota görünmüyor | Service key yok | AI Core instance'ına service key oluştur; Generative AI Hub sadece `extended` planda (SAP Beyni dersi) |

## 3. Çalışma zamanı ve loglar

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Yol A: agent cevap vermiyor / yanlış tool çağırıyor | Talimat ya da tool tanımı | `jl solution traces` (son çalıştırmalar, span detayı), `jl solution observe` (özet metrikler) |
| Yol B: agent 500 dönüyor | Uygulama hatası | `cf logs <app> --recent`; canlı izleme `cf logs <app>` |
| Kyma'da çalışan parça hata veriyor | Pod çöküyor | `kubectl get pods -n <ns>`, `kubectl logs <pod> -n <ns> --tail=200`, `kubectl describe pod <pod> -n <ns>` |
| Joule "zaman aşımı" / cevap gelmiyor | Agent 60 sn'yi aşıyor (Joule beklemiyor) | Demo sorusunu küçült, tool sayısını azalt, LLM adımlarını kısalt (`egitim/10` §5) |
| Joule agent'ı hiç çağırmıyor | Capability / destination / A2A kartı | Yol A: deploy sonrası Joule'a kayıt otomatik — `jl a2a card` ile kart dönüyor mu bak. Yol B: destination adı + `joule deploy` capability, `a2a-inspector` ile kart kontrolü |
| Agent'ın Agent Card'ı | — | `jl a2a card`; mesaj testi `jl a2a message "<metin>"` |
| 401/403 tool çağrısında | Kullanıcı yetkisi ∩ agent yetkisi; principal propagation / teknik kullanıcı | Hangi kimlikle çağrıldığını logla; `egitim/04-kimlik-ias.md`, `beyin/btp/kavramsal/mcp-agent-auth-modlari.md` |
| AI Core kotası bitti / demo provası | — | Yol B: `btp-joule-a2a-pro-code-agent` mock-response extension (`egitim/07`) |

## 4. Takım ve Git

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Merge çakışması | İki kişi aynı dosyaya dokundu | `git pull --rebase origin main`, çakışan dosyanın sahibine sor; sahiplik ihlali ise `takip` skill'i raporlar |
| main bozuldu | Son merge entegrasyonu kırdı | `git log --oneline -5` → sorumlu commit'i `git revert <sha>`; entegrasyon issue'suna yaz |
| `gh issue create --assignee` hata | Kişi repoya collaborator değil | Kaptan ekler; ya da `TASKS.md` yedeği |
| Claude başka klasöre yazmak istiyor | Görev sınırı belirsiz | Dur, issue aç, sahibine ata (`gorevim` kuralı) |

## 5. Hâlâ çözülmediyse

30 dk kuralı: takıma söyle. 60 dk: SAP mentoruna git — hata mesajının **tam metni**, çalıştırdığın komut ve hangi yol (A/B) ile.
<<<END>>>

<<<FILE egitim/13-takim-calismasi.md>>>
# 13 — İlk hackathon: takım çalışması ve görev dağılımı

`10-hackathon-stratejisi.md` §3–4'teki 4 günlük planı ve rolleri, iki Joule yoluna (Yol A `jl` / Yol B A2A) göre günceller. Takım: Fairconsult'tan 5 kişi.

## 1. Temel kurallar (genel hackathon pratiği)

- **Roller Pazartesiden önce belli olsun.** Brifingten sonra sadece ince ayar yapılır.
- **Tek karar verici (kaptan).** 10 dakika tartışıp anlaşamazsanız kaptan karar verir ve devam edilir. Çok şef = kayıp gün.
- **Herkes ilk saatten paralel çalışır.** Bir kişi kod yazarken dört kişi izlemesin. Biri iskeleti, biri veriyi, biri hikâyeyi kurar.
- **Önce demo, sonra kod.** Jüri 5 dakikalık demoda gördüğünü puanlar. Pazartesi akşamı demo senaryosunu yazın, kodu ondan geriye doğru planlayın. Çalışan tek özellik, bozuk beş özellikten iyidir.
- **Tek iletişim kanalı.** Tek bir Teams/WhatsApp grubu, yan sohbet yok. Karar ve linkler tek bir paylaşılan dosyaya yazılır.
- **Herkes projeyi anlatabilmeli.** Jüri rastgele birine soru sorabilir.
- **Uyku.** Günde 2 hacking günü var, gece yarısı kodlama yapmayın; Çarşamba akşamı özellik dondurulur.

## 2. Roller (5 kişi, iki yola göre)

| Rol | Yol A (`jl`, Joule Studio) | Yol B (A2A, kendi agent'ımız) | Kim (öneri) |
|---|---|---|---|
| **Kaptan + ürün/sunum** | Niyet ve PRD'yi yazar (IBD 1–2. faz), kapsamı korur, demo senaryosu, slaytlar, KPI sayısı, saat tutar | Aynı | Sunumu en iyi yapan kişi |
| **Agent geliştirici (2)** | `jl init claude` ile Claude Code'u sürer, spec → kod → test/eval fazları, agent instructions ve tool tanımları | LangGraph + `a2a-sdk` agent, AI Core / GenAI Hub orchestration | En iyi kod yazan iki kişi |
| **Veri + tool (MCP)** | Kaynak veriyi hazırlar, OData/REST'ten MCP server asset'i, demo verisi | Datasphere/BW/HANA verisi, MCP server veya SQL erişimi | **Oktay** |
| **Platform + kimlik + deploy** | `jl login`, `jl solution deploy`, Joule Work'te test, roller, AI Agent Hub | BTP subaccount, CF deploy, destination, IAS, `joule deploy` capability | BTP/Basis bilen kişi |

Ortak işler herkesindir: eval sorularını yazmak (her rol 3–4 soru), demo provası, yedek video.

**Agent geliştirici 2 kişi ise** biri "mutlu yol"u (happy path), diğeri istisna/HITL ve eval'i alır. İkisi aynı dosyaya aynı anda dokunmaz.

## 3. Ritüeller

| Ne zaman | Ne | Süre |
|---|---|---|
| Her sabah (check-in'den sonra) | Stand-up: dün ne bitti, bugün ne bitecek, ne tıkıyor | 10 dk |
| Her gün 13:00 | Öğle yemeğinde entegrasyon: herkesin parçası ana hatta birleşiyor mu? | 15 dk |
| Her gün 17:00 | Demo kontrolü: şu an jüriye gösterseydik ne gösterirdik? Ekran kaydı al | 15 dk |
| Tıkanınca | 30 dakika kuralı: 30 dk tek başına tıkandıysan söyle; 60 dk olduysa mentora git | — |

## 4. Gün gün kim ne yapar

| Gün | Kaptan / sunum | Agent geliştirici (2) | Veri + tool (Oktay) | Platform + deploy |
|---|---|---|---|---|
| **Pzt** | Brifing notu, fikir seçimini yönetir (`katalog/12` §5 çerçevesi), demo senaryosu taslağı, kickoff | Brifingi dinler; öğleden sonra `jl init claude` veya agent iskeleti, mock agent (sabit cevap) | Hangi veri, nereden, hangi 3–6 tool; `docs/contract.md`'deki örnek cevapları döndüren mock tool | Erişimleri test eder: BTP, IAS, AI Core, `jl login` / `joule login`. **Akşam: entegrasyon iskeleti — mock agent deploy, Joule'dan bir kez uçtan uca çağrıldı** |
| **Sal** | Slayt iskeleti, KPI hesabı, persona | Öğlene kadar **"Merhaba Joule"** uçtan uca; sonra asıl mantık | MCP/tool'lar salt okunur çalışır, agent'a bağlanır | İlk deploy, Joule'dan çağırma; deploy'u tekrarlanabilir yapar (script) |
| **Çar** | Demo provası 1, hikâye düzeltme | İstisna/HITL, eval (10–20 soru), guardrail | Yazma tool'u (onaylı), demo verisini sabitler | Son deploy, yedek ortam; **akşam özellik dondurma**, yedek video çekimi |
| **Per** | Sunum, Q&A hazırlığı | Q&A'da teknik sorular | Q&A'da veri soruları | Demo makinesi, ağ, yedek video hazır |

## 5. Görev dağılımında dikkat

- **Darboğaz kimlik ve deploy.** Platform kişisi Pazartesi akşamına kadar erişimleri çözmezse herkes bekler. Gerekirse ikinci bir kişi ona yardım etsin.
- **Kaptan kod yazmasın.** Ya da az yazsın. Saat, kapsam ve sunum tam iş.
- **Kapsam kesme hakkı kaptanda.** Çarşamba öğlen bir özellik çalışmıyorsa kesilir, yerine slaytta "yol haritası" olur.
- **Paylaşılan dosya:** karar listesi, linkler, erişim bilgileri (şifresiz), demo senaryosu. Tek yerde.
- **Kod deposu:** SAP'nin verdiği repo (muhtemelen `github.tools.sap`). Kısa ömürlü branch, sık merge; Çarşamba akşamdan sonra sadece kaptan onayıyla merge.
- **Entegrasyon bir görevdir, yan etki değil.** Hackathon retrospektiflerinde en sık çöken yer parçaların birleşmesi ve geç yapılan deploy. Kaptan veya platform kişisi "entegrasyon sahibi" olur; Pazartesi akşamı mock agent ile iskelet uçtan uca çalışır, her gün 13:00'te main birlikte test edilir.
- **Dil:** Claude herkesle kendi dilinde konuşur (Oktay ile Türkçe, Almanca konuşanlarla Almanca). Repoya giren her şey İngilizce: kod, yorum, commit, issue, PR, doküman, slayt — kod SAP'ye teslim edilip sunumda gösterilecek.
- **Roller esnek:** Kaptan bir görevi başka kişiye kaydırabilir (issue'yu yeniden ata).

## 6. Herkesin kendi Claude Code'u ile aynı repoda çalışma (çakışmasız)

Sorun: 5 kişi, 5 Claude, tek repo. Claude'lar birbirinin dosyasını ezer ya da aynı işi iki kez yapar.

```
Kaptan'ın Claude'u ──(spec + ticket'lar)──► GitHub Issues (tek görev panosu)
                                                │ assignee = kişi
       ┌──────────────┬──────────────┬─────────┴────┬──────────────┐
   Oktay'ın Claude  Dev1 Claude    Dev2 Claude   Platform Claude
   /mcp-server/**   /agent/**      /agent/eval/** /deploy/**
   branch: oktay/*  branch: dev1/* ...
                    └──── hepsi küçük PR → main (sık merge) ────┘
```

**Beş kural:**

1. **Klasör sahipliği.** Her rolün kendi klasörü olur. Yol A'da bu kendiliğinden oluyor, çünkü `jl` her asset'i ayrı klasörde tutuyor: `agent`, `mcp-server`, `cap-app`, `base-ui`. Repo kökündeki `CLAUDE.md`'ye bir sahiplik tablosu yazılır. Örnek: "`mcp-server/` → Oktay. Başkasının klasörüne yazma; gerekiyorsa issue aç ve sahibine ata." Her Claude bu dosyayı okuduğu için kural herkese otomatik uygulanır. İstenirse `.github/CODEOWNERS` dosyası da aynı sahipliği PR'larda zorunlu kılar.
2. **Önce sözleşme, sonra kod.** Pazartesi akşamı agent ile tool'lar arasındaki arayüz `docs/contract.md` dosyasına yazılır: tool adları, girdileri, çıktıları, örnek cevap. Agent geliştirici gerçek MCP hazır olmadan sahte (mock) tool ile ilerler. Sözleşmeyi sadece kaptan değiştirir.
3. **Tek görev panosu = GitHub Issues** (SAP'nin repoda verdiği, muhtemelen `github.tools.sap`).
   - Kaptan'ın Claude'u spec'i ticket'lara böler: her ticket'ta sahip, dokunacağı klasör ve "bitti" tanımı olur, bağımlılıklar "blocked-by" ile işaretlenir. Bizim akışta bu, `/to-spec` → `/to-tickets` adımlarına denk geliyor.
   - Herkesin Claude'u işe şu komutla başlar: `gh issue list --assignee @me`. Bir ticket'a başlayınca yorum atar, bitince PR'a `Closes #12` yazar.
   - Enterprise GitHub için önce `gh auth login --hostname github.tools.sap` gerekir.
   - Issues kullanılamazsa yedek olarak repoda tek bir `TASKS.md` tutulur (sahip / durum / klasör). Bu dosyaya sadece kaptan yazar, diğerleri issue gibi okur.
4. **Branch ve PR kuralı.**
   - Herkes kendi branch'inde çalışır: `oktay/12-mcp-read-tools` gibi.
   - PR'lar küçük olur ve günde birkaç kez merge edilir. Branch ömrü en fazla yarım gün.
   - İşe başlamadan önce `git pull --rebase origin main`.
   - Aynı makinede iki Claude çalışıyorsa her biri ayrı git worktree'de çalışır.
   - **Merge:** PR sadece sahibinin klasörüne dokunuyor ve çalışıyorsa sahibi kendisi merge eder (her PR'a başkasının bakması 2 günde kaptanı darboğaz yapar). Ortak dosyalara, `docs/contract.md`'ye veya başkasının klasörüne dokunan PR kaptan onayı ister; `takip` skill'i ihlalleri yakalar.
   - Çarşamba akşamından sonra main'e sadece kaptan onayıyla merge yapılır.
5. **Ortak dosyalar tek sahipli.** `package.json`, `mta.yaml` / solution manifest, `.env.example`, `CLAUDE.md` ve `docs/contract.md` sadece platform kişisinde ya da kaptanda olur. Başkasının Claude'u bu dosyalarda değişiklik gerekirse doğrudan dokunmaz, issue açar.

**İsteğe bağlı sert koruma:** Herkesin lokal Claude ayarına bir PreToolUse hook'u eklenir. Hook, kişinin sahip olmadığı klasörlere `Edit` ve `Write` çağrılarını engeller. Kural 1 yeterli olmazsa bu devreye alınır. Kurulumu 10 dakika.

**Repo kökündeki `CLAUDE.md` için iskelet:**

```markdown
# Takım kuralları (her Claude okur)
## Sahiplik
| Klasör | Sahip | GitHub kullanıcı |
|---|---|---|
| agent/ | Dev1 | ... |
| agent/eval/ | Dev2 | ... |
| mcp-server/ | Oktay | ... |
| deploy/, solution manifest, package.json | Platform | ... |
| docs/contract.md, CLAUDE.md | Kaptan | ... |
## Akış
1. İşe başlarken: `git pull --rebase origin main` → `gh issue list --assignee @me`
2. Sadece kendi klasörüne yaz. Başka klasör gerekiyorsa issue aç, sahibine ata, dur.
3. Arayüz `docs/contract.md`'de; değiştirme, değişiklik gerekiyorsa kaptana issue aç.
4. Küçük PR, açıklamada `Closes #<no>`. Sadece kendi klasörün ve çalışıyorsa kendin merge et; ortak dosya/contract/başka klasör → kaptan onayı. Çarşamba 18:00'den sonra sadece kaptan.
5. Repoya her şey İngilizce; kullanıcıyla tablodaki sohbet dilinde konuş.
5. Şifre/token commit'leme.
```

### VDI'da bu akış nasıl işler

SAP'nin hazırlık PDF'i `github.tools.sap` (workshop içeriği), `git` ve `gh` CLI'ı ister ve `gh`'yi "Manage GitHub PRs, **issues** & repos from the terminal" diye tanımlar. Yani Issues/PR akışı SAP'nin beklediği çalışma şekli. Issues GitHub'da her repoda varsayılan açıktır; asıl soru **takım reposunu kimin açtığı ve bizim yazma yetkimiz olup olmadığı**.

```
Bu PC (şimdi)                    VDI (hackathon, herkes kendi oturumunda)
github.com/<oktay>/sap-hackathon-kit ──clone (okuma)──► ~/sap-hackathon-kit  → install.ps1 → skill'ler ~/.claude/skills
                                                         │
                                         claude (Hyperspace üzerinden)
                                                         │
                         github.tools.sap/<org>/<takım-repo> ◄── kickoff (kaptan) / gorevim (herkes)
                         Issues + PR + main burada buluşur
```

**Adımlar (her kişi kendi VDI'ında):**
1. `gh auth login --hostname github.tools.sap` (C-User/SSO ile). PowerShell'de kalıcı: `$env:GH_HOST='github.tools.sap'`.
2. **Herkes** kiti çeker: kaptan github.com kullanıcılarını kite collaborator (read) ekler, davet kabul edilir → `gh auth login --hostname github.com` → `git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit` → `pwsh -File kurulum\install.ps1` (sonunda ortam kontrolü çalışır). Herkes katalog, sorun giderme, SAP ve süreç skill'lerine sahip olur.
3. Kaptan, **konu belli olmadan** (Pazartesi sabahı): VDI'da Claude'a kit linkini verip "bu kiti kur" der → ardından "takım reposunu kur ve ekibi hazırla" → `kickoff` Faz E iskelet repoyu **github.tools.sap**'ta açar, arkadaşları davet eder, kişiye özel kurulum mesajları üretir; arkadaşlar kurup bekler. Brifingten sonra "projeye başlıyoruz, konumuz …" → aynı repoya spec, roller, görevler. `kickoff` ve tam `takip` kaptan korumalıdır; başkası çağırırsa `gorevim`'e yönlendirir.
4. Diğerleri: takım reposunu clone → `claude` → "takıma katılıyorum, görevim ne?" → `gorevim`.
5. VS Code: VDI'daki VS Code ile aynı klasörü aç; Claude terminalde, sen editörde. Git işlemleri tek yerden (Claude ya da VS Code), ikisi aynı anda commit atmasın.

**Takım reposu için üç olası durum:**

| Durum | Ne yaparız |
|---|---|
| SAP hazır bir takım reposu verir (en olası) | `kickoff` Faz 5'te repo açmaz, verilen repoyu clone'lar, şablonu içine koyar. Collaborator'ları SAP ekler. |
| Org'da repo açma yetkimiz var | `gh repo create <org>/<ad> --private` |
| Yetki yok, repo da verilmedi | Kaptan kendi `github.tools.sap` kullanıcısı altında açar, diğerlerini collaborator ekler. |

**VDI'dan github.com açılmıyorsa (kit çekilemez):**
- Kit'in sadece **iki skill'i kritik**: `kickoff` ve `gorevim` (toplam ~2 sayfa). Kaptan bunları SAP takım reposuna `.claude/skills/` altına koyarsa (aynı metni elle oluşturarak; kit linkleri olmadan da çalışır) herkesin Claude'u repo açılınca otomatik görür.
- Katalog/eğitim notları kendi laptopunda veya telefonda tarayıcıdan okunur (github.com).
- Bunu önceden bilmek için Ayca'ya sor: "VDI'dan github.com'a erişim var mı?"

### SAP'ye soramazsak: her bilinmeyen için hazır yedek

| Bilinmeyen | Tahmin | Önceden hazır olan yedek |
|---|---|---|
| VDI'dan github.com açılıyor mu? | Belirsiz (SAP iç ağı çoğu zaman açık bırakır, doğrulanmadı) | Varsayılan herkes kiti kurar. Açılmazsa: `kickoff` `gorevim`'i, kontrol script'ini ve sorun giderme kartını takım reposunun `.claude/`'una kopyalar → diğerleri kitsiz çalışır. Kaptan da çekemezse `CEP.md` (telefondan oku/yazdır) ile `kickoff` adımları elle yürütülür; `kickoff` kit dosyaları olmadan da çalışacak şekilde yazıldı. |
| Takım reposunu kim açar? | SAP hazır repo verir | `kickoff` Faz 5 sırayla dener: verilen repo → org'da yeni repo → kaptanın kullanıcısı altında → tarayıcıdan açıp `git clone`. |
| `gh` github.tools.sap'ta çalışır mı / Issues var mı? | Evet (PDF `gh`'yi "PRs, issues & repos" için istiyor) | Çalışmazsa `TASKS.md` tablosu; `gorevim` onu da okur, PR linki tarayıcıdan açılır. |
| Joule Studio (`jl`) erişimi var mı? | Muhtemelen var, ama bazı tenant'lar hâlâ EAC'ye kapalı | Yol B (kendi agent + A2A + `joule` CLI) hazır: `btp-joule-a2a-pro-code-agent`, partner workshop. |
| VDI'da Claude Code / Hyperspace çalışır mı? | PDF istiyor, çalışır | Çalışmazsa skill'ler düz Markdown: VS Code'daki herhangi bir AI asistanına ya da elle okunarak uygulanır. |
| Dil? | Karar verildi: sohbet kişiye göre (Oktay Türkçe, diğerleri Almanca/Türkçe), repo her zaman İngilizce | Şablonlar İngilizce; `kickoff` Faz 1'de herkesin sohbet dilini sorar ve `CLAUDE.md` tablosuna yazar. |

**Dikkat:** SAP ortamında üretilen kod ve bilgi kişisel github.com kitine push edilmez. Kit sadece okunur; çalışma `github.tools.sap`'ta kalır.

## 7. Pazartesiden önce ekipçe yapılacaklar

- [ ] 5 kişinin güçlü yönleri konuşuldu, roller atandı, kaptan seçildi
- [ ] Herkes kiti clone'ladı, `kurulum/install.ps1` çalıştırdı
- [ ] Herkes `@sap/joule-studio-cli` kurdu (`joule -V`, `jl version`), BTP Trial açtı
- [ ] Ortak iletişim kanalı ve paylaşılan karar dosyası açıldı
- [ ] Herkes `katalog/12-agent-tasarim-rehberi.md`'yi okudu
- [ ] 2–3 aday fikir hazır (göreve göre uyarlanacak)

## Kaynaklar

- Takım rolleri ve tek karar verici: https://blogs.reskilll.com/how-to-form-perfect-hackathon-team-roles-skills-find-teammates-2026/
- Kazanma ipuçları (demo önce, paralel çalışma): https://blogs.reskilll.com/how-to-win-a-hackathon-15-tips-from-92000-team-registrations/
- İlk saat: https://intercom.help/builderbase/en/articles/14836121-builder-s-guide-ch-10-the-first-hour
- Kazanan takım kurma: https://hackerearth.com/blog/developers/form-winning-team-hackathons
- SAP'ye özel: `10-hackathon-stratejisi.md`, `../katalog/12-agent-tasarim-rehberi.md`
<<<END>>>

<<<FILE kurulum/kontrol.ps1>>>
param([switch]$Json)
$ErrorActionPreference = 'Continue'

function Run([string]$Cmd) {
    try {
        $out = Invoke-Expression "$Cmd 2>&1" | Out-String
        return @{ ok = ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE); out = $out.Trim() }
    } catch { return @{ ok = $false; out = $_.Exception.Message } }
}

function FirstLine([string]$s) { ($s -split "`n" | Where-Object { $_ -match '\S' } | Select-Object -First 1) -replace '\s+', ' ' }

$checks = @(
    @{ Grup = 'Developer'; Ad = 'git';            Cmd = 'git --version';                                  Fix = 'https://git-scm.com/install/' }
    @{ Grup = 'Developer'; Ad = 'gh';             Cmd = 'gh --version';                                   Fix = 'https://cli.github.com/' }
    @{ Grup = 'Developer'; Ad = 'gh -> github.tools.sap'; Cmd = 'gh auth status --hostname github.tools.sap'; Fix = 'gh auth login --hostname github.tools.sap' ; Opt = $true }
    @{ Grup = 'AI';        Ad = 'hai (Hyperspace)'; Cmd = 'hai --version';                                Fix = 'Hyperspace hai CLI Quickstart (SAP ic agi / VPN)' }
    @{ Grup = 'AI';        Ad = 'claude';         Cmd = 'claude --version';                               Fix = 'Claude Code via Hyperspace (SAP ic agi)' }
    @{ Grup = 'Tools';     Ad = 'VS Code';        Cmd = 'code --version';                                 Fix = 'https://code.visualstudio.com/ (telemetry kapali; Software Hub)' }
    @{ Grup = 'Tools';     Ad = 'node (20.12-24)'; Cmd = 'node -v';                                       Fix = 'https://nodejs.org/en/download' }
    @{ Grup = 'Tools';     Ad = 'python3';        Cmd = $(if (Get-Command python3 -ErrorAction SilentlyContinue) { 'python3 --version' } elseif (Get-Command py -ErrorAction SilentlyContinue) { 'py -3 --version' } else { 'python --version' }); Fix = 'https://www.python.org/downloads/ (Windows: App execution alias kapat)' }
    @{ Grup = 'Tools';     Ad = 'pip';            Cmd = $(if (Get-Command python3 -ErrorAction SilentlyContinue) { 'python3 -m pip --version' } elseif (Get-Command py -ErrorAction SilentlyContinue) { 'py -3 -m pip --version' } else { 'python -m pip --version' }); Fix = 'python3 -m ensurepip --upgrade' }
    @{ Grup = 'Tools';     Ad = 'podman';         Cmd = 'podman --version';                               Fix = 'https://podman-desktop.io/' }
    @{ Grup = 'SAP CLI';   Ad = 'btp';            Cmd = 'btp --version';                                  Fix = 'https://tools.hana.ondemand.com/#cloud-btpcli' }
    @{ Grup = 'SAP CLI';   Ad = 'cf';             Cmd = 'cf version';                                     Fix = 'https://github.com/cloudfoundry/cli/wiki/V8-CLI-Installation-Guide' }
    @{ Grup = 'SAP CLI';   Ad = 'joule (legacy)'; Cmd = 'joule -V';                                       Fix = 'npm install -g @sap/joule-studio-cli' }
    @{ Grup = 'SAP CLI';   Ad = 'jl (Joule Work)'; Cmd = 'jl version';                                    Fix = 'npm install -g @sap/joule-studio-cli  (early-adopters paketi varsa once kaldir)' }
    @{ Grup = 'SAP CLI';   Ad = 'kubectl';        Cmd = 'kubectl version --client';                       Fix = 'https://kubernetes.io/docs/tasks/tools/' }
    @{ Grup = 'SAP CLI';   Ad = 'kyma (opsiyonel)'; Cmd = 'kyma version';                                 Fix = 'https://github.com/kyma-project/cli/releases'; Opt = $true }
)

$rows = foreach ($c in $checks) {
    $exe = ($c.Cmd -split ' ')[0]
    if (-not (Get-Command $exe -ErrorAction SilentlyContinue)) {
        [pscustomobject]@{ Grup = $c.Grup; Arac = $c.Ad; Durum = $(if ($c.Opt) { 'opsiyonel-yok' } else { 'YOK' }); Detay = ''; Cozum = $c.Fix }
        continue
    }
    $r = Run $c.Cmd
    $durum = if ($r.ok) { 'tamam' } elseif ($c.Opt) { 'opsiyonel-yok' } else { 'HATA' }
    if ($c.Ad -like 'node*' -and $r.ok) {
        $v = [version](($r.out -replace '^v', '') -split '\s')[0]
        if ($v -lt [version]'20.12.0' -or $v.Major -gt 24) { $durum = 'HATA' }
    }
    if ($c.Ad -like 'jl*' -and $r.ok -and (npm ls -g --depth=0 2>$null | Select-String 'joule-work-dev-cli-early-adopters')) { $durum = 'HATA'; $c.Fix = 'npm uninstall -g @sap/joule-work-dev-cli-early-adopters; npm install -g @sap/joule-studio-cli --force' }
    [pscustomobject]@{ Grup = $c.Grup; Arac = $c.Ad; Durum = $durum; Detay = (FirstLine $r.out); Cozum = $(if ($durum -eq 'tamam') { '' } else { $c.Fix }) }
}

$claudeHome = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$kitSet = [bool]($env:SAP_HACKATHON_KIT -or [Environment]::GetEnvironmentVariable('SAP_HACKATHON_KIT', 'User'))
$skillOk = (Test-Path (Join-Path $claudeHome 'skills\gorevim\SKILL.md')) -or (Test-Path '.claude\skills\gorevim\SKILL.md')
$extra = @(
    [pscustomobject]@{ Grup = 'Kit'; Arac = 'SAP_HACKATHON_KIT'; Durum = $(if ($kitSet) { 'tamam' } else { 'opsiyonel-yok' }); Detay = ''; Cozum = $(if ($kitSet) { '' } else { 'kurulum\install.ps1 calistir (sadece kaptan)' }) }
    [pscustomobject]@{ Grup = 'Kit'; Arac = 'skill: gorevim'; Durum = $(if ($skillOk) { 'tamam' } else { 'opsiyonel-yok' }); Detay = ''; Cozum = $(if ($skillOk) { '' } else { 'Takim reposunu clone et (.claude/skills icinde gelir) ya da install.ps1' }) }
)
$rows = @($rows) + $extra

if ($Json) { $rows | ConvertTo-Json; return }

$icon = @{ 'tamam' = '[OK]'; 'YOK' = '[--]'; 'HATA' = '[!!]'; 'opsiyonel-yok' = '[..]' }
foreach ($g in ($rows | Select-Object -ExpandProperty Grup -Unique)) {
    Write-Host "`n$g" -ForegroundColor Cyan
    foreach ($r in $rows | Where-Object Grup -eq $g) {
        $color = switch ($r.Durum) { 'tamam' { 'Green' } 'opsiyonel-yok' { 'DarkGray' } default { 'Red' } }
        Write-Host ("  {0} {1,-24} {2}" -f $icon[$r.Durum], $r.Arac, $r.Detay) -ForegroundColor $color
        if ($r.Cozum) { Write-Host ("       -> {0}" -f $r.Cozum) -ForegroundColor Yellow }
    }
}
$bad = @($rows | Where-Object { $_.Durum -in 'YOK', 'HATA' })
Write-Host ''
if ($bad.Count -eq 0) { Write-Host 'Hazirsin. Zorunlu araclarin hepsi calisiyor.' -ForegroundColor Green }
else { Write-Host ("Eksik/hatali zorunlu arac: {0} -> {1}" -f $bad.Count, (($bad | ForEach-Object Arac) -join ', ')) -ForegroundColor Red }
Write-Host 'Giris kontrolleri (tarayici gerekir, script yapmaz): btp login --sso · cf login --sso · jl login <url> · joule login · SAP Outlook / IAS aktivasyonu · BTP Trial.' -ForegroundColor DarkGray
<<<END>>>

<<<FILE sablon/proje/.gitattributes>>>
* text=auto eol=lf
*.ps1 text eol=crlf
<<<END>>>

<<<FILE sablon/proje/.gitignore>>>
.claude/ben.md
.env
*.local
<<<END>>>

<<<FILE sablon/proje/CLAUDE.md>>>
# <PROJECT NAME> — team rules (every Claude reads this)

Hackathon: SAP Industry AI Hackathon, Munich, 9–12 Nov 2026. Path: <A: Joule Studio `jl` | B: own agent + A2A>.

## Language

- **Everything in this repo is English:** code, comments, identifiers, commit messages, branch names, issues, PRs, docs, slides. The code is handed to SAP and shown in the presentation.
- **Talk to each person in their chat language** (table below). Explanations, questions and summaries in that language; anything written into the repo stays English.

## Team and ownership

| Person | Chat language | GitHub | Role | Owns (folders / files) |
|---|---|---|---|---|
| <Oktay> | Türkçe | @<user> | <captain> | `CLAUDE.md`, `docs/contract.md`, `docs/spec.md`, `docs/DURUM.md` |
| <name> | Deutsch | @<user> | <agent> | `<agent/>` |
| <name> | <lang> | @<user> | <data + tools> | `<mcp-server/>` |
| <name> | <lang> | @<user> | <platform> | `<deploy/>`, solution manifest / `mta.yaml`, `package.json`, `.env.example` |

Roles stay flexible: the captain can move a task to another person at any time (reassign the issue).

## Workflow

1. Start: `git pull --rebase origin main` → `gh issue list --assignee @me`.
2. Write **only** inside folders you own. Need a change elsewhere? Open an issue, assign the owner, stop.
3. The agent ↔ tool interface lives in `docs/contract.md`. Do not change it; mock against it until the real side exists. Changes go through the captain.
4. Branch `<name>/<issue>-<short-name>` (`<name>` = your lowercase first name from the table above), push at least every 1–2 hours, PR body `Closes #<issue>`.
5. **Merging:** if the PR touches only your own folders and it runs, merge it yourself (`gh pr merge --squash`). PRs touching shared files, `docs/contract.md` or someone else's folder need the captain's approval. After the Wednesday 18:00 freeze only the captain merges.
6. Blocked? Comment `Blocked: <reason>` on the issue and add the `blocked` label.
7. **Issues can be reassigned.** The captain may move any issue to another person at any time. Before starting, at the start of every session and before every push or PR, re-check the issue (`gh issue view <no> --json assignees,labels`). If the assignee or the `kisi:<name>` label is no longer you: stop, do not push or open a PR, comment `Reassigned, stopping my work on this` with your branch name, tell the user, and pick your next issue. Never take an issue back without asking the captain.
8. Never commit secrets, tokens, passwords or customer data.

## Milestones

- **Mon evening — integration skeleton:** mock agent deployed and called once end to end (Joule → agent → mock tool → answer). Owner: platform + captain.
- Tue 12:00 — real agent replaces the mock, same path still works.
- Tue 17:00 — real data via read-only tools.
- Wed 12:00 — exception path + HITL + eval set.
- **Wed 18:00 — feature freeze**, backup demo video recorded.
- Thu — rehearsal, presentation.

Integration is a task, not a side effect: there is always one open `integration` issue owned by the captain or platform person.

## Pointers

- Spec: `docs/spec.md` · Contract: `docs/contract.md` · Status: `docs/DURUM.md` · Start guide: `BASLA.md`
- Kit (links, guides): `$SAP_HACKATHON_KIT` → `katalog/00-index.md`
<<<END>>>

<<<FILE sablon/proje/.github/CODEOWNERS>>>
# Fill from CLAUDE.md ownership table
/<agent>/          @<user>
/<agent>/eval/     @<user>
/<mcp-server>/     @<user>
/<deploy>/         @<user>
/CLAUDE.md         @<captain>
/docs/             @<captain>
<<<END>>>

<<<FILE sablon/proje/.github/pull_request_template.md>>>
Closes #

## What
-

## How to try
-

## Touched folders (must be yours)
-

## Screenshot / output
<<<END>>>

<<<FILE sablon/proje/.github/ISSUE_TEMPLATE/gorev.md>>>
---
name: Task
about: One vertical slice owned by one person
labels: ''
---

**Owner:** @
**Folder (only write here):** ``
**Done when:**
- [ ]
**Blocked by:** #
**Target:** Mon evening (integration skeleton) | Tue 12:00 | Tue 17:00 | Wed 12:00 | Wed 18:00 (freeze)
<<<END>>>

<<<FILE sablon/proje/docs/contract.md>>>
# Contract — agent ↔ tools

Owner: <captain>. Agent developers mock against this; tool owners implement exactly this. Changes only via issue to the captain.

## Tool: `<tool_name>`
- Kind: read-only | write (needs HITL approval)
- Owner: @<user> · Folder: `<mcp-server/>`
- Description (what the LLM sees, English, action-oriented): "<Use this when …>"
- Input:
  ```json
  { "<param>": "<type> — <meaning>" }
  ```
- Output:
  ```json
  { "<field>": "<type> — <meaning>" }
  ```
- Example call → response:
  ```json
  { "<param>": "…" }
  ```
  ```json
  { "<field>": "…" }
  ```
- Errors: `<code>` — <when>

<!-- copy the block per tool; keep 3–6 tools -->

## Agent card / entry point
- Name: <agent name> · Skills: <list> · Expected latency: < 60 s per answer
<<<END>>>

<<<FILE sablon/proje/docs/DURUM.md>>>
# Status
<!-- Written in English like everything in the repo. The captain's Claude keeps it current and reports it to the captain in their chat language. -->
Last check: <date time>
Next milestone: <Mon evening — integration skeleton> — 🟢

## People
| Person | Role | Done | Working on | Signal |
|---|---|---|---|---|
| <name> | <role> | — | #<no> | — |

## Decisions (dated, newest first)
- <time> · Kickoff: <chosen approach> · <why>

## Risks / open questions
- 

## Cut (goes to the "roadmap" slide)
- 
<<<END>>>

<<<FILE sablon/proje/docs/spec.md>>>
# Spec — <PROJE ADI>

## Problem
<Who suffers, how much (person-days, error rate, volume). One paragraph.>

## Persona
<Role, what they do today, where they leave SAP (Excel, email…).>

## KPI
<From X to Y> · volume: <n per month> · baseline: <source or "assumption">.

## Demo story (5 min)
1. <Persona + pain number>
2. <Happy-path case: agent proposes with confidence + rationale>
3. <Exception case: low confidence → routed to human>
4. <Human approves → action executed>
5. <Trace / eval pass rate on screen>
6. <KPI delta + path to production>

## Architecture
```
Joule (Work) ──A2A / managed──► Agent ──MCP──► Tools ──► <SAP source>
                                  │
                                  └── HITL approval ──► <write action>
```
- Path: <A: jl managed runtime | B: own agent on BTP + A2A>
- LLM: Generative AI Hub (orchestration, masking, filtering)
- Data source: <S/4 API | Datasphere view | HANA Cloud>
- Tools: see `contract.md`
- Identity: <user-context / principal propagation | technical user (read only)>

## Out of scope
- <…>

## Risks
- <access / data / time>
<<<END>>>

