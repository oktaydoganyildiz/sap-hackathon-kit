# Joule & Joule Studio

**Kritik ayrım:** Joule Studio'nun iki araç zinciri var.
- **Yeni Joule Studio:** `jl` CLI + Claude Code/OpenCode, "Intent-Based Development" (niyet → spec → kod → deploy). Node 24+. SAP Help: CLI adımları early-adopter, GA'da değişecek.
- **Classic edition:** `@sap/joule-cli` (`joule` / `sapdas` YAML capability). Lokal `joule-cli` skill'i bunu hedefler.

Hackathonda hangisi kullanılıyor, Pazartesi brifingte netleştir. Tahminimiz yeni yol; ikisine de hazırız.

## İki yol yan yana

| | **Yol A: Yeni Joule Studio (`jl`)** — öncelikli | **Yol B: Classic Joule + A2A** — yedek |
|---|---|---|
| CLI | `jl` = "Joule Work CLI" (`jl version`) | `joule` = "Joule Studio CLI Legacy" (`joule -V`) |
| Paket | **Aynı paket:** `npm install -g @sap/joule-studio-cli` ikisini birlikte kurar (Node 20.12–24). SAP'nin hazırlık PDF'indeki link de bu pakete gidiyor. | ← aynı |
| Claude Code bağlantısı | `jl init claude` → proje + IBD MCP server; `jl skills init claude` → SAP'nin sistem skill'leri | `SAP-archive/joule-a2a-agent-toolkit` plugin'i (Nisan 2026'dan beri güncellenmiyor) |
| Akış | Intent-Based Development: niyet → spec → kod → `jl solution` deploy | LangGraph agent → CF/MTA deploy → BTP destination → `joule deploy` capability (DAS YAML) |
| Parçalar | `jl asset`: `agent`, `agent-extension`, `cap-app`, `mcp-server`, `base-ui`, `domain-model-extension` | Agent uygulaması + capability YAML + destination |
| Test | `jl a2a card`, `jl a2a message "<metin>"` | `joule launch <assistant>`, a2a-inspector |
| Login | `jl login <url>` (AI Core instance'ı; oturum `~/.joulestudio/credentials.json`) | `joule login` (IAS App2App, `Cli2Joule` client) |
| Referans repo | `SAP-samples/teched2026-AD263` | `SAP-samples/btp-joule-a2a-pro-code-agent`, `SAP-samples/partner-reference-application-joule-a2a-agent-workshop` |

**Kurulum tuzağı:** Eski ayrı paket `@sap/joule-work-dev-cli-early-adopters` (eski `jl`) kuruluysa `@sap/joule-studio-cli` ile binary çakışır (`EEXIST ... bin/jl`). Çözüm: `npm uninstall -g @sap/joule-work-dev-cli-early-adopters` → `npm install -g @sap/joule-studio-cli --force`. Kontrol: `npm ls -g --depth=0`. Kaynak: https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/5270f042bdb2459fa2875e241ebae2e7.html

Yol A ilk dakika: `jl login` → `jl init claude` → `jl skills init claude` → `claude` aç, niyeti yaz.
Yol B ilk dakika: toolkit skill'leri kurulu → Claude'a "Joule için A2A agent kur" de → `cf deploy` → `joule deploy -c -n <ad>`.

| Link | Özet | Son push |
|---|---|---|
| https://help.sap.com/docs/joule-studio/joule-studio/pro-code-setup | Yeni Joule Studio pro-code kurulumu (`jl` CLI, Node 24+, Claude Code). | doküman |
| https://help.sap.com/docs/joule-studio/joule-studio/agents | Joule Studio'da agent kavramı ve oluşturma. | doküman |
| https://help.sap.com/docs/joule-studio/joule-studio/general-development-flow | Yeni Joule Studio geliştirme akışı. | doküman |
| https://help.sap.com/docs/joule-studio-classic/joule-studio-classic-edition/create-ai-capabilities | Classic: AI capability oluşturma. | doküman |
| https://help.sap.com/docs/joule/joule-development-guide-ba88d1ec6a1b442098863d577c19b0c0/joule-development | Joule Development Guide (capability, scenario, function). | doküman |
| https://developers.sap.com/tutorials/joule-studio-codejam-0-overview.html | Joule Studio CodeJam, adım adım tutorial serisi. | tutorial |
| https://github.com/SAP-samples/teched2026-AD263 | `jl` CLI + Claude Code ile tedarikçi aksaklığı agent'ı. **Hackathona en yakın akış.** | 2026-10-28 |
| https://github.com/SAP-samples/teched2026-AD161 | Joule Studio ve Joule Work'te agentic çözüm: kur, test et, deploy et, işlet (git promotion dahil). | 2026-11-05 |
| https://github.com/SAP-samples/teched2026-JW160 | Joule 101: prompting, agent, skill, deep reasoning. Isınma. | 2026-11-04 |
| https://github.com/SAP-samples/teched2026-JW260 | İlk Joule Skill'ini yaz. | 2026-10-29 |
| https://github.com/SAP-samples/teched2026-JW261 | Joule Work'te masaüstü→web cross-surface skill'ler. | 2026-11-04 |
| https://github.com/SAP-samples/teched2026-AD164 | Joule Studio içinde SAP-managed n8n ile agentic workflow. | 2026-11-04 |
| https://github.com/SAP-samples/btp-agentic-ai-use-cases | Sektörel agent örnekleri (low-code Joule Studio, Code Editor, Cloud SDK for AI). Klasör 20 = Joule→A2A. | 2026-10-28 |
| https://github.com/SAP-samples/lifecycle-operations-for-joule-studio | Joule Studio için git/CI deploy script'leri. | 2026-10-29 |
| https://github.com/SAP/lifecycle-operation-actions-for-joule-studio | Joule Studio deploy için GitHub Actions. | 2026-08-27 |
| https://github.com/SAP-samples/joule-studio-setup-terraform | Joule Studio subaccount'unu Terraform ile kur. | 2026-05-27 |
| https://github.com/SAP-samples/concur-joule-ips-jobs | Joule kullanıcılarını IPS ile provision etme (IAS kurulumu için faydalı). | 2026-08-20 |

İlgili kit dosyaları: `egitim/02-joule-ve-joule-studio.md`, `egitim/08-joule-cli-capability.md`, `beyin/ai/baglanti/joule-cli-login-sorunlari.md`, `beyin/dersler/2026-10-13-joule-studio-btp-cli-*`.
