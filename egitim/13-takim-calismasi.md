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
3. Kaptan: kit klasöründe `claude` → "projeye başlıyoruz, konumuz …" → `kickoff` takım reposunu **github.tools.sap**'ta kurar/kullanır. `kickoff` ve tam `takip` kaptan korumalıdır; başkası çağırırsa `gorevim`'e yönlendirir.
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
