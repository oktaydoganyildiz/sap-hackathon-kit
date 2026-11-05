---
tur: ders
alan: ai
urun_surumu: "SAP AI Core extended plan, Generative AI Hub"
tarih: 2026-10-15
guven: saha-denendi
kaynak: oturum:a0cddaf3
gozden_gecir: 2027-04-15
---
# SAP AI Core: extended plan kurulu ama model durumu için service key gerekli

**Sorun:** AI Core'da 'hangi model deploy edilmiş' ve kota bilgisi CLI ile görülmüyordu; router 'AI Core canlı yok' diyordu.

**Çözüm:** Subaccount'ta AI Core (aicore_extended) kurulu ve hazır görünür. Deploy edilen modeller, kota ve prompt registry okumak için AI Core service key oluşturulmalı; key olmadan bu bilgiler görünmez. Generative AI Hub yalnız extended planda var.

**Sürüm/ortam:** SAP AI Core extended plan, Generative AI Hub
