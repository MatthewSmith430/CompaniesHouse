#' @title empty2na
#'
#' @description Check is an object is empty and return "NA if it is.
#' @param x data
#' @export
#' @return NA if empty, data otherwise
#'
empty2na<-function(x){
  CHECKres<-rapportools::is.empty(x)
  if (CHECKres==TRUE){
    d<-"NA"
  }else{d<-x}
  return(d)
}

