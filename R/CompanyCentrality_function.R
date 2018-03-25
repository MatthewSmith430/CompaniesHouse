#' @title One-Mode Company Network Centrality Table
#'
#' @description This function calculates a number of centrality metrics for the company to company network.
#' @param gs Company Network (igraph object)
#' @export
#' @return One-Mode Company Network Centrality Table Data frame
CompanyCentrality<-function(gs){
  if (sum(igraph::degree(gs)==0)==0){
    net <- cbind(igraph::get.edgelist(gs, names=FALSE), igraph::E(gs)$weight)
    net <- suppressWarnings(tnet::symmetrise_w(net))
    net <- tnet::as.tnet(net, type="weighted one-mode tnet")

    WeightDegAll<-tnet::degree_w(net,measure=c("degree","output"), type="all")
    WeightBet<-tnet::betweenness_w(net)

    WeightDegAll<-WeightDegAll[order(WeightDegAll[,1]),]
    WeightBet<-WeightBet[order(WeightBet[,1]),]

    Weighted.Degree<-WeightDegAll[,3]
    Binary.Degree<-WeightDegAll[,2]
    Betweenness<-WeightBet[,2]
    Closeness<-igraph::closeness(gs, mode="all")
    Eigenvector<-igraph::eigen_centrality(gs)$vector

    NAMES<-igraph::V(gs)$name
    TAB<-cbind(NAMES,Weighted.Degree,Binary.Degree,
               Betweenness,Closeness,Eigenvector)
    myDF<-as.data.frame(TAB)
    myDF<-ITNr::round_df(myDF,digits=4)
    return(myDF)
  }
  else{
    ISOLATES<-igraph::V(gs)[igraph::degree(gs)==0]$id
    gs<-igraph::delete.vertices(gs, igraph::V(gs)[igraph::degree(gs)==0])
    net <- cbind(igraph::get.edgelist(gs, names=FALSE), igraph::E(gs)$weight)
    net <- suppressWarnings(tnet::symmetrise_w(net))
    net <- tnet::as.tnet(net, type="weighted one-mode tnet")

    WeightDegAll<-tnet::degree_w(net,measure=c("degree","output"), type="all")
    WeightBet<-tnet::betweenness_w(net)

    WeightDegAll<-WeightDegAll[order(WeightDegAll[,1]),]
    WeightBet<-WeightBet[order(WeightBet[,1]),]

    Weighted.Degree.All<-WeightDegAll[,3]
    Binary.Degree.All<-WeightDegAll[,2]
    Betweenness<-WeightBet[,2]
    Closeness<-igraph::closeness(gs, mode="all")
    Eigenvector<-igraph::eigen_centrality(gs)$vector

    NAMES<-igraph::V(gs)$name
    TAB<-cbind(NAMES,
               Weighted.Degree.All,Binary.Degree.All,
               Betweenness,Closeness,Eigenvector)
    TAB2<-as.matrix(TAB)
    mm<-matrix("NA",length(ISOLATES),6)
    mm[,1]<-ISOLATES
    colhead<-c("NAMES","Weighted.Degree","Binary.Degree",
               "Betweenness","Closeness","Eigenvector")
    colnames(mm)<-colhead
    TAB2<-rbind(TAB,mm)
    TAB2<-TAB2[order(TAB2[,1]),]
    myDF<-as.data.frame(TAB2)
    myDF<-ITNr::round_df(myDF,digits=4)
    return(myDF)
  }
}
