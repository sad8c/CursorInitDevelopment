#!/bin/bash
set -euo pipefail

SKILL_DIR=".cursor/skills/init-development"

if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "go.mod" ] && [ ! -f "Cargo.toml" ]; then
  echo "Warning: this doesn't look like a project root."
  echo "Run this script from your project's root directory."
  read -rp "Continue anyway? [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || exit 1
fi

if [ -d "$SKILL_DIR" ]; then
  echo "InitDevelopment skill already installed at $SKILL_DIR"
  echo "To reinstall, remove it first: rm -rf $SKILL_DIR"
  exit 1
fi

CLONE_DIR="$(mktemp -d)"
trap 'rm -rf "$CLONE_DIR"' EXIT

if [ "${CLONE_URL:-}" = "https" ]; then
  REPO_URL="https://github.com/sad8c/CursorInitDevelopment.git"
else
  REPO_URL="git@github.com:sad8c/CursorInitDevelopment.git"
fi

echo "Cloning CursorInitDevelopment..."
git clone --depth 1 "$REPO_URL" "$CLONE_DIR" 2>/dev/null

mkdir -p "$(dirname "$SKILL_DIR")"
cp -r "$CLONE_DIR/init-development" "$SKILL_DIR"

echo ""
echo "InitDevelopment skill installed to $(pwd)/$SKILL_DIR"
echo ""
echo "Open this project in Cursor and ask:"
echo "  Initialize development workflow"
echo ""
echo "The agent will process templates and install skills, rules,"
echo "commands, and agents into this project's .cursor/ directory."
