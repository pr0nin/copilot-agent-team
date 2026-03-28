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

tmp_plugin="$(mktemp)"
tmp_marketplace="$(mktemp)"

jq --arg version "$VERSION" '.version = $version' "$PLUGIN_FILE" > "$tmp_plugin"
mv "$tmp_plugin" "$PLUGIN_FILE"

jq --arg version "$VERSION" '(.plugins[] | select(.name == "agent-team") | .version) = $version' "$MARKETPLACE_FILE" > "$tmp_marketplace"
mv "$tmp_marketplace" "$MARKETPLACE_FILE"

echo "Updated versions to $VERSION in:"
echo "  $PLUGIN_FILE"
echo "  $MARKETPLACE_FILE"
