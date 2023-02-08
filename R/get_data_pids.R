#' Get data pids
#'
#' Given a metadata pid and member node, return the data pids that are documented by
#' the metadata by querying the member node.
#'
#' @param pid (char) Identifier of a metadata document
#' @param authoritative_node (char) Authoritative member node identifier (eg: urn:node:ARCTIC)
#'
#' @return (char) List of data pids
#'
#' @export
#'
#' @examples
#' pids <- get_data_pids("doi:10.18739/A2TH8BP4V", "urn:node:ARCTIC")
get_data_pids <- function(pid, authoritative_node){

  if (grepl("test", authoritative_node, ignore.case = TRUE)){
    cn <- dataone::CNode("STAGING")
  } else {
    cn <- dataone::CNode("PROD")
  }

  mn <- dataone::getMNode(cn, "urn:node:ARCTIC")

  res <- dataone::query(mn, list(q = paste0('id:', '\"', pid, '\"'),
                           fl = 'documents',
                           rows = 5000),
                 as = "data.frame")

  pids <- unlist(res$documents)

  return(pids)
}
