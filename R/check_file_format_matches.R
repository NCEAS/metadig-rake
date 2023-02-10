#' Check file format
#'
#' This checks whether a file's format matches documentation
#' in a file's DataONE system metadata. The output of `file filename.ext` (bash)
#' is checked against the [formatId](https://cn.dataone.org/cn/v2/formats)
#' in the system metadata for that file.
#'
#' @param data_path (char) A path or URL to a data file
#' @param sys_path (char) A path or URL to system metadata for the file
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

  # if it looks like a URL download the sysmeta
  if (grepl("http", sys_path)){
    ts <- tempfile()
    utils::download.file(sys_path, ts, quiet = TRUE)
  } else {
    ts <- sys_path
  }

  # parse the sysmeta
  x <- XML::xmlParseDoc(ts)
  sys <- methods::new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))

  # if it looks like a URL download the file
  if (grepl("http", data_path)){
    ext <- tools::file_ext(sys@fileName)
    tp <- tempfile(fileext = paste0(".", ext))
    utils::download.file(data_path, tp, quiet = TRUE)
  } else {
    tp <- data_path
  }

  if (!file.exists(ts)){
    stop("Could not find system metadata file.")
  }

  if (!file.exists(tp)){
    stop("Could not find data file.")
  }

    res_s <- mime::guess_type(tp)


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
