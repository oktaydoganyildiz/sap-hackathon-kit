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
