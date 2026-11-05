---
tur: arac
alan: ai
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---
# SAP Automation Pilot Agent Skills

SAP'nin resmi deposu; [SAP Automation Pilot](https://help.sap.com/docs/automation-pilot) (BTP operasyonları için native otomasyon/orkestrasyon motoru) içeriğini Claude Code agent skill'leri ile geliştirmeyi sağlar.

## Ne yapar
Automation Pilot "Command"larını (BTP otomasyonları: HANA Cloud lifecycle, Cloud Foundry mass operations, Kyma/Kubernetes, Service Manager, cTMS transport, AI Core, Cloud ALM, vb.) doğal dil tarifinden üretir, güvenlik/naming/expression best-practice'lerine göre review eder, API üzerinden deploy/tetikleme/izleme/debug yapar. 10 skill içerir: Command Generation, Catalog Explorer, Code Review, Content Management API, Executions API, Execution Debugger, Scheduled Executions API, MCP Server Generation, HTTP Executor, Script Executor.

## Bende durumu
Yeni. Envanterde Automation Pilot'a özgü bir plugin, skill veya MCP server kaydı yok; en yakın alan `sap-btp-*` skill ailesi (BTP CLI, Cloud Transport Management, Connectivity, Service Manager vb.) ama Automation Pilot Command geliştirme/deploy/debug akışına doğrudan karşılık gelen bir şey yok.

## Agentic BI'a katkısı
Doğrudan BI/raporlama değil, BTP operasyon otomasyonu alanında. Ancak "MCP Server Generation" skill'i Automation Pilot Command'larını AI asistan tool'u (MCP server) olarak expose edebiliyor — yani bir Command'ı agentic workflow'un bir parçası haline getirip (ör. veri yükleme task chain'i tetikleme, HANA Cloud bakım/credential rotation işlemini bir ajan üzerinden çalıştırma) senaryosu kurulabilir.

## Kurulum
```bash
git clone https://github.com/SAP/automation-pilot-agent-skills.git
```
Sonra `.env` dosyasında `AUTOPI_HOSTNAME`, `AUTOPI_USERNAME`, `AUTOPI_PASSWORD`, `AUTOPI_DEFAULT_CATALOG` tanımlanır, `source .env` ile yüklenir; repo Claude Code'da açılınca skill'ler otomatik devreye girer.

## Dikkat
- Apache-2.0 lisanslı, SAP resmi org (github.com/SAP) altında ama küçük/erken aşama proje (12 yıldız, son push 2026-09-14) — bakım sürekliliği belirsiz.
- Credentials `.env` dosyasında düz metin saklanıyor (gitignored olsa da yerelde plaintext); tenant şifresini ajan/agent ortamına vermeden önce risk değerlendirmesi yap — üçüncü taraf araçlara kimlik bilgisi vermenin genel riskiyle aynı kategoride.
- Bölgeye özgü hostname seçimi gerekiyor (emea/amer/apac/aus/ksa.autopilot.cloud.sap) — yanlış host seçimi bağlantı hatasına yol açar.
- Sadece Claude Code ile çalışacak şekilde tasarlanmış; diğer IDE/agent ortamları için doğrulanmamış görünüyor.

## Benzerleri
- `sap-btp-cloud-transport-management`, `sap-btp-service-manager`, `sap-btp-cloud-platform` gibi kurulu sap-skills plugin'leri — BTP operasyonlarının farklı kesitlerini kapsıyor ama Automation Pilot Command geliştirme/deploy akışına özel değil.

([[kaynaklar/2026-10-09-automation-pilot-agent-skills]])
