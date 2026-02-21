#!/usr/bin/env bash

# Get the script's own directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the function
source "$SCRIPT_DIR/../tests/validate_input_f.sh"
source "$SCRIPT_DIR/../lib/process_fasta_q_f.sh"

# Initialize
dir_input=""
dir_output=""
csv_output=false
summary_csv_output=false
plot=false

# Parse flags
while getopts "i:o:csp" flag; do
  case "$flag" in
  i) dir_input="$OPTARG" ;;
  o) dir_output="$OPTARG" ;;
  c) csv_output=true ;;
  s) summary_csv_output=true ;;
  p) plot=true ;;
  *)
    echo "Usage: $0 -i input_dir -o output_dir [-c] [-s] [-p]"
    exit 1
    ;;
  esac
done

# Show parsed values
echo "Input: $dir_input"
echo "Output: $dir_output"
echo "CSV: $csv_output"
echo "Summary CSV: $summary_csv_output"
echo "Plot: $plot"

# Validate the provided dir for input and output are provided
check_dir_provided "$dir_input" "$dir_output"

echo "Check provided dir : Passed"

# Validate the input files provided in the dir_input
check_fasta_fastq "$dir_input"

echo "Check Provided Files in provided dir : Passed"

# Validate optional argumets
check_optional_arguments "$csv_output" "$summary_csv_output" "$plot"

echo "Check Provided Optinal Arguments : Passed"

# Create a dir from the requested output_dir
echo "Creating output dir $dir_output"
mkdir -p "$dir_output"

# Process the FASTA/FASTAQ data in input_dir
process_fasta_q "$dir_input" "$dir_output" "$csv_output" "$summary_csv_output" "$plot"
