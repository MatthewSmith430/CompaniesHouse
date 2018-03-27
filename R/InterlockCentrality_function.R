#' @title Two-Mode Interlocking Directorates Network Centrality Table
#'
#' @description This function calculates degree centrality for the interlocking directorates network.
#' @param gs Interlocking Directorates Network (igraph object)
#' @export
#' @return Two-Mode Interlocking Directorates Network Centrality Table Data frame

InterlockCentrality<-function(gs){
    NAMES<-igraph::V(gs)$name
    Degree.Centrality<-igraph::degree(gs)
    TAB<-cbind(NAMES,Degree.Centrality)
    myDF<-as.data.frame(TAB,stringsAsFactors=FALSE)
    myDF$NAMES<-as.character(myDF$NAMES)
    myDF$Degree.Centrality<-as.numeric(myDF$Degree.Centrality)
    return(myDF)
}

