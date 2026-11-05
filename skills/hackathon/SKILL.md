---
name: hackathon
description: SAP Industry AI Hackathon (Münih, 9-12 Kasım 2026) router'ı. Joule, Joule Studio (jl / joule CLI), A2A, pro-code agent, SAP AI Core, Generative AI Hub, SAP Cloud SDK for AI, CAP + AI, MCP, BTP, CF, Kyma, IAS, agent değerlendirme sorularında ve hackathon görevi üzerinde çalışırken İLK çağrılacak skill. Önceden araştırılmış link kataloğunu, ders notlarını ve saha notlarını gösterir; kataloğu başlangıç noktası olarak kullanır, onunla sınırlı kalmaz.
---

# Hackathon Router

Kit kökü: bu skill'in kurulduğu repo (`sap-hackathon-kit`). Yol bilinmiyorsa `SAP_HACKATHON_KIT` ortam değişkenine, yoksa `~/sap-hackathon-kit`'e bak.

## Akış

1. **Konuyu eşle** — `katalog/00-index.md`'yi oku, sorunun konusuna denk gelen katalog dosyasını aç.
2. **Derin bilgi gerekiyorsa** — o katalog dosyasının sonundaki "İlgili kit dosyaları" satırındaki `egitim/` ve `beyin/` notlarını oku. `beyin/` notları Oktay'ın daha önce doğruladığı tarif ve derslerdir; tarih ve `guven` alanına dikkat et.
3. **Linkleri aç** — uygun linki WebFetch ile oku veya repo ise `git clone` / `gh repo view` ile incele. Örnek kodu kopyalamadan önce son push tarihine ve arşiv durumuna bak.
4. **Kataloğun dışına çık** — katalog cevap vermiyorsa ya da bilgi bayat görünüyorsa: WebSearch, SAP Help (help.sap.com), SAP Community, `github.com/SAP-samples` / `SAP` / `cap-js` / `a2aproject` org'larında ara. `https://github.com/marianfoo/sap-ai-mcp-servers` güncel SAP MCP/skill listesidir. Kurulu başka bir skill (ör. `joule-a2a-agent`, `aicore-skills`, `cap-developer`) konuya daha uygunsa onu çağır.
5. **Kaynağı yaz** — cevabın başında `Kaynak: <katalog dosyası / link / skill> → <ne baktın>`. Doğrulayamadığın sürüm, limit, özellik adına `(doğrulanmadı)` ekle.

## Fikir ve mimari aşaması

Görev açıklandığında ya da "ne yapalım / nasıl kuralım" sorusunda:
1. `katalog/12-agent-tasarim-rehberi.md` → 5 soruluk agent testi, mimari kontrol listesi, fikir çerçevesi.
2. `katalog/11-hazir-agentlar.md` → SAP bunu zaten yapıyor mu? Boşluk var mı? Extension GA kısıtı.
3. `katalog/10-teched-sapphire-2026.md` → sunum dili (Autonomous Enterprise, governed by design...) ve en yakın TechEd hands-on reposu.
4. Fikri öner: persona + sorunun sayısı + KPI + en küçük mimari + demo hikâyesi. Tahmin olduğunu söyle, kullanıcı onaylamadan kod yazma.

## Bilinen tuzaklar

- **Agent Extension GA'da sadece Instructions:** Tools (MCP) ve Hooks (n8n) feature flag arkasında, CLI'dan yapılamıyor. Extension fikrini ancak sahada flag açıksa öner.
- **Agent Gateway'in iki yönlü trafiği yok:** Joule agent'ının dış agent'a geri çağrı yaptığı bir demo kurma.
- **Joule Studio bazı tenant'larda hâlâ EAC'ye kapalı:** erişim yoksa Yol B'ye geç.
- **SAP IS-U meter-to-cash yol haritası** (billing, outsorting, implausible reading, tariff): utilities'de bu alanlara fikir önerme.

- **Joule Studio'nun iki zinciri var, ikisine de hazır ol** (karşılaştırma tablosu `katalog/01-joule-studio.md`):
  - **Yol A (öncelikli):** yeni `jl` CLI, Claude Code ile Intent-Based Development. Kurulum `jl login` → `jl init claude` → `jl skills init claude`; test `jl a2a card` / `jl a2a message`. Ortamda `jl` varsa ve login çalışıyorsa bu yolu varsay. `jl` hızlı değişiyor (2026-11: v1.0.9, `@sap/joule-studio-cli` 2.0.4 ile gelir): emin olmadan önce `jl <komut> --help`.
  - **Yol B (yedek):** classic `joule` CLI + LangGraph A2A agent + CF deploy + DAS capability YAML. Toolkit skill'leri (`joule-a2a-agent` vb.) bu yol içindir; Yol A'da kullanma.
  - Hangisi kullanılıyor belli değilse kullanıcıya tek soru sor, karıştırma.
- **Hyperspace (`hai`) ≠ Generative AI Hub.** `hai` bizim kodlama asistanımızın LLM kanalı. Agent'ın runtime LLM çağrısı her zaman AI Core / Generative AI Hub üzerinden.
- **Arşivlenen repolar:** `cap-llm-plugin`, `ai-core-samples`, `btp-genai-starter-kit`, `joule-a2a-agent-toolkit` (SAP-archive org'unda). Yerine güncel karşılıkları katalogda.
- Demo provasında AI Core kotası biterse `btp-joule-a2a-pro-code-agent`'ın mock-response extension'ı kullanılabilir (`egitim/07-pro-code-agent.md`).

## Kurallar

- Şifre, token, client secret'ı dosyaya veya repoya yazma.
- Bu kit tek yönlüdür: SAP ortamında üretilen kodu ve bilgiyi bu kişisel repoya **push etme**. Hackathon kodu SAP'nin verdiği repoda kalır.
- Hackathon görevi netleşmeden mimari önerirken tahmin olduğunu belirt.
