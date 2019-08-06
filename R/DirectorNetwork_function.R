#' @title One-Mode Directors Network
#'
#' @description This function creates an director to director network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param start Start Year
#' @param end End Year
#' @export
#' @return One-Mode Director Network - igraph object
DirectorNetwork<-function(coynoLIST,mkey,start,end){
  INTERLOCK<-InterlockNetwork(coynoLIST,mkey,start,end)

  PROJECTION<-igraph::bipartite.projection(INTERLOCK)
  DIRECTORnet<-PROJECTION[[2]]

  return(DIRECTORnet)

}

