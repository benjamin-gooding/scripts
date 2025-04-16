#!/bin/bash

# Find all empty .css files
find . -name "*.css" -empty | while read -r css_file; do
  css_filename=$(basename "$css_file")
  css_filename_escaped=$(printf '%s\n' "$css_filename" | sed 's/[][\.*^$(){}?+|]/\\&/g')

  # Look for all TypeScript files in the same directory
  ts_files=$(find "$(dirname "$css_file")" -maxdepth 1 -name "*.ts")

  for ts_file in $ts_files; do
    echo "Checking $ts_file for reference to $css_filename"

    # Remove any matching styleUrl line — allowing spaces and optional trailing comma
    sed -i '' "/styleUrl[[:space:]]*:[[:space:]]*['\"]\.\/$css_filename_escaped['\"][[:space:]]*,*/d" "$ts_file"
  done

  echo "Deleting empty CSS file: $css_file"
  rm "$css_file"
done

echo "✅ Done cleaning up empty CSS references and files."
