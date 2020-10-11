#' @title One-Mode Directors Network
#'
#' @description This function creates an director to director network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param LABEL Node Label - TRUE/FALSE
#' @param NodeSize Node Size - default is 6, place number or CENTRALITY (weighted centrality)
#' @param start Start Year
#' @param end End Year
#' @export
#' @return One-Mode Director Network - igraph object
DirectorNetworkPLOT<-function(coynoLIST,mkey,LABEL,NodeSize=6,start,end){

  DIRECTORnet<-DirectorNetwork(coynoLIST,mkey,start,end)

  #igraph::V(DIRECTORnet)$type <-igraph::V(DIRECTORnet)$name %in% HH3$Director
  #D1<-igraph::V(DIRECTORnet)$type
  #DC<-as.character(D1)
  #DC<-gsub("TRUE", "Director", DC)
  #DC<-gsub("FALSE", "Company", DC)
  #igraph::V(DIRECTORnet)$DC<-as.vector(DC)

  DIRnetwork<-intergraph::asNetwork(DIRECTORnet)

  if (NodeSize=="CENTRALITY"){
    NAMElist<-network::get.vertex.attribute(DIRnetwork,"vertex.names")
    NAMElist<-as.data.frame(NAMElist,stringAsFactors=FALSE)
    colnames(NAMElist)<-"NAME"
    DIRcent<-one_mode_centrality(DIRECTORnet)
    CC<-DIRcent
    NS<-CC[ order(match(CC$NAMES, NAMElist$NAME)), ]
    NodeSize<-NS$Weighted.Degree
  }else{NodeSize<-NodeSize}

  if (LABEL==TRUE){
    GGally::ggnet2(DIRnetwork,
                   node.size=NodeSize,node.color = "#377EB8",#edge.size = "weight",
                   label = TRUE,label.size = 2.5,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(color = FALSE, size = FALSE)
  } else{
    GGally::ggnet2(DIRnetwork,
                   node.size=NodeSize,node.color = "#377EB8",#edge.size = "weight",
                   label = FALSE,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(color = FALSE, size = FALSE)
  }



}

