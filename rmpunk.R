#!/usr/bin/env Rscript
# This small script will find any libraries that were imported but not used in an R script/ notebook
software <- "rmpunk"
version <- "1.0.0"

escape_special_chars <- function(string) {
  gsub("([][{}()^$|*+?.\\\\])", "\\\\\\1", string)
}

detect_unused_libraries <- function(script_path) {
  # Define the output path and the original folder path
  script_dir <- dirname(script_path)
  script_name <- basename(script_path)
  original_folder <- file.path(script_dir, "original")
  output_path <- script_path
  
  # Create the original folder if it doesn't exist
  if (!dir.exists(original_folder)) {
    dir.create(original_folder)
  }
  
  # Move the original file to the original folder
  file.rename(script_path, file.path(original_folder, script_name))
  
  # Read the script content
  script_content <- suppressMessages(suppressWarnings(readLines(file.path(original_folder, script_name))))
  
  # Extract all library calls
  library_calls <- grep(".*?\\s*(library|require)\\(([^)]+)\\)", script_content, value = TRUE)
  library_names <- gsub(".*?\\s*(library|require)\\(([^)]+)\\)", "\\2", library_calls)
  # Drop () or quotes if present
  library_names <- gsub("[\"'()]", "", library_names)
  library_names <- unique(library_names)
  cat(paste0("Total libraries: ", length(library_names), "\n"))
  
  # Check usage of each library
  used_libraries <- character()
  for (lib in library_names) {
    if (!requireNamespace(lib, quietly = TRUE)) {
      cat(paste0("Warning: ", lib, " is not installed. Retaining unchecked!\n"))
      used_libraries <- c(used_libraries, lib)
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
  
  # Remove unused library calls
  cleaned_script_lines <- character()
  for (line in script_content) {
    if (grepl(".*?\\s*(library|require)\\(([^)]+)\\)", line)) {
      lib <- gsub(".*?\\s*(library|require)\\(([^)]+)\\)", "\\2", line)
      lib <- gsub("[\"'()]", "", lib)
      if (!(lib %in% used_libraries)) {
        next
      }
    }
    cleaned_script_lines <- c(cleaned_script_lines, line)
  }
  
  # Write the cleaned script to the original location with the same name
  writeLines(cleaned_script_lines, output_path)
  # Print the removed libraries
  cat(paste0("Removed libraries: ", paste(setdiff(library_names, used_libraries), collapse = ", "), "\n"))
}

# Main function to read the script path from stdin and call the cleaning function
cat("_______________________________________________\n")
cat(paste0("Welcome to ", software, " version ", version, "\n"))
cat("RM: Remove; P: Packages; UN: Unused; K: Let's say it's the K from pacKage\n")
cat("_______________________________________________\n")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  stop("Usage: Rscript rmpunk.R <script_path>")
}

script_path <- args[1]
detect_unused_libraries(script_path)
cat("Cleaned script saved to", script_path, "\n")
cat(paste0("Thank you for using ", software, " version ", version, "\n"))
cat("_______________________________________________\n")