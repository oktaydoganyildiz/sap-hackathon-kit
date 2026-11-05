# 07 · Pro-Code Agent: Yaz, Çalıştır, Deploy Et

> **Tek cümle:** Pro-code agent, kendi kodunla yazdığın ve A2A konuşabilen küçük bir web sunucusudur. Joule ona iş gönderir, o da LLM'i (Generative AI Hub) ve tool'larını kullanıp cevap döner.

---

## 1. Büyük resim

Agent'ı bir **restoran mutfağı** gibi düşün:
- **Garson (a2a-sdk):** Joule'den gelen siparişi alır, "hazırlanıyor / müşteriye soru var / hazır" diye durum bildirir.
- **Şef (LangGraph):** Siparişe bakar, hangi malzemeyi (tool) kullanacağına karar verir, yemeği yapar.
- **Kiler (Generative AI Hub):** Şefin beyni burada; LLM'e SAP içinden erişim.
- **Restoranın adresi (Cloud Foundry):** Mutfak internette bir adreste durur, Joule oraya gelir.

```
 Joule
   │  A2A  message/send  (JSON-RPC 2.0, A2A 0.3.0)
   ▼
┌──────────────────────────────────────────────┐
│  Bizim Agent  (CF veya Kyma'da)              │
│                                              │
│  ┌────────────────────────┐                  │
│  │ A2A katmanı (a2a-sdk)  │  Agent Card      │
│  │ AgentExecutor          │  /.well-known/   │
│  │ TaskUpdater            │  agent-card.json │
│  └──────────┬─────────────┘                  │
│             │ query                          │
│  ┌──────────▼─────────────┐                  │
│  │ LangGraph ReAct agent  │──► tool'lar      │
│  │ (düşün → tool → düşün) │   (S/4 API, MCP, │
│  └──────────┬─────────────┘    Datasphere…)  │
└─────────────┼────────────────────────────────┘
              │ LLM çağrısı
              ▼
     AI Core / Generative AI Hub
```

İki katmanı ayrı tutmak işin sırrı: **A2A katmanı** her projede neredeyse aynıdır (kopyala-yapıştır). **LangGraph katmanı** senin iş fikrin; hackathonda vaktini oraya harca.

---

## 2. Üç yol: hangisini seçeyim?

| | **A: Python sıfırdan** | **B: SAP referans repo (TS/CAP)** | **C: Claude Code toolkit** |
|---|---|---|---|
| Ne | LangGraph + `a2a-sdk` elle | `btp-joule-a2a-pro-code-agent` klonla, uyarla | `/sap-a2a-agent-toolkit:create-agent` iskelet üretir |
| Dil | Python | TypeScript + CAP | Python veya TypeScript (Express/CAP) |
| Deploy | `cf push` + manifest.yml | `mbt build` + `cf deploy` (MTA) | Tek komut: `deploy-agent` |
| HITL + push hazır mı | Sen yazarsın | Evet, örnekli | Kısmen (iskelet) (doğrulanmadı) |
| Öğrenme maliyeti | Orta | Yüksek (CAP, MTA, Terraform) | Düşük |
| Kontrol | Tam | Tam ama kalabalık | Üretilen kodu okuman lazım |

**Öneri (kodlama süresi fiilen ~2 gün):** **C ile iskeleti kur, A'yı bilerek içini doldur.**
- Toolkit; manifest'i, destination'ı ve Joule YAML'larını tek seferde doğru üretir. En çok vakit kaybedilen yer (deploy + Joule bağlantısı) böylece ilk saatte biter.
- Dil olarak **Python** seç (`--lang python`). Python'da rahatsın, LangGraph örnekleri bol, debug kolay.
- B'yi **okumak için** kullan, kurmak için değil. HITL, push notification ve SAP-RPT-1'i tool olarak bağlama fikirleri oradan çalınır. Terraform + CAP + MTA'yı 2 günde ayağa kaldırmak riskli.
- Toolkit bozulursa veya ağ engeli çıkarsa plan B: A'daki kodla elle yaz (bu dosyadaki kod tek başına çalışacak kadar tam).

---

## 3. Seçenek A: Python (LangGraph + a2a-sdk)

### 3.1 Sürüm uyarısı ⚠️ (önce bunu oku)

- Joule, **A2A 0.3.0 (JSON-RPC)** konuşuyor.
- Python `a2a-sdk` kütüphanesi artık **1.0** sürümünde ve 1.0'da büyük değişiklik var: `A2AStarletteApplication` **kaldırıldı**, enum adları değişti (`TaskState.input_required` → `TaskState.TASK_STATE_INPUT_REQUIRED`), `Part(root=TextPart(...))` yerine `Part(text=...)` geldi.
- SAP örnekleri ve bu dosyadaki kod **0.3 API'sini** kullanıyor. O yüzden sürümü sabitle:

```bash
uv add "a2a-sdk[http-server]<1.0"     # 0.3.x serisinde kal
```

1.0 kullanmak zorunda kalırsan: `create_jsonrpc_routes(..., enable_v0_3_compat=True)` ve Agent Card'a `protocol_version='0.3'` olan bir `AgentInterface` eklemen gerekir. Hackathonda bu yola girme.

### 3.2 Klasör yapısı

```
currency-agent/
├── pyproject.toml          # uv ile bağımlılıklar
├── requirements.txt        # CF buildpack için, uv export ile üretilir
├── manifest.yml            # CF deploy tarifi
├── runtime.txt             # Python sürümü (CF)
├── .env                    # SADECE lokal, git'e girmez
└── src/
    ├── agent.py            # LangGraph: şef
    ├── agent_executor.py   # a2a-sdk: garson
    └── app.py              # Agent Card + HTTP sunucu
```

Bağımlılıklar:
```bash
uv init currency-agent && cd currency-agent
uv add "a2a-sdk[http-server]<1.0" langgraph langchain-core "sap-ai-sdk-gen[all]" uvicorn
```

`sap-ai-sdk-gen`, eski adıyla "generative AI Hub SDK". Paket adı değişti, kod içindeki import (`gen_ai_hub`) aynı kaldı.

### 3.3 LLM: Generative AI Hub'a bağlanmak

SDK kimlik bilgisini şu sırayla arar: **ortam değişkenleri** → `~/.aicore/config.json` → CF'de bağlı servisin `VCAP_SERVICES`'i. Yani CF'de AI Core servisini app'e bağlarsan **koda ve manifest'e hiçbir şifre yazmazsın.**

Lokalde `.env` içinde (değerleri AI Core service key'inden al, asla commit etme):
```
AICORE_AUTH_URL=...
AICORE_CLIENT_ID=...
AICORE_CLIENT_SECRET=...
AICORE_BASE_URL=...      # sonu /v2 ile biter
AICORE_RESOURCE_GROUP=default
```

### 3.4 agent.py: şef (LangGraph)

```python
from langchain_core.tools import tool
from langgraph.prebuilt import create_react_agent
from langgraph.checkpoint.memory import MemorySaver
from gen_ai_hub.proxy.langchain import init_llm


@tool
def get_exchange_rate(from_currency: str, to_currency: str) -> str:
    """İki para birimi arasındaki kuru döner."""   # LLM bu açıklamayı okuyup tool'u seçer
    return f"1 {from_currency} = 0.86 {to_currency}"  # hackathonda burası gerçek API


SYSTEM_PROMPT = (
    "Sen bir döviz asistanısın. Hangi para birimleri olduğu belli değilse "
    "cevaba 'SORU:' ile başlayıp kullanıcıya sor."   # HITL için işaret
)


class CurrencyAgent:
    def __init__(self) -> None:
        llm = init_llm("gpt-4o", max_tokens=1024)    # model adı AI Core deployment'ına göre (doğrulanmadı)
        self.graph = create_react_agent(
            llm,
            tools=[get_exchange_rate],
            prompt=SYSTEM_PROMPT,
            checkpointer=MemorySaver(),               # contextId bazında sohbet hafızası
        )

    async def run(self, query: str, context_id: str) -> dict[str, str | bool]:
        config = {"configurable": {"thread_id": context_id}}   # A2A contextId = LangGraph thread
        result = await self.graph.ainvoke({"messages": [("user", query)]}, config)
        text = result["messages"][-1].content
        return {"content": text, "require_user_input": text.startswith("SORU:")}
```

Not: LangGraph 1.0 ile `create_react_agent` yerine `langchain.agents.create_agent` öneriliyor; eski fonksiyon hâlâ çalışıyor (doğrulanmadı). Hackathonda çalışanı kullan, refactor'a vakit harcama.

### 3.5 agent_executor.py: garson (a2a-sdk)

Garsonun işi: mesajı al, şefe ver, durumu Joule'ye bildir.

```python
from a2a.server.agent_execution import AgentExecutor, RequestContext
from a2a.server.events import EventQueue
from a2a.server.tasks import TaskUpdater
from a2a.types import Part, TaskState, TextPart
from a2a.utils import new_agent_text_message, new_task

from agent import CurrencyAgent


class CurrencyAgentExecutor(AgentExecutor):
    def __init__(self) -> None:
        self.agent = CurrencyAgent()

    async def execute(self, context: RequestContext, event_queue: EventQueue) -> None:
        query = context.get_user_input()                       # Joule'den gelen düz metin
        task = context.current_task or new_task(context.message)
        if not context.current_task:
            await event_queue.enqueue_event(task)              # yeni görev → submitted
        updater = TaskUpdater(event_queue, task.id, task.context_id)

        await updater.update_status(                           # → working
            TaskState.working,
            new_agent_text_message("Kuru kontrol ediyorum...", task.context_id, task.id),
        )

        result = await self.agent.run(query, task.context_id)

        if result["require_user_input"]:                       # → input_required (HITL)
            await updater.update_status(
                TaskState.input_required,
                new_agent_text_message(result["content"], task.context_id, task.id),
                final=True,                                    # tur bitti, cevap bekliyoruz
            )
            return

        await updater.add_artifact(                            # sonucu artifact olarak ekle
            [Part(root=TextPart(text=result["content"]))], name="conversion_result"
        )
        await updater.complete()                               # → completed

    async def cancel(self, context: RequestContext, event_queue: EventQueue) -> None:
        raise NotImplementedError("İptal desteklenmiyor")
```

Import yolları 0.3.x örneklerinden alındı; kurduğun sürümde `python -c "import a2a.server.tasks"` ile kontrol et (doğrulanmadı).

### 3.6 app.py: Agent Card + sunucu

```python
import os

from a2a.server.apps import A2AStarletteApplication
from a2a.server.request_handlers import DefaultRequestHandler
from a2a.server.tasks import InMemoryTaskStore
from a2a.types import AgentCapabilities, AgentCard, AgentSkill

from agent_executor import CurrencyAgentExecutor

PUBLIC_URL = os.getenv("AGENT_PUBLIC_URL", "http://localhost:8080/")   # CF'de route adresi

skill = AgentSkill(
    id="convert_currency",
    name="Currency Exchange",
    description="İki para birimi arasında kur çevirir",
    tags=["currency"],
    examples=["USD'den EUR'ya kur ne?"],
)

agent_card = AgentCard(
    name="Currency Agent",
    description="Döviz kuru soruları için agent",
    url=PUBLIC_URL,                                   # Joule'nin çağıracağı adres
    version="1.0.0",
    default_input_modes=["text"],                     # Joule sadece text gönderir
    default_output_modes=["text"],
    capabilities=AgentCapabilities(streaming=False, push_notifications=False),
    skills=[skill],
)

handler = DefaultRequestHandler(
    agent_executor=CurrencyAgentExecutor(),
    task_store=InMemoryTaskStore(),                   # görevler RAM'de; restart'ta silinir
)

app = A2AStarletteApplication(agent_card=agent_card, http_handler=handler).build()
```

`InMemoryTaskStore`: görev listesini RAM'de tutar. Demo için yeter. CF app restart olursa veya 2 instance çalışırsa multi-turn bozulur, o yüzden **instance sayısı 1** kalsın.

---

## 4. Seçenek B: SAP referans repo (TypeScript + CAP)

Repo: `SAP-samples/btp-joule-a2a-pro-code-agent`. Satış teklifi optimize eden uçtan uca örnek.

```
btp-joule-a2a-pro-code-agent/
├── a2a-agent/pro-code-agent/agent/
│   ├── srv/server.ts                 # CAP'i başlatır, A2A endpoint'lerini ve Agent Card'ı açar
│   ├── srv/agent-executor.ts         # LangGraph mantığı + tool'lar
│   ├── srv/CustomRequestHandler.ts   # push notification URL'lerini doğrular
│   ├── srv/tools/tools.ts            # tool kayıt yeri
│   ├── mta.yaml                      # deploy tarifi (aicore, destination, application-logs)
│   └── .cdsrc.sample.json            # ALLOWED_PUSH_NOTIFICATION_URLS burada
├── joule-integration/                # capability, scenario, function YAML'ları
├── webhook-server/                   # push notification alıcısı + React canlı ekran
└── terraform/                        # BTP'yi baştan kuran IaC (subaccount, IAS, Joule, AI Core, HANA)
```

- Agent kısmı **LangGraph JS** + **A2A JS SDK** (`@a2a-js/sdk`) + **SAP Cloud SDK for AI** ile yazılmış.
- LLM bağlantısı `@sap-ai-sdk/langchain` paketiyle (toolkit README'si bunu söylüyor; referans repo README'si paket adını vermiyor, doğrulanmadı).
- **SAP-RPT-1** tool olarak kullanılıyor: teklif varyantlarını skorlar. Jüriye "SAP'nin kendi tahmin modelini tool yaptık" demek için iyi fikir.

Lokal çalıştırma (Node 24):
```bash
cd a2a-agent/pro-code-agent/agent
npm install
cp .cdsrc.sample.json .cdsrc.json
npx cds bind -2 generative-ai-hub     # CF'deki AI Core servisine lokalden bağlan (önce 1 kez deploy gerekir)
npm run watch                          # http://localhost:4004
```

**Mock modu:** mesajın `extensions` listesine `https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent/a2a-agent/extensions/mock-response/v1` koyarsan LLM'e gitmeden sahte cevap döner. Demo provası ve AI Core kotası bittiğinde hayat kurtarır.

Deploy:
```bash
mbt build
cf deploy mta_archives/code-based-agent_1.0.0.mtar
```

⚠️ README'deki örnek JSON'da `extensions` dizisinden sonra fazladan virgül var, kopyalarsan JSON hatası alırsın.

---

## 5. Seçenek C: Claude Code toolkit

Repo: `SAP-samples/joule-a2a-agent-toolkit`. Claude Code'a 4 skill + 3 komut ekler.

Ön koşullar: cf CLI v8 (login olmuş), Joule CLI (`npm install -g @sap/joule-studio-cli`, login olmuş, IAS App2App kurulu), CF + AI Core + Destination servisli subaccount, Node 24, Python agent için Python 3.12+.

```bash
claude --plugin-dir <toolkit-klasörü>     # plugin'i yükle
cf login -a https://api.cf.eu10.hana.ondemand.com
joule login --no-app-tid                  # flagsiz login joule-cli 2.0.2'de hata veriyor (bkz. 08)
```

Claude Code içinde:
```
/sap-a2a-agent-toolkit:create-agent fx-agent --lang python --landscape eu10
        → iskelet: LangGraph agent + A2AStarletteApplication + manifest.yml + Joule YAML'ları
/sap-a2a-agent-toolkit:create-destination fx-agent FX_AGENT_A2A eu10
        → BTP'de HTTP destination
/sap-a2a-agent-toolkit:deploy-agent ./fx-agent
        → cf push + destination + joule deploy, tek seferde
```

| Bayrak | Değerler | Varsayılan |
|---|---|---|
| `--lang` | `typescript`, `python` | `typescript` |
| `--framework` | `express`, `cap` (CAP sadece TS) | `express` |
| `--namespace` | **`joule.ext` olmak zorunda** | `joule.ext` |

Dikkat:
- Toolkit kendi `btp-cli` ve `cf-cli` skill'lerini getiriyor; bizde aynı isimli skill'ler zaten var. Hangisinin tetiklendiğine bak.
- Toolkit cf/joule oturumunu kullanıyor. Ürettiği komutu çalıştırmadan önce oku, özellikle destination auth tipini.
- Üretilen proje ağacı README'de gösterilmiyor; ilk iş `tree` ile bak ve bu dosyadaki A yapısıyla eşleştir.

---

## 6. Lokal çalıştır ve curl ile test et

```bash
cd src
uv run uvicorn app:app --host 0.0.0.0 --port 8080
```

**1) Kartvizit duruyor mu?**
```bash
curl http://localhost:8080/.well-known/agent-card.json
```
JSON'da `name`, `url`, `skills` görmelisin. Görmüyorsan Joule de göremez.

**2) Joule'nin attığı isteğin aynısını at (message/send, JSON-RPC):**
```bash
curl -X POST http://localhost:8080/ \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": "1",
    "method": "message/send",
    "params": {
      "message": {
        "role": "user",
        "messageId": "msg-001",
        "parts": [ { "kind": "text", "text": "100 USD kaç EUR?" } ]
      },
      "configuration": { "blocking": true }
    }
  }'
```

Beklenen cevabın iskeleti:
```json
{
  "jsonrpc": "2.0", "id": "1",
  "result": {
    "kind": "task",
    "id": "<taskId>", "contextId": "<contextId>",
    "status": { "state": "completed" },
    "artifacts": [ { "name": "conversion_result",
                     "parts": [ { "kind": "text", "text": "100 USD = 86 EUR" } ] } ]
  }
}
```

Joule tarafındaki `apiResponse.body.artifacts[0].parts[0].text` yolu tam olarak bu yapıyı okuyor (bkz. `08-joule-cli-capability.md`).

**3) Multi-turn testi:** "Kur ne?" gibi eksik bir soru gönder → `state: input-required` dönmeli. Sonra aynı `taskId` ve `contextId`'yi `message` içine koyup cevabı gönder:
```json
"message": { "role": "user", "messageId": "msg-002",
             "taskId": "<taskId>", "contextId": "<contextId>",
             "parts": [ { "kind": "text", "text": "USD'den TRY'ye" } ] }
```

---

## 7. Human-in-the-Loop (HITL)

Agent eksik bilgi fark edince durur ve kullanıcıya sorar. Jüri bunu "agent kör kör iş yapmıyor" diye okur.

```
Kullanıcı ──"Teklifi optimize et"──► Joule ──► Agent
                                               │ "Hangi müşteri?" 
                                               │ state = input-required, final=True
Kullanıcı ◄──"Hangi müşteri?"────── Joule ◄────┘
   │
   └──"Altinova"──► Joule ──(aynı taskId + contextId)──► Agent
                                                         │ işi bitirir
                                                         ▼ state = completed
```

Üç şart:
1. Agent `input_required` durumunu `final=True` ile döner (3.5'teki kod).
2. Agent aynı görevi hatırlar: `InMemoryTaskStore` + LangGraph `MemorySaver` (thread_id = contextId).
3. Joule function YAML'ı `taskId` ve `contextId`'yi cevaptan alıp sonraki çağrıya koyar (`body` içinde, bkz. `08`).

---

## 8. Push notification (60 saniyeyi aşan işler)

Joule senkron çağrıda cevabı **60 saniye** bekler. Daha uzun süren iş (çok adımlı LLM, büyük veri, simülasyon) için asenkron yol var:

```
Joule ──message/send (pushNotifications: true + webhook bilgisi)──► Agent
Joule ◄── "aldım, working" ─────────────────────────────────────────┘
                 ... agent arka planda çalışır ...
Joule webhook ◄── POST: task güncellemesi / completed ── Agent
```

- Joule tarafı: function YAML'ında `body.configurations.pushNotifications: true`. Webhook'u Joule kendisi ayarlar.
- Agent tarafı: Agent Card'da `push_notifications=True`; request handler'a bir push config store ve push sender verilir (Python 0.3'te `InMemoryPushNotificationConfigStore` + `BasePushNotificationSender`, doğrulanmadı).
- **Güvenlik şartı:** Agent'ın Joule webhook'una yazabilmesi için Joule ile agent arasında **IAS App2App trust** gerekir (bkz. `04-kimlik-ias.md`).
- Referans repo, izin verilen webhook adreslerini `ALLOWED_PUSH_NOTIFICATION_URLS` listesiyle kısıtlıyor. Kopyalanacak iyi alışkanlık: agent rastgele bir URL'ye veri göndermesin.

**Hackathon tavsiyesi:** Önce senkron çalıştır. Agent'ı 60 saniyenin altında tutmak (az tool çağrısı, küçük model, önbellek) push kurmaktan çok daha ucuz. Push'u sadece senaryo gerçekten uzun sürüyorsa ve vakit kalırsa ekle.

---

## 9. Cloud Foundry'ye deploy (Python)

CF Python buildpack `requirements.txt` okur. Biz `uv` kullanıyoruz, o yüzden deploy öncesi üret:
```bash
uv export --format requirements-txt --no-hashes > requirements.txt
```

**runtime.txt**
```
python-3.12.x
```
(Buildpack'in desteklediği sürüm landscape'e göre değişir; `cf buildpacks` ile bak, doğrulanmadı.)

**manifest.yml**
```yaml
applications:
  - name: currency-agent
    memory: 512M
    instances: 1                                # InMemoryTaskStore yüzünden 1
    buildpacks:
      - python_buildpack
    command: uvicorn app:app --host 0.0.0.0 --port $PORT --app-dir src
    random-route: true
    env:
      AGENT_PUBLIC_URL: https://currency-agent-xxx.cfapps.eu10.hana.ondemand.com/
    services:
      - my-aicore                               # AI Core instance'ı; şifre VCAP_SERVICES'ten gelir
```

```bash
cf create-service aicore extended my-aicore     # yoksa (plan adı entitlement'a göre)
cf push                                         # manifest.yml'yi okur
cf app currency-agent                           # route'u gör → AGENT_PUBLIC_URL'ye yaz
curl https://<route>/.well-known/agent-card.json
```

Servis bağlamak yerine env ile vermek istersen (önerilmez):
```bash
cf set-env currency-agent AICORE_CLIENT_SECRET "<service key'den>"   # manifest'e ASLA yazma
cf restage currency-agent
```

Sonra BTP Cockpit'te destination aç (adı = Joule'deki `system_alias`'ın gösterdiği destination adı, URL = route) ve Joule capability'yi deploy et. İkisi `08-joule-cli-capability.md`'de.

### Loglar

```bash
cf logs currency-agent --recent     # son loglar
cf logs currency-agent              # canlı takip (Joule'den test ederken açık tut)
```

Joule'den deneme yaparken bu pencere açık dursun: istek agent'a hiç gelmiyorsa sorun Joule/destination tarafında, geliyor ama hata veriyorsa agent kodunda.

---

## 10. Kyma / Podman (kısaca)

CF yerine Kyma (Kubernetes) seçilirse agent bir container imajı olur.

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080", "--app-dir", "src"]
```

```bash
podman build -t <registry>/currency-agent:1 .
podman run -p 8080:8080 --env-file .env <registry>/currency-agent:1   # lokal test
podman push <registry>/currency-agent:1
kubectl apply -f k8s/                     # Deployment + Service + APIRule (dışa açmak için)
kubectl logs deploy/currency-agent -f
```

Kyma'da AI Core kimlik bilgisi bir Kubernetes Secret'tan env olarak gelir. 2 günlük hackathonda **CF daha hızlı**: imaj, registry, APIRule derdi yok. Kyma'yı ancak takımda Kubernetes bilen varsa seç.

---

## 11. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| `ImportError: cannot import name 'A2AStarletteApplication'` | `a2a-sdk` 1.0 kurulmuş; `<1.0` ile sabitle |
| Agent Card 404 | Yol yanlış (`agent-card.json`, eski örneklerde `agent.json`) veya app başlamadı |
| Joule çağırıyor ama agent hiç log basmıyor | Destination URL'si yanlış veya `system_alias` ↔ destination adı uyuşmuyor |
| Agent Card'daki `url` localhost gösteriyor | CF'de `AGENT_PUBLIC_URL` set edilmemiş |
| `401` / AI Core token hatası | AI Core servisi bağlı değil veya `AICORE_BASE_URL` sonunda `/v2` yok |
| `Deployment not found` / model hatası | AI Core'da o model için deployment yok veya resource group yanlış |
| Multi-turn'de agent önceki konuşmayı unutuyor | Joule `taskId`/`contextId`'yi geri göndermiyor, ya da 2+ instance / restart oldu |
| Joule "zaman aşımı" diyor | 60 saniye aşıldı; agent'ı hızlandır veya push notification'a geç |
| Joule cevabı boş gösteriyor | Agent artifact eklemedi (sadece status mesajı döndü) |
| `cf push` Python buildpack hatası | `requirements.txt` yok veya `runtime.txt` sürümü buildpack'te yok |

---

## 12. Neleri bilmen lazım (kontrol listesi)

- [ ] Agent'ın iki katmanı nedir? Hangisi her projede aynı, hangisi senin iş fikrin?
- [ ] `a2a-sdk` neden `<1.0` sabitleniyor?
- [ ] `TaskUpdater` hangi üç durumu bildirir, `final=True` ne zaman kullanılır?
- [ ] Agent Card'da `url` neden CF route'u olmalı, localhost olursa ne olur?
- [ ] AI Core şifresini koda yazmadan agent'a nasıl verirsin? (iki yol)
- [ ] curl ile `message/send` atınca cevapta neyi kontrol edersin?
- [ ] HITL için hangi üç şart gerekir?
- [ ] 60 saniyeyi aşan iş için ne yapılır, bunun kimlik ön şartı nedir?

---

## Kaynaklar

- GitHub: SAP-samples/btp-joule-a2a-pro-code-agent. https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent
- GitHub: a2a-agent README (lokal kurulum, mock, CF deploy). https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent/blob/main/a2a-agent/README.md
- GitHub: joule-integration README. https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent/blob/main/joule-integration/README.md
- GitHub: SAP-samples/joule-a2a-agent-toolkit. https://github.com/SAP-samples/joule-a2a-agent-toolkit
- GitHub: a2aproject/a2a-python (sürüm 1.0, 0.3 uyumluluk modu). https://github.com/a2aproject/a2a-python
- a2a-python v0.3 → v1.0 geçiş rehberi. https://github.com/a2aproject/a2a-python/blob/main/docs/migrations/v1_0/README.md
- SAP Help: Code-Based Agents (Bring Your Own Agent), 60 sn, push notification, taskId/contextId. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/2f9701e60fd24e948c2c74fe9e55ce23.html
- SAP Cloud SDK for AI (Python), kurulum ve AICORE_* değişkenleri. https://github.com/SAP/ai-sdk/blob/main/docs-python/overview.mdx
- SAP Architecture Center: Pro-Code AI Agents on SAP BTP. https://architecture.learning.sap.com/docs/ref-arch/7b6426
- SAP Architecture Center: A2A and MCP for AI Agent Interoperability. https://architecture.learning.sap.com/docs/ref-arch/76ec36
- A2A Protocol 0.3.0 Specification. https://a2a-protocol.org/v0.3.0/specification/
- SAP Beyni notları: `ai/baglanti/custom-agent-joule-a2a-entegrasyonu.md`, `araclar/btp-joule-a2a-pro-code-agent.md`, `araclar/joule-a2a-agent-toolkit.md`, `araclar/a2a-cap-agent-sablonu.md`
