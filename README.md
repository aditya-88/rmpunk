# RMPUNK

`rmpunk` is a small R script designed to find and remove any libraries that were imported but not used in an R script or R Markdown file. This helps in cleaning up your code by removing unnecessary dependencies.

## Features

- Detects unused libraries in R scripts and R Markdown files.
- Removes unused library calls from the script.
- Outputs a cleaned version of the script.
- Intutively skips processed files.

## Installation

To use `rmpunk`, you need to have R installed on your system. You can download and install R from [CRAN](https://cran.r-project.org/).

## Usage

1. Clone this repository or download the `rmpunk.R` script.

2. Run the script from the terminal with the path to your R script or R Markdown file:

    ```sh
    Rscript rmpunk.R path/to/your_script.R
    ```

    Replace `path/to/your_script.R` with the actual path to your R script or R Markdown file.

3. The cleaned script will be saved in the same directory with the prefix `cleaned_`.

### dirpunker.sh

`dirpunker.sh` is a shell script that applies `rmpunk.R` to all R scripts (`.R` or `.Rmd` files) in a specified directory. This requires a `Unix/ Linux` system. The program optionally (recommended) uses `GNU parallel`, if availabe, to multi-thread the run.

1. Clone this repository or download the `dirpunker.sh` script.

2. Make the script executable:

    ```bash
    chmod +x dirpunker.sh
    ```

3. Run the script from the terminal with the path to the directory containing your R scripts:

    ```bash
    ./dirpunker.sh path/to/your_directory
    ```

    Replace `path/to/your_directory` with the actual path to the directory containing your R scripts.

4. The cleaned scripts will be saved in the same directory with the prefix `cleaned_`.

## Example

### rmpunk.R

Suppose you have an R script `example.R` with the following content:

```r
suppressWarnings(library(dplyr))
library(ggplot2)

# Some code that uses ggplot2 but not dplyr
```
Run RMPUNK!

```bash
Rscript rmpunk.R example.R
```

Output file `cleaned_example.R` saved in the input file directory

```r
library(ggplot2)

# Some code that uses ggplot2 but not dplyr
```

### dirpunker.sh

Suppose you have a directory `scripts` containing multiple R scripts:

```bash
scripts/
├── script1.R
├── script2.R
└── script3.R
```

Running dirpunker.sh on this directory:

```bash
./dirpunker.sh scripts
```

Will produce cleaned scripts for each R script in the directory:

```bash
scripts/
├── cleaned_script1.R
├── cleaned_script2.R
├── cleaned_script3.R
├── script1.R
├── script2.R
└── script3.R
```
## Limitations

**Warning**

**If you are sourcing packages from different `.R` file(s) into your script, these packages WILL be removed from the source file as these are not used in those files. Only use `RMPUNK` on files where you are not sourcing other files. This feature is planned for a future release.**

If there are overlapping library modules and you happen to import these libraries but use only one of them, all of these packages that have an overlapping module would be retained.

## To do

1. Add a method to process `source` R file packages.