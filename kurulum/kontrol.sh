#!/usr/bin/env bash
check() {
  name="$1"; cmd="$2"; fix="$3"; opt="$4"
  exe="${cmd%% *}"
  if ! command -v "$exe" >/dev/null 2>&1; then
    [ -n "$opt" ] && printf "  [..] %-24s\n" "$name" || { printf "  [--] %-24s\n       -> %s\n" "$name" "$fix"; BAD="$BAD $name"; }
    return
  fi
  out="$(eval "$cmd" 2>&1 | grep -m1 .)"
  if eval "$cmd" >/dev/null 2>&1; then printf "  [OK] %-24s %s\n" "$name" "$out"
  elif [ -n "$opt" ]; then printf "  [..] %-24s %s\n       -> %s\n" "$name" "$out" "$fix"
  else printf "  [!!] %-24s %s\n       -> %s\n" "$name" "$out" "$fix"; BAD="$BAD $name"; fi
}
BAD=""
echo "Developer"
check git "git --version" "https://git-scm.com/install/"
check gh "gh --version" "https://cli.github.com/"
check "gh -> github.tools.sap" "gh auth status --hostname github.tools.sap" "gh auth login --hostname github.tools.sap" opt
command -v brew >/dev/null && check brew "brew --version" "https://brew.sh/" opt
echo "AI"
check "hai (Hyperspace)" "hai --version" "Hyperspace hai CLI Quickstart (SAP internal / VPN)"
check claude "claude --version" "Claude Code via Hyperspace"
echo "Tools"
check "VS Code" "code --version" "https://code.visualstudio.com/"
check node "node -v" "https://nodejs.org/en/download (20.12-24)"
check python3 "python3 --version" "https://www.python.org/downloads/"
check pip "python3 -m pip --version" "python3 -m ensurepip --upgrade"
check podman "podman --version" "https://podman-desktop.io/"
echo "SAP CLI"
check btp "btp --version" "https://tools.hana.ondemand.com/#cloud-btpcli"
check cf "cf version" "https://github.com/cloudfoundry/cli/wiki/V8-CLI-Installation-Guide"
check "joule (legacy)" "joule -V" "npm install -g @sap/joule-studio-cli"
check "jl (Joule Work)" "jl version" "npm install -g @sap/joule-studio-cli"
check kubectl "kubectl version --client" "https://kubernetes.io/docs/tasks/tools/"
check "kyma (optional)" "kyma version" "https://github.com/kyma-project/cli/releases" opt
npm ls -g --depth=0 2>/dev/null | grep -q joule-work-dev-cli-early-adopters && { echo "  [!!] early-adopters jl paketi kurulu -> npm uninstall -g @sap/joule-work-dev-cli-early-adopters && npm install -g @sap/joule-studio-cli --force"; BAD="$BAD jl-conflict"; }
echo
[ -z "$BAD" ] && echo "Hazirsin." || echo "Eksik/hatali:$BAD"
echo "Giris (tarayici gerekir): btp login --sso · cf login --sso · jl login <url> · joule login"
