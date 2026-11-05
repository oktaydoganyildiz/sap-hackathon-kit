---
tur: kaynak
alan: btp
tarih: 2026-10-09
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/from-automation-to-agentic-ops-mcp-servers-in-sap-automation-pilot/ba-p/14307662
gozden_gecir: 2027-04-09
---

# From Automation to Agentic Ops: MCP Servers in SAP Automation Pilot

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/from-automation-to-agentic-ops-mcp-servers-in-sap-automation-pilot/ba-p/14307662

Yazı türü: arac

## Özet
- SAP Automation Pilot, mevcut otomasyonları task-specific MCP server olarak dışa açma özelliği sunuyor.
- Tipik kullanım alanları: BTP operasyonları (Cloud Foundry apps, HANA Cloud sağlık kontrolleri), cTMS transport doğrulama/yürütme, incident yönetimi.
- MCP server'lar kod yazmadan, Automation Pilot'un low-code/no-code arayüzü ile oluşturuluyor.
- Amaç: operasyonel aksiyonları agent'lar (Joule, Cline vb.) için güvenli, yönetilebilir tool'lara dönüştürmek.
- Governance built-in: yalnız onaylı otomasyonlar expose edilir, input'lar kontrollü, her çalıştırma auditable.
- Joule entegrasyonu zaten GA (Joule Studio agent builder üzerinden); Cline gibi diğer agent araçlarıyla da entegre edilebiliyor.
- SAP Automation Pilot execution engine olarak kalmaya devam ediyor; MCP server sadece expose katmanı.
- Somut kurulum adımı/kod verilmemiş, genel tanıtım + dokümantasyon linkleri (MCP Server Overview, Managing MCP Servers, Integrating SAP Automation Pilot with AI Agents) içeriyor.

## Beslediği sayfalar
- [[araclar/sap-automation-pilot-mcp-servers]]
