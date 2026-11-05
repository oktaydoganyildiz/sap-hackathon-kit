---
tur: ders
alan: btp
urun_surumu: "cf CLI 3.229.0, SAP BTP Cloud Foundry EU10"
tarih: 2026-10-09
guven: saha-denendi
kaynak: oturum:1ee7c6d2
gozden_gecir: 2027-04-09
---
# CF CLI --sso ile BTP login interaktif kod ister; ! ile çalışmaz

**Sorun:** cf login --sso Claude'un ! öneki altında çalışınca passcode girişi istenemiyor, 'Unable to authenticate' ile düşüyor.

**Çözüm:** Passcode'u https://login.cf.eu10-005.hana.ondemand.com/passcode adresinden al, `cf login -a <api> --sso-passcode <KOD>` ile tek seferde gir. Kod tek kullanımlık.

**Sürüm/ortam:** cf CLI 3.229.0, SAP BTP Cloud Foundry EU10
