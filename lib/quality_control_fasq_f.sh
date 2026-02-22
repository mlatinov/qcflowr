#!/usr/bin/env bash

## Function to Check the Quality of the raw provided Fastq files
quality_control_fastq() {

  # Source R Function
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  R_SCRIPT="$SCRIPT_DIR/../R/summarize_quality.R"

  # Local Variables
  local input_dir="$1"
  local output_dir="$2"
  local proc="$3"
  local files=("$input_dir"/*.fastq)

  mkdir -p "$output_dir"
  echo "Running FastQC on ${#files[@]} files..."

  # Run FastQC in CLI-only mode
  fastqc --nogroup --quiet -o "$output_dir" "${files[@]}"

  if [ $? -ne 0 ]; then
    echo "FastQC failed."
    return 1
  fi

  # Unzip all the files and save them again in the output_dir
  for zip in "$output_dir"/*.zip; do
    unzip -o "$zip" -d "$output_dir"
  done

  echo "FastQC completed successfully."

  # Call to Summarize the Output
  Rscript "$R_SCRIPT" "$output_dir" "$proc"

  # Clean all the files from the unzip
  rm -rf "$output_dir"/*_fastqc
  rm -f "$output_dir"/*.zip
  rm -f "$output_dir"/*.html

}
