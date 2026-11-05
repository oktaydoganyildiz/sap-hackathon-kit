# 12 · A2A ile Joule'ye Bağlı Agent Kurma: Yol Haritası

> **Tek cümle:** Kendi agent'ımızı yazıp BTP'ye koyuyoruz, Joule'ye "bu işi ona devret" diyoruz. Aradaki köprü A2A.

Hackathonun büyük ihtimalle bu tip bir case olacağını düşünüyoruz (doğrulanmadı, görev Pazartesi açıklanacak). Kodun çoğunu birlikte yazacağız. Bu sayfa **senin bilmen gerekenleri** gösteriyor. Detaylar 01–09 dosyalarında.

---

## 1. Büyük resim

```
                         SAP BTP Subaccount
 ┌──────────────────────────────────────────────────────────────────┐
 │                                                                  │
 │  ┌─────────┐   ③ A2A    ┌────────────┐   ④   ┌────────────────┐  │
 │  │  Joule  │──────────► │ Destination│─────► │  Bizim Agent   │  │
 │  │         │            │ "MY_AGENT" │       │  (Cloud Foundry)│  │
 │  └────▲────┘            └────────────┘       └───┬────────┬───┘  │
 │       │ ② capability                             │ ⑤      │ ⑥    │
 │       │   (YAML)                                 ▼        ▼      │
 │       │                                   ┌──────────┐ ┌────────┐ │
 │       │                                   │ AI Core  │ │  Veri  │ │
 │       │                                   │  (LLM)   │ │ (MCP / │ │
 │       │                                   └──────────┘ │ API)   │ │
 │       │                                                └────────┘ │
 │  ┌────┴────────────────────── IAS (kimlik) ────────────────────┐  │
 │  └──────────────────────────────────────────────────────────────┘  │
 └──────────────────────────────────────────────────────────────────┘
   ▲
   │ ① "Şu KPI neden düştü?"
 Kullanıcı
```

1. Kullanıcı Joule'ye sorar.
2. Joule, bizim yüklediğimiz **capability**'ye bakar: "Bu soru bu scenario'ya uyuyor."
3. Joule, A2A ile **destination**'a gider.
4. Destination, isteği CF'deki agent'ımıza iletir.
5. Agent, LLM'i **AI Core** üzerinden kullanır.
6. Agent, veriye **MCP** veya API ile erişir, cevabı Joule'ye döner.

---

## 2. Adım adım yol haritası

```
 ADIM 0          ADIM 1         ADIM 2         ADIM 3          ADIM 4          ADIM 5
 BTP hazırlık ─► AI Core ─────► Agent kodu ──► CF'ye deploy ─► Destination ──► Joule
 (subaccount,    (model         (LangGraph     (cf push)       + IAS trust     capability
 entitlement)    deployment)    + a2a-sdk,                                      + joule deploy
                                lokal test)                                         │
                                                                                    ▼
                                                                           ADIM 6: Joule'de test
```

| Adım | Ne yapılır | Kim | Bilmen gereken | Dosya |
|---|---|---|---|---|
| **0. BTP hazırlık** | Subaccount, CF ortamı, entitlement: AI Core, Joule, Destination | Muhtemelen SAP hazır verir | Subaccount ve entitlement ne demek | `03` |
| **1. AI Core** | Bir LLM deployment'ı (örn. GPT ya da Claude), service key | Biz | Agent LLM'e doğrudan değil AI Core üzerinden erişir | `05` |
| **2. Agent kodu** | LangGraph agent + a2a-sdk sarmalayıcı, Agent Card. Lokalde curl ile test | Birlikte (Claude yazar) | Agent Card, Task durumları, `input-required` | `01`, `07` |
| **3. Deploy** | `cf push`, AI Core key'i env var olarak ver | Birlikte | `cf push`, `cf logs` | `03`, `07` |
| **4. Destination + IAS** | BTP'de agent URL'li destination, Joule ↔ agent App2App trust | En çok takılınan yer | Destination adı = `system_alias`, demo'da NoAuthentication | `03`, `04` |
| **5. Joule capability** | capability / scenario / function YAML, `joule deploy` | Birlikte | `namespace: joule.ext`, `schema_version >= 3.27.0`, `agent-request` | `08` |
| **6. Test** | `joule launch` ile Joule'yü aç, soru sor | Biz | 60 saniye limiti | `01` |

---

## 3. Kod tarafında üç dosya (sadece şekli)

```
my-agent/
├── agent.py            ← Beyin: LangGraph, tool'lar, LLM (AI Core)
├── agent_executor.py   ← A2A çevirmeni: mesajı al, agent'ı çalıştır, durumu bildir
├── app.py              ← Kapı: Agent Card + HTTP sunucusu
├── manifest.yml        ← CF deploy ayarı
└── joule/
    ├── capability.sapdas.yaml   ← kimlik + destination bağlantısı
    ├── scenarios/ask_agent.yaml ← "hangi sorular bu agent'a gider"
    └── functions/call_agent.yaml← agent-request + cevabı gösterme
```

**Benzetme:** `agent.py` uzman, `agent_executor.py` tercüman, `app.py` kapıdaki tabela, `joule/` klasörü ise Joule'ye verilen "bu konularda şu uzmanı ara" talimatı.

---

## 4. Konuşma nasıl akar (sequence)

```
Kullanıcı        Joule                 Agent (CF)             AI Core      Veri
   │  soru         │                       │                     │           │
   │──────────────►│                       │                     │           │
   │               │ scenario eşleşti      │                     │           │
   │               │── message/send ──────►│                     │           │
   │               │                       │── LLM: plan yap ───►│           │
   │               │                       │◄────────────────────│           │
   │               │                       │── tool çağır ──────────────────►│
   │               │                       │◄────────────────────────────────│
   │               │                       │ eksik bilgi var mı?             │
   │               │◄─ input-required ─────│  (HITL: "Hangi bölge?")         │
   │◄── soru ──────│                       │                                 │
   │── cevap ─────►│── message/send ──────►│  (aynı contextId)               │
   │               │◄── completed + artifact│                                │
   │◄── sonuç ─────│                       │                                 │
```

---

## 5. Bilmen gerekenler (kısa liste)

Kodu birlikte yazacağız. Sen şunları anlatabilir olmalısın:

**Kavramlar**
- [ ] **A2A** agent'a iş devreder, **MCP** agent'a alet verir.
- [ ] **Joule** orkestra şefi, bizim agent uzman.
- [ ] **Agent Card:** agent'ın kartviziti, `/.well-known/agent-card.json`.
- [ ] **Task durumları:** `working` → `completed`. Ara durum `input-required`, yani agent kullanıcıya soru soruyor.
- [ ] **contextId:** çok turlu konuşmanın hafızası.

**BTP**
- [ ] **Subaccount:** projenin evi. **Entitlement:** o evde kullanabileceğin servislerin izni.
- [ ] **Cloud Foundry:** agent'ın çalıştığı yer, `cf push` ile koyulur.
- [ ] **Destination:** agent'ın adres defteri kaydı. Adı, YAML'daki `system_alias` ile birebir aynı olmalı.
- [ ] **AI Core:** LLM'e SAP içinden, yönetişimli erişim.

**Joule**
- [ ] **capability → scenario → function:** paket → tetikleyici → yapılacak iş.
- [ ] Function içindeki **`agent-request`** action'ı, A2A çağrısının kendisi.
- [ ] Üç kural: `namespace: joule.ext`, `schema_version >= 3.27.0`, 60 saniye limiti.

**Kimlik (sadece mantık)**
- [ ] **IAS:** SAP'nin kimlik servisi. Joule ile agent arasında **App2App trust** gerekir.
- [ ] **Principal propagation:** Agent, işi gerçek kullanıcının yetkisiyle yapar.
- [ ] Demoda NoAuthentication olabilir, gerçekte olmaz.

**Hackathon**
- [ ] İlk hedef **"Merhaba Joule"**: Boş agent Joule'den cevap veriyor. Önce bu, sonra özellikler.
- [ ] Hazır şablonlar: `SAP-samples/btp-joule-a2a-pro-code-agent`, `SAP-samples/joule-a2a-agent-toolkit` (Claude Code plugin'i).

---

## Kaynaklar

- SAP Architecture Center, Integrating AI Agents with Joule (Outbound A2A). https://architecture.learning.sap.com/docs/ref-arch/ae6821
- SAP Architecture Center, A2A and MCP for Interoperability. https://architecture.learning.sap.com/docs/ref-arch/76ec36
- Joule Development Guide, Bring Your Own Agent. https://help.sap.com/docs/joule/joule-development-guide-ba88d1ec6a1b442098863d577c19b0c0/code-based-agents-bring-your-own-agent
- GitHub: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent
- GitHub: https://github.com/SAP-samples/joule-a2a-agent-toolkit
- SAP Beyni: `ai/baglanti/custom-agent-joule-a2a-entegrasyonu.md`
