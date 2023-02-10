# metadig-rake

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/NCEAS/metadig-rake/workflows/R-CMD-check/badge.svg)](https://github.com/NCEAS/metadig-rake/actions)
  <!-- badges: end -->

MetaDIG rake, a cross-domain QA/QC library

## Installation

`metarake` is used alongside the `metadig` R package for running quality checks.

```
devtools::install_github("NCEAS/metadig-rake@develop")
devtools::install_github("NCEAS/metadig-r")
```

## Examples

This example uses a check that uses `metarake::check_text_file_format()` to see if a text file can be parsed into a table given the number of header lines
and delimiter.

```
library(metadig)

metadataFile <- tempfile()
download.file("https://arcticdata.io/metacat/d1/mn/v2/object/doi%3A10.18739%2FA2CJ87N0J", metadataFile)

checkFile <- system.file("extdata/text_format_valid-check.xml", package = "metarake")

results <- runCheck(checkFile, metadataFile)
```

`check_text_file_parsable()` can also be run standalone on any given file.

```
library(metarake)

data <- "'x';'y'\r1;2\r3;4"
file <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".txt")
writeLines(data, file)

check_text_file_parsable(file, delimiter = ";", header_lines = 1)
```

