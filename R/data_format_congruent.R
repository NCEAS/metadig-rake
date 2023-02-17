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
#' data_format_congruent(data_path, sys_path)
data_format_congruent <- function(data_path, sys_path){

  if (!file.exists(data_path)){
    stop("Could not find data file.")
  }

  if (!file.exists(sys_path)){
    stop("Could not find system metadata file.")
  }

  x <- XML::xmlParseDoc(sys_path)
  sys <- methods::new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))
  ext <- tools::file_ext(sys@fileName)

  res_s <- mime::guess_type(data_path)

  if (ext == "tif"){
    ext <- "tiff" # account for different tiff extensions
  }

  # get the corresponding dataone formatID from the MIME type
  formats <- dataone::listFormats(dataone::CNode("PROD"))
  i <- which(formats$MediaType == res_s & formats$Extension == ext)

  if (length(i) > 1){
    warning("Multiple DataONE formats match this file.")
  }

  if (length(i) == 0){
    warning("No DataONE formats match this file.")
    return(FALSE)
  }

  f_format <- formats$ID[i]

  # check if sysmeta matches formatID
  if (!(sys@formatId %in% f_format)) {
    return(FALSE)
  } else if (sys@formatId %in% f_format){
    return(TRUE)
  }

}
