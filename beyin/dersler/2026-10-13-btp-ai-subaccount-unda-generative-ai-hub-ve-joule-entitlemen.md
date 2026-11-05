---
tur: ders
alan: btp
urun_surumu: "btp CLI v2.116.3, BTP global account, eu10"
tarih: 2026-10-13
guven: saha-denendi
kaynak: oturum:341b75ad
gozden_gecir: 2027-04-13
---
# BTP AI subaccount'unda Generative AI Hub ve Joule entitlement'ları kontrolü

**Sorun:** Hangi subaccount'ta Generative AI Hub (AI Core extended), Joule (das-application) ve Build Process Automation'ın hazır olduğu bilinmiyor; global account'taki entitlement'lar her subaccount'a otomatik atanmış sanılabilir.

**Çözüm:** `btp list accounts/subaccount` ile subaccount'ları listele, sonra `btp list accounts/entitlement` ve `btp list accounts/subscription` ile hedef subaccount'ın entitlement/abonelik durumunu kontrol et. Global account'ta olup subaccount'a atanmamış entitlement'lar (ör. HANA Cloud, Integration Suite enhanced_edition) o subaccount'ta kullanılamaz; atama yapılmalı.

**Sürüm/ortam:** btp CLI v2.116.3, BTP global account, eu10
