#!/usr/bin/env bash
# Read-only checks before the challenge. Changes nothing.
set -u
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; }

echo "Tools"
for t in git terraform az dotnet node npm zip curl; do
  if command -v "$t" >/dev/null 2>&1; then
    case "$t" in
      git)       v=$(git --version) ;;
      terraform) v=$(terraform version 2>/dev/null | head -1) ;;
      az)        v=$(az version --query '"azure-cli"' -o tsv 2>/dev/null) ;;
      dotnet)    v=$(dotnet --list-sdks 2>/dev/null | tr '\n' ' ') ;;
      node)      v=$(node --version) ;;
      npm)       v=$(npm --version) ;;
      *)         v="" ;;
    esac
    ok "$t $v"
  else
    bad "$t not found  (macOS: brew install $( [ "$t" = az ] && echo azure-cli || ([ "$t" = terraform ] && echo hashicorp/tap/terraform) || ([ "$t" = dotnet ] && echo --cask dotnet-sdk) || echo "$t"))"
  fi
done

if command -v dotnet >/dev/null 2>&1; then
  if dotnet --list-sdks 2>/dev/null | grep -q '^10\.'; then ok ".NET 10 SDK present (backend targets .NET 10)"; else warn ".NET 10 SDK not found: the challenge backend targets .NET 10"; fi
fi

echo
echo "Azure"
if command -v az >/dev/null 2>&1; then
  if az account show -o none 2>/dev/null; then
    az account show --query '{subscription:name, tenant:tenantId, user:user.name}' -o table
    warn "Confirm this is the hackathon tenant / 'Suscripción 1' before deploying (az account set --subscription ...)."
  else
    warn "Not logged in. On challenge day: az login (only the 1-2 designated people, one at a time, from the venue network)."
  fi
fi

echo
echo "Repo"
[ -d challenge ] && ls -1 challenge 2>/dev/null | sed 's/^/  challenge\//' || true
[ -f EVIDENCE.md ] && ok "EVIDENCE.md exists" || warn "Copy templates/EVIDENCE.md to EVIDENCE.md when the challenge starts."
echo
echo "Skills: $(ls -1d skills/*/ 2>/dev/null | wc -l | tr -d ' ') installed in skills/ (linked into .claude, .agents, .github, .cursor, .opencode, .gemini)."
