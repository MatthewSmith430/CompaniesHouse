#' @title Weighted outdegree igraph2tnet
#'
#' @description This function calculates tnet weighted outdegree centrality directly on an igraph object and return a dataframe
#' @param gs igraph object
#' @param alpha alpha value
#' @export
#' @return Dataframe of weighted outdegree centrality results

wo_igraph2tnet<-function(gs,alpha){
  DF<-igraph::get.data.frame(gs,what="edges")
  DF<-dplyr::select(DF,"to","from","weight")
  DFV<-igraph::get.data.frame(gs,what="vertices")
  DFV<-dplyr::mutate(DFV,id_num=1:igraph::vcount(gs))
  DFV<-dplyr::select(DFV,"name","id_num")
  DF[["from"]] <- DFV[ match(DF[['from']], DFV[['name']] ) , 'id_num']
  DF[["to"]] <- DFV[ match(DF[['to']], DFV[['name']] ) , 'id_num']

  TN<-tnet::as.tnet(DF,type="weighted one-mode tnet")
  TN$w<-as.numeric(TN$w)
  DEG_O<-tnet::degree_w(net=TN,type="out",alpha=alpha)
  DEGO_DF<-as.data.frame(DEG_O,stringsAsFactors = FALSE)
  SWO<-scale(DEGO_DF$output)
  SWO<-SWO[,1]
  DEGO_DF<-dplyr::mutate(DEGO_DF,scale=SWO)
  colnames(DEGO_DF)<-c("id_num","outdegree","weighted_outdegree",
                       "WO_scaled")
  DEGO_DF<-merge(DFV,DEGO_DF,by="id_num",all.x=TRUE)
  DEGO_DF<-dplyr::select(DEGO_DF,-c("id_num"))
  DEGO_DF[is.na(DEGO_DF)]<-0
  return(DEGO_DF)

}
