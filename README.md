# sap-hackathon-kit

Private prep kit for the SAP Industry AI Hackathon (Munich, 9–12 Nov 2026): curated links, training notes and a Claude Code router skill for Joule Studio, A2A, SAP AI Core / Generative AI Hub, CAP + AI, MCP and BTP.

## For Claude — if you were asked to "install this kit" from this link

Talk to the user in **Turkish** if they are Oktay (the captain); otherwise in their language. Do these steps in order, telling the user one line per step:

1. **Access:** `gh auth status --hostname github.com`. Not logged in → give the user `gh auth login --hostname github.com` to run (browser login), wait, re-check.
2. **Clone:** `git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit` (already there → `git -C $HOME\sap-hackathon-kit pull`).
3. **Install:** `pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1` (Mac/Linux: `bash kurulum/install.sh`). It copies skills to `~/.claude/skills`, installs process/SAP skills and ends with an environment check. Summarise the check in one line; for each `[--]`/`[!!]` give the fix command.
4. **Load the brain:** read `$HOME\sap-hackathon-kit\CLAUDE.md` and follow it from now on. Skills installed in step 3 become available in a **new** Claude session in the kit folder — tell the user: `cd $HOME\sap-hackathon-kit; claude` and continue there (or read `skills/kickoff/SKILL.md` directly and continue in this session).
5. **Next:** ask "Are you the captain?" If yes → run the **early setup** (`kickoff` skill, section "Faz E — Erken iskelet"): team repo skeleton + teammate invitations + a ready setup message per teammate. If no → tell them to wait for the captain's team repo link.

Never write secrets into files. Ask before anything outward-facing (creating repos, inviting people, pushing).

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

## Other coding agents (opencode etc.)

Rehearsal result (2026-11-06): opencode 1.2.26 picked up the repo's `.claude/skills/` (`gorevim`, `kickoff`, `takip`, `hackathon`) and followed `CLAUDE.md` / `BASLA.md`. Notes:
- Start the agent **inside the team repo folder**, otherwise skills and rules are not found.
- opencode also loads the user's global `~/.claude/skills`; extra skills can distract a free/small model.
- The template ships `AGENTS.md` (points to `CLAUDE.md`) for agents that look for that file first.
- Free models may drift on the language rule or ownership rule: re-check after the first PR.
- Several people on one GitHub account (rehearsal only): `gorevim` asks "which person are you?" and stores the answer in `.claude/ben.md` (git-ignored).
