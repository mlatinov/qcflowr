#!/usr/bin/env bash

## Function to quantify BAM files using featureCounts
quantification_bam() {
  local gtf_file="$1"   # path to GTF
  local dir_bam="$2"    # directory with BAM files
  local dir_output="$3" # output folder

  mkdir -p "$dir_output"

  # Get all sorted BAMs
  bam_files=("$dir_bam"/*_sorted.bam)
  echo "${bam_files[@]}"
  echo "GTF FILE : $gtf_file"
  echo "Output Dir :$dir_output"

  # Run featureCounts once for all BAMs
  featureCounts -a "$gtf_file" -o "$dir_output/gene_counts.txt" "${bam_files[@]}"
  if [ $? -ne 0 ]; then
    echo "Error: featureCounts failed. Check BAMs and GTF."
    exit 1
  fi
  echo "Quantification completed. Counts saved to $dir_output/gene_counts.t"

}
