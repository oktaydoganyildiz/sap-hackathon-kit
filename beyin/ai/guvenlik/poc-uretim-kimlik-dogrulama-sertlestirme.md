---
tur: konu
alan: ai
kategori: guvenlik
urun_surumu: "BTP, AI Core, SAC custom widget, XSUAA, Credential Store"
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

# AI Pipeline'larda POC'tan Üretime: Kimlik Doğrulama ve Sertleştirme Kontrol Listesi

## Özet
SAP BTP üzerinde (AI Core, SAC custom widget, Datasphere, Cloud Foundry) kurulan bir AI/agentic pipeline'ı trial/POC aşamasından üretime taşırken karşılaşılan kimlik doğrulama ve güvenlik eksiklerinin somut bir listesi.

## Ne zaman kullanılır
- SAC custom widget içinden harici bir REST API'ye (ör. AI Core destekli bir forecasting backend'i) çağrı yapan bir POC üretime alınacağında.
- Joule Skill / zamanlanmış script / widget gibi birden fazla tüketicisi olan bir backend API'nin kimlik doğrulamasını gözden geçirirken.
- Trial tier'da "tek paylaşılan API key" veya "kişisel LLM API key" ile kurulmuş bir entegrasyonu kurumsal ortama taşırken.

## Tuzaklar
- **SAC custom widget'ta client-side API key**: Widget'ın JavaScript bundle'ına gömülen API key, tarayıcı dev tools ile herkes tarafından görülebilir — bu bir "gizli" kimlik bilgisi değildir, düz metin kadar açıktır.
- **Paylaşılan statik X-Api-Key**: Backend'e erişen tüm tüketiciler (Joule Skill, widget, scheduled job) aynı key'i paylaşıyorsa, kimin hangi isteği attığı ayırt edilemez ve key sızarsa tüm tüketiciler etkilenir.
- **`except Exception` genel yakalayıcı**: Hata durumunda stack trace veya iç sistem detaylarının çağırana (caller) sızmasına yol açabilir.
- **Kişisel LLM API key'i (ör. Gemini) üretime taşımak**: Governance/observability AI Core ile aynı hizada olmaz, kurumsal fatura/limit/denetim dışında kalır.
- Backend "kendisine verilen proje ID'sine güveniyor" — rate limiting ve input validation yoksa herhangi bir ID ile keyfi sorgu/maliyet tetiklenebilir.

## Çözümler
- **Backend API erişimi**: Paylaşılan statik key yerine XSUAA üzerinden tüketici-bazlı gerçek kimlik bilgileri (her tüketici için ayrı client/scope).
- **SAC widget**: Client-side'da gömülü key yerine widget katmanında XSUAA tabanlı OAuth akışı kurulmalı.
- **AI Core/RPT bağlantısı**: Trial'daki basit Bearer token yerine AI Core aboneliği kurulduğunda servis-key tabanlı OAuth kullanılmalı.
- **Datasphere bağlantısı**: OAuth2 Client Credentials + Technical User zaten doğru enterprise pattern — sadece trial-tier kısıtlarının kaldırılması yeterli, yöntem değişmiyor.
- **Narrative/LLM katmanı**: Kişisel API key yerine Generative AI Hub (AI Core ile aynı governance/observability) ya da müşterinin zaten kurumsal erişimi/governance'ı olan LLM servisinin kurumsal kimlik bilgisi mekanizması.
- **Secrets yönetimi**: Elle ayarlanan ortam değişkenleri yerine SAP Credential Store servisi.
- **Hata yönetimi**: Genel `except Exception` yerine, iç detay/stack trace sızdırmayan yapılandırılmış hata sınırları (error boundaries).
- **API sertleştirme**: Rate limiting + input validation eklenmesi, tek istekle test edilmiş backend için yük testi ve yatay ölçekleme, manuel `cf push` yerine security scanning içeren gerçek bir CI/CD pipeline.
- Ölçekte mimari: Cloud Foundry yerine Kyma (container-native/ölçekleme), model versiyon takibi, kimin hangi tahmini ne zaman gördüğüne dair audit logging, rescale/escalation mantığı için değişiklik yönetimi süreci.

## Tarifler
(Bu konu için ayrı bir adım-adım tarif sayfası henüz yok; yukarıdaki çözümler bir pipeline örneği — [[araclar/ai-forecasting-sac-rpt-genai-pipeline]] — bağlamında uygulanmıştır.)

## Sürüm notu
Örnekler BTP/AI Core/Datasphere trial tier üzerinde yapılan bir POC'a dayanıyor (2026-09); enterprise tier'da servis adları/abonelik modelleri güncel olmayabilir, kontrol edilmeli.

([[kaynaklar/2026-10-09-ai-forecasting-sac-rpt-genai-part6-poc-uretim]])
