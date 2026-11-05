---
tur: kaynak
alan: ai
tarih: 2026-10-08
guven: topluluk
kaynak: https://github.com/Hochfrequenz/sapgui.mcp
gozden_gecir: 2027-04-08
---

# Hochfrequenz/sapgui.mcp

Link: https://github.com/Hochfrequenz/sapgui.mcp

Yazı türü: arac

## Özet
- SAP GUI'yi (Desktop COM scripting veya WebGUI/browser otomasyonu) Claude Desktop, Claude Code veya opencode üzerinden otomatikleştiren açık kaynak (MIT) MCP server.
- İki backend: Desktop (yalnız Windows, SAP GUI Scripting + COM API, `sapsucker` kütüphanesi üzerinden) ve WebGUI (Chrome CDP ile tüm platformlar, macOS binary yalnız bu backend'i destekler).
- Kurulum için paylaşılan kimlik dosyası `systems.json` (aibap.mcp ile ortak format) ve MCP client kaydı (standalone exe, Docker veya kaynaktan) gerekir.
- `sap_run_script`: Python sandbox'ta SAP GUI COM API'ye karşı çok adımlı/toplu iş akışlarını tek round-trip'te çalıştırma — token tasarrufu sağlar, yalnız desktop backend.
- Hazır transaction kısayolları: SE16/SE16N, SE09/SE10, SM37, ST22, SLG1, SM30, SE11; ekran görüntüsü alma, çoklu SAP GUI session yönetimi, abapGit pull ve ABAP kaynak kod inceleme.
- `aibap.mcp` ile birlikte iki-ajanlı vibe-coding kurulumu önerilir: bir ajan ADT REST üzerinden ABAP yazar, bu server ile ikinci ajan kodu gerçek SAP UI'de test edip ekran görüntüsüyle doğrular.
- Kritik ön koşul: sunucu tarafında RZ11 → `sapgui/user_scripting = TRUE`, istemci tarafında SAP Logon → Options → Scripting → "Enable Scripting" açık + iki bildirim kutusu kapalı (açık kalırsa her COM bağlantısında modal popup otomasyonu bloklar).

## Beslediği sayfalar
- [[araclar/sapgui-mcp]]
