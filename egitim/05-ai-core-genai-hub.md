# 05 · SAP AI Core ve Generative AI Hub

> **Tek cümle:** AI Core, SAP'nin modelleri çalıştıran motoru; Generative AI Hub bu motorun içinde Claude, GPT, Gemini ve SAP modellerine tek kapıdan erişim; bizim agent'ımız "düşünmek" için LLM'i buradan çağıracak.

---

## 1. Neden var?

Agent'ımız Python'da yazılacak ve bir LLM'e ihtiyacı var. En kolay yol OpenAI'ın ya da Anthropic'in API'sine doğrudan bağlanmak gibi görünür. Ama müşteri tarafında bu üç soruna yol açar:

- Her model sağlayıcısı için ayrı sözleşme, ayrı API anahtarı, ayrı fatura.
- Müşteri verisi kontrolsüz şekilde dışarıdaki bir API'ye gider.
- Model değiştirmek istersen kodu değiştirirsin.

Generative AI Hub bunları tek yerde çözer: bir BTP servisi, tek fatura, SAP'nin sözleşmesi, ve tüm modeller aynı API şekliyle.

**Benzetme:** Generative AI Hub bir **otel resepsiyonu** gibi. Sen restoran (OpenAI), spa (Anthropic), havuz (Google) ile ayrı ayrı anlaşmazsın; resepsiyona söylersin, hepsi oda hesabına yazılır. Kim hangi hizmeti kullandı, resepsiyon kayıt tutar.

---

## 2. Üç isim, tek ürün ailesi (sınavda kesin çıkar)

Bu üçü çok karıştırılıyor, çünkü aynı ekranda iç içe görünüyorlar.

| | **SAP AI Core** | **SAP AI Launchpad** | **Generative AI Hub** |
|---|---|---|---|
| Ne | Modelleri çalıştıran motor (runtime) | AI Core'un yönetim ekranı (web arayüzü) | AI Core'un içindeki bir yetenek (capability) |
| Ne yaparsın | API ile deployment açarsın, model çağırırsın | Tıklayarak deployment açarsın, prompt denersin, kullanımı izlersin | Hazır foundation model'lere ve orchestration'a erişirsin |
| Kod mu, ekran mı | Kod / REST API | Ekran | İkisi de (Launchpad'de prompt editörü, kodda SDK) |
| Benzetme | Mutfak | Mutfağın kamerası ve sipariş ekranı | Mutfaktaki hazır menü |

**Akılda tutma cümlesi:** *AI Core motor, Launchpad direksiyon, Generative AI Hub motorun içindeki hazır model kataloğu.*

⚠️ **Plan kısıtı:** Generative AI Hub yalnız AI Core'un **`extended`** planında var. `free` veya `standard` plan ile Claude/GPT çağıramazsın. Hackathon subaccount'ında ilk kontrol bu.

Generative AI Hub'ı Launchpad'den kullanabilmek için şu rollerden biri gerekir: `genai_manager`, `prompt_manager`, `genai_experimenter`, `prompt_experimenter`. Yalnız "experimenter" rolü olan prompt kaydedemez.

---

## 3. Temel kavramlar

Dört terimi bilmeden AI Core dokümanını okuyamazsın.

### 3.1 Resource group (çalışma odası)

AI Core içinde birbirinden ayrı **odalar**. Her deployment bir resource group'un içinde yaşar. Her API çağrısında hangi odaya gittiğini header ile söylersin:

```
AI-Resource-Group: default
```

- Hazır gelen oda genelde `default`.
- Takım başına ayrı oda açılabilir (ör. `hackteam1`). Ad 3–10 küçük harf/rakam, tire ortada olabilir.
- **Tuzak:** Model başka odada deploy edilmişse senin odandan "deployment yok" hatası alırsın. Model orada ama sen yanlış kapıyı çalıyorsun.

### 3.2 Scenario ve executable

SAP, modelleri hazır **scenario**'lar altında sunar. Bizi ilgilendiren iki tane:

| Scenario | Ne işe yarar |
|---|---|
| `foundation-models` | Tek bir modele doğrudan erişim (ör. sadece GPT veya sadece Claude) |
| `orchestration` | Modelin önüne boru hattı koyan servis (bkz. bölüm 5). Model adını istekte seçersin |

`foundation-models` altında model sağlayıcısına göre **executable** vardır:

| Sağlayıcı | Executable ID |
|---|---|
| OpenAI (Azure üzerinden) | `azure-openai` |
| Anthropic Claude, Amazon modelleri | `aws-bedrock` |
| Google Gemini | `gcp-vertexai` |
| Mistral | `aicore-mistralai` |
| Açık kaynak modeller | `aicore-opensource` |
| SAP'nin kendi modelleri (SAP-RPT-1 dahil) | `aicore-sap` (doğrulanmadı) |

### 3.3 Configuration ve deployment

- **Configuration**: "Hangi scenario, hangi executable, hangi model" bilgisini tutan tarif kartı.
- **Deployment**: O tarifin **çalışan hali**. Bir URL'si olur, modele bu URL'den istek atarsın.

```
Configuration (tarif)  ──deploy──►  Deployment (çalışan servis, URL'li)
                                         │
                                         ▼
                           https://api.ai.<region>.../v2/inference/deployments/<id>
```

Deployment'ın açılması birkaç dakika sürebilir (orchestration için 10 dakikaya kadar). Durumu `RUNNING` olmadan istek atma.

**Hackathon kısayolu:** Tek tek her model için deployment açmak yerine **tek bir orchestration deployment'ı** aç. Ondan sonra istekte model adını değiştirerek Claude'a, GPT'ye, Gemini'ye geçebilirsin. Ayrı deployment gerekmez.

### 3.4 Foundation model listesi

Hub'da (Kasım 2026 itibarıyla dokümanda görünenler): OpenAI GPT ailesi (ör. `gpt-4o-mini`, `gpt-5`), Anthropic Claude (adı `anthropic--claude-...` kalıbında, ör. `anthropic--claude-4-sonnet`), Google Gemini (ör. `gemini-3.5-flash`), Mistral, Amazon, IBM ve açık kaynak modeller, embedding modelleri (ör. `text-embedding-ada-002`) ve SAP'nin tablo modeli **SAP-RPT-1** (SDK'da `sap-rpt-1.6`).

⚠️ Model listesi her ay değişiyor. **Tek doğru kaynak SAP Note 3437766**: hangi model var, kaç token kaç AI unit eder, rate limit ne, ne zaman emekliye ayrılıyor. Model adını hafızadan yazma, listeden kopyala; yanlış ad deployment anında "Invalid Configuration" hatası verir.

**SAP-RPT-1 neden önemli:** Tablo verisinden tahmin yapar (sınıflandırma, regresyon), eğitim gerektirmez. Örnek satırları verirsin, tahmin edilecek hücreye `[PREDICT]` yazarsın. SAP'nin referans hackathon örneği (`btp-joule-a2a-pro-code-agent`) bunu kullanıyor. Jüriye "SAP'nin kendi modelini kullandık" demek artı puan.

---

## 4. Service key → ortam değişkenleri

Agent'ın AI Core'a bağlanması için BTP'de AI Core instance'ına bir **service key** oluşturursun. Key olmadan ne model listesi ne kota görünür. Key'in içindeki alanlar SDK'nın beklediği değişkenlere şöyle eşlenir:

```
Service key alanı                    →  Ortam değişkeni
─────────────────────────────────────────────────────────────
clientid                             →  AICORE_CLIENT_ID
clientsecret                         →  AICORE_CLIENT_SECRET
url  (+ "/oauth/token")              →  AICORE_AUTH_URL
serviceurls.AI_API_URL  (+ "/v2")    →  AICORE_BASE_URL
(kendin seçersin, genelde "default") →  AICORE_RESOURCE_GROUP
```

⚠️ **En sık hata:** `AICORE_BASE_URL` sonuna `/v2` eklenmezse her çağrı `404` döner.

Nereye yazılır:
- **Lokalde:** `.env` dosyası veya `~/.aicore/config.json`. `.env` mutlaka `.gitignore`'da olsun.
- **Cloud Foundry'de:** AI Core instance'ını uygulamaya **bind** et. SDK değişkenleri `VCAP_SERVICES`'ten kendisi okur, secret'ı koda veya manifest'e yazman gerekmez.

SDK değişkenleri şu öncelikle arar: ortam değişkeni → config dosyası → `VCAP_SERVICES`.

---

## 5. Orchestration: modelin önündeki boru hattı

Orchestration, isteği modele göndermeden önce ve cevabı aldıktan sonra bir dizi **module**'den geçirir. Hepsini tek bir istekte, JSON ayarıyla açıp kapatırsın.

```
Kullanıcı sorusu
      │
      ▼
┌───────────────────┐
│ Templating        │  {{?soru}} gibi boşlukları doldurur
├───────────────────┤
│ Data masking      │  İsim, e-posta, telefon → MASKED_PERSON_1
├───────────────────┤
│ Input filtering   │  Nefret, şiddet içeren girdiyi durdurur
├───────────────────┤
│ Grounding         │  Şirket dokümanlarından ilgili parçayı ekler (RAG)
└─────────┬─────────┘
          ▼
     LLM (Claude / GPT / Gemini — istekte seçilir)
          │
          ▼
┌───────────────────┐
│ Output filtering  │  Uygunsuz cevabı durdurur
├───────────────────┤
│ Unmasking         │  MASKED_PERSON_1 → gerçek isim (pseudonymization'da)
└─────────┬─────────┘
          ▼
       Cevap
```

| Module | Ne yapar | Ne zaman aç |
|---|---|---|
| **Templating** | Prompt şablonu, `{{?degisken}}` ile doldurma | Her zaman (zorunlu) |
| **Grounding** | Vektör aramayla dokümanlardan bağlam ekler (SAP'nin RAG'i) | Agent şirket dokümanına dayanmalıysa |
| **Data masking** | Kişisel veriyi modele gitmeden gizler (SAP Data Privacy Integration) | Müşteri/çalışan verisi geçiyorsa |
| **Content filtering** | Girdi ve çıktıyı zararlı içeriğe karşı süzer (Azure Content Safety) | Son kullanıcıya açık her demoda |

**Data masking'in iki modu:**
- `anonymization`: Gizler ve bir daha açmaz. Cevapta da `MASKED_PERSON` kalır.
- `pseudonymization`: `MASKED_PERSON_1` diye numaralar, cevap gelince gerçek değere **geri çevirir**. Kullanıcı gerçek ismi görür, model hiç görmez. Jüriye anlatması en kolay güvenlik özelliği bu.

**Benzetme:** Orchestration, bir mektubu tercümana göndermeden önce sekreterin isimleri karartması, mektubu şirket şablonuna oturtması ve gelen cevaptaki karartmaları geri açması gibi.

Endpoint şekli:

```
POST {ORCHESTRATION_DEPLOYMENT_URL}/v2/completion
Headers:  Authorization: Bearer <token>
          AI-Resource-Group: <resource-group>
```

Cevap `final_result.choices[0].message.content` yolunda gelir, model hangisi olursa olsun OpenAI formatında. Buna **Harmonized API** denir: Claude'dan Gemini'ye geçince cevap okuyan kodun değişmez.

⚠️ **Reasoning modeller** (gpt-5, Gemini 2.5 Pro gibi) önce görünmeyen "düşünme" token'ı harcar. `max_completion_tokens` düşükse cevap **boş** döner. En az 1024, gpt-5 için 2048+ ver.

---

## 6. SDK'lar: SAP Cloud SDK for AI

SAP'nin resmi kütüphanesi. Eski adı "generative AI hub SDK"; yeniden adlandırıldı ama **sınıf ve import adları değişmedi**.

| Dil | Paket | Import / kullanım |
|---|---|---|
| Python | `sap-ai-sdk-gen` (eski `generative-ai-hub-sdk` artık kullanılmıyor) | `from gen_ai_hub...` |
| JavaScript / TypeScript | `@sap-ai-sdk/orchestration`, `@sap-ai-sdk/langchain` | `OrchestrationClient`, `AzureOpenAiChatClient` |

Python kurulum (uv ile):

```bash
uv add "sap-ai-sdk-gen[all]"     # OpenAI + Google + Amazon (Claude) + LangChain desteği
```

`[all]` yazmazsan sadece OpenAI modelleri gelir. Claude için `[amazon]`, Gemini için `[google]` gerekir.

### 6.1 Python: orchestration ile tek çağrı

```python
from gen_ai_hub.orchestration.service import OrchestrationService
from gen_ai_hub.orchestration.models.config import OrchestrationConfig
from gen_ai_hub.orchestration.models.llm import LLM
from gen_ai_hub.orchestration.models.template import Template, TemplateValue
from gen_ai_hub.orchestration.models.message import SystemMessage, UserMessage

config = OrchestrationConfig(
    template=Template(messages=[
        SystemMessage("Sen bir satış asistanısın."),
        UserMessage("{{?soru}}"),                     # boşluk, çalışırken doldurulur
    ]),
    llm=LLM(name="gpt-4o-mini", version="latest"),    # model adını değiştirmek yeter
)
svc = OrchestrationService(config=config)              # kimlik bilgisi env'den okunur
sonuc = svc.run(template_values=[TemplateValue("soru", "Son siparişi özetle")])
print(sonuc.orchestration_result.choices[0].message.content)
```

Content filtering eklemek:

```python
from gen_ai_hub.orchestration.models.content_filtering import (
    ContentFiltering, InputFiltering, OutputFiltering,
)
from gen_ai_hub.orchestration.models.azure_content_filter import AzureContentFilter

filtre = AzureContentFilter(hate=2, violence=2, sexual=2, self_harm=2)  # 0 en sıkı
config = OrchestrationConfig(
    template=..., llm=...,
    filtering=ContentFiltering(
        input_filtering=InputFiltering(filters=[filtre]),    # kullanıcıdan geleni süz
        output_filtering=OutputFiltering(filters=[filtre]),  # modelden çıkanı süz
    ),
)
```

### 6.2 Python: LangGraph agent'ında LLM olarak kullanmak

Hackathonda yazacağımız agent (`07-pro-code-agent.md`) LangGraph ile. SDK, LangChain'in model arayüzünü birebir taklit eder, yani LangGraph Hub'daki modeli normal bir LangChain modeli sanır.

```python
from gen_ai_hub.proxy import get_proxy_client
from gen_ai_hub.proxy.langchain import init_llm
from langgraph.prebuilt import create_react_agent
from langchain_core.tools import tool

@tool
def siparis_getir(siparis_no: str) -> str:
    """Verilen numaralı satış siparişinin özetini döner."""
    return "..."                                       # gerçekte MCP Gateway çağrısı (06)

llm = init_llm(
    "gpt-4o-mini",                                     # Claude için Claude model adı (doğrulanmadı: init_llm + Claude)
    max_tokens=1024,
    proxy_client=get_proxy_client("gen-ai-hub"),       # AI Core'a giden kimlikli istemci
)

agent = create_react_agent(llm, tools=[siparis_getir])  # LangGraph'ın hazır agent döngüsü
cevap = agent.invoke({"messages": [("user", "4711 nolu siparişi özetle")]})
print(cevap["messages"][-1].content)
```

Belirli bir sağlayıcı sınıfı istersen: `from gen_ai_hub.proxy.langchain import ChatOpenAI` ve `ChatOpenAI(proxy_model_name="gpt-4o-mini", proxy_client=...)`. Gemini için `ChatGoogleGenerativeAI` aynı kalıpta.

### 6.3 Python: SAP-RPT-1 ile tahmin

```python
from gen_ai_hub.proxy.native.sap import RPTClient, RPTRequest, PredictionConfig, TargetColumn

satirlar = [
    {"URUN": "Koltuk", "FIYAT": 999.99, "INDIRIM": "[PREDICT]"},  # tahmin edilecek hücre
    {"URUN": "Sandalye", "FIYAT": 150.80, "INDIRIM": 0.12},       # örnek satırlar
    {"URUN": "Masa", "FIYAT": 640.00, "INDIRIM": 0.10},
]
istek = RPTRequest(
    prediction_config=PredictionConfig(target_columns=[
        TargetColumn(name="INDIRIM", prediction_placeholder="[PREDICT]", task_type="regression")
    ]),
    rows=satirlar,
)
print(RPTClient().predict(body=istek, model_name="sap-rpt-1.6").predictions)
```

### 6.4 JavaScript / TypeScript (CAP yolu seçilirse)

```bash
npm install @sap-ai-sdk/langchain @langchain/langgraph @langchain/core @langchain/mcp-adapters
```

```ts
import { OrchestrationClient } from '@sap-ai-sdk/langchain';

// Orchestration'ı LangChain modeli gibi kullan; tool'ları bindTools ile bağla
const model = new OrchestrationClient({
  promptTemplating: { model: { name: 'gpt-4o-mini' } },   // alan adları (doğrulanmadı)
});
const modelWithTools = model.bindTools(tools);            // tools: MCP'den gelen tool listesi
```

SAP'nin resmi JS öğreticisi aynı kurguyu kuruyor: `@sap-ai-sdk/langchain` + LangGraph + `@langchain/mcp-adapters` ile MCP tool'u çağıran, Human-in-the-Loop'lu bir agent.

---

## 7. Maliyet ve kota

- Ücret **AI unit** ile ölçülür. Her modelin token'ı farklı oranda AI unit'e çevrilir. Oranlar SAP Note 3437766'da.
- Her model için **rate limit** (dakikadaki istek / token) var. Hackathonda 4–5 takım aynı subaccount'ı paylaşırsa limite takılmak mümkün (doğrulanmadı: hackathon subaccount'ının paylaşımlı olup olmadığı).
- Ucuz kural: geliştirme ve deneme sırasında küçük model (`gpt-4o-mini`, Gemini Flash), demo sırasında büyük model. Model adı istekte olduğu için tek satır değişir.
- Claude modellerinde **prompt caching** destekleniyor (`cache_control`, istek başına en fazla 4 kırılma noktası). Uzun sistem prompt'u olan agent'ta maliyeti ve süreyi düşürür.
- 60 saniye kuralını hatırla (`01-a2a.md`): Joule senkron cevabı 60 saniye bekler. Büyük reasoning modeli + çok tool çağrısı bu süreyi kolayca aşar.

---

## 8. Hyperspace proxy ile farkı (karıştırma)

Hazırlık listesinde geçen **Hyperspace LLM proxy** (`hai` CLI) SAP içi bir geliştirici aracı. Biz Claude Code ile kod yazarken, Claude Code'un kendi LLM çağrılarını SAP'nin onaylı kanalından geçirmeye yarıyor (doğrulanmadı: herkese açık dokümanı yok, bilgi hazırlık listesinden).

| | **Hyperspace proxy (`hai`)** | **Generative AI Hub** |
|---|---|---|
| Kim kullanır | Biz, geliştirirken (Claude Code) | Agent'ımız, çalışırken |
| Nerede çalışır | Laptop'ta | BTP'de, Cloud Foundry'deki agent içinden |
| Kimlik | SAP çalışanı hesabı (doğrulanmadı) | AI Core service key / binding |
| Demoda görünür mü | Hayır | Evet, jüri mimaride bunu görmek ister |

**Akılda tutma cümlesi:** *Hyperspace bizim kalemimiz, Generative AI Hub agent'ın beyni.* Agent kodunda Hyperspace'e bağlanan tek satır olmamalı; runtime LLM çağrısı her zaman AI Core üzerinden.

---

## 9. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| Her çağrı `404 Not Found` | `AICORE_BASE_URL` sonunda `/v2` yok |
| `401 Unauthorized` | Client ID/secret yanlış veya `AICORE_AUTH_URL` sonunda `/oauth/token` yok |
| `Resource group not found` / deployment görünmüyor | Yanlış resource group header'ı; deployment başka odada |
| Launchpad'de Generative AI Hub menüsü yok | AI Core planı `extended` değil veya `genai_*` rolü atanmamış |
| Model listesi, kota hiçbir şey görünmüyor | AI Core service key oluşturulmamış |
| Deployment'ta `Invalid Configuration` | Model adı katalogdakiyle birebir aynı değil |
| Cevap boş geliyor (`content: ""`) | Reasoning model, `max_completion_tokens` çok düşük |
| `ModuleNotFoundError` Claude/Gemini sınıfında | `sap-ai-sdk-gen` ekstrası olmadan kuruldu, `[all]` ile kur |
| `429 Too Many Requests` | Modelin rate limit'i aşıldı; küçük modele geç veya bekle |
| Joule cevap gelmeden pes ediyor | LLM zinciri 60 saniyeyi aştı (bkz. `01-a2a.md`) |

---

## 10. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] AI Core, AI Launchpad ve Generative AI Hub arasındaki fark nedir?
- [ ] Generative AI Hub hangi AI Core planında var?
- [ ] Resource group nedir, istekte nasıl belirtilir?
- [ ] `foundation-models` ile `orchestration` scenario'su arasındaki fark ne? Hackathonda neden tek orchestration deployment yeterli?
- [ ] Orchestration'ın dört module'ü ne yapar? Anonymization ile pseudonymization farkı?
- [ ] Service key'deki hangi alan hangi ortam değişkenine gider, en sık yapılan hata ne?
- [ ] LangGraph agent'ına Hub'daki modeli hangi fonksiyonla bağlarız?
- [ ] Hyperspace proxy ile Generative AI Hub'ın farkı nedir, demoda hangisi görünür?

---

## 11. Hackathon için hazır örnekler

- **SAP-samples/btp-joule-a2a-pro-code-agent**: Agent'ın LLM çağrılarını Generative AI Hub'dan yapan, SAP-RPT-1 ile tahmin eden uçtan uca örnek (bkz. `01-a2a.md`).
- **SAP/ai-sdk-js → sample-code/src/tutorials/travel-itinerary-agent.ts**: `@sap-ai-sdk/langchain` + LangGraph + MCP adapter ile çalışan agent.
- **aicore-skills Claude Code plugin'i** (`genai-hub-foundation-models`, `genai-hub-orchestration`, `aicore-admin-resources`, `aicore-lifecycle-management`): Model listesi, deployment açma ve orchestration denemesi için hazır script'ler. Hackathonda deployment kurulumunda zaman kazandırır.

---

## Kaynaklar

- SAP Help: Generative AI Hub (AI Core). https://help.sap.com/docs/AI_CORE/2d6c5984063c40a59eda62f4a9135bee/7db524ee75e74bf8b50c167951fe34a5.html?version=CLOUD
- SAP Help: Models and Scenarios in the Generative AI Hub (AI Launchpad). https://help.sap.com/docs/AI_LAUNCHPAD/92d77f26188e4582897b9106b9cb72e0/fef463b24bff4f44a33e98bb1e4f3148.html?version=CLOUD
- SAP Help: Enhancing Model Consumption with Data Masking. https://help.sap.com/docs/AI_CORE/2d6c5984063c40a59eda62f4a9135bee/592c570f22734ec5ba7881a0aeb49c50.html?version=CLOUD
- SAP Help: Grounding. https://help.sap.com/docs/AI_CORE/2d6c5984063c40a59eda62f4a9135bee/035c455a5a424697b60f4a24b6d791fe.html?version=CLOUD
- SAP Help: Prompt Caching. https://help.sap.com/docs/AI_CORE/2d6c5984063c40a59eda62f4a9135bee/77118d6cfc1f49a4944d616ad3bdb9a0.html?version=CLOUD
- SAP Note 3437766: Generative AI Hub model listesi, token oranları, rate limit'ler. https://me.sap.com/notes/3437766
- SAP Cloud SDK for AI (Python), kurulum ve yapılandırma. https://github.com/SAP/ai-sdk/blob/main/docs-python/overview.mdx
- SAP Cloud SDK for AI (Python), LangChain ve SAP-RPT örnekleri. https://github.com/SAP/ai-sdk/blob/main/docs-python/examples/gen-ai-hub.mdx
- SAP Cloud SDK for AI (JS), Getting Started with Agents. https://sap.github.io/ai-sdk/docs/js/tutorials/getting-started-agents
- SAP Cloud SDK for AI (JS), LangChain Orchestration Client. https://sap.github.io/ai-sdk/docs/js/langchain/orchestration
- SAP Developers: Leveraging Orchestration Capabilities. https://developers.sap.com/tutorials/ai-core-orchestration-consumption-opt.html
- SAP Beyni notları: `ai/kavramsal/sap-ai-terim-sozlugu.md`, `dersler/2026-10-15-sap-ai-core-extended-plan-kurulu-ama-model-durumu-icin-servi.md`, `dersler/2026-10-13-btp-ai-subaccount-unda-generative-ai-hub-ve-joule-entitlemen.md`
