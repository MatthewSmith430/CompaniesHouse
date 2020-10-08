#' @title Generate Document Download Link
#'
#' @description This function generates the download link for a particular document. Use with \code{doc_meta_extract}
#' for best results
#' @param doc_id Document number
#' @param mkey Authorisation key
#' @param doc_type The filetype of the document. Should be one of \code{'application/pdf'},
#' \code{'application/json'}, \code{'application/xml'}, \code{'application/xhtml+xml'} or \code{'text/csv'}
#' @export
#' @return Character vector of document location
#'

doc_getlink <- function(doc_id, mkey, doc_type){
  stopifnot(is.character(doc_id),
            is.character(mkey),
            is.character(doc_type))

  # Request document location

  rq.url <- paste0('http://document-api.companieshouse.gov.uk/document/',
                   doc_id,
                   '/content')
  rq.get <- httr::GET(rq.url,
                      httr::authenticate(mkey, ''),
                      httr::add_headers(Accept = doc_type),
                      httr::config(followlocation = FALSE))

  if (rq.get$status_code != 302){
    stop(paste0('Document locator returned with status code ', rq.get$status_code, '. (302 is success)'))
  }

  loc.get <- httr::GET(rq.get$headers$location)

  return(loc.get$url)

}
