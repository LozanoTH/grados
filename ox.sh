#!/bin/bash

MEDIA_FOLDER="./momentos"
OUTPUT_FILE="media.json"

# Iniciar archivo
echo "{" > "$OUTPUT_FILE"
echo '  "success": true,' >> "$OUTPUT_FILE"
echo '  "media": [' >> "$OUTPUT_FILE"

first=true
total=0

detect_version() {
    filename="$1"
    if [[ $filename =~ [vV]([0-9]+) ]]; then
        echo "v${BASH_REMATCH[1]}"
    else
        echo "v1"
    fi
}

for file in "$MEDIA_FOLDER"/*; do
    [ -f "$file" ] || continue

    filename=$(basename "$file")
    extension="${filename##*.}"
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    version=$(detect_version "$filename")

    case "$extension" in
        jpg|jpeg|png|gif|webp) type="image" ;;
        mp4|webm|ogg|mov)      type="video" ;;
        *) continue ;;
    esac

    # Coma SI NO es el primer elemento
    if [ "$first" = false ]; then
        echo "    ," >> "$OUTPUT_FILE"
    fi
    first=false

    cat >> "$OUTPUT_FILE" << EOF
    {
      "type": "$type",
      "src": "$file",
      "full": "$file",
      "name": "$filename",
      "version": "$version"
    }
EOF

    ((total++))
done

echo "  ]," >> "$OUTPUT_FILE"
echo "  \"total\": $total" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"