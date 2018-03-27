#' @title One-Mode Company Network
#'
#' @description This function creates an company to company network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param LABEL Node Label - TRUE/FALSE
#' @param NodeSize Node Size - default is 6, place number or CENTRALITY (weighted centrality)
#' @export
#' @return One-Mode Company Network - igraph object
CompanyNetworkPLOT<-function(coynoLIST,mkey,LABEL,NodeSize){
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
  INTERLOCK<-igraph::graph.data.frame(HH3)

  igraph::V(INTERLOCK)$type <- igraph::V(INTERLOCK)$name %in% HH3$Director

  PROJECTION<-igraph::bipartite.projection(INTERLOCK)
  COMPANYnet<-PROJECTION[[1]]

  igraph::V(COMPANYnet)$type <- igraph::V(COMPANYnet)$name %in% HH3$Director
  D1<-igraph::V(COMPANYnet)$type
  DC<-as.character(D1)
  DC<-gsub("TRUE", "Director", DC)
  DC<-gsub("FALSE", "Company", DC)
  igraph::V(COMPANYnet)$DC<-as.vector(DC)

  COMPnetwork<-intergraph::asNetwork(COMPANYnet)

  if (NodeSize=="CENTRALITY"){
    NAMElist<-network::get.vertex.attribute(COMPnetwork,"vertex.names")
    NAMElist<-as.data.frame(NAMElist,stringAsFactors=FALSE)
    colnames(NAMElist)<-"NAME"
    COMPANYcent<-CompanyCentrality(COMPANYnet)
    CC<-COMPANYcent
    NS<-CC[ order(match(CC$NAMES, NAMElist$NAME)), ]
    NodeSize<-NS$Weighted.Degree.All
  }else{NodeSize<-NodeSize}

  if (LABEL==TRUE){
    GGally::ggnet2(COMPnetwork,
                   node.size=NodeSize,node.color = "#E41A1C",#edge.size = "weight",
                   label = TRUE,label.size = 2.5,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(color = FALSE, size = FALSE)
  } else{
    GGally::ggnet2(COMPnetwork,
                   node.size=NodeSize,node.color = "#E41A1C",#edge.size = "weight",
                   label = FALSE,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(color = FALSE, size = FALSE)
  }


}

