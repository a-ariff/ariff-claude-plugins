#!/bin/bash
set -e

SOURCE="/Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/Ariff-code-config/.claude-plugin/plugins"
TARGET="/Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/ariff-claude-plugins/plugins"

mkdir -p "$TARGET"

count=0
for plugin in "$SOURCE"/*/; do
    if [ -d "$plugin" ]; then
        name=$(basename "$plugin")
        [[ "$name" == "." || "$name" == ".." || "$name" == ".DS_Store" ]] && continue

        echo "Copying: $name"
        cp -r "$plugin" "$TARGET/$name"
        ((count++))
    fi
done

echo "✓ Copied $count plugins"
