---
tur: arac
alan: ai
urun_surumu: "Joule 1.0, joule-cli 2.0.2+, schema_version >=3.27.0"
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# Joule Pro-Code Extensibility + A2A

## Ne yapar
Joule 1.0'ın pro-code extensibility özelliği, Joule Studio'nun low-code skill mekanizmasını aşarak YAML tabanlı capability/scenario/function projeleri yazmayı sağlar. "agent-request" action type'ı sayesinde, A2A (Agent2Agent) protokolü üzerinden harici kod tabanlı ajanlar (ör. LangChain/LangGraph ile yazılmış ReAct ajanları, dil/framework bağımsız) Joule'ye bir skill gibi entegre edilebilir. Joule Studio CLI (joule-cli) ile proje derlenir (.daar), sandbox assistant'a veya doğrudan sap_digital_assistant'a deploy edilir.

## Bende durumu
ENVANTER'de Joule CLI veya A2A entegrasyonu bulunmuyor → **yeni**. Mevcut sap-datasphere/sac MCP server'larından farklı: onlar Claude'u SAP verisine bağlıyor, bu mekanizma ise tam tersine harici (LangGraph tabanlı) ajanları Joule'nin konuşma arayüzüne bağlıyor.

## Agentic BI'a katkısı
Joule orchestrator kullanıcı isteğini bir scenario'ya yönlendirir; function içindeki `agent-request` action'ı A2A üzerinden özel bir analiz ajanını (örn. Datasphere/SAC üzerinde çalışan özel bir hesaplama ajanı) çağırabilir. Sonuç `result_variable` (örn. `apiResponse.body.artifacts[0].parts[0].text`) ile Joule yanıtına işlenir. Bu, Claude/LangGraph ile geliştirilen agentic BI bileşenlerinin Joule'nin kurumsal sohbet arayüzüne kod seviyesinde entegre edilmesini sağlayan somut bir köprü.

## Kurulum
Yazıda tek bir kurulum komutu verilmemiş; adımlar: Joule Developer dokümantasyonundan (help.sap) `joule-cli` kurulumu, ardından `joule login --no-app-tid` ile IAS client credentials kullanılarak giriş (bkz [[ai/baglanti/joule-cli-login-sorunlari]]).

## Dikkat
- Agent entegrasyonu için minimum `schema_version: 3.27.0` şart; altındaki sürümlerde `agent-request` action type çalışmaz.
- Capability namespace mutlaka `joule.ext` olmalı — aksi halde "User is not authorized to deploy sap capabilities (Tenant Administration Worker - 5014)" hatası alınır.
- joule-cli 2.0.2'de varsayılan `joule login` bozuk; `--no-app-tid` flag'i CLI default düzeltilene kadar zorunlu.
- Demo'da destination `NoAuthentication` ile kurulmuş — üretimde uygun kimlik doğrulama şart; ayrıca agent'ı internete açık host ederseniz varsayılan olarak herkese açık erişilebilir olur (IAS ile güvenlik öneriliyor, yazar takip yazısına atıf yapıyor).
- Özellik 2026 başı itibarıyla yeni (pro-code extensibility + A2A); hızlı değişebilir, sürüm notlarını takip edin.
- Üçüncü taraf/özel A2A server'a kimlik bilgisi/secret paylaşımı dikkatli yönetilmeli (destination'da client secret BTP Destination Service'te saklanır).

## Benzerleri
A2A protokolü, MCP (tool exposure) yaklaşımına alternatif/tamamlayıcı bir ajan-ajan (agent-to-agent task delegation) entegrasyon standardı; vendor/framework bağımsızdır (Node.js, Java, Python örnekleri mevcut).

([[kaynaklar/2026-10-10-joule-a2a-connect-code-based-agents]])
