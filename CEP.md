# CEP KARTI — kit inmezse bu yeter (telefondan oku / yazdır)

## 1. VDI'da ilk 15 dakika (herkes)
```
gh auth login --hostname github.tools.sap
$env:GH_HOST='github.tools.sap'
npm install -g @sap/joule-studio-cli      # joule -V ve jl version
git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1
```
github.com açılmazsa: 3. satıra kadar yap, kiti atla; kaptan aşağıdaki §2'yi elle yürütür.
Ortam kontrolü: `pwsh -File kurulum\kontrol.ps1` (takım reposunda `.claude\tools\kontrol.ps1`) → ✅/❌ tablo + çözüm linkleri. Hata alınca: `katalog/13-sorun-giderme.md` (repoda `.claude/sorun-giderme.md`). En sık: `btp login --sso --url https://cli.btp.cloud.sap --subdomain <sub>` · `cf login -a <api> --sso-passcode <kod>` · `jl solution validate` · `jl solution traces` · `cf logs <app> --recent`.

## 2. Kaptan — kickoff (kod yok, önce bu)
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
