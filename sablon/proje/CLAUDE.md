# <PROJE ADI> — team rules (every Claude reads this)

Hackathon: SAP Industry AI Hackathon, Munich, 9–12 Nov 2026. Path: <Yol A: Joule Studio `jl` | Yol B: own agent + A2A>.
Language for issues, commits, code comments: <English | Türkçe>.

## Ownership

| Folder / file | Owner | GitHub |
|---|---|---|
| `<agent/>` | <name> | @<user> |
| `<agent/eval/>` | <name> | @<user> |
| `<mcp-server/>` | <name> | @<user> |
| `<deploy/>`, solution manifest / `mta.yaml`, `package.json`, `.env.example` | <platform> | @<user> |
| `CLAUDE.md`, `docs/contract.md`, `docs/spec.md` | <captain> | @<user> |

## Workflow

1. Start: `git pull --rebase origin main` → `gh issue list --assignee @me`.
2. Write **only** inside folders you own. Need a change elsewhere? Open an issue, assign the owner, stop.
3. The agent ↔ tool interface lives in `docs/contract.md`. Do not change it; mock against it until the real side exists. Changes go through the captain.
4. Branch `<user>/<issue>-<short-name>`, small PRs, body `Closes #<issue>`. Don't merge your own PR; after Wednesday evening freeze only the captain merges.
5. Never commit secrets, tokens, passwords or customer data.

## Milestones

- Tue 12:00 — "Hello Joule": empty agent called from Joule, answers end to end.
- Tue 17:00 — real data via read-only tools.
- Wed 12:00 — exception path + HITL + eval set.
- Wed 18:00 — **feature freeze**, backup demo video recorded.
- Thu — rehearsal, presentation.

## Pointers

- Spec: `docs/spec.md` · Contract: `docs/contract.md`
- Kit (links, guides): `$SAP_HACKATHON_KIT` → `katalog/00-index.md`
