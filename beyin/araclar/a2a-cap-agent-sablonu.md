---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# A2A CAP Agent Şablonu (@a2a-js/sdk + CAP)

## Ne yapar
Google A2A protokolünü (JSON-RPC + discovery /.well-known/agent.json) bir CAP uygulamasının Express instance'ına cds.on("bootstrap") ile monte ederek, ayrı bir servis/sidecar yerine CAP'in kendi HANA binding, XSUAA ve destination altyapısını paylaşan bir "ajan" çalıştırma mimarisi sağlar. İçerir: HanaTaskStore (task kalıcılığı), BaseAgentExecutor (lifecycle: working/input-required/completed, LangGraph interrupt/checkpoint, timeout/concurrency guard), agent-definition (deklaratif ajan konfigürasyonu + Orchestration Client + MCP server listesi), telemetry CDS şeması.

## Bende durumu
yeni (envanterde eşleniği bildirilmedi; mevcut bir CAP/A2A kurulumu varsa onunla karşılaştırılmalı).

## Agentic BI'a katkısı
Joule ve diğer ajan-ajan senaryolarında (örn. Datasphere/SAC agentic BI akışlarına dış ajan bağlama) CAP tabanlı native bir A2A sunucu/istemci iskeleti sunar; MCP araçlarını BTP Destination Service üzerinden, kullanıcı JWT'si ile principal propagation yaparak keşfedip çağırabilir — böylece ajan tabanlı BI sorgularının yetkilendirmesi satır/obje seviyesinde kullanıcı kimliğine bağlı kalır.

## Kurulum
Tek komutla hazır bir şablon paylaşılmamış (proje henüz "kısa blog serisi" olarak duyuruldu, tam çalışan şablon ileride gelecek); mevcut bir CAP projesine eklemek için: `npm install @a2a-js/sdk @sap-ai-sdk/orchestration` ardından `server.ts` içine `cds.on("bootstrap", ...)` hook'unu ve `db/schema.cds` içine Tasks/AgentTaskTelemetry entity'lerini eklemek gerekir ([[kaynaklar/2026-10-09-a2a-agents-sap-btp-cap]]).

## Dikkat
- Yazı, planlanan blog serisinin ilk parçası; "tam çalışan proje şablonu" henüz yayınlanmadı — kod örnekleri "simplified" olarak verilmiş, production'a almadan önce eksiksiz doğrulanmalı.
- @a2a-js/sdk üçüncü taraf (Google ekosistemi) bir kütüphane; MCP destination'larına ve LLM orchestration'a giden JWT/credential akışını (principal propagation) dikkatli tasarlamak gerekir — yanlış yapılandırılmış bir destination üçüncü tarafa kullanıcı JWT'si sızdırabilir.
- Son push tarihi / bakım durumu yazıda belirtilmemiş; @a2a-js/sdk'nin kendi sürüm/bakım durumu ayrıca kontrol edilmeli.

## Benzerleri
Diğer MCP/agent orkestrasyon araçları ve agentic BI şablonları (SAP Beyni'nde henüz kayıtlı değil); gelecekte eklenecek LangGraph tabanlı benzer CAP ajan şablonlarıyla karşılaştırılabilir.

(kaynak: [[kaynaklar/2026-10-09-a2a-agents-sap-btp-cap]])
