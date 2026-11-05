---
tur: konu
alan: ai
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

# Joule Studio için custom MCP server: destination ve authentication kurulumu

## Özet
SAP BTP/Cloud Foundry üzerinde Node.js tabanlı custom bir MCP server'ı Joule Studio'ya bağlarken destination modeli ve authentication akışı kritik önem taşır. MCP server thin bir orkestrasyon katmanı olarak tasarlanmalı, backend erişimi named destination üzerinden yapılmalı ve Joule-facing destination doğrudan CAP servisine değil MCP server'ın kendisine point etmelidir.

## Ne zaman kullanılır
- Joule Studio'ya custom tool seti (ör. structured enterprise data, document reference) expose eden bir MCP server geliştirirken
- Node.js + SAP Cloud SDK for JavaScript ile Cloud Foundry'de MCP server deploy ederken
- MCP server'ın birden fazla backend servise (örn. DMS/folder, processor servisleri) destination üzerinden erişmesi gerektiğinde

## Tuzaklar
- Destination URL'sine `/mcp` eklemek: Joule-facing destination URL'si MCP server'ın kök adresini göstermeli, `/mcp` yalnızca Joule Studio'nun advanced path ayarında olmalı. Aksi halde troubleshooting sırasında isteğin nereye ulaştığı karışır.
- MCP server'ı browser-session tabanlı authentication varsayımıyla kurmak: Joule bir teknik entry point olarak MCP server'ı çağırdığında, browser-authenticated path varsayımları (incoming bearer token bekleme) çalışmaz; stale destination credential ve token uyuşmazlıkları ortaya çıkar.
- MCP server'ı authentication-heavy bir gateway gibi tasarlamak hem debug'ı hem Joule tarafı entegrasyonu zorlaştırır.
- Destination/binding varsayımlarını manuel çıkarsamaya çalışmak: `cf services` / `cf env <app>` kullanmadan hangi servis instance'ın hangi app'e bağlı olduğunu tahmin etmek zaman kaybettirir.

## Çözümler
- MCP server'ı önce MCP protokolü olmadan, geçici `/test` route'larıyla bir "wrapper" olarak kur; backend servis çağrılarını (destination + relative path üzerinden) MCP transport'tan bağımsız doğrula. Bu, MCP sorunlarıyla destination/auth sorunlarını ayırt etmeyi hızlandırır.
- Destination modelini şöyle kur: MCP server hardcoded tam URL kullanmaz, named destination + relative resource path kullanır. Ayrı backend destination'lar (ör. DMS/folder için bir, processor-style servisler için bir) tanımla; ayrıca Joule-facing ayrı bir MCP destination tanımla.
- Joule-facing MCP destination'ı doğrudan raw Node.js app'e yönlendir (approuter/CAP üzerinden değil); bu hem auth modelini basitleştirir hem debug'ı kolaylaştırır.
- MCP server'ı incoming bearer token'a bağımlı olmaktan çıkar; backend destination'lar kendi technical OAuth akışını yönetsin. MCP server sadece thin orkestrasyon katmanı olsun.
- Cloud Foundry'de implementasyon/debug için şu komutları standart iş akışının parçası yap:
  - `cf services` → space'teki gerçek service instance adlarını görmek için
  - `cf env <app-name>` → hangi service instance'ların target app'e bind edildiğini ve runtime'ın gerçekte ne gördüğünü teyit etmek için
  - `cf push` + `cf logs <app-name> --recent` → deploy/debug döngüsü

## Tarifler
Bu kaynaktan doğrudan bir tarif sayfası türetilmedi; adım adım akış yukarıdaki "Çözümler" bölümünde özetlenmiştir.

## Sürüm notu
Topluluk kaynaklı tek bir implementasyon deneyimine dayanır (Node.js + SAP Cloud SDK for JavaScript + Cloud Foundry + XSUAA). Ürün sürümü belirtilmemiş; Joule Studio'nun MCP desteği hızla değişebilir, bu notları güncel sürümle doğrulayın.

([[kaynaklar/2026-10-09-sap-joule-studio-mcp-setup-guide]])
