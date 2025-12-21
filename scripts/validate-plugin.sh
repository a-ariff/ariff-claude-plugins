#!/bin/bash
# =============================================================================
# Plugin Validator - Checks plugin structure and manifest
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PLUGIN_DIR="${1:-.}"

echo "🔍 Validating plugin: $PLUGIN_DIR"
echo ""

errors=0
warnings=0

# Check manifest.json exists
if [ -f "$PLUGIN_DIR/manifest.json" ]; then
    echo -e "${GREEN}✓${NC} manifest.json exists"
    
    # Validate JSON
    if command -v jq &> /dev/null; then
        if jq empty "$PLUGIN_DIR/manifest.json" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} manifest.json is valid JSON"
            
            # Check required fields
            name=$(jq -r '.name // empty' "$PLUGIN_DIR/manifest.json")
            version=$(jq -r '.version // empty' "$PLUGIN_DIR/manifest.json")
            description=$(jq -r '.description // empty' "$PLUGIN_DIR/manifest.json")
            category=$(jq -r '.category // empty' "$PLUGIN_DIR/manifest.json")
            
            [ -n "$name" ] && echo -e "${GREEN}✓${NC} name: $name" || { echo -e "${RED}✗${NC} Missing: name"; ((errors++)); }
            [ -n "$version" ] && echo -e "${GREEN}✓${NC} version: $version" || { echo -e "${RED}✗${NC} Missing: version"; ((errors++)); }
            [ -n "$description" ] && echo -e "${GREEN}✓${NC} description defined" || { echo -e "${YELLOW}⚠${NC} Missing: description"; ((warnings++)); }
            [ -n "$category" ] && echo -e "${GREEN}✓${NC} category: $category" || { echo -e "${RED}✗${NC} Missing: category"; ((errors++)); }
            
            # Check files exist
            files=$(jq -r '.files[]? // empty' "$PLUGIN_DIR/manifest.json")
            for file in $files; do
                if [ -f "$PLUGIN_DIR/$file" ]; then
                    echo -e "${GREEN}✓${NC} File exists: $file"
                else
                    echo -e "${RED}✗${NC} File missing: $file"
                    ((errors++))
                fi
            done
        else
            echo -e "${RED}✗${NC} manifest.json is not valid JSON"
            ((errors++))
        fi
    else
        echo -e "${YELLOW}⚠${NC} jq not installed, skipping JSON validation"
        ((warnings++))
    fi
else
    echo -e "${RED}✗${NC} manifest.json not found"
    ((errors++))
fi

# Check for absolute paths
if grep -r "/Users/\|/home/\|C:\\\\" "$PLUGIN_DIR"/*.md 2>/dev/null | grep -v "example" > /dev/null; then
    echo -e "${YELLOW}⚠${NC} Found absolute paths in plugin files"
    ((warnings++))
else
    echo -e "${GREEN}✓${NC} No hardcoded absolute paths"
fi

# Check for secrets
if grep -rE "(api[_-]?key|password|secret|token)\s*[:=]" "$PLUGIN_DIR" 2>/dev/null | grep -v "example\|placeholder\|YOUR_" > /dev/null; then
    echo -e "${RED}✗${NC} Possible secrets detected in plugin files"
    ((errors++))
else
    echo -e "${GREEN}✓${NC} No obvious secrets detected"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}✓ Plugin validation passed!${NC}"
elif [ $errors -eq 0 ]; then
    echo -e "${YELLOW}⚠ Plugin has $warnings warning(s)${NC}"
else
    echo -e "${RED}✗ Plugin has $errors error(s) and $warnings warning(s)${NC}"
    exit 1
fi
