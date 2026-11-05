# Hackathon Eğitimi: Yol Haritası

Varsayım: hackathonda, istediğimiz bir alanda **bir AI agent yazıp Joule'ye bağlayacağız** ve BTP üzerinde çalıştıracağız. Checklist'teki araçlar da bunu gösteriyor: `joule`, `btp`, `cf`, `kubectl`, Python, Claude Code.

Her başlık ayrı bir dosya. Sıra, birbirinin üstüne kurulacak şekilde ayarlandı.

| # | Dosya | Konu | Neden lazım |
|---|---|---|---|
| 01 | `01-a2a.md` | A2A protokolü ve SAP'deki A2A mimarisi | Agent'ımızı Joule'ye bağlayan "dil" bu |
| 02 | `02-joule-ve-joule-studio.md` | Joule, Joule Studio, low-code agent ve skill | Pro-code mu low-code mu kararını verdirir |
| 03 | `03-btp-temelleri.md` | Global account, subaccount, entitlement, CF ve Kyma, destination | Agent'ı nereye ve nasıl koyacağız |
| 04 | `04-kimlik-ias.md` | IAS, App2App trust, token exchange, principal propagation | En çok burada takılınıyor |
| 05 | `05-ai-core-genai-hub.md` | AI Core, Generative AI Hub, orchestration, Cloud SDK for AI | Agent'ın LLM'e SAP içinden erişimi |
| 06 | `06-mcp-ve-mcp-gateway.md` | MCP, Integration Suite MCP Gateway | Agent'ın SAP verisine/API'sine erişimi |
| 07 | `07-pro-code-agent.md` | LangGraph + a2a-sdk (Python) veya CAP (TS) ile agent yazma ve CF'ye deploy | Hackathonda yazacağımız asıl kod |
| 08 | `08-joule-cli-capability.md` | `joule` CLI, capability, scenario, function YAML'ları, `agent-request` | Agent'ı Joule'ye kaydetme |
| 09 | `09-agent-gateway-inbound.md` | Agent Gateway: dışarıdan Joule agent'larını çağırmak | Ters yön, bilmekte fayda var |
| 10 | `10-hackathon-stratejisi.md` | Senaryo fikirleri, 4 günlük plan, demo ve sunum | Kazanmak için |
| 11 | `11-hackathon-arastirma.md` | Etkinlik, organizatörler, SAP'nin Industry AI yönü, geçmiş jüri kriterleri | Ne beklemeli |

| 12 | `12-a2a-joule-agent-yol-haritasi.md` | A2A ile Joule'ye bağlı agent kurma: şemalar + bilmen gerekenler | **Önce bunu oku**, özet |

**Durum (2026-11-04):** Hepsi yazıldı. Okuma sırası: 12 → 11 → 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10.
