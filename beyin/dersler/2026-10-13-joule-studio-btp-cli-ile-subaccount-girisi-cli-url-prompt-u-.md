---
tur: ders
alan: btp
urun_surumu: "btp CLI v2.116.3, BTP CF ortamı, eu10"
tarih: 2026-10-13
guven: saha-denendi
kaynak: oturum:341b75ad
gozden_gecir: 2027-04-13
---
# Joule Studio / BTP CLI ile subaccount girişi: CLI URL prompt'u interaktif kalır

**Sorun:** `btp login --sso --subdomain <sub>` komutu, non-interaktif ortamda (bash-input üzerinden) 'CLI server URL' sorusunda takılır ve 'Reading input failed: EOF' hatasıyla düşer.

**Çözüm:** CLI server URL'yi açıkça vererek çalıştır (ya da komutu interaktif terminalde çalıştır). Non-interaktif ortamda SSO için CLI'ın ürettiği browser login linki kullanılır; link tarayıcıda tamamlanınca oturum açılır.

**Sürüm/ortam:** btp CLI v2.116.3, BTP CF ortamı, eu10
