# Claude Code / agent skill repoları

Kurulum komutları `kurulum/install.ps1` ve `install.sh` içinde. Elle kurmak istersen aşağıdaki komutlar.

| Repo | Ne verir | Kurulum |
|---|---|---|
| `jl` CLI (yeni Joule Studio, Yol A) | SAP'nin resmi Joule Studio skill'leri ve IBD MCP server bağlantısı. **Önce bu.** | proje klasöründe `jl login <url>` → `jl init claude` → `jl skills init claude` |
| https://github.com/SAP-archive/joule-a2a-agent-toolkit | Yol B (classic): `joule-a2a-agent`, `joule-cli`, `btp-cli`, `cf-cli` skill'leri. Güncellenmiyor. | clone + `skills/*` → `~/.claude/skills/` |
| https://github.com/SAP-samples/partner-reference-application-joule-a2a-agent-workshop | Yol B: workshop'un kendi `setup-dev-environment` skill'i. | repo içinde `claude` aç, `.claude/skills` otomatik yüklenir |
| https://github.com/SAP/ai-skills-library | SAP resmi skill kütüphanesi: `aicore-skills` (orchestration, foundation models, prompt evaluation, admin), `aicore-sdk-js/java`, Fiori. Registry: https://skills.cloud.sap | `claude plugin marketplace add SAP/ai-skills-library` → `claude plugin install aicore-skills@ai-skills-library` · alternatif `npx skills add SAP/ai-skills-library` |
| https://github.com/capire/skills | Resmi CAP skill'i `cap-developer`. | `claude plugin marketplace add capire/skills` → `claude plugin install cap-developer@cap` |
| https://github.com/SAP/ai-native-architecture-advisor | İş probleminden AI çözüm mimarisi tasarlar. **Fikir aşamasında kullan.** | `claude plugin marketplace add SAP/ai-native-architecture-advisor` → `claude plugin install ai-native-architecture-advisor@sap-ai-native-architecture-advisor` |
| https://github.com/secondsky/sap-skills | Topluluk: BTP, CAP, Fiori, ABAP, HANA, AI Core plugin'leri. | `claude plugin marketplace add secondsky/sap-skills` → ör. `claude plugin install sap-ai-core@sap-skills` |
| https://github.com/SAP/automation-pilot-agent-skills | Automation Pilot skill'leri. | marketplace add |
| https://github.com/SAP-samples/hana-cli-claude-plugin | hana-cli Claude plugin'i. | marketplace add |
| https://github.com/UI5/plugins-coding-agents | UI5 coding agent plugin'leri. | marketplace add |
| https://github.com/marianfoo/sap-ai-mcp-servers | Tüm SAP MCP + skill'lerin güncel listesi. | liste |

Plugin adları değişebilir. Komut hata verirse önce `claude plugin marketplace list` ile marketplace'in adını kontrol et.
