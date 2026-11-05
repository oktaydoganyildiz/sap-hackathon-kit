# Template — setup message for teammates (captain sends)

Claude fills this in during **Faz E (early skeleton)**, after the captain installed the kit and the team repo skeleton exists. Write it in each teammate's chat language (Deutsch / Türkçe / English); commands stay as they are. Check kit visibility first:
`GH_HOST=github.com gh repo view oktaydoganyildiz/sap-hackathon-kit --json visibility --jq .visibility`

---

Hi <name>, please get ready for the hackathon in your VDI (≈10 min). You don't need to build anything yet.

1. Accept the two GitHub invitations: our team repo `<org>/<team-repo>` on github.tools.sap and the kit `oktaydoganyildiz/sap-hackathon-kit` on github.com. *(Skip the kit invitation if the kit is public.)*
2. In PowerShell:
   ```
   # kit (skip this block if github.com is blocked in the VDI)
   gh auth login --hostname github.com
   git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
   pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1

   # team repo
   gh auth login --hostname github.tools.sap
   $env:GH_HOST='github.tools.sap'
   git clone <team-repo-url> $HOME\<team-repo>
   cd $HOME\<team-repo>
   pwsh -File .claude\tools\kontrol.ps1
   ```
3. Fix anything marked `[--]` / `[!!]` (the hint is shown), then reply "setup ready" in our group.
4. Wait for my message after the briefing. Then: `git pull` → `claude` → "I'm joining the team, what's my task?" (in your language). Claude will talk to you in <language>; everything written into the repo is English.

---

## What Claude does around this message

- Before inviting: show the list of usernames (team repo: write; kit: read), get approval, then
  - team repo: `GH_HOST=github.tools.sap gh api -X PUT repos/<org>/<team-repo>/collaborators/<user> -f permission=push`
  - kit: `GH_HOST=github.com gh api -X PUT repos/oktaydoganyildiz/sap-hackathon-kit/collaborators/<user> -f permission=pull`
- Before making the kit public (only if the captain asks): list what's inside (`katalog/`, `egitim/`, `beyin/` = the captain's personal SAP notes, `NOTLAR.md`, `skills/`), run a secrets scan (emails, S/P-user IDs, tokens), wait for an explicit "yes". Then `GH_HOST=github.com gh repo edit oktaydoganyildiz/sap-hackathon-kit --visibility public --accept-visibility-change-consequences`. Say clearly: going public is effectively irreversible (forks, caches).
- After sending: track who replied "setup ready" in `docs/DURUM.md` and remind the captain about the rest.
