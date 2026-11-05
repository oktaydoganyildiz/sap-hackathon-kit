---
tur: tarif
alan: ai
kategori: baglanti
urun_surumu: "Joule 1.0 pro-code, schema_version >=3.27.0, a2a-sdk (Python)"
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# Özel LangGraph ajanını A2A ile Joule'ye bağlama

## Use case
LangChain/LangGraph (veya başka framework/dil) ile yazılmış, kendi mantığına sahip bir AI ajanını, A2A (Agent2Agent) protokolü üzerinden Joule'nin pro-code extensibility mekanizmasına bağlayıp Joule sohbet arayüzünden tetiklemek.

## Varyantlar

### LangGraph ReAct ajanı + a2a-sdk server + Joule pro-code capability

**Adımlar:**
1. IAS'ta Joule için client credentials oluştur: Admin panel (`<ias-tenant-url>/admin`) > Application & Resources > Applications > Create (OpenID Connect) > Dependencies > Add, isim tam olarak `Cli2Joule`, Joule application + API seç, Save. Sonra Client Authentication > Add Secret.
2. `joule login --no-app-tid` ile IAS Authentication URL, Joule API URL, client id/secret, IAS kullanıcı adı/şifresi gir.
3. LangGraph ile ReAct ajanı yaz (`agent.py`): bir `@tool` fonksiyonu (örn. döviz kuru), `ChatOpenAI` (gen_ai_hub proxy ile AI Core model), `create_react_agent`, `stream()` metodu ile ara durum/son yanıt üretimi.
4. a2a-sdk `AgentExecutor` alt sınıfı yaz (`agent_executor.py`): `execute()` içinde `context.get_user_input()` ile sorguyu al, `agent.stream()`'i dolaş, `TaskUpdater` ile `working`/`input_required` durum güncellemeleri ve `add_artifact` + `complete()` ile sonucu bildir.
5. `A2AStarletteApplication` ile Agent Card (`AgentCard`, `AgentSkill`, `AgentCapabilities`) ve `DefaultRequestHandler` oluştur, ASGI `app` olarak export et (`app.py`); well-known discovery endpoint otomatik yayınlanır.
6. Ajanı bir host'a deploy et (ör. Cloud Foundry: `manifest.yaml` + `runtime.txt` + `cf push`); AI Core/gen-ai-hub kimlik bilgilerini env var olarak geç.
7. Joule tarafında capability projesi yaz:
   - `capability.sapdas.yaml`: `metadata.namespace: joule.ext` (zorunlu), `schema_version >= 3.27.0`, `system_aliases.<ALIAS>.destination: <DESTINATION_NAME>`.
   - `scenarios/*.yaml`: `description` + `target: {name: <function>, type: function}`.
   - `functions/*.yaml`: `action_groups` altında `type: agent-request`, `system_alias: <ALIAS>`, `agent_type: remote`, `result_variable: "apiResponse"`; ardından `type: message` ile `apiResponse.body.artifacts[0].parts[0].text` çıktısını formatla.
8. BTP Cockpit'te Connectivity > Destinations altında HTTP destination oluştur: adı capability'deki `system_alias` ile birebir aynı, URL = ajan base URL, Proxy Type Internet (auth demo için NoAuthentication, prod'da uygun değil).
9. Derle + deploy: `joule deploy -c -n "<bot_name>"` (sandbox assistant için `da.sapdas.yaml` kullanılır). Prod'a taşımak için: `joule update "sap_digital_assistant" --capability-file capability.sapdas.yaml`.
10. `joule launch "<bot_name>"` ile webclient URL'sini al ve test et.

**Örnek capability.sapdas.yaml:**
```yaml
schema_version: 3.27.0
metadata:
  namespace: joule.ext
  name: currency_agent_capability
  version: 1.0.0
  display_name: Currency Agent Capability
  description: Capability containing the currency agent
system_aliases:
  CURRENCY_AGENT:
    destination: CURRENCY_AGENT
```

**Örnek scenario yaml:**
```yaml
description: The Currency Agent supports converting between different currencies.
target:
  name: currency_agent_function
  type: function
```

**Örnek function yaml:**
```yaml
action_groups:
  - actions:
      - type: agent-request
        system_alias: CURRENCY_AGENT
        agent_type: remote
        result_variable: "apiResponse"
      - type: message
        message:
          type: text
          content: "<? apiResponse.body.artifacts[0].parts[0].text ?>"
```

**Agent tarafı özet (Python, a2a-sdk):**
```python
# agent_executor.py (özet)
class CurrencyAgentExecutor(AgentExecutor):
    def __init__(self):
        self.agent = CurrencyAgent()

    async def execute(self, context, event_queue):
        query = context.get_user_input()
        task = context.current_task or new_task(context.message)
        updater = TaskUpdater(event_queue, task.id, task.context_id)
        async for item in self.agent.stream(query, task.context_id):
            if not item['is_task_complete'] and not item['require_user_input']:
                await updater.update_status(TaskState.working,
                    new_agent_text_message(item['content'], task.context_id, task.id))
            elif item['require_user_input']:
                await updater.update_status(TaskState.input_required,
                    new_agent_text_message(item['content'], task.context_id, task.id), final=True)
                break
            else:
                await updater.add_artifact([Part(root=TextPart(text=item['content']))],
                    name='conversion_result')
                await updater.complete()
                break

# app.py (özet)
agent_card = AgentCard(
    name='Currency Agent', description='Helps with exchange rates',
    url='https://<your-agent-url>', version='1.0.0',
    capabilities=AgentCapabilities(streaming=True, push_notifications=True),
    skills=[AgentSkill(id='convert_currency', name='Currency Exchange Rates Tool',
        description='Helps with exchange values between currencies',
        tags=['currency conversion'], examples=['What is exchange rate between USD and GBP?'])])
request_handler = DefaultRequestHandler(agent_executor=CurrencyAgentExecutor(),
    task_store=InMemoryTaskStore())
app = A2AStarletteApplication(agent_card=agent_card, http_handler=request_handler).build()
```

**Ne zaman seçilir:** Mevcut LangChain/LangGraph (veya başka framework/dilde yazılmış) bir ajanı sıfırdan Joule skill'i olarak yeniden yazmadan, A2A standardı üzerinden doğrudan Joule'ye bağlamak istediğinizde; Joule Studio low-code skill'lerinin yetmediği karmaşık mantık/çoklu adım gerektiren senaryolarda.

**Kaynak:** ([[kaynaklar/2026-10-10-joule-a2a-connect-code-based-agents]])

## Tuzaklar
- Capability namespace `joule.ext` olmazsa deploy "User is not authorized to deploy sap capabilities (Tenant Administration Worker - 5014)" hatasıyla başarısız olur.
- `schema_version` 3.27.0'ın altındaysa agent entegrasyonu (agent-request action type) desteklenmez.
- Destination adı ile capability'deki `system_alias` birebir eşleşmezse Joule ajanı bulamaz.
- `joule login` flagsiz çağrıldığında joule-cli 2.0.2'de `AUTH_FETCH_TOKEN_FAILED` hatası alınır — bkz [[ai/baglanti/joule-cli-login-sorunlari]].
- IAS Dependency ismi tam olarak `Cli2Joule` olmalı.
- `result_variable` içindeki path (`apiResponse.body.artifacts[0].parts[0].text`) ajanın artifact yapısına bağlıdır; farklı ajanlarda/ çoklu artifact'larda değişebilir.
- Agent varsayılan olarak internete açık host edilirse herkese erişilebilir olur; NoAuthentication destination sadece demo amaçlıdır.

## İlgili
[[araclar/joule-pro-code-a2a|Joule Pro-Code Extensibility + A2A]], [[ai/baglanti/joule-cli-login-sorunlari|Joule CLI login sorunları]]
