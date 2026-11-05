#!/usr/bin/env bash
KIT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILLS="$CLAUDE_HOME/skills"
mkdir -p "$SKILLS"

step() { echo "==> $1"; shift; if "$@"; then echo "    ok"; else echo "    atlandi"; fi; }

step "hackathon router skill" cp -r "$KIT/skills/hackathon" "$SKILLS/"

toolkit() {
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/SAP-archive/joule-a2a-agent-toolkit.git "$tmp/t" || return 1
  cp -r "$tmp/t/skills/"* "$SKILLS/" && rm -rf "$tmp"
}
step "joule-a2a-agent-toolkit skill-leri" toolkit

if command -v claude >/dev/null; then
  for m in SAP/ai-skills-library capire/skills SAP/ai-native-architecture-advisor secondsky/sap-skills; do
    step "marketplace: $m" claude plugin marketplace add "$m"
  done
  for p in aicore-skills@ai-skills-library cap-developer@cap ai-native-architecture-advisor@sap-ai-native-architecture-advisor sap-ai-core@sap-skills sap-btp-cloud-platform@sap-skills; do
    step "plugin: $p" claude plugin install "$p"
  done
else
  echo "==> claude CLI yok, plugin adimlari atlandi. Komutlar: katalog/08-skill-repolari.md"
fi

echo
echo "Bitti. Kit: $KIT  |  export SAP_HACKATHON_KIT=\"$KIT\" satirini shell profiline ekle."
for c in git gh claude hai node python3 podman btp cf joule jl kubectl kyma; do
  printf "  %-8s %s\n" "$c" "$(command -v $c >/dev/null && echo var || echo YOK)"
done
