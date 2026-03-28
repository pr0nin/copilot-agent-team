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

# Safety checks before destructive operations
if [[ -z "${MIRROR_AGENTS_DIR:-}" || -z "${MIRROR_SKILLS_DIR:-}" ]]; then
  echo "Refusing to proceed: mirror directory variables are empty."
  echo "  MIRROR_AGENTS_DIR='$MIRROR_AGENTS_DIR'"
  echo "  MIRROR_SKILLS_DIR='$MIRROR_SKILLS_DIR'"
  exit 1
fi

MIRROR_AGENTS_REAL="$(realpath -m "$MIRROR_AGENTS_DIR")"
MIRROR_SKILLS_REAL="$(realpath -m "$MIRROR_SKILLS_DIR")"
EXPECTED_AGENTS_REAL="$(realpath -m "$REPO_ROOT/.github/agents")"
EXPECTED_SKILLS_REAL="$(realpath -m "$REPO_ROOT/.github/skills")"
GITHUB_ROOT_REAL="$(realpath -m "$REPO_ROOT/.github")"

if [[ "$MIRROR_AGENTS_REAL" != "$GITHUB_ROOT_REAL"/* && "$MIRROR_AGENTS_REAL" != "$GITHUB_ROOT_REAL" ]]; then
  echo "Refusing to proceed: MIRROR_AGENTS_DIR is outside .github."
  echo "  MIRROR_AGENTS_REAL='$MIRROR_AGENTS_REAL'"
  echo "  .github root       ='$GITHUB_ROOT_REAL'"
  exit 1
fi

if [[ "$MIRROR_SKILLS_REAL" != "$GITHUB_ROOT_REAL"/* && "$MIRROR_SKILLS_REAL" != "$GITHUB_ROOT_REAL" ]]; then
  echo "Refusing to proceed: MIRROR_SKILLS_DIR is outside .github."
  echo "  MIRROR_SKILLS_REAL='$MIRROR_SKILLS_REAL'"
  echo "  .github root       ='$GITHUB_ROOT_REAL'"
  exit 1
fi

if [[ "$MIRROR_AGENTS_REAL" != "$EXPECTED_AGENTS_REAL" || "$MIRROR_SKILLS_REAL" != "$EXPECTED_SKILLS_REAL" ]]; then
  echo "Refusing to proceed: mirror paths do not match expected .github mirrors."
  echo "  MIRROR_AGENTS_REAL='$MIRROR_AGENTS_REAL'"
  echo "  EXPECTED_AGENTS   ='$EXPECTED_AGENTS_REAL'"
  echo "  MIRROR_SKILLS_REAL='$MIRROR_SKILLS_REAL'"
  echo "  EXPECTED_SKILLS   ='$EXPECTED_SKILLS_REAL'"
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
