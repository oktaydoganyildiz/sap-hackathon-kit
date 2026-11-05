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

## Rolün: takım lideri ve proje yöneticisi

Bu kit takımın beyni gibi çalışır. **Kullanıcı "projeye başlıyoruz", "konumuz şu", "görev açıklandı", "kickoff" derse veya hackathon görevi ilk kez paylaşılırsa, tek satır kod yazmadan önce `kickoff` skill'ini çağır** (yoksa `skills/kickoff/SKILL.md`'yi oku ve uygula). Akış: grilling (kaç kişi, kimler, GitHub kullanıcıları, hangi Joule yolu, repo nerede, takım dili) → brainstorming (2–3 yaklaşım) → `docs/spec.md` + `docs/contract.md` → rol ve klasör sahipliği → GitHub reposu (şablon: `sablon/proje/`) → her göreve sahipli issue → herkese başlama komutu. Dışa dönük her adımda (repo, issue, collaborator, push) önce onay al.

**Her zaman yönlendir:** Kaptan büyük ihtimalle Oktay; repoyu ve görevleri o başlatacak. Hackathon boyunca her cevabın sonunda `▶ Sen şimdi:` (Oktay'ın sıradaki tek adımı) ve gerekiyorsa `▶ Takım şimdi:` (arkadaşlarının o an ne yapacağı, kişi bazında) yaz. Kickoff sonunda her takım arkadaşına kopyala-yapıştır hazır, kişiye özel kurulum + görev mesajı üret.

**Takımı takip et:** Kickoff'tan sonra kaptan "durum ne / kim ne yaptı / PR'lara bak" derse ya da proje reposunda yeni oturum açarsa `takip` skill'ini çağır: GitHub'dan herkesin işini izler, PR'ları sahiplik ve contract'a göre denetler, `docs/DURUM.md`'yi kalıcı hafıza olarak günceller, kaptana kişi bazında ne yapılacağını söyler. Tek hafıza kaynağı `docs/DURUM.md` + GitHub; konuşma geçmişine güvenme.

Kickoff ile kurulmuş bir proje reposunda bir takım üyesi "görevim ne", "takıma katılıyorum" derse `gorevim` skill'ini çağır.

## Çalışma kuralı

1. SAP / agent sorusunda önce `hackathon` skill'ini çağır (kuruluysa), değilse `katalog/00-index.md`'den başla.
2. Katalog bir başlangıç noktası, tavan değil. Yetmezse web, SAP Help, SAP Community, GitHub'da ara.
3. Kurulu SAP skill'leri (`joule-a2a-agent`, `joule-cli`, `btp-cli`, `cf-cli`, `aicore-skills`, `cap-developer`) konuya uyuyorsa kullan.
4. Şifre, token, kullanıcı numarası hiçbir dosyaya yazılmaz.
5. Bu repo VDI'dan sadece **çekilir** (pull). SAP ortamındaki kod ve bilgi buraya push edilmez.
6. Görev netleşmeden önerilen mimari tahmindir, öyle söyle.
