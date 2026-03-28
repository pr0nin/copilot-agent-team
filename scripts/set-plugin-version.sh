#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_FILE="$REPO_ROOT/.plugin/plugin.json"
MARKETPLACE_FILE="$REPO_ROOT/.plugin/marketplace.json"

if [[ ! -f "$PLUGIN_FILE" || ! -f "$MARKETPLACE_FILE" ]]; then
  echo "Expected manifest files not found."
  exit 1
fi

# Accept strict SemVer plus optional prerelease label (no build metadata for manifest compatibility).
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid version: $VERSION"
  exit 1
fi

# Create temp files next to the targets so mv is atomic (same filesystem)
tmp_plugin="$(mktemp "${PLUGIN_FILE}.XXXXXX")"
tmp_marketplace="$(mktemp "${MARKETPLACE_FILE}.XXXXXX")"
trap 'rm -f "$tmp_plugin" "$tmp_marketplace"' EXIT

# Validate exactly one marketplace entry matches before writing
agent_team_count="$(jq --arg name "agent-team" '[.plugins[] | select(.name == $name)] | length' "$MARKETPLACE_FILE")"
if [[ "$agent_team_count" -ne 1 ]]; then
  echo "Expected exactly one marketplace plugin with name \"agent-team\", found $agent_team_count" >&2
  exit 1
fi

jq --arg version "$VERSION" '.version = $version' "$PLUGIN_FILE" > "$tmp_plugin"
mv "$tmp_plugin" "$PLUGIN_FILE"

jq --arg version "$VERSION" '(.plugins[] | select(.name == "agent-team") | .version) = $version' "$MARKETPLACE_FILE" > "$tmp_marketplace"
mv "$tmp_marketplace" "$MARKETPLACE_FILE"

echo "Updated versions to $VERSION in:"
echo "  $PLUGIN_FILE"
echo "  $MARKETPLACE_FILE"
