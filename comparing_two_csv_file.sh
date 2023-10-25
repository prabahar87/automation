#!/bin/bash

# Define the input CSV files
original1="original1.csv"
original2="original2.csv"

# Define the output files
matched="matched.csv"
unmatched="unmatched.csv"

# Create empty output files
> "$matched"
> "$unmatched"

# Read each line from original1 and compare with original2 (case-insensitive)
while IFS= read -r line1; do
  found=false
  line1_lower=$(echo "$line1" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase
  
  while IFS= read -r line2; do
    line2_lower=$(echo "$line2" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase
    
    if [ "$line1_lower" = "$line2_lower" ]; then
      found=true
      break
    fi
  done < "$original2"
  
  if [ "$found" = true ]; then
    echo "$line1" >> "$matched"
  else
    echo "$line1" >> "$unmatched"
  fi
done < "$original1"

echo "Comparison completed (case-insensitive)."
