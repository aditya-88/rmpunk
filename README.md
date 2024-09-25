# RMPUNK

`rmpunk` is a small R script designed to find and remove any libraries that were imported but not used in an R script or R Markdown file. This helps in cleaning up your code by removing unnecessary dependencies.

## Features

- Detects unused libraries in R scripts and R Markdown files.
- Removes unused library calls from the script.
- Outputs a cleaned version of the script.

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

## Example

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