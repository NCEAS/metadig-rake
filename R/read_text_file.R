#' Read tabular data from a delimited text file
#'
#' This function takes a path, delimiter, and header lines to read in a file
#' returning the data as a data.frame if it is succesfull, and NULL if not.
#'
#' @param path (char) A path to a data file
#' @param delimiter (char) Record delimter to be used to parse the file
#' @param header_lines Number of header lines in the file
#'
#' @return (boolean) Whether or not the file could be parsed
#'
#' @export
#'
#' @examples
#' path <- system.file("extdata/test.csv", package = "metadigRake")
#' check_text_file_format(path, ",", 1)
read_text_file <- function(path, delimiter, header_lines){

  stopifnot(inherits(path, "character"))
  stopifnot(inherits(delimiter, "character"))

  if (inherits(header_lines, "character")){
    header_lines = as.integer(header_lines)
  }

  # assume that if no header is specified, there is one
  if (is.na(header_lines) | is.null(header_lines)){
    header_lines <- 1
  }

  if (header_lines == 1){

    df <- tryCatch(utils::read.table(path, sep = delimiter, header = TRUE),
                   error = function(err){
                     return(NULL)
                   }
    )

  } else if (header_lines > 1){

    df <- tryCatch(utils::read.table(path, sep = delimiter, header = TRUE, skip = header_lines - 1),
                   error = function(err){
                     return(NULL)
                   }
    )

  } else if (header_lines == 0){

    df <- tryCatch(utils::read.table(path, sep = delimiter, header = FALSE),
                   error = function(err){
                     return(NULL)
                   }
    )

  }


  return(df)

}
