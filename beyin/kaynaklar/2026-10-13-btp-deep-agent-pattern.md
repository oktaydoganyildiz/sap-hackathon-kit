---
tur: kaynak
alan: ai
tarih: 2026-10-13
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-turning-a-specialist-into-a-deep-agent/ba-p/14501349
gozden_gecir: 2027-04-13
---

# Agentic AI on BTP: Turning a Specialist into a Deep Agent

Link: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-turning-a-specialist-into-a-deep-agent/ba-p/14501349

Yazı türü: tarif

BTP üzerindeki dynamic multi-agent uygulamasına (Pydantic AI + SAP AI Core) LangChain'in "deep agents" pattern'i uyarlanıyor: planning (write_todos/read_todos), scratchpad (in-memory ls/read_file/write_file/edit_file) ve sub-agents (task(description), ephemeral, parent'ın tool ve state'ini paylaşır). Amaç: büyük tool çıktıları, uzun sıralı görevler ve paralelleştirilebilir alt-işlerle context window'un dolmasını önlemek. Sub-agent, peer veya workflow adımından farklıdır — asla kayıt edilmez, orchestrator'a görünmez, parent'ın plan/scratchpad'ini paylaşır. Limitler: max_subagents (1-20, varsayılan 5), subagent_max_depth (1-3, varsayılan 1, derinlik 1'de task tool çocuğa verilmez), semaphore derinlik başına. State: DeepState, run id'ye bağlı, 1 saatlik TTL'li tabloda; 200 dosya, 256 KB/dosya, 4 MB toplam, 100 todo, sub-agent cevabı 20.000 karakterde kesilir, bir satır okuma 2.000 karakterle sınırlı. Pydantic AI'nın varsayılan 50 model-request limiti sub-agent'larla paylaşıldığı için uygulama AGENT_REQUEST_LIMIT ile bunu 200'e çıkarıyor. Konfigürasyon agent JSON'una "deep" bloğu olarak eklenir (enabled, planning, scratchpad, subagents, max_subagents, subagent_max_depth, subagent_instructions), export/import ile taşınır, bilinmeyen key 422 verir. Kaynak kod: github.com/lemaiwo/btp-dynamic-multiagent-app.

## Beslediği sayfalar
- [[araclar/btp-dynamic-multiagent-app]]
