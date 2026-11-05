---
tur: konu
alan: ai
kategori: diger
urun_surumu: ""
tarih: 2026-10-11
guven: resmi
gozden_gecir: 2027-04-11
---

# BTP CAP GenAI Mail Insights (RAG referans örneği)

## Özet
SAP-samples/btp-cap-genai-rag, SAP BTP üzerinde CAP tabanlı bir GenAI uygulaması örneğidir ("GenAI Mail Insights"). Apache-2.0 lisanslıdır, resmi SAP örneğidir. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

Mimari bileşenler:
- LLM erişimi: Generative AI Hub (SAP AI Core) üzerinden farklı foundation model ve LLM'ler. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- CAP içinde LangChain kullanımı. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- Çıktıyı özel şemaya göre parse etme (output parsing). ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- RAG: embedding'ler ve SAP HANA Cloud Vector Engine. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

Örnek iş senaryosu (seyahat acentesi müşteri desteği): ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- Gelen e-postadan kategori, duygu (sentiment) ve aciliyet çıkarılır.
- Konum gibi özelleştirilebilir alanlar çıkarılır. Alanlar ayrı bir konfigürasyon sayfasından yönetilir.
- E-posta embedding'i ile benzer geçmiş e-postalar bulunur. Böylece benzer taleplerin nasıl ele alındığı görülür.
- E-posta konusu ve gövdesi özetlenir ve çevrilir.
- Yapılandırılabilir aksiyon ve servislerle yanıt taslağı üretilir. SAP Concur gibi SAP sistemleriyle bağlanabilir.
- Senaryo çok kiracılı SaaS çözümüne genişletilebilir.

Repo yapısı: kökte `app`, `db`, `srv`, `router`, `mta.yaml`, `xs-security.json`, `terraform` ve `test` bulunur. Tek kiracılı ve çok kiracılı sürüm ayrı dizinlerdedir. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

## Ne zaman kullanılır
- BTP'de CAP + Generative AI Hub + HANA Cloud Vector Engine iskeletini sıfırdan kurmak yerine çalışan bir referansla başlamak için. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- Yalnız backend gerekiyorsa repodaki ayrı branch `cap-genaihub-vectorengine-sample` daha hafif bir başlangıç noktasıdır. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- Kendi RAG mimarini doğrulamak için: repo, SAP referans mimarisi (Retrieval Augmented Generation with GenAI on SAP BTP) ve Discovery Center Mission ile birlikte yürür. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- BI/analitik odaklı değildir. E-posta destek senaryosudur. Vektör arama ve LLM çağrı desenleri başka senaryolara uyarlanabilir. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

## Tuzaklar
- Üretim şablonu değildir. Repo SAP-samples altında "örnek" statüsündedir. Destek GitHub issue ve SAP Community üzerindendir. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- `@cap-js/sqlite` paketi bilerek bağımlılıklara eklenmemiştir. Paketo build sürecinde sorun çıkarır. Yerelde çalıştırırken veya build'de eksik paket hatası görürsen aşağıdaki workaround'a bak. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
- Kodun telif yılı 2023'tür. Tanıtım blog yazısı Kasım 2023 tarihlidir. Kullandığın model, Generative AI Hub ve CAP sürümleriyle uyumu kendin doğrulamalısın. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

## Çözümler
Paketo build hatası için workaround: paketi `package.json`'a kaydetmeden elle kur. Komutu `single-tenant/code` veya `multi-tenant/code` dizininde çalıştır. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

```
npm i @cap-js/sqlite --no-save
```

## Tarifler
Bu sayfa için ayrı tarif sayfası yok. Repo adım adım tutorial sunuyor: senaryo girişi, landscape kurulumu, deploy, test ve çözümü genişletme. Hem tek kiracılı hem çok kiracılı sürümü kapsıyor. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])

## Cevapladığı sorular
- SAP BTP'de CAP ile Generative AI Hub ve HANA Cloud Vector Engine kullanan referans örnek hangisi?
- RAG için embedding'leri HANA Cloud Vector Engine'de tutan resmi SAP örneği var mı?
- btp-cap-genai-rag paketo build sırasında `@cap-js/sqlite` hatası verirse ne yapılır?

## Sürüm notu
Son push 2026-08-05, 141 yıldız, Apache-2.0 lisans. Kod telif yılı 2023. Belirli bir ürün sürümü yazıda belirtilmemiştir. ([[kaynaklar/2026-10-11-btp-cap-genai-rag]])
