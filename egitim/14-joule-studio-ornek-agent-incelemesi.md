# Joule Studio örnek agent incelemesi

2026-11-06. Oktay'ın Joule Studio'dan export ettiği iki solution incelendi. Her ders internetteki resmi kaynakla karşılaştırıldı.

> **Bu bir referans örnek, kalıp değil.** SAP'nin ürettiği demo çıktılar bunlar. Bizim agent'ın konusunu, kapsamını, mimarisini ya da araç seçimini sınırlamaz. Buradan sadece iki şey alıyoruz: (1) SAP'nin araçları içeride nasıl çalışıyor, (2) neler iyi, nerelerde tuzak var. Hackathonda daha büyük, farklı ya da bambaşka bir yol seçmekte serbestiz (Yol A / Yol B, kendi MCP'miz, CAP, çoklu agent, fark etmez).

Dosyalar kitte: `ornekler/joule-studio-export/` (kod, YAML, mock, intent/PRD; SAP'nin IBD kılavuz dosyaları hariç).

## 1. Ne var

| Solution | Tür | Kod var mı | A2A | MCP |
|---|---|---|---|---|
| Customer Billing Review Agent | `agent` (pro-code, Python) + 2 `mcp-server` asset'i | Evet, ~1.350 satır + 150 test | Evet, agent bir A2A server | Evet, Agent Gateway üzerinden 2 S/4 API'si |
| Financial Closing Escalation Extension | `agent-extension` | Hayır, sadece `extension.yaml` | Yok | Yok (flag kapalı) |

## 2. Billing agent nasıl çalışıyor

```
Joule / A2A istemcisi
   │  JSON-RPC  message/send  +  Authorization: Bearer <kullanıcı JWT>
   ▼
Agent (Starlette + a2a-sdk 0.3, port 5000, agent card /.well-known/...)
   │  JWT middleware → token'ı isteğe bağlı bağlam değişkenine koyar
   │  LangGraph create_agent  →  LiteLLM  →  AI Core (sap/anthropic--claude-4.5-sonnet)
   ▼
Agent Gateway (sap_cloud_sdk.agentgateway)  ← her istekte list_mcp_tools(user_token)
   │  principal propagation (kullanıcı adına)
   ▼
MCP server = translation.json (OData → MCP tool eşlemesi, SAP çalıştırır)
   ▼
S/4HANA OData API (CE_BILLINGDOCUMENT_0001, API_CABUSPARTPAYMENT_0002)
```

Dosya iskeleti: `solution.yaml` → `assets/<ad>/asset.yaml`. Agent'ın `asset.yaml`'ı `provides: kind: a2a`, MCP'leri de `requires: kind: mcp-server` + ORD ID ile bağlar.

## 3. Doğrulanmış dersler

| # | Ders | Kaynak | Durum |
|---|---|---|---|
| 1 | Joule Studio'nun MCP server'ı çalışan bir program değil, bir tarif dosyası (`translation.json`). Çağrıyı Agent Gateway yapar. Kuracak, çalıştıracak bir şey yok. | [SAP Help: MCP Servers](https://help.sap.com/docs/JOULESTUDIO/7e496fe6f81f4975aec07d9c1cbd2aef/f784ab604a2243f69819a245a10ed34c.html) | ✅ |
| 2 | Backend'e bağlanmanın tek yolu principal propagation. Şartlar: agent ile backend arasında bir formation + SPII açık olmalı. API key veya saklanmış şifre henüz yok. | aynı sayfa | ✅ |
| 3 | Şu an sadece SAP API'leri için MCP üretiliyor (Path A). Harici API veya harici MCP server sonraki sürümde (Path B). | aynı sayfa | ✅ (Joule Studio tarafı için; Yol B'de kendi MCP'mizi yazmak serbest) |
| 4 | Joule Studio API'nin tamamını değil, sadece gereken işlemleri tool yapar. Export'ta `.tool-list.json` tam katalog (update/delete dahil, ~70 tool); deploy edilen `translation.json` salt okunur alt küme (17 + 6 tool). | aynı sayfa + export | ✅ |
| 5 | Tool listesi her istekte, kullanıcının token'ıyla çekilir. Token sabit bir string değil, her çağrıda yeniden okunan bir fonksiyon (callable) olmalı; şablon bunu doğru yapıyor. | [Cloud SDK Python: Troubleshooting](https://github.com/SAP/cloud-sdk/blob/main/docs-python/troubleshooting.mdx) | ✅ |
| 6 | SDK'nın bilinen sorunları: tool sonucu düz metne çevriliyor (#214, gerekirse `json.loads`), iki MCP'de aynı tool adı varsa yanlış tool çağrılabiliyor (#208, çare `MCPToolFilter(ord_ids=[...])`), hata loglarında correlation ID eksik (#195). | aynı sayfa | ✅ |
| 7 | Ham OData tool'ları semantik zenginleştirme olmadan kullanılırsa doğruluk düşer, token tüketimi artar. SAP'nin ürettiği MCP'ler bu zenginleştirmeyi yapıyor. MCP spec'inde geriye uyumsuz bir sürüm (RC, 2026-07-28) yolda. | [Ref-arch 137800](https://architecture.learning.sap.com/docs/ref-arch/137800) | ✅ |
| 8 | A2A 0.3'ten beri agent card'ın standart yolu `/.well-known/agent-card.json`. Şablonun sağlık kontrolleri eski `agent.json` yolunu, testleri yeni yolu kullanıyor. a2a-sdk 0.3 şimdilik ikisini de sunuyor. A2A v1.0 da çıktı. | [AAIF: A2A v1.0 migration](https://aaif.io/blog/a2a-v1-0-a-builder-s-guide-part-2-migration-security-and-production), [Atlan A2A guide](https://atlan.com/know/mcp/a2a-protocol-implementation-guide/) | ⚠️ Joule'un hangi A2A sürümünü beklediği doğrulanmadı |
| 9 | Regex ile prompt injection taraması sadece ilk savunma hattı. Dolaylı injection (tool sonucunun içine gömülen talimat) regex'i kolayca atlatır; katmanlı savunma gerekir. | [OWASP LLM Prompt Injection Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/LLM_Prompt_Injection_Prevention_Cheat_Sheet.html), [OpenRouter guardrails](https://openrouter.ai/docs/guides/features/guardrails/prompt-injection) | ✅ |
| 10 | Agent Extension'da sadece Instructions çalışıyor; Tools (MCP) ve Hooks (n8n) feature flag arkasında. Örnekteki intent "Before Hook" kullanacağını söylüyor ama çıktıda hook yok. | export'taki `guidelines-agent-extension.md` + `NOTLAR.md` 2026-11-05 | ✅ |
| 11 | Joule Studio'nun 6 fazı (intent → PRD → spec → kod → test → deploy) ve Pro-Code akışı (`jl` + Claude Code + IBD skill'leri MCP üzerinden). | [Ref-arch 219c07](https://architecture.learning.sap.com/docs/ref-arch/219c07) | ✅ |

## 4. İyi yanlar: alınabilecek desenler

- **Mock modu:** `IBD_TESTING=1` açılınca tool'lar `mcp-mock.json`'dan cevap döner, hiç ağ çağrısı yapılmaz. Sistem erişimi gelmeden demo ve test için ideal.
- **Runtime skill'leri:** `app/skills/<ad>/SKILL.md` + `load(path)` tool'u. Uzun süreç talimatları system prompt'a gömülmüyor, gerektiğinde yükleniyor.
- **Tool sonucu koruması:** JSON sıkıştırılıyor, 30.000 karakteri geçen sonuç kesiliyor (`MCP_MAX_RESPONSE_CHARS`). Her tool sonucu injection taramasından geçiyor (`wrap_tool`).
- **Maliyet:** Sabit kısım (system prompt + tool şemaları) prompt cache'te tutuluyor. Geçmiş 100.000 token'ı geçince daha ucuz bir modelle (Haiku) özetleniyor.
- **Kullanıcı bazlı hafıza:** Sohbet anahtarı `JWT sub:contextId`, kullanıcıların sohbetleri karışmıyor. Agent Memory Service checkpointer'ı kullanılıyor.
- **İş metrikleri logda:** `M1.achieved` / `M1.missed` gibi milestone log'ları var. Demoda "agent şu adımı başardı" diye gösterilebilir.
- **Ayarlar arayüzden değişiyor:** `@agent_model`, `@agent_config`, `@prompt_section` dekoratörleri (`sap_cloud_sdk.agent_decorators`). Model, sıcaklık ve prompt büyük ihtimalle kodu değiştirmeden ayarlanabiliyor (doğrulanmadı).
- **Test disiplini:** 150 test, hepsi geçmiş. Coverage hedefi ≥%70, testler tamamen offline çalışıyor.
- **Planlama dokümanları:** `intent.md`'deki fit-gap tablosu (ihtiyaç → hazır asset → API/MCP ORD ID → boşluk var mı) sunumda "neden bu çözüm" sorusunu cevaplıyor.

## 5. Kötü yanlar ve tuzaklar

- **Talimatta olmayan tool adları:** System prompt ve skill dosyası `get_customer_billing_information` ile `get_contract_payment_terms` adlarını kullanıyor. Gerçek tool'lar ise `list_billingdocument_for_sap_self`, `GET_ContrAcctgBusPartnerPayment` gibi adlar taşıyor. Üstelik SAP'nin kendi kılavuzu "tool adını koda gömme" diyor. Mock testleri bu uyumsuzluğu yakalamıyor. **Ders:** talimatta tool'u adıyla değil yeteneğiyle tarif et, en az bir kez gerçek Gateway'e karşı dene.
- **`batch_for_sap_self` yazma işaretli** (`readOnlyHint: false`). OData `$batch` isteği içinde yazma işlemi de taşınabilir mi, doğrulanmadı. Gerek yoksa bu tool'u kaldır.
- **"Salt okunur" kuralını sadece talimat ve tool alt kümesi koruyor.** Bu yeterli bir başlangıç. Yazan bir agent'ta ise insan onayı şart ([SAP: require user confirmation](https://help.sap.com/docs/Joule_Studio_classic/45f9d2b8914b4f0ba731570ff9a85313/e1d5bd4898654a09b82f991755108bd1.html)).
- **Ham OData tool'ları:** Billing tarafında 17 genel amaçlı tool var. Bu kadar çok tool LLM'in yanlış tool seçmesine ve fazla token harcamasına yol açar (bkz. ders 7, SAP'nin "restrict the toolset" kuralı). Kendi MCP'mizi yazarsak iş odaklı birkaç tool daha iyi sonuç verir.
- **Gerçek streaming yok:** Önce "Processing..." gidiyor, sonra cevabın tamamı tek parça geliyor.
- **Görevler bellekte tutuluyor** (`InMemoryTaskStore`): agent yeniden başlarsa görevler kaybolur. İptal desteği de yok.
- **JWT imzası doğrulanmıyor:** `sub` alanı imza kontrolü yapılmadan okunuyor, çünkü SAP'nin managed runtime'ı token'ı önceden doğruluyor. Kendi subaccount'umuzda (Yol B) aynısını yaparsak güvenlik açığı olur.
- **Paket sürümleri:** Sürümler sabitlenmiş (a2a-sdk 0.3.22, langchain 1.3, litellm 1.91) ve Python 3.11+ gerekiyor. SDK yükseltmesi bağımlılık çakışması çıkarabilir (`pip check`).

## 6. Bizim için ne anlama geliyor (seçenek, kısıt değil)

- **Joule Studio'yu (Yol A) seçersek:** Bu iskelet otomatik üretilir. Asıl emeği talimata, skill'lere, mock veriye ve demo senaryosuna harcarız. Yukarıdaki tuzak listesini review'da kontrol listesi olarak kullanırız.
- **Kendi subaccount'umuzda (Yol B) yaparsak:** Aynı kütüphaneler (a2a-sdk, LangGraph, LiteLLM, sap-cloud-sdk) çalışır. Mock modu, tool sonucu kesme ve injection sarmalayıcı desenleri kopyalanabilir. Kimlik doğrulama ve JWT kontrolü ise bizim sorumluluğumuzda.
- **Fark yaratabileceğimiz yerler:** Örnek tek agent, tek tur, salt okunur ve rapor üreten bir agent. Biz insan onaylı yazma, çoklu agent (A2A ile birbirine iş devreden), Datasphere/BDC verisi ya da eval ile ölçülmüş doğruluk ekleyerek ondan daha ileri gidebiliriz.
- **Extension yolu:** Tek başına zayıf bir demo. Ancak ana agent'ın yanında bir "SAP agent'ını da genişlettik" bonusu olarak işe yarar.
