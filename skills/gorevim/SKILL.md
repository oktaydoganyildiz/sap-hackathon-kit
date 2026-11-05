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
2. Kimsin: `gh api user --jq .login` → sahiplik tablosunda hangi klasörler senin?
3. Görevlerin: `gh issue list --assignee @me --state open` (enterprise ise önce `GH_HOST=github.tools.sap`). `gh` çalışmıyor ya da repoda `TASKS.md` varsa oradan, `Sahip` sütununda sen olan satırları oku. Bloke olmayan ve hedef saati en yakın olanı öner, kullanıcıya onaylat.
4. Başla: `gh issue comment <no> --body "Başladım"`, branch `git switch -c <kullanıcı>/<no>-<kısa-ad>`.

## Çalışırken

- **Sadece kendi klasörüne yaz.** Başka klasörde değişiklik gerekiyorsa yazma; `gh issue create` ile sahibine aç, kullanıcıya söyle, kendi işine dön.
- **Sözleşmeye uy.** `docs/contract.md`'deki tool adı/girdi/çıktıyı değiştirme. Karşı taraf hazır değilse sözleşmeye göre mock kullan. Sözleşme yanlışsa kaptana issue aç.
- **Ortak dosyalara dokunma** (`CLAUDE.md`, `docs/contract.md`, manifest, `package.json`, `.env.example`) — sahibi değilsen issue aç.
- Küçük ve sık commit. Şifre/token commit'leme.
- Hata/login/deploy sorununda önce `.claude/sorun-giderme.md`'de belirtiyi eşle (araç eksikse `.claude/tools/kontrol.ps1`). Hata metnini tam iste, tahminle düzeltme.
- 30 dakika tıkandıysan kullanıcıya söyle; 60 dakikaysa mentora gitmesini öner.
- **Kaptan seni GitHub'dan takip ediyor, görünür ol:** her 1–2 saatte bir push et (draft PR açık olabilir: `gh pr create --draft`). Tıkanınca issue'ya yorum + etiket: `gh issue comment <no> --body "Blocked: <neden, kime ihtiyaç var>"` ve `gh issue edit <no> --add-label blocked`. Çözülünce etiketi kaldır.

## Bitirirken

1. `git pull --rebase origin main`, test/çalıştırma kontrolü.
2. `git push -u origin HEAD` → `gh pr create --fill --body "Closes #<no>"` (şablonu doldur: ne yapıldı, nasıl denenir, ekran görüntüsü). `gh` yoksa push'tan sonra PR'ı tarayıcıdan açması için linki kullanıcıya ver; `TASKS.md` kullanılıyorsa görev numarasını PR başlığına yaz.
3. **Merge:** PR sadece senin klasörlerine dokunuyor ve çalışıyorsa kendin merge et: `gh pr merge <no> --squash --delete-branch`. Ortak dosyalara, `docs/contract.md`'ye veya başkasının klasörüne dokunuyorsa merge etme, kaptandan onay iste. Çarşamba 18:00 freeze'den sonra sadece kaptan merge eder.
4. Merge sonrası entegrasyon hattı (main) hâlâ çalışıyor mu, hızlıca dene; bozulduysa hemen entegrasyon issue'suna yaz.
5. Sıradaki görevi öner (Başlarken §3).
