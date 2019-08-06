#' @title Make an interlocking directorates network
#'
#' @description This function creates an interlocking directorates network from a dataframe with company and director data
#' @param DF Dataframe - column 1 Companies, Column 2 - Directors
#' @export
#' @return Two-Mode Interlocking Directorates Network - igraph object
make_interlock<-function(DF){
  HH<-cbind(as.character(DF[,1]),as.character(DF[,2]))
  colnames(HH)<-c("CompanyID","Director")
  HH2<-unique(HH)
  HH2[is.na(HH2)] <- "na"
  HH2<-as.data.frame(HH2)
  HH3<-dplyr::filter(HH2,HH2$Director!="na")

  INTERLOCK<- igraph::graph.data.frame(HH3)

  igraph::V(INTERLOCK)$type <- igraph::V(INTERLOCK)$name %in% HH3$Director

  return(INTERLOCK)

}

