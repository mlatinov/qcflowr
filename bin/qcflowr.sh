#!/usr/bin/env bash

# Get the script's own directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the function
source "$SCRIPT_DIR/../tests/validate_input_f.sh"
source "$SCRIPT_DIR/../lib/process_fasta_q_f.sh"
source "$SCRIPT_DIR/../lib/quality_control_fasq_f.sh"
source "$SCRIPT_DIR/../lib/trim_fastq_fastp.sh"
source "$SCRIPT_DIR/../lib/alignment_f.sh"
source "$SCRIPT_DIR/../lib/quantification_f.sh"

# Initialize
dir_input=""
dir_output=""
dir_reference=""
dir_gtf_annotation=""

# Parse flags
while getopts "i:o:r:g:" flag; do
  case "$flag" in
  i) dir_input="$OPTARG" ;;
  o) dir_output="$OPTARG" ;;
  r) dir_reference="$OPTARG" ;;
  g) dir_gtf_annotation="$OPTARG" ;;
  *)
    echo "Usage: $0 -i input_dir -o output_dir -r dir_reference"
    exit 1
    ;;
  esac
done

# Show parsed values
echo "Input: $dir_input"
echo "Output: $dir_output"
echo "Reference: $dir_reference"
echo "GTF : $dir_gtf_annotation"

# Validate the provided dir for input and output are provided
#check_dir_provided "$dir_input" "$dir_output"

echo "Check provided dir : Passed"

# Validate the input files provided in the dir_input
#check_fasta_fastq "$dir_input"

echo "Check Provided Files in provided dir : Passed"

# Validate optional argumets
#check_optional_arguments "$csv_output" "$summary_csv_output" "$plot"

echo "Check Provided Optinal Arguments : Passed"

# Quality Control Check on the pre-trimed - FASTQ
quality_control_fastq "$dir_input" "$dir_output" "pre_trimed_"

echo "Quality Control on the pre-trimed FASTQ : DONE"

# Triming of the FASTQ by fastp
trim_fastq_fastp "$dir_input" "$dir_output"

echo "Triming FASTQ : DONE"

# Quality Contorl Check on the trimed FASTQ
quality_control_fastq "$dir_output" "$dir_output" "post_trimed_"

echo "Post Triming Quality Control : DONE "

# Alignment with HAZ Tool to the ref genome provided in the inputs
alignment_to_reference "$dir_reference" "$dir_output" "$dir_output"

echo "Alignment to Reference : DONE "

echo "DEBUG: BAM files:"
ls -lh "$dir_output"/*_sorted.bam

# Qunatification with feature Count
quantification_bam "$dir_gtf_annotation" "$dir_output" "$dir_output"

# Process the FASTA/FASTAQ data in input_dir
# process_fasta_q "$dir_input" "$dir_output" "$csv_output" "$summary_csv_output" "$plot"
