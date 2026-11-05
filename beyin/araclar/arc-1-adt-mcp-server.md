---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---
# ARC-1 — ABAP Sistemine Bağlanan MCP Server

## Ne yapar
ARC-1, ADT (ABAP Development Tools) REST API'si üzerinden gerçek bir ABAP sistemine bağlanan güvenli bir MCP proxy'sidir. Sınıf/CDS kaynak kodu okuma, where-used analizi, CDS blast-radius hesaplama, lint, dump teşhisi, sistem tablosu sorgulama ve transport yönetimi gibi 12 adet amaç-odaklı (intent-based) araç sunar (200+ endpoint wrapper yerine). Varsayılan olarak salt okunurdur (read-only); yazma, veri önizleme ve serbest SQL ayrı bayraklarla ve paket allowlist'leriyle açılır.

## Bende durumu
yeni

## Agentic BI'a katkısı
Bir orkestratör/specialist-agent mimarisinde (ör. btp-dynamic-multiagent-app) "ABAP Development Agent" rolüne SAP dokümantasyon MCP server'ı ile birlikte eklenince, Joule for Consultants benzeri — ama kendi sisteminize bağlı — bir asistan oluşturur. OAuth2 + Dynamic Client Registration (RFC 7591) ile kullanıcının kendi kimliği ABAP sistemine iletilir; paylaşılan servis hesabı yerine yetkilendirme ve audit korunur.

## Kurulum
Cloud Foundry üzerine kendi ABAP sisteminizin önüne deploy edilir (Marian Zeis'in ARC-1 deposu); MCP server URL'si daha sonra host agent uygulamasında oauth2 + "Dynamic registration" seçeneğiyle kaydedilir.

## Dikkat
- Yalnızca *.hana.ondemand.com üzerindeki HTTPS URL'ler varsayılan olarak authenticated modlarda (jwt/oauth2) register edilebilir; ARC-1 başka bir yerde çalışıyorsa host uygulamanın MCP_URL_ALLOWLIST env değişkenine eklenmesi gerekir.
- Üçüncü taraf bir MCP server'a kurumsal ABAP OAuth tokenı akıtıldığından, deploy ve erişim kapsamını (read-only, paket allowlist) dikkatli sınırlayın.
- Topluluk kaynaklı, resmi SAP ürünü değildir; bakım ve güvenlik güncellemeleri yazara bağlıdır.

## Benzerleri
SAP Docs MCP server (Marian Zeis) — yalnız dokümantasyon, sistem bağlantısı yok. Joule for Consultants — lisanslı, kendi sisteminize bağlanamaz.

([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])
