#!/usr/bin/env bash

## Function to Trim FASTQ files based on input folder
trim_fastq_fastp() {

  # Local Variables
  local dir_input="$1"
  local dir_output="$2"
  local files=("$dir_input"/*.fastq)

  echo "Running FASTP on ${#files[@]} files..."

  # Loop and trim every file from dir input
  for input_file in "${files[@]}"; do
    local base=$(basename "$input_file" .fastq)

    # Run FASTP
    # Trim bases from the ends of reads until the average quality score is ≥ 20.
    # After trimming reads shorter than 30 bp are discarded
    # Generate json report
    fastp -i "$input_file" \
      -o "$dir_output/${base}_trimmed.fastq" \
      --cut_mean_quality 20 \
      --length_required 30

    echo "Trimmed $input_file → $dir_output/${base}_trimmed.fastq"

  done
}
