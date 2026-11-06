# <PROJECT NAME> — team rules (every Claude reads this)

Hackathon: SAP Industry AI Hackathon, Munich, 9–12 Nov 2026. Path: <A: Joule Studio `jl` | B: own agent + A2A>.

## Language

- **Everything in this repo is English:** code, comments, identifiers, commit messages, branch names, issues, PRs, docs, slides. The code is handed to SAP and shown in the presentation.
- **Talk to each person in their chat language** (table below). Explanations, questions and summaries in that language; anything written into the repo stays English.

## Team and ownership

| Person | Chat language | GitHub | Role | Owns (folders / files) |
|---|---|---|---|---|
| <Oktay> | Türkçe | @<user> | <captain> | `CLAUDE.md`, `docs/contract.md`, `docs/spec.md`, `docs/DURUM.md` |
| <name> | Deutsch | @<user> | <agent> | `<agent/>` |
| <name> | <lang> | @<user> | <data + tools> | `<mcp-server/>` |
| <name> | <lang> | @<user> | <platform> | `<deploy/>`, solution manifest / `mta.yaml`, `package.json`, `.env.example` |

Roles stay flexible: the captain can move a task to another person at any time (reassign the issue).

## Workflow

1. Start: `git pull --rebase origin main` → `gh issue list --assignee @me`.
2. Write **only** inside folders you own. Need a change elsewhere? Open an issue, assign the owner, stop.
3. The agent ↔ tool interface lives in `docs/contract.md`. Do not change it; mock against it until the real side exists. Changes go through the captain.
4. Branch `<name>/<issue>-<short-name>` (`<name>` = your lowercase first name from the table above), push at least every 1–2 hours, PR body `Closes #<issue>`.
5. **Merging:** if the PR touches only your own folders and it runs, merge it yourself (`gh pr merge --squash`). PRs touching shared files, `docs/contract.md` or someone else's folder need the captain's approval. After the Wednesday 18:00 freeze only the captain merges.
6. Blocked? Comment `Blocked: <reason>` on the issue and add the `blocked` label.
7. **Issues can be reassigned.** The captain may move any issue to another person at any time. Before starting, at the start of every session and before every push or PR, re-check the issue (`gh issue view <no> --json assignees,labels`). If the assignee or the `kisi:<name>` label is no longer you: stop, do not push or open a PR, comment `Reassigned, stopping my work on this` with your branch name, tell the user, and pick your next issue. Never take an issue back without asking the captain.
8. Never commit secrets, tokens, passwords or customer data.

## Milestones

- **Mon evening — integration skeleton:** mock agent deployed and called once end to end (Joule → agent → mock tool → answer). Owner: platform + captain.
- Tue 12:00 — real agent replaces the mock, same path still works.
- Tue 17:00 — real data via read-only tools.
- Wed 12:00 — exception path + HITL + eval set.
- **Wed 18:00 — feature freeze**, backup demo video recorded.
- Thu — rehearsal, presentation.

Integration is a task, not a side effect: there is always one open `integration` issue owned by the captain or platform person.

## Pointers

- Spec: `docs/spec.md` · Contract: `docs/contract.md` · Status: `docs/DURUM.md` · Start guide: `BASLA.md`
- Kit (links, guides): `$SAP_HACKATHON_KIT` → `katalog/00-index.md`
