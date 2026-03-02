# QCFlowR

## Overview

**QCFlowR** is a comprehensive bioinformatics workflow for RNA-seq data quality control and analysis. It automates the entire pipeline from raw FASTQ file quality assessment through read trimming, genome alignment, and gene quantification.

## What It Does

QCFlowR performs the following sequential steps on your RNA-seq data:

1. **Pre-Trimming Quality Control** - Analyzes raw FASTQ files using FastQC to assess read quality before processing
2. **Read Trimming** - Removes low-quality bases and short reads using FASTP
   - Trims bases until average quality score ≥ 20
   - Discards reads shorter than 30 bp
3. **Post-Trimming Quality Control** - Re-evaluates FASTQ quality after trimming
4. **Genome Alignment** - Aligns reads to a reference genome using HISAT2
   - Automatically builds or reuses a HISAT2 index
   - Generates sorted BAM files with index files
5. **Gene Quantification** - Counts aligned reads per gene using featureCounts

## External Tools Required

The following bioinformatics tools must be installed and available in your system PATH:

| Tool | Purpose | Installation |
|------|---------|--------------|
| **FastQC** | Quality control for FASTQ files | `conda install -c bioconda fastqc` or download from [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) |
| **FASTP** | FASTQ file trimming and filtering | `conda install -c bioconda fastp` |
| **HISAT2** | Sequence alignment to reference genome | `conda install -c bioconda hisat2` |
| **SAMtools** | BAM file processing and indexing | `conda install -c bioconda samtools` |
| **featureCounts** | Gene quantification from BAM files | `conda install -c bioconda subread` |
| **R** | Statistical analysis (for quality summarization) | `conda install -c conda-forge r-base` or install from [R Project](https://www.r-project.org/) |

### Quick Installation with Conda

```bash
conda install -c bioconda fastqc fastp hisat2 samtools subread
conda install -c conda-forge r-base
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/mlatinov/qcflowr.git
cd qcflowr
```

2. Make the main script executable:
```bash
chmod +x bin/qcflowr.sh
```

3. Verify external tools are installed:
```bash
fastqc --version
fastp --version
hisat2 --version
samtools --version
featureCounts -v
Rscript --version
```

## Usage

### Basic Command

```bash
./bin/qcflowr.sh -i <input_dir> -o <output_dir> -r <ref_dir> -g <gtf_file>
```

### Parameters

| Flag | Parameter | Required | Description |
|------|-----------|----------|-------------|
| `-i` | input_dir | Yes | Directory containing input FASTQ files |
| `-o` | output_dir | Yes | Directory for output files (will be created if it doesn't exist) |
| `-r` | ref_dir | Yes | Directory containing reference genome FASTA file (*.fasta or *.fa) |
| `-g` | gtf_file | Yes | GTF annotation file for gene quantification |

### Example

```bash
# Prepare your directories
mkdir -p results
mkdir -p reference

# Run the workflow
./bin/qcflowr.sh \
  -i ./fastq_samples \
  -o ./results \
  -r ./reference \
  -g ./reference/annotation.gtf
```

## Input Requirements

### Input Directory Structure
```
fastq_samples/
├── sample1.fastq
├── sample2.fastq
└── sample3.fastq
```

- FASTQ files should have `.fastq` extension
- Raw, uncompressed FASTQ format

### Reference Directory Structure
```
reference/
├── genome.fa              # or genome.fasta
└── annotation.gtf         # (optional, can be in output dir)
```

- Genome FASTA file (supports *.fasta or *.fa extensions)
- HISAT2 index will be auto-generated in `reference/genome_index/`

## Output Files

The workflow generates the following output files in your output directory:

| File | Description |
|------|-------------|
| `pre_trimed_*` | FastQC reports for raw FASTQ files |
| `*_trimmed.fastq` | Trimmed FASTQ files after FASTP |
| `post_trimed_*` | FastQC reports for trimmed FASTQ files |
| `*_sorted.bam` | Aligned BAM files (sorted by position) |
| `*_sorted.bam.bai` | BAM index files |
| `*_hisat2.log` | HISAT2 alignment logs |

## Workflow Pipeline

```
Raw FASTQ Files
        ↓
    [FastQC] ← Pre-trimming QC
        ↓
    [FASTP] ← Trimming
        ↓
    [FastQC] ← Post-trimming QC
        ↓
    [HISAT2] ← Alignment to Reference
        ↓
    [featureCounts] ← Gene Quantification
        ↓
    Count Matrix
```

## System Requirements

- **OS**: Linux or macOS
- **Memory**: Minimum 4GB RAM (8GB+ recommended for large files)
- **Disk Space**: Sufficient space for input FASTQ + output BAM files (typically 2-5x input size)
- **Bash**: Version 4.0+

## Troubleshooting

### Issue: "Command not found" for FASTQC, HISAT2, etc.
**Solution**: Ensure all tools are installed and in your PATH. If using conda:
```bash
conda activate your_env_name
./bin/qcflowr.sh [options]
```

### Issue: "No FASTQ files found"
**Solution**: Verify input directory contains files with `.fastq` extension (not `.fq` or compressed `.gz`)

### Issue: "No FASTA found"
**Solution**: Ensure reference directory contains a file with `.fa` or `.fasta` extension

### Issue: HISAT2 index building fails
**Solution**: Ensure reference FASTA is valid and you have write permissions to the reference directory

## Notes

- The workflow creates intermediate files and directories automatically
- BAM alignment uses 8 parallel threads (configurable in source code)
- Quality control output is summarized using R scripts located in the `R/` directory
- FastQC HTML reports are cleaned up after processing to save space

## License

This project is provided as-is for research and educational purposes.

## Author

mlatinov

---

**For issues or improvements**, please visit the [GitHub repository](https://github.com/mlatinov/qcflowr).