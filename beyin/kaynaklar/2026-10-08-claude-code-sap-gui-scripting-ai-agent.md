---
tur: kaynak
alan: ai
tarih: 2026-10-08
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/claude-code-python-sap-gui-scripting-your-ai-agent-for-any-sap-transaction/ba-p/14327865
gozden_gecir: 2027-04-08
---

# Claude Code + Python + SAP GUI Scripting: Your AI Agent for Any SAP Transaction

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/claude-code-python-sap-gui-scripting-your-ai-agent-for-any-sap-transaction/ba-p/14327865

Yazı türü: arac

## Özet
- Python + pywin32 ile canlı bir SAP GUI oturumuna COM (ROT) üzerinden bağlanan, transaction navigasyonu yapan, tree/ALV grid/splitter shell gibi kontrolleri parse eden bir Claude Code ajanı tanıtılıyor.
- Ajan doğal dil komutlarıyla yönlendiriliyor ("Open /SLO/PECON", "check messages, create Excel with solutions") ve openpyxl ile severity-sıralı remediation Excel'i üretiyor.
- Gerçek senaryo: DMLT Posting Engine (/SLO/PECON) Error Monitor'daki 14.000+ hata, mesaj sınıfına göre (NR 751, CNV_PE 451, CNV_OT_CX 000 vb.) analiz edilip SAP transaction önerileriyle (FBN1/SNRO, CNV_PE_CUSTOM, ST22/SM21) raporlanıyor.
- Ön koşullar: Windows + SAP GUI for Windows, Alt+F12 scripting açık, RZ11'de sapgui/user_scripting=TRUE, ajan başlamadan önce SAP oturumu açık olmalı.
- Read-only analiz modu olarak tasarlanmış, mevcut oturum yetkileriyle çalışıyor; herhangi bir SAP GUI sistemi (ECC, S/4HANA) ve özel Z-transaction'larda kullanılabildiği belirtiliyor.
- Kaynak kodun tamamı henüz paylaşılmamış; "Part 1" olarak canlı demo, kurulum adımları ve tam kod gelecek hafta vaat ediliyor.
- LLM olarak Claude (Anthropic) + LangChain kullanılıyor, mimarinin OpenAI/Azure/yerel modellere açık olduğu söyleniyor.

## Beslediği sayfalar
- [[araclar/sap-gui-scripting-ai-agent]]
