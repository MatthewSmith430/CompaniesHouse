#' @title One-Mode Company Network Properties Table
#'
#' @description This function calculates network properties for the company to company network.
#' @param gs Company Network (igraph object)
#' @export
#' @return One-Mode Company Network Properties Table Data frame

CompanyNetworkProperties<-function(gs){
  WeightDegAll<-wo_igraph2tnet(gs,alpha = 0.5)
  WeightedClustering<-clustering_global_igraph2tnet(gs,alpha = 0.5)
  WeightedClustering<-WeightedClustering$am_arithmetic_mean

  Wall<-WeightDegAll$weighted_outdegree
  Dall<-WeightDegAll$outdegree

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
  myDF<-as.data.frame(sapply(myDF, as.numeric))
  myDF<-ITNr::round_df(myDF,digits=4)
  rownames(myDF)<-c("Size", "Density", "Diameter", "Average.path.lenth",
                    "Average.node.stregnth","Average.Degree",
                    "Betweenness.Centralisation","Closeness.Centralisation",
                    "Eigenvector.Centralisation", "Degree.Centralisation",
                    "Clustering.coefficent.transitivity",
                    "Clustering.Weighted")
  return(myDF)
}

