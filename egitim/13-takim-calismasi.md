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
| **Pzt** | Brifing notu, fikir seçimini yönetir (`katalog/12` §5 çerçevesi), demo senaryosu taslağı | Brifingi dinler; öğleden sonra `jl init claude` veya agent iskeleti, "Merhaba" agent'ı lokal | Hangi veri, nereden, hangi 3–6 tool; örnek veriyi yükler | Erişimleri test eder: BTP, IAS, AI Core, `jl login` / `joule login`. **Akşama kadar hepsi çalışmalı** |
| **Sal** | Slayt iskeleti, KPI hesabı, persona | Öğlene kadar **"Merhaba Joule"** uçtan uca; sonra asıl mantık | MCP/tool'lar salt okunur çalışır, agent'a bağlanır | İlk deploy, Joule'dan çağırma; deploy'u tekrarlanabilir yapar (script) |
| **Çar** | Demo provası 1, hikâye düzeltme | İstisna/HITL, eval (10–20 soru), guardrail | Yazma tool'u (onaylı), demo verisini sabitler | Son deploy, yedek ortam; **akşam özellik dondurma**, yedek video çekimi |
| **Per** | Sunum, Q&A hazırlığı | Q&A'da teknik sorular | Q&A'da veri soruları | Demo makinesi, ağ, yedek video hazır |

## 5. Görev dağılımında dikkat

- **Darboğaz kimlik ve deploy.** Platform kişisi Pazartesi akşamına kadar erişimleri çözmezse herkes bekler. Gerekirse ikinci bir kişi ona yardım etsin.
- **Kaptan kod yazmasın.** Ya da az yazsın. Saat, kapsam ve sunum tam iş.
- **Kapsam kesme hakkı kaptanda.** Çarşamba öğlen bir özellik çalışmıyorsa kesilir, yerine slaytta "yol haritası" olur.
- **Paylaşılan dosya:** karar listesi, linkler, erişim bilgileri (şifresiz), demo senaryosu. Tek yerde.
- **Kod deposu:** SAP'nin verdiği repo (muhtemelen `github.tools.sap`). Kısa ömürlü branch, sık merge; Çarşamba akşamdan sonra sadece kaptan onayıyla merge.

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
4. Küçük PR, açıklamada `Closes #<no>`. Kendi PR'ını merge etme, bir kişi baksın (Çarşamba akşamından sonra sadece kaptan).
5. Şifre/token commit'leme.
```

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
