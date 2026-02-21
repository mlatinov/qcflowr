
#### Source Functions ####
source("R/helpers.R")

#### Store and Receive Arguments from Bash ####
paths_list <- get_from_bash()

### Validate the Information from Bash ####
validate_from_bash()

### Process all the input files paths ####
process_data <- process_paths(paths_list)




