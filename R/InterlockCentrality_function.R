#' @title Two-Mode Interlocking Directorates Network Centrality Table
#'
#' @description This function calculates degree centrality for the interlocking directorates network.
#' @param gs Interlocking Directorates Network (igraph object)
#' @export
#' @return Two-Mode Interlocking Directorates Network Centrality Table Data frame

InterlockCentrality<-function(gs){
  if (sum(igraph::degree(gs)==0)==0){
    net <- cbind(igraph::get.edgelist(gs, names=FALSE), igraph::E(gs)$weight)
    net <- tnet::as.tnet(net, type="binary two-mode tnet")

    WeightDegAll<-tnet::degree_tm(net,measure=c("degree","output"))

    Degree.Centrality<-WeightDegAll[order(WeightDegAll[,1]),]

    NAMES<-igraph::V(gs)$name
    TAB<-cbind(NAMES,Degree.Centrality)
    myDF<-as.data.frame(TAB)
    return(myDF)
  }
  else{
    ISOLATES<-igraph::V(gs)[igraph::degree(gs)==0]$id
    gs<-igraph::delete.vertices(gs, igraph::V(gs)[igraph::degree(gs)==0])
    net <- cbind(igraph::get.edgelist(gs, names=FALSE), igraph::E(gs)$weight)
    net <- tnet::as.tnet(net, type="binary two-mode tnet")

    WeightDegAll<-tnet::degree_tm(net,measure=c("degree","output"))

    Degree.Centrality<-WeightDegAll[order(WeightDegAll[,1]),]

    NAMES<-igraph::V(gs)$name
    TAB<-cbind(NAMES,Degree.Centrality)
    TAB2<-as.matrix(TAB)
    mm<-matrix("NA",length(ISOLATES),2)
    mm[,1]<-ISOLATES
    colhead<-c("NAMES","Degree.Centrality")
    colnames(mm)<-colhead
    TAB2<-rbind(TAB,mm)
    TAB2<-TAB2[order(TAB2[,1]),]
    myDF<-as.data.frame(TAB2)
    return(myDF)
  }
}

