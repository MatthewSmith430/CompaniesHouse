#' @title Document Download
#'
#' @description This function downloads a file to the specified location. It's a wrapper for
#' \code{download.file} and helps extract lots of files into ordered directory trees.
#' Use with \code{doc_meta_extract} and \code{doc_getlink} for best results.
#' @param doc_id Document number
#' @param mkey Authorisation key
#' @param dl_loc The location you want to download the file to, ending in a \code{'/'}. Directories will
#' be created recursively if they don't exist
#' @param filename The name you want to give the file
#' @param doc_type The filetype of the document. Should be one of \code{'application/pdf'},
#' \code{'application/json'}, \code{'application/xml'}, \code{'application/xhtml+xml'} or \code{'text/csv'}
#' @export
#' @return Downloads the file to the location specified in the specified format. Expect warning messages for directories that exist
#'

source('./R/doc_getlink_function.R')

doc_download <- function(doc_id, mkey, dl_loc, filename, doc_type){
  stopifnot(is.character(doc_id),
            is.character(mkey),
            is.character(dl_loc),
            is.character(filename),
            is.character(doc_type))
  dir.create(dl_loc, recursive = TRUE)

  # Strip any added file extentions and re-gen from requested filetype

  if (sub('^(.*\\.)', '', filename, ignore.case = TRUE) %in% c('pdf', 'json', 'xml', 'xhtml', 'csv')){
    filename <- sub('\\.(?!.*\\.).*', '', filename, ignore.case = TRUE, perl = TRUE)
  }

  file_ext <- sub('^(.*[\\/])', '', doc_type, perl = TRUE)
  file_ext <- sub('(\\+.*)$', '', file_ext, perl = TRUE)

  if (!(file_ext %in% c('pdf', 'json', 'xml', 'xhtml', 'csv'))){
    # This assumes a doc_type of one of the following:
    # application/pdf
    # application/json
    # application/xml
    # application/xhtml+xml
    # text/csv
    stop(paste0('Filetype ', file_ext, ' not currently handled. Raise issue on github.'))
  }

  # Download file to directory

  download.file(doc_getlink(doc_id, mkey, doc_type),
                paste0(dl_loc, filename, '.', file_ext),
                mode = 'wb',
                headers = c(Accept = doc_type))

}
