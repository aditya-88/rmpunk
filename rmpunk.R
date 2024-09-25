#!/usr/bin/env Rscript
# This small script will find any libraries that were imported but not used in an R script/ notebook
software <- "rmpunk"
version <- "0.0.1-alpha"

# Function to escape special characters in function names for regex
escape_special_chars <- function(string) {
  gsub("([][{}()^$|*+?.\\\\])", "\\\\\\1", string)
}


detect_unused_libraries <- function(script_path, output_path) {
  # Read the script content
  script_content <- readLines(script_path)
  
  # Extract all library calls
  library_calls <- grep(".*?\\s*(library|require)\\(([^)]+)\\)", script_content, value = TRUE)
  library_names <- gsub(".*?\\s*(library|require)\\(([^)]+)\\)", "\\2", library_calls)
  library_names <- gsub("[^[:alnum:]]", "", library_names)
  library_names <- unique(library_names)
  cat(paste0("Total libraries: ", length(library_names), "\n"))
  # Check usage of each library
  used_libraries <- character()
  for (lib in library_names) {
    if (!requireNamespace(lib, quietly = TRUE)) {
      next
    }
    lib_functions <- ls(getNamespace(lib), all.names = TRUE)
    for (func in lib_functions) {
      func_pattern <- paste0("\\b", escape_special_chars(func), "\\b")
      if (any(grepl(func_pattern, script_content))) {
        used_libraries <- c(used_libraries, lib)
        break
      }
    }
  }
  cat(paste0("Used libraries: ", length(used_libraries), "\n"))
  cat(paste0("Unused libraries: ", length(library_names) - length(used_libraries), "\n"))
  cat(paste0("Unused library names: ", paste(setdiff(library_names, used_libraries), collapse = ", "), "\n"))
  
  # Remove unused library calls
  cleaned_script_lines <- character()
  for (line in script_content) {
    if (grepl(".*?\\s*(library|require)\\(([^)]+)\\)", line)) {
      lib <- gsub(".*?\\s*(library|require)\\(([^)]+)\\)", "\\2", line)
      lib <- gsub("[\"')]", "", lib)
      if (!(lib %in% used_libraries)) {
        next
      }
    }
    cleaned_script_lines <- c(cleaned_script_lines, line)
  }
  
  # Write the cleaned script to a new file
  writeLines(cleaned_script_lines, output_path)
}

# Main function to read the script path from stdin and call the cleaning function
cat(paste0("Welcome to ", software, " version ", version, "\n"))
cat("RM: Remove; P: Packages; UN: Unused; K:Let's say its the K from pacKage\n\n")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  stop("Usage: Rscript clean_r_script.R <script_path>")
}

script_path <- args[1]
# Set the output path to the same folder as the input file
script_dir <- dirname(script_path)
script_name <- basename(script_path)
output_path <- file.path(script_dir, paste0("cleaned_", script_name))

detect_unused_libraries(script_path, output_path)
cat("Cleaned script saved to", output_path, "\n")