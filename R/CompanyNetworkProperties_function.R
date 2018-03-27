#' @title One-Mode Company Network Properties Table
#'
#' @description This function calculates network properties for the company to company network.
#' @param gs Company Network (igraph object)
#' @export
#' @return One-Mode Company Network Properties Table Data frame

CompanyNetworkProperties<-function(gs){
  net <- cbind(igraph::get.edgelist(gs, names=FALSE), igraph::E(gs)$weight)
  net <- suppressWarnings(tnet::symmetrise_w(net))
  net <- tnet::as.tnet(net, type="weighted one-mode tnet")

  WeightDegAll<-tnet::degree_w(net,measure=c("degree","output"), type="all")
  WeightedClustering<-tnet::clustering_w(net)

  Wall<-WeightDegAll[,3]
  Dall<-WeightDegAll[,2]

  BetCen<-igraph::centr_betw(gs)
  closenesscen<-igraph::centr_clo(gs,mode="total")
  DegAllCen<-igraph::centr_degree(gs,mode="all")
  EigCen<-igraph::centr_eigen(gs)

  AveragePathLength<-igraph::mean_distance(gs, directed=TRUE)
  AverageNodeStrengthAll<-mean(Wall)
  AverageDegreeAll<-mean(Dall)

  den<-igraph::graph.density(gs,loops=F)
  DIA<-igraph::diameter(gs, directed = F)
  size<-igraph::vcount(gs)

  CC<-igraph::transitivity(gs,"global")
  myDF<-data.frame(
    id="One-Mode Company network",
    Size=size,
    Density=den,
    Diameter=DIA,
    Average.path.lenth=AveragePathLength,
    Average.node.stregnth=AverageNodeStrengthAll,
    Average.Degree=AverageDegreeAll,
    Betweenness.Centralisation=BetCen$centralization,
    Closeness.Centralisation=closenesscen$centralization,
    Eigenvector.Centralisation=EigCen$centralization,
    Degree.Centralisation=DegAllCen$centralization,
    clustering.coefficent.transitivity=CC,
    Clustering.Weighted=WeightedClustering
  )
  myDF<-t(myDF)
  colnames(myDF)<-"One-Mode Company Network"
  myDF<-as.data.frame(myDF,stringsAsFactors = FALSE)
  myDF<-ITNr::round_df(myDF,digits=4)
  return(myDF)
}

