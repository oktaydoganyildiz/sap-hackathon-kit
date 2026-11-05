---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# MCP server for SAP BTP administration

## Ne yapar

SAP'ın resmi, uzak (remote) MCP server'ı. BTP Cockpit'te derin hiyerarşilerde tıklamak veya CLI komutlarını zincirlemek yerine, MCP destekli bir istemciden (Claude Desktop, Claude Code) doğal dille BTP altyapısını sorgulama, denetleme ve provizyonlama imkanı verir. Örnek görevler: "US-East bölgesindeki subaccount'larımda hangi entitlement'lar var?", "foo@bar.com kullanıcısı tüm prod subaccount'larda doğru rollere sahip mi?", "QA subaccount'u Staging'in entitlement ve kullanıcı erişimini birebir kopyalayarak oluştur." Ajan, niyete göre gereken API çağrılarını dinamik olarak sıralıyor; ID bulma, JSON parse etme gibi script yazma ihtiyacını ortadan kaldırıyor.

## Bende durumu

yeni — envanterde BTP altyapısını (subaccount/entitlement/rol) doğal dille sorgulayıp yönetebilen resmi bir admin MCP server yok. Mevcut `sap-btp-*` plugin'leri (sap-skills marketplace: `sap-btp-cloud-platform`, `sap-btp-best-practices`, `sap-btp-connectivity` vb.) ve `btp-cli` / `cf-cli` skill'leri yalnızca CLI komutu *üretiyor*, kendisi API çağırmıyor ve gerçek zamanlı durum sorgulayamıyor. Bu MCP, `btp-cli` skill'inin fonksiyonel bir tamamlayıcısı/alternatifi: komut üretmek yerine doğrudan BTP API'lerini kullanıcı kimliğiyle çağırıyor.

## Agentic BI'a katkısı

Datasphere/BW/SAC gibi BI katmanlarının altındaki BTP altyapı katmanını (subaccount, entitlement, role collection, kullanıcı ataması) ajan üzerinden yönetmeyi sağlar. Örneğin yeni bir BI/Datasphere ortamı kurulurken "Staging subaccount'unun entitlement ve erişimini QA'ya aynen uygula" gibi bir komutla altyapı hazırlığı otomatikleşir — agentic BI zincirinin "ortam/erişim hazırlığı" adımını insan müdahalesi olmadan tamamlayabilir.

## Kurulum

```
claude mcp add --transport http btp-administration "https://sso.mcp.btp.cloud.sap/mcp" --client-id e789ba01-5612-47ee-bfe7-79e26411c1ca
```

## Dikkat

- Resmi SAP ürünü (domain: sso.mcp.btp.cloud.sap), üçüncü taraf bir MCP değil; yine de kimlik akışını doğrula — Authentication Code Flow + SAP Default Identity Provider ile principal propagation yapılıyor, yani ajan bağlanan kullanıcının mevcut IAM/role collection yetkisinin ötesine geçemiyor (tasarım iddiası; canlı ortamda doğrulanmalı).
- Yazma/provizyon işlemleri (ör. subaccount oluşturma) geri alınamaz olabilir; doğal dil komutlarının üretebileceği API çağrı zincirini prod'da dikkatli kullan.
- Sürüm/bakım/destek bilgisi yazıda belirtilmemiş; resmi dokümantasyonda tam bağlantı parametreleri ve desteklenen istemciler kontrol edilmeli.
- Zero platform setup iddiası: kaynak derleme, host etme, destination/proxy app kurulumu gerekmiyor — mevcut `btp-cli` skill'ine göre kurulum sürtünmesi daha düşük.

## Benzerleri

- `btp-cli` skill (kullanıcı: sap-skills-yonetim) — BTP CLI komutu üretir, kendisi çalıştırmaz.
- `cf-cli` skill — Cloud Foundry CLI için benzer, komut üretici yaklaşım.

([[kaynaklar/2026-10-09-mcp-server-sap-btp-administration]])
