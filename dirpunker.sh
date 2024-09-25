#!/bin/bash

# This BASH script finds all .R or .Rmd files in the given directory and runs the rmpunk.R Rscript on these files
# Get the complete path of the current directory and set rmpunk.R location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RMPUNK=$DIR/rmpunk.R
# Check if the user has provided a directory
if [ $# -eq 0 ]; then
  echo "Please provide a directory"
  exit 1
fi

# Check if the directory exists
if [ ! -d $1 ]; then
  echo "Directory does not exist"
  exit 1
fi

# Find all .R and .Rmd files in the directory
files=$(find $1 -type f -name "*.R" -o -name "*.Rmd")
# Skip the files that start with cleaned_
files=$(echo $files | tr ' ' '\n' | grep -v "cleaned_")

echo Files found: $files
# Loop through the files and run the rmpunk.R script using parallel processing using gnu parallel (if available)

if [ -x "$(command -v parallel)" ]; then
  echo "GNU Parallel available: Using parallel processing"
  echo $files | tr ' ' '\n' | parallel Rscript "$RMPUNK" {}
else
  echo "GNU parallel is not installed. Running the script sequentially"
  for file in $files; do
    Rscript "$RMPUNK" $file
  done
fi
