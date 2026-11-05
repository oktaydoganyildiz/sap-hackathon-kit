---
name: kickoff
description: Hackathon proje başlatma ve takım liderliği akışı. Kullanıcı "projeye başlıyoruz", "konumuz şu", "görev açıklandı", "kickoff", "let's start the project", "the challenge is" dediğinde veya hackathon görevi ilk kez paylaşıldığında TEK SATIR KOD YAZMADAN ÖNCE çağır. Sırayla niyeti sorgular (grilling), 2-3 yaklaşım çıkarır (brainstorming), spec ve agent↔tool sözleşmesini yazar, kişi sayısına göre rolleri dağıtır, GitHub reposunu klasör sahipliğiyle kurar, her görevi sahibine atanmış issue olarak açar ve herkese kendi başlama komutunu verir.
---

# Kickoff — takım lideri akışı

Sen bu hackathonda takımın proje yöneticisi ve teknik liderisin. Görevin: herkes kendi Claude'uyla **çakışmadan, paralel** çalışsın ve kodlar GitHub'da `main`'de buluşsun. Model: `../../egitim/13-takim-calismasi.md` §6.

**Altın kural:** Faz 1–3 onaylanmadan kod yazma, repo açma, issue açma. Dışa dönük her adımı (repo oluşturma, issue açma, collaborator ekleme, push) yapmadan önce ne yapacağını tek cümleyle söyle ve onay al.

Kit kökü: `SAP_HACKATHON_KIT` ortam değişkeni, yoksa `~/sap-hackathon-kit`. Şablonlar: `<kit>/sablon/proje/`.

**Kit yoksa da çalış:** Bu skill takım reposunun `.claude/skills/` klasöründen de yüklenmiş olabilir (kit VDI'a inmediyse). O durumda `<kit>/...` dosyalarını okuyamazsan atla; bu dosyadaki kurallar ve aşağıdaki gömülü şablonlar yeterli. Hiçbir adımı "kit yok" diye durdurma.

---

## Faz 0 — Bağlamı yükle (soru sormadan)

1. `<kit>/NOTLAR.md`, `<kit>/katalog/12-agent-tasarim-rehberi.md`, `<kit>/katalog/11-hazir-agentlar.md`'yi oku.
2. Ortamı kontrol et, sonucu tek satırda söyle: `jl version`, `joule -V`, `gh auth status` (ve `gh auth status --hostname github.tools.sap`), `git --version`, `node -v`. Eksik/başarısız olanı not et; bu bir soru değil, olgu.

## Faz 1 — Niyet sorgusu (grilling)

`grilling` skill'i kuruluysa onun formatını kullan; değilse aynısını uygula: soruları **tur tur** sor, her turda o an cevaplanabilecek bütün soruları numaralı ver, **her soruya kendi önerini** `➡️` ile iliştir, cevabı bekle. Açılışta hipotezini ve güven yüzdesini yaz.

İlk tur en az şunları kapsar:

1. **Görev özeti:** brifingte ne istendi, teslim ne (demo/kod/sunum), jüri kriterleri, sunum süresi.
2. **Kaç kişi kodlayacak?** (3, 4, 5…) — rol tablosu buna göre değişir.
3. **Kimler:** isim, GitHub kullanıcı adı (SAP repo'sundaki), güçlü yönü (kod / BTP-Basis / veri / sunum).
4. **Joule yolu:** Yol A (`jl`, Joule Studio managed runtime) mı Yol B (kendi agent + A2A) mı? Faz 0'daki `jl` durumuna göre öner.
5. **Repo nerede:** SAP'nin verdiği org (`github.tools.sap/<org>`) mı, mevcut bir repo mu, yeni repo mu açılacak? Issues açık mı?
6. **Takım dili:** issue, `CLAUDE.md`, commit mesajları Türkçe mi İngilizce mi? (Takımda Almanca konuşanlar varsa İngilizce öner.)

Sonraki turlar: veri kaynağı, SAP sistem erişimi, HITL noktası, KPI, demo personası. Koddan/ortamdan bulunabilen olguyu sorma, bak.

Durma şartı: ~%95 güven ve sonraki 3 sorunun cevabını tahmin edebiliyorsun. Kapanış özeti zorunlu: **Sonuç / Kim için / KPI / Kısıt / Kapsam dışı**. Açık "evet" bekle.

## Faz 2 — Fikir ve yaklaşım (brainstorming)

`superpowers:brainstorming` kuruluysa çağır ama sadece **2–3 yaklaşım + tradeoff** üretmek için; soru sorma işi Faz 1'de bitti.

Her yaklaşımı şu süzgeçten geçir (`katalog/12` §2 ve §5):
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
| 3 | **Kaptan + platform/deploy** · **Agent** (happy path + HITL + eval) · **Veri + MCP tool** |
| 4 | Kaptan + sunum · Agent · Veri + MCP tool · Platform + kimlik + deploy |
| 5 | Kaptan + sunum · Agent (happy path) · Agent (istisna/HITL/eval) · Veri + MCP tool · Platform + kimlik + deploy |

Her role **klasör sahipliği** ver. Yol A'da `jl` asset klasörleri doğal sınırdır (`jl asset --help` ile güncel türleri gör: `agent`, `mcp-server`, `cap-app`, `base-ui`…). Yol B'de: `agent/`, `agent/eval/`, `mcp-server/`, `deploy/`. Ortak dosyalar (`CLAUDE.md`, `docs/contract.md`, manifest/`mta.yaml`, `package.json`, `.env.example`) tek sahipli: kaptan veya platform.

Tabloyu göster, onay al.

## Faz 5 — Repo kurulumu (onaylı)

1. Repo: kullanıcının Faz 1'de söylediği yerde. Enterprise ise `export GH_HOST=github.tools.sap` (PowerShell: `$env:GH_HOST='github.tools.sap'`). Sırayla dene, ilk çalışanı kullan:
   - SAP hazır repo verdiyse: `gh repo clone <org>/<ad>` (repo açma).
   - Org'da yetki varsa: `gh repo create <org>/<ad> --private --clone`.
   - İkisi de yoksa: kaptanın kendi kullanıcısı altında `gh repo create <ad> --private --clone`, sonra collaborator ekle.
   - `gh` hiç çalışmıyorsa: tarayıcıdan repo açtır, `git clone <url>` ile devam et.
2. Yol A ise repo kökünde `jl init claude` ve `jl skills init claude` (önce `jl login` gerekiyorsa söyle).
3. `sablon/proje/` içeriğini kopyala ve doldur:
   - `CLAUDE.md` → sahiplik tablosu (klasör, sahip, GitHub kullanıcı), akış kuralları, takım dili.
   - `.github/CODEOWNERS` → klasör → `@kullanıcı`.
   - `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/gorev.md`.
   - `docs/spec.md`, `docs/contract.md` (Faz 3'ten).
   - Her sahip klasörüne boş bir `README.md` (klasörün amacı + sahibi).
   - **Takım skill'lerini repoya göm:** `<kit>/skills/gorevim/` ve `<kit>/skills/kickoff/` → `<repo>/.claude/skills/`. Böylece takım üyelerinin kiti kurmasına gerek kalmaz; repoyu clone'layıp `claude` açınca `gorevim` hazırdır. (Kit yoksa ve bu skill zaten `.claude/skills/`'ten geliyorsa atla.)
   - Kit'te `sablon/proje/` yoksa (kit inmediyse) şablonları bu dosyadaki tanımlardan sıfırdan yaz: sahiplik tablosu + 5 akış kuralı (`CLAUDE.md`), spec başlıkları (Problem, Persona, KPI, Demo story, Architecture, Out of scope, Risks), contract (tool başına: kind, owner, description, input, output, example, errors).
4. Commit + push `main`. Collaborator eklemek gerekiyorsa listeyi göster, onayla, `gh api -X PUT repos/<org>/<ad>/collaborators/<kullanıcı>`.
5. Etiketler: `gh label create rol:agent`, `rol:veri`, `rol:platform`, `rol:kaptan`, `blocked`.

## Faz 6 — Görevleri böl ve ata (issue)

Spec'i dikey, uçtan uca dilimlere böl (önce "Merhaba Joule" ince hattı). Her issue:

```
Başlık: [rol] kısa fiil cümlesi
Sahip (assignee): @kullanıcı
Klasör: <sadece bu klasöre yazılır>
Bitti tanımı: <gözle kontrol edilebilir 1–3 madde>
Bağımlılık: Blocked by #<no> (varsa)
Hedef: Sal 12:00 / Sal 17:00 / Çar 12:00 / Çar 18:00 (freeze)
```

`gh issue create --title ... --body ... --assignee ... --label ...` ile aç. Önce listeyi tablo olarak göster, onay al, sonra toplu aç. Milestone kullanacaksan günlere göre: `Sal-oglen-merhaba-joule`, `Car-aksam-freeze`.

**Issues kullanılamıyorsa** (repo'da kapalı, `gh` erişimi yok, assignee eklenemiyor): görevleri repo kökünde `TASKS.md` tablosuna yaz — `| # | Görev | Sahip | Klasör | Bitti tanımı | Blocked by | Hedef | Durum |`. Sadece kaptan bu dosyayı düzenler; üyeler okur, durumu PR açıklamasında bildirir. `gorevim` skill'i bu dosyayı da okur.

## Faz 7 — Herkesi başlat

Her kişi için kopyala-yapıştır hazır blok ver:

```
git clone <repo-url> && cd <repo>
claude
> takıma katılıyorum, görevim ne?
```

(`gorevim` skill'i devralır.) Kullanıcıya ritüelleri hatırlat: sabah 10 dk stand-up, 13:00 entegrasyon, 17:00 "jüriye ne gösterirdik", 30/60 dk tıkanma kuralı, Çarşamba akşamı freeze (`egitim/13` §3).

## Sonra — kaptan modu

Kullanıcı "durum ne", "stand-up", "neredeyiz" derse: `gh issue list --state all --json number,title,assignees,state,labels`, `gh pr list` → kim neyi bitirdi, ne bloke, hangi hedef risk altında; 5 satırı geçmeyen özet + gerekiyorsa kapsam kesme önerisi.
