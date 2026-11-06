$ErrorActionPreference = 'Stop'
$Kit = Split-Path -Parent $PSScriptRoot
$Out = Join-Path $Kit 'BOOTSTRAP.md'

$Include = @(
    'CLAUDE.md'
    'CEP.md'
    'skills/hackathon/SKILL.md'
    'skills/kickoff/SKILL.md'
    'skills/gorevim/SKILL.md'
    'skills/takip/SKILL.md'
    'sablon/takim-kurulum-mesaji.md'
    'katalog/12-agent-tasarim-rehberi.md'
    'katalog/13-sorun-giderme.md'
    'egitim/13-takim-calismasi.md'
    'kurulum/kontrol.ps1'
)
$Include += Get-ChildItem (Join-Path $Kit 'sablon/proje') -Recurse -File -Force |
    ForEach-Object { [IO.Path]::GetRelativePath($Kit, $_.FullName).Replace('\', '/') }

$Header = @'
# BOOTSTRAP — sap-hackathon-kit without github.com

**Human:** paste this whole file into Claude Code on the VDI (or save it from your SAP mailbox and say "read BOOTSTRAP.md and follow it"). Nothing else is needed: no github.com, no install script.

## For Claude — do this, in order

Talk to the user in **Turkish** if they are Oktay (the captain); otherwise in their language. One status line per step.

1. **Write the files.** Below, every file sits between a line that **starts** with `<<<FILE ` (then the relative path, then `>>>`) and a line that is exactly `<<<END>>>`. Markers only count at the start of a line. Write each one, byte for byte, to `$HOME/sap-hackathon-kit/<relative/path>` (create folders). Do not summarise, reformat or translate them. Write them one by one with your file-writing tool; do not build one giant shell command.
2. **Install the skills.** Copy every folder under `$HOME/sap-hackathon-kit/skills/` into the user skill folder (`$CLAUDE_CONFIG_DIR/skills` if set, else `~/.claude/skills`). If that folder is not writable, copy them to `<team repo>/.claude/skills/` instead once a team repo exists — project skills work the same.
3. **Remember the kit path:** `[Environment]::SetEnvironmentVariable('SAP_HACKATHON_KIT', "$HOME\sap-hackathon-kit", 'User')` (skip silently if blocked).
4. **Check:** list what you wrote (file count must be FILE_COUNT_PLACEHOLDER). Then run `pwsh -File $HOME\sap-hackathon-kit\kurulum\kontrol.ps1` if scripts are allowed; summarise in one line, give the fix command for each failed item.
5. **What is missing:** this is the slim kit. `katalog/` (except 12 and 13), `egitim/` (except 13) and `beyin/` are NOT here. When a skill points to one of those files, say so in one line and continue with `CEP.md` and your own knowledge.
6. **Load the brain:** read `$HOME/sap-hackathon-kit/CLAUDE.md` and follow it from now on. Tell the user: new skills appear in a **new** session → `cd $HOME\sap-hackathon-kit; claude`.
7. **Next:** ask "Are you the captain?" Yes → `kickoff` skill (team repo on `github.tools.sap`; `kickoff` copies itself and `gorevim` into the team repo's `.claude/skills/`, so teammates need no kit). No → wait for the captain's team repo link.

Never write secrets into files. Ask before anything outward-facing (creating repos, inviting people, pushing).

---

'@

$sb = [Text.StringBuilder]::new()
[void]$sb.Append($Header.Replace('FILE_COUNT_PLACEHOLDER', [string]$Include.Count))
foreach ($rel in $Include) {
    $full = Join-Path $Kit $rel
    if (-not (Test-Path $full)) { throw "eksik: $rel" }
    $text = [IO.File]::ReadAllText($full).Replace("`r`n", "`n").TrimEnd("`n")
    if ($text.Contains('<<<FILE') -or $text.Contains('<<<END>>>')) { throw "ayirac cakismasi: $rel" }
    [void]$sb.Append("<<<FILE $rel>>>`n$text`n<<<END>>>`n`n")
}
[IO.File]::WriteAllText($Out, $sb.ToString(), [Text.UTF8Encoding]::new($false))
Write-Host ("BOOTSTRAP.md: {0} dosya, {1:N0} KB" -f $Include.Count, ((Get-Item $Out).Length / 1KB))
