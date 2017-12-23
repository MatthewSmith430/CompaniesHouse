#' @title One-Mode Directors Network
#'
#' @description This function creates an director to director network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @export
#' @return One-Mode Director Network - igraph object
DirectorNetwork<-function(coynoLIST,mkey){
  DATA<-list()
  for (i in 1:length(coynoLIST)){
    DATA[[i]]<-ExtractDirectorsData(coynoLIST[i],mkey)
  }
  Rdata<-plyr::ldply(DATA, data.frame)

  HH<-cbind(as.character(Rdata$id),as.character(Rdata$directors))
  colnames(HH)<-c("CompanyID","Director")
  HH2<-unique(HH)
  HH2[is.na(HH2)] <- "na"
  HH2<-as.data.frame(HH2)
  HH3<-dplyr::filter(HH2,HH2$Director!="na")

  INTERLOCK<- igraph::graph.data.frame(HH3)

  igraph::V(INTERLOCK)$type <- igraph::V(INTERLOCK)$name %in% HH3$Director

  PROJECTION<-igraph::bipartite.projection(INTERLOCK)
  DIRECTORnet<-PROJECTION[[2]]

  return(DIRECTORnet)

}

