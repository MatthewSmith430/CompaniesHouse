#' @title One-Mode Company Network
#'
#' @description This function creates an company to company network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param start Start Year
#' @param end End Year
#' @param LABEL Node Label - TRUE/FALSE
#' @param NodeSize Node Size - default is 6, state number or CENTRALITY (weighted centrality)
#' @export
#' @return One-Mode Company Network - igraph object
CompanyNetworkPLOT<-function(coynoLIST,mkey,start,end,LABEL,NodeSize=6){

  COMPANYnet<-CompanyNetwork(coynoLIST,mkey,start,end)

  COMPnetwork<-intergraph::asNetwork(COMPANYnet)

  if (NodeSize=="CENTRALITY"){
    NAMElist<-network::get.vertex.attribute(COMPnetwork,"vertex.names")
    NAMElist<-as.data.frame(NAMElist,stringAsFactors=FALSE)
    colnames(NAMElist)<-"NAME"
    COMPANYcent<-one_mode_centrality(COMPANYnet)
    CC<-COMPANYcent
    NS<-CC[ order(match(CC$NAMES, NAMElist$NAME)), ]
    NodeSize<-NS$Weighted.Degree
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

