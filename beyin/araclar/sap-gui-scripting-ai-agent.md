---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-08
guven: resmi
gozden_gecir: 2027-04-08
---

# SAP GUI Scripting AI Agent (Claude Code + Python + pywin32)

## Ne yapar
Python tabanlı bir ajan, pywin32 COM automation ile çalışan bir SAP GUI oturumuna (ROT - Running Object Table üzerinden) bağlanır; transaction'ları açar, tree control / ALV grid / splitter shell gibi dinamik GUI kontrollerini parse eder, hata mesajlarını sınıflandırıp severity (önem derecesi) skorlar ve openpyxl ile çözüm önerili (SAP transaction referanslı) bir Excel raporu üretir. Claude Code ile doğal dil komutlarıyla yönlendirilir, örn: "List SAP connections", "Open /SLO/PECON", "Go into Error Monitor, check messages, create Excel with solutions". Somut örnek: DMLT Posting Engine Error Monitor'daki (/SLO/PECON) 14.000+ simülasyon hatası, mesaj sınıfına göre (NR 751 → number range gap, CNV_PE 451 → TRule hatası, CNV_OT_CX 000 → generic exception vb.) gruplanıp severity'ye göre sıralanarak ilgili SAP transaction önerisiyle (FBN1/SNRO, CNV_PE_CUSTOM, ST22/SM21, XK02/FK02, FS00 vb.) Excel'e dökülüyor. Yazara göre süreç ~4 saatten ~2 dakikaya düşmüş.

## Bende durumu
yeni

## Agentic BI'a katkısı
SAP GUI'yi klasik transaction-kod bazlı kullanmak yerine doğal dille "konuşarak" veri çekme/analiz/aksiyon önerisi üretme fikrinin ECC/S4 GUI katmanında somut bir örneği. SAC/Datasphere tarafındaki agentic BI çalışmalarına paralel düşünülebilir: ajan canlı sistemdeki dinamik (statik SQL'le yakalanamayan) tree/grid verisini okuyup yorumluyor ve danışman bağımlılığını azaltıp self-service analiz sunuyor. Read-only modda tasarlandığı için üretim ortamında güvenli bir keşif/raporlama katmanı olarak konumlanabilir; ama scripting API'nin kendisi yazma/postings da yapabildiğinden, prompt ve guard-rail tasarımı kritik.

## Kurulum
`pip install pywin32 openpyxl` sonrası SAP GUI tarafında Alt+F12 → Options → Scripting açılmalı, RZ11'de `sapgui/user_scripting = TRUE` set edilmeli ve ajan çalıştırılmadan önce bir SAP GUI oturumu açık olmalı (ajan oturum başlatmaz, mevcut ROT'taki oturuma `win32com.client.GetObject("SAPGUI")` ile bağlanır).

## Dikkat
- Blog yazarının kendi geliştirdiği özel bir Python betiği (sap_scripting.py + CLAUDE.md); hazır, paketlenmiş üçüncü taraf bir MCP server/araç değil. Tam kaynak kod henüz paylaşılmamış — "Part 1" olarak canlı demo ve kurulum rehberi vaat ediliyor, bu yüzden bu kartın güncelliği (tam kod/depo yayınlandı mı) kontrol edilmeli.
- Windows + SAP GUI for Windows'a bağımlı; SAP GUI scripting'in açılması birçok kurumda güvenlik politikasıyla kısıtlı/kapalıdır — yalnız SAP güvenlik ekibiyle onaylanmış ortamlarda etkinleştirilmeli.
- Ajan mevcut oturumun kullanıcı yetkileriyle çalışır (session permissions); yazarın "read-only analiz modu" dediği şey tasarım tercihidir, scripting API'si teknik olarak posting/veri değişikliği de yapabilir.
- Claude (Anthropic) + LangChain kullanılıyor; OpenAI/Azure/yerel model desteği mimari olarak öngörülmüş ama detaylandırılmamış.
- Lisans, bakım durumu ve son push tarihi (kod deposu linki paylaşılmadığından) blog yazısında belirtilmemiş.

## Benzerleri
- Klasik SAP GUI Scripting API tabanlı RPA/VBScript otomasyonları (doğal dil katmanı olmadan)
- SAP sistemine OData/API üzerinden bağlanan MCP server tabanlı araçlar — bu ajan ise API katmanını atlayıp doğrudan GUI/oturum üzerinden çalışıyor, bu yüzden API'si olmayan/özel Z-transaction'larda avantajlı

([[kaynaklar/2026-10-08-claude-code-sap-gui-scripting-ai-agent]])
