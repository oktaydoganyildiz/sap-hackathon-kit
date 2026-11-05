---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-08
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/hands-on-tutorial-vibe-coding-sap-hana-cloud-machine-learning-with-bas/ba-p/14411326
gozden_gecir: 2027-04-08
---

# Hands-on Tutorial: Vibe coding SAP HANA Cloud Machine Learning with BAS, Python, Claude and Cline

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/hands-on-tutorial-vibe-coding-sap-hana-cloud-machine-learning-with-bas/ba-p/14411326

Yazı türü: tarif

## Özet
- SAP Business Application Studio (BAS)'a Cline eklentisi kurulup SAP AI Core üzerinden Claude (veya SAP AI Core'daki diğer LLM'ler) bağlanıyor; bu kurulumla "vibe coding" yapılarak Jupyter Notebook ve Python kodu otomatik üretiliyor.
- Cline iki modda çalışıyor: "Plan" (dosya değişikliği yok, sadece plan oluşturma) ve "Act" (planın uygulanması, dosya oluşturma/düzenleme — kullanıcı onayı gerektirir).
- Context7 MCP server'ı (remote URL olarak) Cline'a eklenerek, hana_ml Python paketinin güncel dokümantasyonu ajana sağlanıyor ve üretilen kodun kalitesi artırılıyor.
- Örnek senaryo: HOTELNIGHTS tablosu hana_ml ile (veriyi indirmeden) HANA Cloud içinde aylık bazda aggregate ediliyor, AdditiveModelForecast modeliyle 6 aylık tahmin üretiliyor ve sonuç HOTELNIGHTS_FORECAST_BAS tablosuna yazılıyor.
- Üretilen kod ilk seferde çalışıyor ama bazı detaylar (tahmin tarihlerinin her ayın ilk günü olması gibi) ek bir istemle düzeltilmesi gerekiyor; yazar üretilen kodun bir "stajyer kodu" gibi mutlaka incelenmesi gerektiğini vurguluyor.
- Ön koşullar: SAP AI Core Extended Service Plan (SAP AI Launchpad gerekmiyor), HANA Cloud'da Predictive Analysis Library (PAL) aktif olması, BAS'ta Jupyter Notebook desteği.

## Beslediği sayfalar
- [[araclar/cline-bas-sap-ai-core|Cline (BAS) + SAP AI Core ile Vibe Coding]]
- [[araclar/context7-mcp-remote|Context7 MCP Server (Remote)]]
