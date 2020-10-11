#' @title Weighted indegree igraph2tnet
#'
#' @description This function calculates tnet weighted indegree centrality directly on an igraph object and return a dataframe
#' @param gs igraph object
#' @param alpha alpha value
#' @export
#' @return Dataframe of weighted outdegree centrality results

wi_igraph2tnet<-function(gs,alpha){
  DF<-igraph::get.data.frame(gs,what="edges")
  DF<-dplyr::select(DF,"to","from","weight")
  DFV<-igraph::get.data.frame(gs,what="vertices")
  DFV<-dplyr::mutate(DFV,id_num=1:igraph::vcount(gs))
  DFV<-dplyr::select(DFV,"name","id_num")
  DF[["from"]] <- DFV[ match(DF[['from']], DFV[['name']] ) , 'id_num']
  DF[["to"]] <- DFV[ match(DF[['to']], DFV[['name']] ) , 'id_num']

  TN<-tnet::as.tnet(DF,type="weighted one-mode tnet")
  TN$w<-as.numeric(TN$w)
  DEG_I<-tnet::degree_w(net=TN,type="out",alpha=alpha)
  DEGI_DF<-as.data.frame(DEG_I,stringsAsFactors = FALSE)
  SWI<-scale(DEGI_DF$output)
  SWI<-SWI[,1]
  DEGI_DF<-dplyr::mutate(DEGI_DF,scale=SWI)
  colnames(DEGI_DF)<-c("id_num","indegree","weighted_indegree",
                       "WI_scaled")
  DEGI_DF<-merge(DFV,DEGI_DF,by="id_num",all.x=TRUE)
  DEGI_DF<-dplyr::select(DEGI_DF,-c("id_num"))
  DEGI_DF[is.na(DEGI_DF)]<-0
  return(DEGI_DF)

}
