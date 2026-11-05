---
tur: kaynak
alan: ai
tarih: 2026-10-10
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/joule-a2a-connect-code-based-agents-into-joule/ba-p/14329279
gozden_gecir: 2027-04-10
---

# Joule A2A: Connect Code Based Agents into Joule

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/joule-a2a-connect-code-based-agents-into-joule/ba-p/14329279

Yazı türü: arac

Joule 1.0'ın yeni pro-code extensibility özelliği ile A2A (Agent2Agent) protokolü kullanılarak LangGraph/LangChain gibi framework'lerle yazılmış kod tabanlı ajanların Joule'ye bağlanması anlatılıyor. Örnek olarak Python + LangGraph ile bir ReAct döviz çevirme ajanı yazılıp a2a-sdk ile A2A server haline getiriliyor, Cloud Foundry'ye deploy ediliyor. Joule tarafında capability/scenario/function YAML'ları (joule.ext namespace, schema_version ≥3.27.0) ile "agent-request" action type kullanılarak uzak ajan çağrılıyor; sonuç result_variable (apiResponse.body.artifacts[0].parts[0].text) üzerinden Joule yanıtına işleniyor. Joule CLI (joule-cli) ile login, compile ve deploy akışı (joule login --no-app-tid, joule deploy -c -n, joule update, joule launch) adım adım gösteriliyor. IAS üzerinde "Cli2Joule" dependency ve client secret oluşturma adımları ile joule-cli 2.0.2'deki login bug'ı (--no-app-tid zorunluluğu) kritik pratik bilgi olarak paylaşılıyor.

## Beslediği sayfalar
- [[araclar/joule-pro-code-a2a]]
- [[ai/baglanti/custom-agent-joule-a2a-entegrasyonu]]
- [[ai/baglanti/joule-cli-login-sorunlari]]
