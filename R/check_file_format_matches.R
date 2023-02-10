#' Check file format
#'
#' This checks whether a file's format matches documentation
#' in a file's DataONE system metadata. The output of `file filename.ext` (bash)
#' is checked against the [formatId](https://cn.dataone.org/cn/v2/formats)
#' in the system metadata for that file.
#'
#' @param data_path (char) A path to a data file
#' @param sys_path (char) A path to system metadata for the file
#'
#' @return (boolean) Whether or not the file type matches the formatId
#'
#' @import datapack
#' @export
#'
#' @examples
#' data_path <- system.file("extdata/test.csv", package = "metarake")
#' sys_path <- system.file("extdata/sysmeta.xml", package = "metarake")
#' check_file_format_matches(data_path, sys_path)
check_file_format_matches <- function(data_path, sys_path){

  if (!file.exists(data_path)){
    stop("Could not find data file.")
  }

  if (!file.exists(sys_path)){
    stop("Could not find system metadata file.")
  }

  x <- XML::xmlParseDoc(sys_path)
  sys <- methods::new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))

  res_s <- mime::guess_type(data_path)


  # get the corresponding dataone formatID from the MIME type
  formats <- dataone::listFormats(dataone::CNode("PROD"))
  i <- which(formats$MediaType == res_s)
  f_format <- formats$ID[i]

  # check if sysmeta matches formatID
  if (sys@formatId != f_format) {
    return(FALSE)
  } else if (sys@formatId == f_format){
    return(TRUE)
  }

}
