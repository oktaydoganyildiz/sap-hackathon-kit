# Joule Studio örnek export'ları

> **Referans, kalıp değil.** Bunlar SAP Joule Studio'nun bir demo tenant'ta ürettiği örnek çıktılar. Hackathon agent'ımızın konusunu, kapsamını, mimarisini ya da araç seçimini **bağlamaz**. Planlamaya buradan başlanmaz (`kickoff` buraya atıf yapmaz). Kod parçası lazımsa kopyala, gerisini yok say. Daha gelişmiş ya da tamamen farklı bir yol seçmek serbest.

Analiz, kaynakla doğrulanmış iyi/kötü yanlar: `egitim/14-joule-studio-ornek-agent-incelemesi.md`. **Önce onu oku**: buradaki kodun bilinen hataları var (örn. prompt'taki tool adları gerçek tool adlarıyla eşleşmiyor).

| Klasör | Ne |
|---|---|
| `Customer Billing Information Agent/` | Pro-code Python A2A agent (LangGraph + LiteLLM + sap-cloud-sdk) + 2 MCP server asset'i (S/4 OData → `translation.json`). Şirket adı kurgusal. |
| `Financial Closing Assistant Agent Extend/` | Agent extension: SAP'nin Financial Closing Assistant'ına sadece instruction ekliyor (`extension.yaml`). |

## İşe yarar dosyalar (Yol B'de kopyalanabilir)

- `assets/customer-billing-review-agent/app/mcp_providers/agw.py`: Agent Gateway'den tool çekme + `IBD_TESTING=1` mock modu
- `app/prompt_injection_detector.py`: tool sonuçlarını injection'a karşı tarayan sarmalayıcı (`wrap_tool`)
- `app/util.py`: tool sonucunu sıkıştırma ve kesme (`MCP_MAX_RESPONSE_CHARS`)
- `app/load_skill_resources.py` + `app/skills/`: runtime skill'leri, `load(path)` tool'u
- `app/main.py`: A2A server, agent card, JWT middleware
- `mcp-mock.json`: mock tool tanımı ve örnek veri formatı
- `intent.md`: fit-gap tablosu (sunum için iyi bir şablon)

## Kite alınmayanlar

SAP'nin IBD kılavuz dosyaları (`specification/guidelines-*.md`, SAP içeriği), coverage/test raporları ve tenant `.build` ID'si. Tam export Oktay'ın laptopunda duruyor.
