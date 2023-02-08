#' Check if a text file is parsable
#'
#' This is a wrapper around the helper `read_text_file` which returns TRUE if
#' the file is read in successfully and NULL if not.
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
#' check_text_file_parsable(path, ",", 1)
check_text_file_parsable <- function(path, delimiter, header_lines){

  df <- read_text_file(path, delimiter, header_lines)

  if (is.null(df)) {
    return(FALSE)
  } else if (nrow(df) > 0 & inherits(df, "data.frame")){
    return(TRUE)
  }

}
