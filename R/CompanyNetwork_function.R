#' @title One-Mode Company Network
#'
#' @description This function creates an company to company network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param start Start Year
#' @param end End Year
#' @export
#' @return One-Mode Company Network - igraph object
CompanyNetwork<-function(coynoLIST,mkey,start,end){

  INTERLOCK<-InterlockNetwork(coynoLIST,mkey,start,end)

  PROJECTION<-igraph::bipartite.projection(INTERLOCK)
  COMPANYnet<-PROJECTION[[1]]

  return(COMPANYnet)

}

