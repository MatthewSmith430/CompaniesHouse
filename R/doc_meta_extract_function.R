#' @title Document Metadata Extraction
#'
#' @description This function returns the metadata of a particular document number
#' @param doc_id Document number
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company number, document number, date, date type, document type and document format
#'

doc_meta_extract <- function(doc_id, mkey){
  stopifnot(is.character(doc_id), is.character(mkey))

  rq.url <- paste0('http://document-api.companieshouse.gov.uk/document/',
                   doc_id)
  rq.get <- httr::GET(rq.url, httr::authenticate(mkey, ''))

  if (rq.get$status_code != 200){
    stop(paste0('Request returned with status code ', rq.get$status_code, '. (200 is success)'))
  }

  rq.contents <- httr::content(rq.get, as = 'text')
  rq.js <- jsonlite::fromJSON(rq.contents, flatten = TRUE)

  df <- data.frame(company_id = rq.js$company_number,
                   doc_id = doc_id,
                   significant_date = ITNr::isEmpty(rq.js$significant_date),
                   significant_date_type = ITNr::isEmpty(rq.js$significant_date_type),
                   category = ITNr::isEmpty(rq.js$category),
                   resource_types = names(rq.js$resources))

  if (nrow(df) == 0){
    stop('Frame of 0 rows returned. Step through with debug() to check.')
  }

  return(df)

}
