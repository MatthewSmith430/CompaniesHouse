#' @title One-Mode Network Centrality Table
#'
#' @description This function calculates a number of centrality metrics for the one-mode network ie.e either the company or director networks.
#' @param gs Company Network  or Director Network (igraph object)
#' @export
#' @return One-Mode Company Network Centrality Table Data frame
one_mode_centrality<-function(gs){
    igraph::V(gs)$Weighted.Degree<-igraph::strength(gs,mode="all")

    igraph::V(gs)$Binary.Degree<-igraph::degree(gs,mode="all")
    igraph::V(gs)$Betweenness<-igraph::betweenness(gs,directed = FALSE)
    igraph::V(gs)$Closeness<-suppressWarnings(igraph::closeness(gs,
                                                                mode="all"))

    igraph::V(gs)$Eigenvector<-igraph::eigen_centrality(gs)$vector

    myDF<-igraph::get.data.frame(gs,what="vertices")
    myDF$NAMES<-as.character(myDF$name)
    myDF$Weighted.Degree<-as.numeric(myDF$Weighted.Degree)
    myDF$Binary.Degree<-as.numeric(myDF$Binary.Degree)
    myDF$Betweenness<-as.numeric(myDF$Betweenness)
    myDF$Closeness<-as.numeric(myDF$Closeness)
    myDF$Eigenvector<-as.numeric(myDF$Eigenvector)
    myDF<-ITNr::round_df(myDF,digits=4)
    return(myDF)

  }

