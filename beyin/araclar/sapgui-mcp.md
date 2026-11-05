---
tur: arac
alan: ai
tarih: 2026-10-08
guven: topluluk
gozden_gecir: 2027-04-08
---

# sapgui.mcp — SAP GUI MCP Server

## Ne yapar
MCP server; SAP GUI'yi iki backend üzerinden kontrol eder: **Desktop** (Windows, SAP GUI Scripting/COM, `sapsucker` kütüphanesi) veya **WebGUI** (Chrome CDP ile browser otomasyonu, tüm platformlar). Claude Desktop, Claude Code ve opencode ile çalışır. Sağladıkları: herhangi bir transaction kodunu çalıştırma, form alanı doldurma, buton tıklama, tab navigasyonu, ALV grid okuma/yazma, modal popup ve status bar mesajı yönetimi; SE16/SE16N, SE09/SE10, SM37, ST22, SLG1, SM30, SE11 için hazır kısayollar; `sap_run_script` ile sandbox'ta Python script çalıştırarak tek seferde döngü/dallanma gerektiren toplu işlemler (yalnız desktop backend); ekran görüntüsü alma (görsel doğrulama, E2E test, dokümantasyon); çevrimdışı transaction/tablo/sınıf/fonksiyon modülü katalog araması; abapGit repo pull ve ABAP kaynak kod inceleme; çoklu SAP GUI session yönetimi.

## Bende durumu
yeni — ENVANTER'de `sapgui.mcp` veya `aibap.mcp` kayıtlı değil. ENVANTER'deki `sap-browser-automation` (sap-skills plugin) farklı bir araç; tarayıcı otomasyonu açısından kısmen örtüşebilir ama bu MCP server'ın doğrudan alternatifi değil — canlı test gerekir.

## Agentic BI'a katkısı
SAC/Datasphere/BW geliştirmelerinin (ör. CDS view, sorgu, transport) çıktısını gerçek SAP GUI üzerinde uçtan uca test etmeyi, ekran görüntüsüyle görsel doğrulamayı ve ABAP geliştirme ajanı ile GUI test ajanını ayırarak (`aibap.mcp` ile iki-ajanlı kurulum: biri ADT REST üzerinden ABAP yazar, diğeri bu server ile UI'de test edip hata raporlar) agentic geliştirme döngüsünü kapatmayı sağlar.

## Kurulum
Desktop backend (Windows, SAP GUI Scripting etkin, önce `%USERPROFILE%\.config\sap-mcp\systems.json` oluşturulmalı):
```
claude mcp add --scope user sap-desktop -e BACKEND_TYPE=desktop '--' C:/path/to/sapgui_mcp_windows_<version>.exe
```
Alternatif: WebGUI backend (Chrome `--remote-debugging-port=9222` ile başlatılıp) veya Docker (nginx CDP proxy ile, `ghcr.io/hochfrequenz/sapgui.mcp:latest`).

## Dikkat
- MIT lisans, son push 2026-10-08 (aktif bakım, 9 yıldız — küçük/yeni proje).
- **Kritik ön koşul:** SAP GUI Scripting kapalıysa çalışmaz. Sunucu tarafı: `RZ11` → `sapgui/user_scripting = TRUE` (dinamik parametre, restart gerekmez ama kullanıcı yeniden login olmalı). İstemci tarafı: SAP Logon → Options → Accessibility & Scripting → Scripting → "Enable Scripting" açık + iki bildirim kutusu ("Notify when script attaches/opens connection") **kapalı** olmalı, yoksa her COM bağlantısında modal popup otomasyonu bloklar.
- `systems.json` SAP kimlik bilgilerini (kullanıcı/şifre) düz metin tutabilir; üçüncü taraf MCP'ye kimlik bilgisi vermeden önce `${env:VAR}` placeholder yöntemiyle ortam değişkeninden okutmak tercih edilmeli — dosya böylece commit edilebilir hale gelir.
- macOS binary yalnız WebGUI backend'i destekler; Desktop/COM backend yalnız Windows'ta çalışır.
- WebGUI backend Chrome'un `--remote-debugging-port` ile başlatılmasını ve (Docker kullanılıyorsa) host-container arası nginx CDP proxy kurulumunu gerektirir — ek karmaşıklık.
- `GITHUB_PAT` yalnız `log_feedback` (GitHub issue açma) ve abapGit private repo işlemleri için gerekli, opsiyonel.

## Benzerleri
- `aibap.mcp` (aynı ekip, ADT REST üzerinden ABAP geliştirme ajanı; bu server'ın doğal eşi) — ayrı kart yok, [[kaynaklar/2026-10-08-sapgui-mcp]] kaynağında bahsediliyor.
- ENVANTER'deki `sap-browser-automation` (sap-skills plugin) — tarayıcı otomasyonu açısından kısmen örtüşebilir, kapsam ve derinlik farkı canlı testle doğrulanmalı.

([[kaynaklar/2026-10-08-sapgui-mcp]])
