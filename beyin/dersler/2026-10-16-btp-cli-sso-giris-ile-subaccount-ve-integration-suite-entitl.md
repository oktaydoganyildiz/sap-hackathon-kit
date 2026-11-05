---
tur: ders
alan: btp
urun_surumu: "btp CLI v2.116.3"
tarih: 2026-10-16
guven: saha-denendi
kaynak: oturum:9b5efd8e
gozden_gecir: 2027-04-16
---
# BTP CLI SSO giriş ile subaccount ve Integration Suite entitlement kontrolü

**Sorun:** btp CLI oturumu 'Unknown session' ile düştü; subaccount'larda Integration Suite subscription/Marketplace'te görünürlüğü kontrol edilmek istendi.

**Çözüm:** btp login --sso --url https://cli.btp.cloud.sap --subdomain <global-account-subdomain> ile tarayıcıdan SSO girişi yapılır. Ardından btp list accounts/subaccount, btp list services/instance -sa <id>, btp list accounts/subscription -sa <id> ile subaccount bazında Instances/Subscriptions alınır. Integration Suite Marketplace'te yalnızca subaccount'a entitlement (accounts/entitlement) verilmişse görünür; entitlement yoksa önce global account'ta kota kontrol edilip atama yapılır.

**Sürüm/ortam:** btp CLI v2.116.3
