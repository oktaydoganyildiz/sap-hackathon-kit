# Template — kit setup message for teammates (captain sends)

Claude fills this in **after the captain has installed the kit**, in each teammate's chat language (Deutsch / Türkçe / English). Pick variant A or B with:
`GH_HOST=github.com gh repo view oktaydoganyildiz/sap-hackathon-kit --json visibility --jq .visibility`

---

## Variant A — kit is PRIVATE (send after inviting them)

Hi <name>, please set up our hackathon kit in your VDI (≈10 min):

1. Accept the GitHub invitation for `oktaydoganyildiz/sap-hackathon-kit` (email from GitHub, or https://github.com/oktaydoganyildiz/sap-hackathon-kit/invitations).
2. In PowerShell:
   ```
   gh auth login --hostname github.com
   git clone https://github.com/oktaydoganyildiz/sap-hackathon-kit.git $HOME\sap-hackathon-kit
   pwsh -File $HOME\sap-hackathon-kit\kurulum\install.ps1
   ```
3. The script ends with an environment check. Anything marked `[--]` or `[!!]`: fix it with the hint shown, or tell me.
4. Also log in to SAP's GitHub: `gh auth login --hostname github.tools.sap`
5. Done. You don't need to start anything yet — on Monday I'll send you the team repo and your first task. Then: open the repo, run `claude`, say "I'm joining the team, what's my task?" (in your language).

If github.com doesn't open in the VDI: skip 1–3, only do 4 and tell me.

## Variant B — kit is PUBLIC

Same as A, without step 1 and without `gh auth login --hostname github.com`.

---

## What Claude does around this message

- Before inviting: ask the captain for the teammates' github.com usernames, show the list, get approval, then per user:
  `GH_HOST=github.com gh api -X PUT repos/oktaydoganyildiz/sap-hackathon-kit/collaborators/<user> -f permission=pull`
- Before making the kit public (captain asks): list what is inside (`katalog/`, `egitim/`, `beyin/` = the captain's personal SAP notes, `NOTLAR.md`, `skills/`), run a secrets scan (emails, S/P-user IDs, tokens), show the result and wait for an explicit "yes". Then:
  `GH_HOST=github.com gh repo edit oktaydoganyildiz/sap-hackathon-kit --visibility public --accept-visibility-change-consequences`
  Making a repo public is effectively irreversible (forks/caches) — say so.
- After sending: tell the captain who has confirmed setup and who hasn't (ask them to report).
