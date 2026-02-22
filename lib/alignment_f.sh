#!/usr/bin/env bash

## Function to align the FASTQ with the provided Ref genome
alignment_to_reference() {

  # Inputs
  local dir_reference="$1"
  local dir_fastq="$2"
  local dir_output="$3"

  # Make sure output exists
  mkdir -p "$dir_output"

  # Look for FASTA in reference folder
  fasta=$(find "$dir_reference" -maxdepth 1 -type f \( -name "*.fasta" -o -name "*.fa" \) | head -n1)

  # Index folder
  index_folder="$dir_reference/genome_index"
  mkdir -p "$index_folder"

  # Check if index already exists
  if [[ -f "$index_folder/genome.1.ht2" ]]; then
    echo "HISAT2 index already exists. Using it..."
    index_prefix="$index_folder/genome"
  elif [[ -n "$fasta" ]]; then
    echo "FASTA found. Building HISAT2 index..."
    hisat2-build "$fasta" "$index_folder/genome"
    index_prefix="$index_folder/genome"
  else
    echo "ERROR: No FASTA found and no existing HISAT2 index in $index_folder"
    return 1
  fi

  # Align all FASTQ files in the folder
  for fastq in "$dir_fastq"/*.fastq; do
    [[ -f "$fastq" ]] || {
      echo "No FASTQ files found in $dir_fastq"
      continue
    }
    base=$(basename "$fastq" .fastq)
    echo "Aligning $base ..."

    hisat2 --dta -x "$index_prefix" -U "$fastq" -p 8 2>"$dir_output/${base}_hisat2.log" |
      samtools sort -o "$dir_output/${base}_sorted.bam"

    samtools index "$dir_output/${base}_sorted.bam"
  done

  echo "Alignment complete!"
}
