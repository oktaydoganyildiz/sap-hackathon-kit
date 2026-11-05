# SAP Hackathon Kit

SAP Industry AI Hackathon (SAP Labs Münih, 9–12 Kasım 2026) için hazırlık kiti. Sahibi Oktay (Fairconsult24-7, dış partner). Konu büyük ihtimalle BTP üzerinde AI agent geliştirme (Joule Studio, A2A, AI Core).

## Dil ve ton

Türkçe, kısa, samimi. SAP ve ürün terimleri İngilizce kalır. Sonucu ilk cümlede söyle.

## Nerede ne var

- `katalog/` — konu başına önceden araştırılmış link + kısa özet. Giriş: `katalog/00-index.md`.
- `egitim/` — 13 ders notu (A2A, Joule Studio, BTP, IAS, AI Core, MCP, pro-code agent, Joule CLI, Agent Gateway, strateji).
- `beyin/` — Oktay'ın SAP Beyni'nden seçilmiş agent/BTP tarifleri, araç notları, dersler, kaynaklar.
- `NOTLAR.md` — etkinlik bilgisi, ön hazırlık listesi, brifingte sorulacaklar.
- `skills/hackathon/` — router skill'i. `kurulum/` — kurulum script'leri.

## Çalışma kuralı

1. SAP / agent sorusunda önce `hackathon` skill'ini çağır (kuruluysa), değilse `katalog/00-index.md`'den başla.
2. Katalog bir başlangıç noktası, tavan değil. Yetmezse web, SAP Help, SAP Community, GitHub'da ara.
3. Kurulu SAP skill'leri (`joule-a2a-agent`, `joule-cli`, `btp-cli`, `cf-cli`, `aicore-skills`, `cap-developer`) konuya uyuyorsa kullan.
4. Şifre, token, kullanıcı numarası hiçbir dosyaya yazılmaz.
5. Bu repo VDI'dan sadece **çekilir** (pull). SAP ortamındaki kod ve bilgi buraya push edilmez.
6. Görev netleşmeden önerilen mimari tahmindir, öyle söyle.
