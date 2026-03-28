#!/usr/bin/env bash
set -euo pipefail

# Sync dogfooding mirrors from the distributable plugin source of truth.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PLUGIN_AGENTS_DIR="$REPO_ROOT/plugins/agent-team/agents"
PLUGIN_SKILLS_DIR="$REPO_ROOT/plugins/agent-team/skills"
MIRROR_AGENTS_DIR="$REPO_ROOT/.github/agents"
MIRROR_SKILLS_DIR="$REPO_ROOT/.github/skills"

if [[ ! -d "$PLUGIN_AGENTS_DIR" || ! -d "$PLUGIN_SKILLS_DIR" ]]; then
  echo "Expected plugin source directories were not found."
  echo "Looked for:"
  echo "  $PLUGIN_AGENTS_DIR"
  echo "  $PLUGIN_SKILLS_DIR"
  exit 1
fi

echo "Syncing .github mirrors from plugins/agent-team ..."

rm -rf "$MIRROR_AGENTS_DIR" "$MIRROR_SKILLS_DIR"
mkdir -p "$MIRROR_AGENTS_DIR" "$MIRROR_SKILLS_DIR"

cp -a "$PLUGIN_AGENTS_DIR/." "$MIRROR_AGENTS_DIR/"
cp -a "$PLUGIN_SKILLS_DIR/." "$MIRROR_SKILLS_DIR/"

echo "Mirror sync complete:"
echo "  $MIRROR_AGENTS_DIR"
echo "  $MIRROR_SKILLS_DIR"
