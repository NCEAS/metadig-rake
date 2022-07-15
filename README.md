# metadig-rake
MetaDIG rake, a cross-domain QA/QC library

## Installation

`metadigRake` is used alongside the `metadig` R package for running quality checks.

```
devtools::install_github("NCEAS/metadigRake@develop")
devtools::install_github("NCEAS/metadig-r")
```

## Examples

This example uses a check that uses `metadigRake::check_text_file_format()` to see if a text file can be parsed into a table given the number of header lines
and delimiter.

```
library(metadig)

metadataFile <- tempfile()
download.file("https://arcticdata.io/metacat/d1/mn/v2/object/doi%3A10.18739%2FA2CJ87N0J", metadataFile)

checkFile <- system.file("extdata/text_format_valid-check.xml", package = "metadigRake")

results <- runCheck(checkFile, metadataFile)
```

`check_text_file_format()` can also be run standalone on any given file.

```
data <- "'x';'y'\r1;2\r3;4"
file <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".txt")
writeLines(data, file)

check_text_file_format(file, delimiter = ";", header_lines = 1)
```
