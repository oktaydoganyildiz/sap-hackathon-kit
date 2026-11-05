---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# SAP Automation Pilot MCP Servers

## Ne yapar
SAP Automation Pilot içinde tanımlı otomasyonları (ör. Cloud Foundry app kontrolleri, SAP HANA Cloud sağlık/validasyon/remediation işlemleri, cTMS transport doğrulama ve yürütme, incident yönetimi akışları) task-specific (senaryoya özel) MCP server'lar olarak dışa açar. Böylece bu otomasyonlar, kod yazmadan, agent'ların çağırabileceği yapılandırılmış MCP tool'larına dönüşür. Her senaryo için ayrı, sadece o bağlamla ilgili otomasyonları içeren bir MCP server kurulabilir; bu da hem insan hem agent etkileşimini güvenli ve kontrollü tutar.

## Bende durumu
yeni

## Agentic BI'a katkısı
Doğrudan bir BI aracı değil, bir Ops/BTP otomasyon aracı. Ancak agentic mimari deseni (governed tool exposure, input kontrolü, auditable execution, senaryo bazlı tool gruplama) agentic BI tasarımlarına örnek teşkil edebilir: BI tarafında da benzer şekilde SAC/Datasphere otomasyonlarını (ör. model yenileme, veri yükleme tetikleme) MCP tool olarak expose etmek için ilham alınabilir. Joule agent builder ile entegrasyon zaten GA olduğundan, aynı desenin Joule tabanlı BI agent senaryolarına taşınması mümkün.

## Kurulum
Tek komut yok; Automation Pilot arayüzünde low-code/no-code olarak: istenen otomasyonlar seçilir, scenario-specific bir MCP server grubu halinde paketlenir ve expose edilir. Detaylar için resmi dokümantasyon: "MCP Server Overview", "Managing MCP Servers", "Integrating SAP Automation Pilot with AI Agents" (SAP Automation Pilot resmi dokümantasyonu).

## Dikkat
- SAP'nin kendi resmi ürünü (Automation Pilot), üçüncü taraf değil; yine de hangi otomasyonların expose edildiği ve input kontrolleri dikkatle yapılandırılmalı (governance built-in ama yapılandırma sorumluluğu kullanıcıda).
- Joule entegrasyonu GA; Cline gibi diğer agent istemcileriyle de kullanılabiliyor — ancak üçüncü taraf agent istemcilerine (Cline vb.) kimlik bilgisi/erişim verirken erişim kapsamını senaryo bazlı sınırlı tutmak gerekir.
- Yazıda lisans detayı, versiyon numarası veya son güncelleme tarihi belirtilmemiş; somut kurulum adımı/kod örneği yok, yalnız kavramsal tanıtım + resmi dokümantasyon linkleri var.

## Benzerleri
- Joule Studio Agent Builder (agent oluşturma, Joule ile entegrasyon)
- Cline (agent istemcisi, MCP tool tüketicisi)

([[kaynaklar/2026-10-09-mcp-servers-sap-automation-pilot]])
