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
#' data_path <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
#' sys_path <- "https://arcticdata.io/metacat/d1/mn/v2/meta/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
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

  if (.Platform$OS.type %in% c("unix", "linux")){
    # get the MIME type and do a little string massaging
    res <- system2("file",c("--mime-type", tp), stdout = TRUE)
    res_s <- stringr::str_extract(res, ":(.)*")
    res_s <- gsub(": ", "" ,res_s)
  } else {
    # on windows it guesses by extension only
    res_s <- mime::guess_type(tp)
  }


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
