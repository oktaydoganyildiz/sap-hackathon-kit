# sap-hackathon-kit

Private prep kit for the SAP Industry AI Hackathon (Munich, 9–12 Nov 2026): curated links, training notes and a Claude Code router skill for Joule Studio, A2A, SAP AI Core / Generative AI Hub, CAP + AI, MCP and BTP.

## Use on a new machine (e.g. VDI)

```powershell
git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
cd $HOME\sap-hackathon-kit
pwsh -File kurulum\install.ps1
```

```bash
git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git ~/sap-hackathon-kit
cd ~/sap-hackathon-kit && bash kurulum/install.sh
```

The script copies the `hackathon` skill into `~/.claude/skills`, pulls the skills from `SAP-archive/joule-a2a-agent-toolkit`, and adds the official SAP plugin marketplaces. Every step is optional and keeps going on failure.

Then start `claude` inside the repo folder. `CLAUDE.md` and the `hackathon` skill take over from there.

## Team flow

- **Captain:** in this kit folder say *"projeye başlıyoruz, konumuz …"* → the `kickoff` skill interviews (team size, members, GitHub users, Joule path, repo), proposes 2–3 approaches, writes spec + tool contract, assigns folder ownership, creates the GitHub repo from `sablon/proje/` and one assigned issue per task.
- **Everyone else:** install the kit (above), then clone the project repo, run `claude`, say *"I'm joining the team, what's my task?"* (any language) → the `gorevim` skill picks your issue, keeps you inside your folders and opens a PR with `Closes #n`. The kit's catalogue, troubleshooting card and SAP skills are available to you too.

**Order:** the captain installs first, then opens `claude` in the kit and says *"kiti kurdum, arkadaşlarıma ne göndereyim?"* — Claude produces a ready setup message per teammate (their language), inviting them if the kit is private (`sablon/takim-kurulum-mesaji.md`).

**Everyone installs the kit** (teammates are added as read collaborators). Only the captain runs `kickoff` and full `takip`; both skills check the captain in the team repo's `CLAUDE.md` and hand over to `gorevim` for everyone else.

**If github.com is blocked in the VDI:** the team repo still works — `kickoff` copies `gorevim`, the environment check and the troubleshooting card into the repo's `.claude/`. If even the captain can't get the kit, use `CEP.md` (one-page pocket card, read on phone or print).

## Layout

| Path | Content |
|---|---|
| `katalog/` | Topic link catalogue with short Turkish summaries |
| `egitim/` | 13 training notes |
| `beyin/` | Curated notes from the personal SAP knowledge base |
| `NOTLAR.md` | Event info, prerequisites, open questions |
| `skills/` | `hackathon` (router), `kickoff` (team lead), `gorevim` (member) |
| `sablon/proje/` | Project repo template: ownership CLAUDE.md, spec, contract, CODEOWNERS, PR/issue templates |
| `kurulum/` | Install scripts |

No credentials, user IDs or SAP-internal documents are stored here. Pull only; don't push from SAP environments.
