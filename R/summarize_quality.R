
#### Summarize quality control and output a csv ####

## Libraries 
library(tidyverse)

# Take the arguments output dir provided by bash 
args <- commandArgs(trailingOnly = TRUE)
qc_dir <- args[1] # output dir
proc <- args[2] # pre_proc or post_proc

# List all summary.txt files
summary_files <- list.files(qc_dir, pattern="summary.txt$", recursive=TRUE, full.names=TRUE)
parse_summary <- function(file) {
  read_tsv(file, col_names = c("status", "module", "file"), show_col_types = FALSE)
}

# Combine all summaries
qc_data <- bind_rows(lapply(summary_files, parse_summary))

# Save the table as a csv and export it 
file_name <- paste(proc, "quality_report.csv", sep = "")

csv_file <- file.path(qc_dir, file_name)
write_csv(qc_data, csv_file)
cat("CSV report saved to:", csv_file, "\n")
  

