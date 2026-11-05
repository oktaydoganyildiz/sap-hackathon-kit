$ErrorActionPreference = 'Continue'
$Kit = Split-Path -Parent $PSScriptRoot
$ClaudeHome = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$Skills = Join-Path $ClaudeHome 'skills'
New-Item -ItemType Directory -Force -Path $Skills | Out-Null

function Step([string]$Name, [scriptblock]$Action) {
    Write-Host "==> $Name"
    try { & $Action; Write-Host "    ok" -ForegroundColor Green }
    catch { Write-Host "    atlandi: $($_.Exception.Message)" -ForegroundColor Yellow }
}

Step 'hackathon router skill' {
    Copy-Item -Recurse -Force (Join-Path $Kit 'skills\hackathon') $Skills
}

[Environment]::SetEnvironmentVariable('SAP_HACKATHON_KIT', $Kit, 'User')

Step 'joule-a2a-agent-toolkit skill-leri (joule-a2a-agent, joule-cli, btp-cli, cf-cli)' {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) "joule-toolkit-$([guid]::NewGuid().ToString('N'))"
    git clone --depth 1 https://github.com/SAP-archive/joule-a2a-agent-toolkit.git $tmp
    if ($LASTEXITCODE -ne 0) { throw 'git clone basarisiz (github.com erisimi?)' }
    Get-ChildItem (Join-Path $tmp 'skills') -Directory | ForEach-Object { Copy-Item -Recurse -Force $_.FullName $Skills }
    Remove-Item -Recurse -Force $tmp
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    $markets = @('SAP/ai-skills-library', 'capire/skills', 'SAP/ai-native-architecture-advisor', 'secondsky/sap-skills')
    foreach ($m in $markets) {
        Step "marketplace: $m" { claude plugin marketplace add $m; if ($LASTEXITCODE -ne 0) { throw 'marketplace add hata' } }
    }
    $plugins = @('aicore-skills@ai-skills-library', 'cap-developer@cap', 'ai-native-architecture-advisor@sap-ai-native-architecture-advisor', 'sap-ai-core@sap-skills', 'sap-btp-cloud-platform@sap-skills')
    foreach ($p in $plugins) {
        Step "plugin: $p" { claude plugin install $p; if ($LASTEXITCODE -ne 0) { throw 'plugin install hata' } }
    }
} else {
    Write-Host '==> claude CLI bulunamadi, plugin adimlari atlandi. Komutlar: katalog\08-skill-repolari.md' -ForegroundColor Yellow
}

Write-Host ''
Write-Host "Bitti. Kit: $Kit  |  Skill klasoru: $Skills"
Write-Host 'Arac kontrolu:'
foreach ($c in 'git','gh','claude','hai','node','python','podman','btp','cf','joule','jl','kubectl','kyma') {
    $ok = [bool](Get-Command $c -ErrorAction SilentlyContinue)
    Write-Host ("  {0,-8} {1}" -f $c, $(if ($ok) { 'var' } else { 'YOK' }))
}
