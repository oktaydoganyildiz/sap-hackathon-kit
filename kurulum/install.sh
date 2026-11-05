#!/usr/bin/env bash
KIT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILLS="$CLAUDE_HOME/skills"
mkdir -p "$SKILLS"

step() { echo "==> $1"; shift; if "$@"; then echo "    ok"; else echo "    atlandi"; fi; }

step "kit skill-leri (hackathon, kickoff, gorevim)" cp -r "$KIT/skills/"* "$SKILLS/"

copy_from_repo() {
  repo="$1"; shift
  tmp="$(mktemp -d)"
  git clone --depth 1 "https://github.com/$repo.git" "$tmp/r" || return 1
  for p in "$@"; do cp -r "$tmp/r/"$p "$SKILLS/" 2>/dev/null && echo "    + $p"; done
  rm -rf "$tmp"
}

toolkit() {
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/SAP-archive/joule-a2a-agent-toolkit.git "$tmp/t" || return 1
  cp -r "$tmp/t/skills/"* "$SKILLS/" && rm -rf "$tmp"
}
step "joule-a2a-agent-toolkit skill-leri" toolkit

if command -v claude >/dev/null; then
  for m in SAP/ai-skills-library capire/skills SAP/ai-native-architecture-advisor secondsky/sap-skills mattpocock/skills; do
    step "marketplace: $m" claude plugin marketplace add "$m"
  done
  for p in superpowers@claude-plugins-official mattpocock-skills@mattpocock aicore-skills@ai-skills-library cap-developer@cap ai-native-architecture-advisor@sap-ai-native-architecture-advisor sap-ai-core@sap-skills sap-btp-cloud-platform@sap-skills; do
    claude plugin install "$p" >/dev/null 2>&1 && echo "==> plugin: $p ok" || FAILED="$FAILED $p"
  done
else
  echo "==> claude CLI yok, plugin yerine skill kopyalanacak."
  FAILED="superpowers@ mattpocock-skills@ aicore-skills@ sap-skills@"
fi
case "$FAILED" in *superpowers@*) step "yedek: superpowers skill-leri" copy_from_repo obra/superpowers skills/brainstorming skills/writing-plans skills/systematic-debugging skills/verification-before-completion;; esac
case "$FAILED" in *mattpocock-skills@*) step "yedek: mattpocock skill-leri" copy_from_repo mattpocock/skills skills/productivity/grilling skills/engineering/tdd skills/engineering/diagnosing-bugs;; esac
case "$FAILED" in *aicore-skills@*) step "yedek: SAP ai-skills-library" copy_from_repo SAP/ai-skills-library "plugins/aicore-skills/skills/*" "skills/aicore-sdk-*";; esac
case "$FAILED" in *sap-skills@*) step "yedek: secondsky/sap-skills" copy_from_repo secondsky/sap-skills "plugins/sap-ai-core/skills/*" "plugins/sap-btp-cloud-platform/skills/*" "plugins/sap-cap-capire/skills/*" "plugins/sap-cloud-sdk-ai/skills/*";; esac

echo
echo "Yol A (yeni Joule Studio): hackathon proje klasorunde: jl login <url> && jl init claude && jl skills init claude"
command -v jl >/dev/null || echo "  (jl kurulu degil; Pro-Code Setup: katalog/01-joule-studio.md)"
echo
echo "Bitti. Kit: $KIT  |  export SAP_HACKATHON_KIT=\"$KIT\" satirini shell profiline ekle."
for c in git gh claude hai node python3 podman btp cf joule jl kubectl kyma; do
  printf "  %-8s %s\n" "$c" "$(command -v $c >/dev/null && echo var || echo YOK)"
done
