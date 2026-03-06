
#!/bin/bash

CACHE_DIR="$HOME/Library/Caches"

echo "==============================================="
echo " macOS Cache Cleaner"
echo " Checking unused application caches..."
echo "==============================================="
echo ""

total_freed=0

for dir in "$CACHE_DIR"/*; do
    [ -d "$dir" ] || continue

    name=$(basename "$dir")
    size=$(du -sk "$dir" 2>/dev/null | cut -f1)

    app_found=$(ls /Applications | grep -i "$name" | head -1)

    if [ -z "$app_found" ]; then
        size_hr=$(du -sh "$dir" 2>/dev/null | cut -f1)

        printf "Removing: %-35s Size: %s\n" "$name" "$size_hr"

        rm -rf "$dir"

        total_freed=$((total_freed + size))
    fi
done

echo ""
echo "==============================================="

freed_mb=$((total_freed / 1024))
freed_gb=$(awk "BEGIN {printf \"%.2f\", $freed_mb/1024}")

echo " Cleanup completed"
echo " Space freed: ${freed_mb} MB (~${freed_gb} GB)"
echo "==============================================="
