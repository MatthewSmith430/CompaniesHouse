#' @title Weighted clustering global igraph2tnet
#'
#' @description This function calculates tnet weighted global clustering directly on an igraph object and return a dataframe
#' @param gs igraph object
#' @param alpha alpha value
#' @export
#' @return Dataframe of weighted global clustering results results

clustering_global_igraph2tnet<-function(gs,alpha){
  DF<-igraph::get.data.frame(gs,what="edges")
  DF<-dplyr::select(DF,"to","from","weight")
  DFV<-igraph::get.data.frame(gs,what="vertices")
  DFV<-dplyr::mutate(DFV,id_num=1:igraph::vcount(gs))
  DFV<-dplyr::select(DFV,"name","id_num")
  DF[["from"]] <- DFV[ match(DF[['from']], DFV[['name']] ) , 'id_num']
  DF[["to"]] <- DFV[ match(DF[['to']], DFV[['name']] ) , 'id_num']

  TN<-tnet::as.tnet(DF,type="weighted one-mode tnet")
  TN$w<-as.numeric(TN$w)

  CW<-tnet::clustering_w(TN, measure=c("bi", "am", "gm", "ma", "mi"))

  DFRES<-data.frame(metric="weighted_global_clustering",
                    am_arithmetic_mean=CW[[2]],
                    gm_geometric_mean_method=CW[[3]],
                    mi_minimum_method=CW[[5]],
                    ma_maximum_method=CW[[4]],
                    bi_binary_measure=CW[[1]])
  return(DFRES)

}
