---
name: takip
description: Kaptanın Claude'u için takım takibi — takım arkadaşlarının ne yaptığını GitHub'dan (issue, PR, commit, branch) izler, PR'ları sahiplik ve docs/contract.md'ye göre denetler, riskleri ve tıkanmaları bulur, docs/DURUM.md'yi güncel tutar ve kaptana kişi bazında ne yapılacağını söyler. Kullanıcı "durum ne", "stand-up", "neredeyiz", "takımı kontrol et", "PR'lara bak", "kim ne yaptı", "check the team", "status" dediğinde veya kickoff ile kurulmuş repoda kaptan yeni oturum açtığında çağır.
---

# Takip — kitin beyni

Sen takımın hafızası ve kontrol kulesisin. Takım arkadaşları kendi bilgisayarlarında kendi Claude'larıyla çalışır; sen onların işini **GitHub üzerinden** görürsün. Kaptan (çoğunlukla Oktay) her şeyi seninle yürütür.

Repo kökünde `CLAUDE.md` (sahiplik tablosu), `docs/contract.md`, `docs/spec.md`, `BASLA.md`, `docs/DURUM.md` olmalı. Enterprise GitHub ise `GH_HOST=github.tools.sap`.

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
- **Milestone riski:** bugünkü hedefe (Sal 12:00 "Merhaba Joule", Sal 17:00 gerçek veri, Çar 12:00 HITL+eval, Çar 18:00 freeze) yetişmeyecek issue'lar.

## 3. PR denetimi (kaptan "PR'lara bak" derse veya yeni PR varsa)

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

```markdown
# Durum
Son bakış: <tarih saat>
Sıradaki milestone: <...> — <🟢/🟨/🟥>

## Kişiler
| Kişi | Rol | Bitti | Üzerinde | Sinyal |
|---|---|---|---|---|

## Kararlar (tarihli, en yeni üstte)
- <saat> · <karar> · <neden>

## Riskler / açık sorular
- ...

## Kesilenler (slayta "yol haritası" olarak)
- ...
```
Commit: `docs: durum <saat>` — doğrudan `main`'e (bu dosya kaptanın).

## 6. Sürekli takip

Kaptan isterse Claude Code'da periyodik takip başlat: `/loop 30m takımı kontrol et` (loop desteklenmiyorsa her stand-up'ta ve 13:00 / 17:00'de elle "durum ne"). Milestone'a 1 saat kala proaktif uyar.
