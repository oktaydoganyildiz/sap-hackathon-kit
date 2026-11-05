---
name: gorevim
description: Hackathon takım üyesinin kendi görevini alıp çakışmadan çalışması. Kullanıcı "takıma katılıyorum", "görevim ne", "sıradaki işim", "my task", "what should I work on", "PR açalım", "işim bitti" dediğinde veya kickoff ile kurulmuş bir hackathon reposunda (kökünde sahiplik tablolu CLAUDE.md ve docs/contract.md var) iş başlarken çağır.
---

# Görevim — takım üyesi akışı

Repo kökündeki `CLAUDE.md` takım kurallarıdır, önce onu oku. Sahiplik tablosu ve `docs/contract.md` bağlayıcıdır.

**Yönlendirme:** Her cevabın sonunda `▶ Sen şimdi:` ile kullanıcının yapacağı tek somut adımı yaz. Repo kökünde `BASLA.md` varsa önce oradaki kişinin bölümünü oku.

## Başlarken

1. `git pull --rebase origin main`
2. Kimsin: `gh api user --jq .login` → sahiplik tablosunda hangi klasörler senin?
3. Görevlerin: `gh issue list --assignee @me --state open` (enterprise ise önce `GH_HOST=github.tools.sap`). `gh` çalışmıyor ya da repoda `TASKS.md` varsa oradan, `Sahip` sütununda sen olan satırları oku. Bloke olmayan ve hedef saati en yakın olanı öner, kullanıcıya onaylat.
4. Başla: `gh issue comment <no> --body "Başladım"`, branch `git switch -c <kullanıcı>/<no>-<kısa-ad>`.

## Çalışırken

- **Sadece kendi klasörüne yaz.** Başka klasörde değişiklik gerekiyorsa yazma; `gh issue create` ile sahibine aç, kullanıcıya söyle, kendi işine dön.
- **Sözleşmeye uy.** `docs/contract.md`'deki tool adı/girdi/çıktıyı değiştirme. Karşı taraf hazır değilse sözleşmeye göre mock kullan. Sözleşme yanlışsa kaptana issue aç.
- **Ortak dosyalara dokunma** (`CLAUDE.md`, `docs/contract.md`, manifest, `package.json`, `.env.example`) — sahibi değilsen issue aç.
- Küçük ve sık commit. Şifre/token commit'leme.
- 30 dakika tıkandıysan kullanıcıya söyle; 60 dakikaysa mentora gitmesini öner.

## Bitirirken

1. `git pull --rebase origin main`, test/çalıştırma kontrolü.
2. `git push -u origin HEAD` → `gh pr create --fill --body "Closes #<no>"` (şablonu doldur: ne yapıldı, nasıl denenir, ekran görüntüsü). `gh` yoksa push'tan sonra PR'ı tarayıcıdan açması için linki kullanıcıya ver; `TASKS.md` kullanılıyorsa görev numarasını PR başlığına yaz.
3. Kendi PR'ını merge etme; bir takım arkadaşı baksın. Çarşamba akşamı freeze'den sonra sadece kaptan merge eder.
4. Sıradaki görevi öner (Başlarken §3).
