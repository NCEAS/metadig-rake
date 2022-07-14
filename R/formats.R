#' Example function
#'
#' Here is some documentation for this example function.
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
check_text_file_format <- function(path, delimiter, header_lines){

  stopifnot(inherits(path, "character"))
  stopifnot(inherits(delimiter, "character"))

  if (inherits(header_lines, "character")){
    header_lines = as.integer(header_lines)
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


  if (is.null(df)) {
    return(FALSE)
  } else if (nrow(df) > 0 & inherits(df, "data.frame")){
    return(TRUE)
  }

}
