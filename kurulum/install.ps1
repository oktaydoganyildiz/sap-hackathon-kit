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

Step 'kit skill-leri (hackathon, kickoff, gorevim)' {
    Get-ChildItem (Join-Path $Kit 'skills') -Directory | ForEach-Object { Copy-Item -Recurse -Force $_.FullName $Skills; Write-Host "    + $($_.Name)" }
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
    $markets = @('SAP/ai-skills-library', 'capire/skills', 'SAP/ai-native-architecture-advisor', 'secondsky/sap-skills', 'mattpocock/skills')
    $mpDir = Join-Path $ClaudeHome 'plugins\marketplaces'
    foreach ($m in $markets) {
        Step "marketplace: $m" {
            $short = ($m -split '/')[1]
            for ($i = 1; $i -le 3; $i++) {
                $out = claude plugin marketplace add $m 2>&1 | Out-String
                if ($LASTEXITCODE -eq 0) { return }
                if ($out -notmatch 'EPERM') { throw 'marketplace add hata' }
                Write-Host "    EPERM (dosya kilidi), temizleyip tekrar deniyorum ($i/3)"
                Get-ChildItem $mpDir -Directory -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -like "*$short*" } |
                    Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 5
            }
            throw 'EPERM devam ediyor; elle: claude plugin marketplace add ' + $m
        }
    }
    $plugins = @('superpowers@claude-plugins-official', 'mattpocock-skills@mattpocock', 'aicore-skills@ai-skills-library', 'cap-developer@cap', 'ai-native-architecture-advisor@sap-ai-native-architecture-advisor', 'sap-ai-core@sap-skills', 'sap-btp-cloud-platform@sap-skills')
    $script:failed = @()
    foreach ($p in $plugins) {
        Step "plugin: $p" { claude plugin install $p; if ($LASTEXITCODE -ne 0) { $script:failed += $p; throw 'plugin install hata' } }
    }
} else {
    Write-Host '==> claude CLI bulunamadi, plugin yerine skill kopyalanacak.' -ForegroundColor Yellow
    $script:failed = @('superpowers@claude-plugins-official', 'mattpocock-skills@mattpocock', 'aicore-skills@ai-skills-library', 'sap-ai-core@sap-skills', 'sap-btp-cloud-platform@sap-skills')
}

function Copy-SkillsFromRepo([string]$Repo, [string[]]$Globs) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) "sk-$([guid]::NewGuid().ToString('N').Substring(0,8))"
    git clone --depth 1 "https://github.com/$Repo.git" $tmp 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "git clone $Repo basarisiz" }
    foreach ($g in $Globs) {
        $p = Join-Path $tmp $g
        $dirs = if ($g -match '[\*\?]') { Get-ChildItem $p -Directory -ErrorAction SilentlyContinue } else { Get-Item $p -ErrorAction SilentlyContinue }
        $dirs | ForEach-Object { Copy-Item -Recurse -Force $_.FullName $Skills; Write-Host "    + $($_.Name)" }
    }
    Remove-Item -Recurse -Force $tmp -Confirm:$false -ErrorAction SilentlyContinue
}

if ($script:failed | Where-Object { $_ -like 'superpowers@*' }) {
    Step 'yedek yol: obra/superpowers brainstorming (+ plan, debug) skill-lerini kopyala' {
        Copy-SkillsFromRepo 'obra/superpowers' @('skills\brainstorming', 'skills\writing-plans', 'skills\systematic-debugging', 'skills\verification-before-completion')
    }
}
if ($script:failed | Where-Object { $_ -like 'mattpocock-skills@*' }) {
    Step 'yedek yol: mattpocock/skills grilling (+ tdd, diagnosing-bugs) skill-lerini kopyala' {
        Copy-SkillsFromRepo 'mattpocock/skills' @('skills\productivity\grilling', 'skills\engineering\tdd', 'skills\engineering\diagnosing-bugs')
    }
}
if ($script:failed | Where-Object { $_ -like '*@ai-skills-library' }) {
    Step 'yedek yol: SAP/ai-skills-library skill-lerini dogrudan kopyala' {
        Copy-SkillsFromRepo 'SAP/ai-skills-library' @('plugins\aicore-skills\skills\*', 'skills\aicore-sdk-*')
    }
}
if ($script:failed | Where-Object { $_ -like '*@sap-skills' }) {
    Step 'yedek yol: secondsky/sap-skills AI/BTP/CAP skill-lerini dogrudan kopyala' {
        Copy-SkillsFromRepo 'secondsky/sap-skills' @('plugins\sap-ai-core\skills\*', 'plugins\sap-btp-cloud-platform\skills\*', 'plugins\sap-cap-capire\skills\*', 'plugins\sap-cloud-sdk-ai\skills\*', 'plugins\sap-cloud-sdk-ai-python\skills\*')
    }
}

Write-Host ''
Write-Host 'Yol A (yeni Joule Studio): hackathon proje klasorunde su sirayla calistir:' -ForegroundColor Cyan
Write-Host '  jl login <AI Core / Joule Studio URL>'
Write-Host '  jl init claude'
Write-Host '  jl skills init claude'
if (-not (Get-Command jl -ErrorAction SilentlyContinue)) { Write-Host '  (jl kurulu degil; Pro-Code Setup: katalog\01-joule-studio.md)' -ForegroundColor Yellow }

Write-Host ''
Write-Host "Bitti. Kit: $Kit  |  Skill klasoru: $Skills"
Write-Host 'Ortam kontrolu:'
& (Join-Path $PSScriptRoot 'kontrol.ps1')

Write-Host ''
Write-Host 'SIRADAKI ADIM' -ForegroundColor Cyan
Write-Host "  cd `"$Kit`""
Write-Host '  claude'
Write-Host '  Kaptan isen yaz:  "kiti kurdum, takim reposunu kur ve ekibi hazirla"'
Write-Host '     -> Claude bos takim reposunu acar, arkadaslarini davet eder, her birine kendi dilinde kurulum mesaji verir.'
Write-Host '  Takim uyesiysen: kaptanin mesajindaki takim reposunu clone et, kontrol.ps1 calistir, gorevini bekle.'
