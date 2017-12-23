#' @title Check Nulls
#'
#' @description This function checks if data is NULL
#' @param x data
#' @export
#' @return NA if null, data otherwise
#'
CheckNulls <- function(x) {
  if(is.null(x)==TRUE) {
    return(NA)
  } else {
    return(x)
  }
}
