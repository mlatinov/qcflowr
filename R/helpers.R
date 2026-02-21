
#### Function to Store and Receive Arguments from Bash ####
get_from_bash <- function() {
  
  # Take all the positional arguments from bash from Bash
  args <- commandArgs(trailingOnly = TRUE)
  input_file_path <- args[1]
  output_file_path <- args[2]
  csv_boolean <- args[3]
  summary_csv_boolean <- args[4]
  plot_boolean <- args[5]
  
  # Get Debug messages
  cat("R Getting the Bash input information...")
  cat("Argument input file path took:", input_file_path, "\n")
  cat("Argument output file path took:", output_file_path, "\n")
  cat("Argument csv took:", csv_boolean, "\n")
  cat("Argument summary csv took:", summary_csv_boolean, "\n")
  cat("Argument plot took:", plot_boolean, "\n")
  
  # Return a list with all the specification 
  return(list(
    input_file_path = input_file_path,
    output_dir_path = output_dir_path,
    csv_boolean = csv_boolean,
    summary_csv_boolean = summary_csv_boolean,
    plot_boolean = plot_boolean
  ))
}

