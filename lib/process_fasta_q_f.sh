#!/usr/bin/env bash

## Function to Process FASTA and FASTAQ files and call R
process_fasta_q() {

  # Get the directory of THIS script
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # R script path
  R_SCRIPT="$SCRIPT_DIR/../R/main.R"

  # Declare local positional variables
  local input="$1"
  local output="$2"
  local csv="$3"
  local summary_csv="$4"
  local plot="$5"

  shopt -s nullglob # make globs expand to nothing if no match

  for file in "$input"/*.{fa,fasta,fq,fastq}; do

    [[ ! -e "$file" ]] && continue # skip if no match

    # Get the full name and extention
    full_name=$(basename "$file")
    echo "Full name of the File : $file"

    base_name="${full_name//./_}"
    echo "Base name of the File : $base_name"

    extention="${full_name##*.}"
    echo "File extention : $extention"

    # Create a subdir for this file
    output_path="$output/$base_name"
    mkdir -p "$output_path"
    echo "Creating Sub dir : $output_path"

    echo "Processing $file -> storing results in $output_path"

    # Call R
    Rscript "$R_SCRIPT" "$file" "$output_path" "$cvs" "$summary_csv" "$plot"

  done

}
