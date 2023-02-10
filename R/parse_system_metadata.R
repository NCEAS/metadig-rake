#' Parse system metadata
#'
#' Helper to parse system metadata from a string in one function call
#'
#' @param sysmeta (char) String representation of XML system metadata
#'
#' @return (SystemMetadata) SystemMetadata object
#'
#' @export
#'
#' @examples
#' sys_path <- system.file("extdata/sysmeta.xml", package = "metarake")
#' sys_char <- readChar(sys_path, file.info(sys_path)$size)
#' sys <- parse_system_metadata(sys_char)
parse_system_metadata <- function(sysmeta){

  x <- XML::xmlParse(sysmeta)
  sys <- methods::new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))

  return(sys)
}
