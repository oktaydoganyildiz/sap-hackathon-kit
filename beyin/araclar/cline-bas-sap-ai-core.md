---
tur: arac
alan: ai
urun_surumu: "SAP BAS; SAP AI Core (Extended Service Plan)"
tarih: 2026-10-08
guven: resmi
gozden_gecir: 2027-04-08
---

# Cline (BAS) + SAP AI Core ile Vibe Coding

## Ne yapar
Cline, SAP Business Application Studio (BAS)'a kurulan bir agentic coding (IDE içi kod ajanı) eklentisidir. SAP AI Core'a bağlanarak Claude (veya SAP AI Core üzerinden sunulan diğer LLM'ler, örn. Mistral — SAP altyapısında host edilir) kullanıp Jupyter Notebook ve Python kodunu otomatik üretir, çalıştırır, hatalarını tespit edip düzeltir. "Plan" modunda önce bir uygulama planı çıkarır (dosyaya dokunmaz), onaylandığında "Act" modunda dosya oluşturma/düzenleme yapar; varsayılan ayarlarda her adım için kullanıcı onayı istenir.

## Bende durumu
yeni (envanterde eşleşen bir IDE-içi kod ajanı kaydı yok)

## Agentic BI'a katkısı
- SAP HANA Cloud / SAP Datasphere embedded HANA üzerindeki Predictive Analysis Library (PAL) çağrılarını (ör. AdditiveModelForecast) tetikleyen hana_ml Python kodunu insan yazmadan, veriyi indirmeden (in-database ML) üretir.
- "Plan → Act" döngüsü, üretken AI ajanının veri bilimi/ML görevlerini yarı-otonom (insan onaylı) yürütmesine somut bir örnektir; agentic BI mimarilerinde "kod üreten/çalıştıran ajan" bileşeni olarak değerlendirilebilir.
- Aynı kurulum SAP Datasphere'in embedded HANA Cloud'u ile de çalışır.

## Kurulum
BAS'ta Cline eklentisini kur → SAP AI Core instance'ından bir Service Key al → Cline'da "Bring my own API key" seç, "API Provider" olarak "SAP AI Core" seç ve Service Key'den `clientid` (AI Core Client ID), `clientsecret` (AI Core Client Secret), `AI_API_URL` (AI Core Base URL), `url` (AI Core Auth URL) değerlerini gir, Resource Group'u (varsayılan "default") belirt → "Orchestration Mode" işaretle (modelleri önceden deploy etmeden kullanmayı sağlar) → modeli seç (ör. Claude 4.7 Opus).

## Dikkat
- SAP AI Core **Extended Service Plan** gerekir; SAP AI Launchpad bu senaryo için gerekli değildir.
- Claude, SAP dışında (Anthropic tarafından) host edilir; bazı modeller (ör. Mistral) SAP altyapısında host edilir — veri rezidansı/gizlilik açısından fark yaratabilir.
- Üretilen kod bir "stajyer kodu" gibi değerlendirilmeli: ne yaptığı mutlaka incelenmeli ve test edilmeli (yazıda tarih hesaplama hatası örneği var).
- Arayüz bazen takılabilir; tarayıcıyı yenilemek veya "Try again"e tıklamak genelde çözüyor; onay istekleri ekranda görünmeyebilir, aşağı kaydırmak gerekebilir.
- Son push/bakım tarihi YAZI'da belirtilmemiş; üçüncü taraf bir eklenti olduğundan yalnızca kendi SAP AI Core Service Key'inizi girin, paylaşmayın.

## Benzerleri
[[araclar/context7-mcp-remote|Context7 MCP Server (Remote)]] (doküman erişimi için tamamlayıcı araç); SAP AI Launchpad (deploy edilmiş modelleri yönetmek için, bu senaryoda gerekli değil).

([[kaynaklar/2026-10-08-vibe-coding-hana-ml-bas-cline-claude]])
