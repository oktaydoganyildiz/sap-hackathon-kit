---
tur: kaynak
alan: ai
tarih: 2026-10-11
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-configuring-code-based-agents-on-the-fly/ba-p/14488352
gozden_gecir: 2027-04-11
---
# Agentic AI on BTP: Configuring Code-Based Agents on the Fly

Link: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-configuring-code-based-agents-on-the-fly/ba-p/14488352

Yazı türü: arac

## Özet
- Ajan tanımı kod değil, `agent_configs` tablosunda bir satırdır. Orchestrator başlangıçta ve her Reload'da bu satırlardan yeniden kurulur.
- Ajan alanları: name, description (orchestrator'ın yönlendirme ölçütü), instructions, ajan başına model seçimi.
- Skill: ad + açıklama + içerik olarak bir kez tanımlanır, birden çok ajana bağlanır. İçerik `load_skill` aracıyla ihtiyaç olunca yüklenir.
- Toolset: çoğu MCP endpoint'i. `builtin:gmail`, `builtin:jira`, `builtin:sapnotes` pseudo-URL'leri MCP üzerinden değil süreç içinde sunulur. Her toolset'in kendi auth modu vardır: kullanıcı JWT'si iletme, kullanıcı başına OAuth2, public ve gözetimsiz çalışma için üç mod (BTP destination dahil).
- Authenticated modlarda varsayılan olarak yalnız `*.hana.ondemand.com` HTTPS URL'leri kaydedilebilir. Başka adresler için `MCP_URL_ALLOWLIST` env değişkeni gerekir.
- Peers: ajanlar birbirini doğrudan çağırabilir. Chat'te görünme ve API ile tetiklenen job olarak açma ayrı anahtarlardır.
- Tüm yapılandırma tek JSON olarak export/import edilir. Ortamlar arası taşıma (DEV'den PROD'a) transport veya pipeline olmadan yapılır.
- Yazar, Joule Studio'ya benzer bir deneyim sunduğunu ama code-based olduğu için UI'ın kapsamadığı şeylerin kodla eklenebildiğini söylüyor.
- Sonraki yazı: aynı tanımın zamanlanmış gözetimsiz çalışması ve ödünç alınan kimlik.

## Beslediği sayfalar
- [[araclar/btp-dynamic-multiagent-app|BTP Dynamic Multi-Agent App]]
