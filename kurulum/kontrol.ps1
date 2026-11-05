param([switch]$Json)
$ErrorActionPreference = 'Continue'

function Run([string]$Cmd) {
    try {
        $out = Invoke-Expression "$Cmd 2>&1" | Out-String
        return @{ ok = ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE); out = $out.Trim() }
    } catch { return @{ ok = $false; out = $_.Exception.Message } }
}

function FirstLine([string]$s) { ($s -split "`n" | Where-Object { $_ -match '\S' } | Select-Object -First 1) -replace '\s+', ' ' }

$checks = @(
    @{ Grup = 'Developer'; Ad = 'git';            Cmd = 'git --version';                                  Fix = 'https://git-scm.com/install/' }
    @{ Grup = 'Developer'; Ad = 'gh';             Cmd = 'gh --version';                                   Fix = 'https://cli.github.com/' }
    @{ Grup = 'Developer'; Ad = 'gh -> github.tools.sap'; Cmd = 'gh auth status --hostname github.tools.sap'; Fix = 'gh auth login --hostname github.tools.sap' ; Opt = $true }
    @{ Grup = 'AI';        Ad = 'hai (Hyperspace)'; Cmd = 'hai --version';                                Fix = 'Hyperspace hai CLI Quickstart (SAP ic agi / VPN)' }
    @{ Grup = 'AI';        Ad = 'claude';         Cmd = 'claude --version';                               Fix = 'Claude Code via Hyperspace (SAP ic agi)' }
    @{ Grup = 'Tools';     Ad = 'VS Code';        Cmd = 'code --version';                                 Fix = 'https://code.visualstudio.com/ (telemetry kapali; Software Hub)' }
    @{ Grup = 'Tools';     Ad = 'node (20.12-24)'; Cmd = 'node -v';                                       Fix = 'https://nodejs.org/en/download' }
    @{ Grup = 'Tools';     Ad = 'python3';        Cmd = $(if (Get-Command python3 -ErrorAction SilentlyContinue) { 'python3 --version' } elseif (Get-Command py -ErrorAction SilentlyContinue) { 'py -3 --version' } else { 'python --version' }); Fix = 'https://www.python.org/downloads/ (Windows: App execution alias kapat)' }
    @{ Grup = 'Tools';     Ad = 'pip';            Cmd = $(if (Get-Command python3 -ErrorAction SilentlyContinue) { 'python3 -m pip --version' } elseif (Get-Command py -ErrorAction SilentlyContinue) { 'py -3 -m pip --version' } else { 'python -m pip --version' }); Fix = 'python3 -m ensurepip --upgrade' }
    @{ Grup = 'Tools';     Ad = 'podman';         Cmd = 'podman --version';                               Fix = 'https://podman-desktop.io/' }
    @{ Grup = 'SAP CLI';   Ad = 'btp';            Cmd = 'btp --version';                                  Fix = 'https://tools.hana.ondemand.com/#cloud-btpcli' }
    @{ Grup = 'SAP CLI';   Ad = 'cf';             Cmd = 'cf version';                                     Fix = 'https://github.com/cloudfoundry/cli/wiki/V8-CLI-Installation-Guide' }
    @{ Grup = 'SAP CLI';   Ad = 'joule (legacy)'; Cmd = 'joule -V';                                       Fix = 'npm install -g @sap/joule-studio-cli' }
    @{ Grup = 'SAP CLI';   Ad = 'jl (Joule Work)'; Cmd = 'jl version';                                    Fix = 'npm install -g @sap/joule-studio-cli  (early-adopters paketi varsa once kaldir)' }
    @{ Grup = 'SAP CLI';   Ad = 'kubectl';        Cmd = 'kubectl version --client';                       Fix = 'https://kubernetes.io/docs/tasks/tools/' }
    @{ Grup = 'SAP CLI';   Ad = 'kyma (opsiyonel)'; Cmd = 'kyma version';                                 Fix = 'https://github.com/kyma-project/cli/releases'; Opt = $true }
)

$rows = foreach ($c in $checks) {
    $exe = ($c.Cmd -split ' ')[0]
    if (-not (Get-Command $exe -ErrorAction SilentlyContinue)) {
        [pscustomobject]@{ Grup = $c.Grup; Arac = $c.Ad; Durum = $(if ($c.Opt) { 'opsiyonel-yok' } else { 'YOK' }); Detay = ''; Cozum = $c.Fix }
        continue
    }
    $r = Run $c.Cmd
    $durum = if ($r.ok) { 'tamam' } elseif ($c.Opt) { 'opsiyonel-yok' } else { 'HATA' }
    if ($c.Ad -like 'node*' -and $r.ok) {
        $v = [version](($r.out -replace '^v', '') -split '\s')[0]
        if ($v -lt [version]'20.12.0' -or $v.Major -gt 24) { $durum = 'HATA' }
    }
    if ($c.Ad -like 'jl*' -and $r.ok -and (npm ls -g --depth=0 2>$null | Select-String 'joule-work-dev-cli-early-adopters')) { $durum = 'HATA'; $c.Fix = 'npm uninstall -g @sap/joule-work-dev-cli-early-adopters; npm install -g @sap/joule-studio-cli --force' }
    [pscustomobject]@{ Grup = $c.Grup; Arac = $c.Ad; Durum = $durum; Detay = (FirstLine $r.out); Cozum = $(if ($durum -eq 'tamam') { '' } else { $c.Fix }) }
}

$claudeHome = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$kitSet = [bool]($env:SAP_HACKATHON_KIT -or [Environment]::GetEnvironmentVariable('SAP_HACKATHON_KIT', 'User'))
$skillOk = (Test-Path (Join-Path $claudeHome 'skills\gorevim\SKILL.md')) -or (Test-Path '.claude\skills\gorevim\SKILL.md')
$extra = @(
    [pscustomobject]@{ Grup = 'Kit'; Arac = 'SAP_HACKATHON_KIT'; Durum = $(if ($kitSet) { 'tamam' } else { 'opsiyonel-yok' }); Detay = ''; Cozum = $(if ($kitSet) { '' } else { 'kurulum\install.ps1 calistir (sadece kaptan)' }) }
    [pscustomobject]@{ Grup = 'Kit'; Arac = 'skill: gorevim'; Durum = $(if ($skillOk) { 'tamam' } else { 'opsiyonel-yok' }); Detay = ''; Cozum = $(if ($skillOk) { '' } else { 'Takim reposunu clone et (.claude/skills icinde gelir) ya da install.ps1' }) }
)
$rows = @($rows) + $extra

if ($Json) { $rows | ConvertTo-Json; return }

$icon = @{ 'tamam' = '[OK]'; 'YOK' = '[--]'; 'HATA' = '[!!]'; 'opsiyonel-yok' = '[..]' }
foreach ($g in ($rows | Select-Object -ExpandProperty Grup -Unique)) {
    Write-Host "`n$g" -ForegroundColor Cyan
    foreach ($r in $rows | Where-Object Grup -eq $g) {
        $color = switch ($r.Durum) { 'tamam' { 'Green' } 'opsiyonel-yok' { 'DarkGray' } default { 'Red' } }
        Write-Host ("  {0} {1,-24} {2}" -f $icon[$r.Durum], $r.Arac, $r.Detay) -ForegroundColor $color
        if ($r.Cozum) { Write-Host ("       -> {0}" -f $r.Cozum) -ForegroundColor Yellow }
    }
}
$bad = @($rows | Where-Object { $_.Durum -in 'YOK', 'HATA' })
Write-Host ''
if ($bad.Count -eq 0) { Write-Host 'Hazirsin. Zorunlu araclarin hepsi calisiyor.' -ForegroundColor Green }
else { Write-Host ("Eksik/hatali zorunlu arac: {0} -> {1}" -f $bad.Count, (($bad | ForEach-Object Arac) -join ', ')) -ForegroundColor Red }
Write-Host 'Giris kontrolleri (tarayici gerekir, script yapmaz): btp login --sso · cf login --sso · jl login <url> · joule login · SAP Outlook / IAS aktivasyonu · BTP Trial.' -ForegroundColor DarkGray
