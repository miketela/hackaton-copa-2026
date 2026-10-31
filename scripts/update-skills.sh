#!/usr/bin/env bash
# Re-pull the official Azure and Dynatrace skills into ./skills.
#   ./scripts/update-skills.sh        -> refresh the curated set used by this repo
#   ./scripts/update-skills.sh --all  -> copy every skill from both repos
set -euo pipefail
cd "$(dirname "$0")/.."

AZURE=(azure-diagnostics appinsights-instrumentation azure-validate azure-resource-lookup azure-resource-visualizer azure-quotas azure-kusto)
DYNA=(dt-dql-essentials dt-obs-problems dt-obs-services dt-obs-tracing dt-obs-logs dt-obs-kubernetes dt-obs-hosts dt-obs-frontends dt-obs-analytics dt-sec-insights dt-sec-contextualization dt-app-notebooks dt-app-dashboards dt-migration)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone --depth 1 -q https://github.com/microsoft/azure-skills "$tmp/azure"
git clone --depth 1 -q https://github.com/Dynatrace/dynatrace-for-ai "$tmp/dyna"

if [ "${1:-}" = "--all" ]; then
  AZURE=($(ls "$tmp/azure/skills")); DYNA=($(ls "$tmp/dyna/skills"))
fi

for s in "${AZURE[@]}"; do rm -rf "skills/$s"; cp -R "$tmp/azure/skills/$s" "skills/$s"; done
for s in "${DYNA[@]}";  do rm -rf "skills/$s"; cp -R "$tmp/dyna/skills/$s"  "skills/$s"; done

echo "microsoft/azure-skills       @ $(git -C "$tmp/azure" rev-parse HEAD)"
echo "Dynatrace/dynatrace-for-ai   @ $(git -C "$tmp/dyna"  rev-parse HEAD)"
echo "Updated ${#AZURE[@]} Azure + ${#DYNA[@]} Dynatrace skills. Review with: git status && git diff --stat"
