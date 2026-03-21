#!/bin/bash
# Deploy Baby Jack Adventures
# Copies the latest game build from docs/ and pushes to GitHub Pages

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")/docs"

echo "🦈 Baby Jack Adventures — Deploy"
echo "================================"

# Check source exists
if [ ! -f "$SOURCE_DIR/index.html" ]; then
  echo "❌ Can't find $SOURCE_DIR/index.html"
  exit 1
fi

# Copy game files
cp "$SOURCE_DIR/index.html" "$SCRIPT_DIR/index.html"
cp "$SOURCE_DIR/"*.glb "$SCRIPT_DIR/" 2>/dev/null

echo "✓ Copied game files from docs/"

cd "$SCRIPT_DIR"

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

# Show what changed
echo ""
git diff --stat
echo ""

# Commit and push
read -p "Commit message (or Enter for 'Update game build'): " MSG
MSG="${MSG:-Update game build}"

git add -A
git commit -m "$MSG"
git push

echo ""
echo "🌊 Deployed to babyjackadventures.com"
