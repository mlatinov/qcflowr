#!/usr/bin/env bash

# Function to check if input and output dir are provided
check_dir_provided() {
  local names=("input" "output")
  local values=("$1" "$2")

  for i in "${!values[@]}"; do
    if [[ -z "${values[$i]}" ]]; then
      echo "The ${names[$i]} directory provided is empty" >&2
      exit 1
    else
      echo "Valid directory provided for ${names[$i]}: ${values[$i]}"
    fi
  done
}

# Function to check if the files provided in the directory are FASTA or FASTAQ files
check_fasta_fastq() {
  local dir="$1"
  local valid=true # Flag to track if all files are valid

  # Loop over all files in the directory
  for file in "$dir"/*; do
    # Skip if not a regular file
    [[ -f "$file" ]] || continue

    # Get file extension
    ext="${file##*.}"

    # Check if extension is fasta, fa, fq, fastq (case-insensitive)
    case "${ext,,}" in
    fasta | fa | fq | fastq) ;;
    *)
      echo "Invalid file found: $file"
      valid=false
      ;;
    esac
  done

  # Return result
  $valid && echo "All files are FASTA/FASTQ" || echo "Some files are not FASTA/FASTQ"
}

# Function to check the optional inputs provided
check_optional_arguments() {
  local names=("CSV Output" "Summary CSV" "Plot")
  local values=("$1" "$2" "$3")

  for i in "${!values[@]}"; do
    case "${values[$i]}" in
    true)
      echo "${names[$i]} was requested and is valid"
      ;;
    false)
      echo "${names[$i]} was not requested"
      ;;
    *)
      echo "${names[$i]} provided is invalid: ${values[$i]}"
      ;;
    esac
  done
}
