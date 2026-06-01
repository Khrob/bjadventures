#!/bin/bash
# Deploy Baby Jack Adventures
# This repo IS the GitHub Pages source (CNAME -> babyjackadventures.com), so
# deploying just means committing and pushing whatever is in this folder.
# (It used to copy a build in from ../docs/ — that overwrote the live build with
#  a stale copy, so that step has been removed.)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🦈 Baby Jack Adventures — Deploy"
echo "================================"

# Must be a git repo
if [ ! -d .git ] && ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not a git repository: $SCRIPT_DIR"
  exit 1
fi

# Warn if not on main (GitHub Pages serves main)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" != "main" ]; then
  echo "⚠️  You're on '$BRANCH', not 'main' (GitHub Pages serves main)."
  read -p "   Continue anyway? [y/N]: " GO
  [ "$GO" = "y" ] || [ "$GO" = "Y" ] || { echo "Aborted."; exit 1; }
fi

# Anything to deploy?
if git diff --quiet && git diff --cached --quiet; then
  echo "No local changes."
else
  echo ""
  git status --short
  echo ""
  read -p "Commit message (or Enter for 'Update game build'): " MSG
  MSG="${MSG:-Update game build}"
  git add -A
  git commit -m "$MSG"
fi

# Push (no-op if already up to date)
echo ""
echo "⬆️  Pushing to origin/$BRANCH..."
git push origin "$BRANCH"

echo ""
echo "🌊 Deployed to babyjackadventures.com"
