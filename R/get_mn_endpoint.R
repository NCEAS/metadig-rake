#' Get member node endpoint
#'
#' Given a member node identifier, return the endpoint.
#'
#' @param mn_id (char) Identifier of a member node
#'
#' @return (char) Endpoint to query node
#'
#' @export
#'
#' @examples
#' endpoint <- get_mn_endpoint("urn:node:ARCTIC")
get_mn_endpoint <- function(mn_id){

  if (!grepl("urn:node:", mn_id)){
    stop("Member node identifier invalid. Node identifiers should look like urn:node:ARCTIC")
  }

  if (grepl("test", mn_id, ignore.case = TRUE)){
    cn <- "https://cn-stage.test.dataone.org/cn/v2/node/"
  } else {
    cn <- "https://cn.dataone.org/cn/v2/node/"
  }

  url <- paste0(cn, mn_id)
  # get the base URL
  p <- httr::GET(url)
  node_info <- rawToChar(p$content)
  x <- XML::xmlParseDoc(node_info)
  n <- XML::getNodeSet(x, "/ns3:node/baseURL")
  # get the max version of MNread API supported
  s <- XML::getNodeSet(x, "/ns3:node/services/*[@name='MNRead']")
  s_vers <- sapply(s, XML::xmlGetAttr, "version")
  max_vers <- max(as.numeric(gsub("v", "", s_vers)))
  # stitch together the endpoint
  endpoint <- paste0(XML::xmlValue(n), "/v", max_vers, "/")

  return(endpoint)
}
