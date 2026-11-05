---
tur: ders
alan: btp
urun_surumu: "btp CLI (2026-10-15 itibarıyla)"
tarih: 2026-10-15
guven: saha-denendi
kaynak: oturum:a0cddaf3
gozden_gecir: 2027-04-15
---
# BTP CLI canlı erişim: subaccount ve servis listeleme

**Sorun:** Router'da BTP için 'canlı katman yok' yazıyordu; oysa btp CLI kurulu ve oturum açıktı. Dosya kendi içinde çelişiyordu.

**Çözüm:** btp list accounts/subaccount, btp list services/instance, btp list services/binding komutlarıyla subaccount, entitlement ve instance durumu canlı okunabilir. Bayat 'canlı yok' iddiası düzeltildi.

**Sürüm/ortam:** btp CLI (2026-10-15 itibarıyla)
