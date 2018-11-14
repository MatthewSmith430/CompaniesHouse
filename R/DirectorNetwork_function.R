#' @title One-Mode Directors Network
#'
#' @description This function creates an director to director network from a list of company numbers, the one-mode projection of the interlocking directorates network
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param YEAR Year - put CURRENT for current realisation of the network
#' @export
#' @return One-Mode Director Network - igraph object
DirectorNetwork<-function(coynoLIST,mkey,YEAR){
  DATA<-list()
  for (i in 1:length(coynoLIST)){
    DATA[[i]]<-company_ExtractDirectorsData(coynoLIST[i],mkey)
  }
  Rdata<-plyr::ldply(DATA, data.frame)


  if (YEAR=="CURRENT"){
    Rdata2<-dplyr::filter(Rdata,is.na(Rdata$end.date))
  }else{

    YEAR2<-paste0(as.character(YEAR),"-01-01")
    Rdata$start.date<-as.Date(Rdata$start.date, format = "%Y-%m-%d")
    Rdata$end.date<-as.Date(Rdata$end.date, format = "%Y-%m-%d")
    Rdata2A<-dplyr::filter(Rdata,Rdata$start.date<=YEAR2&is.na(Rdata$end.date))

    Rdata2B<-dplyr::filter(Rdata,Rdata$start.date<=YEAR2&Rdata$end.date>=YEAR2)
    Rdata2<-rbind(Rdata2A,Rdata2B)
    }
  HH<-cbind(as.character(Rdata2$company.id),as.character(Rdata2$directors))
  colnames(HH)<-c("CompanyID","Director")
  HH2<-unique(HH)
  HH2[is.na(HH2)] <- "na"
  HH2<-as.data.frame(HH2)
  HH3<-dplyr::filter(HH2,HH2$Director!="na")

  INTERLOCK<- igraph::graph.data.frame(HH3)

  igraph::V(INTERLOCK)$type <- igraph::V(INTERLOCK)$name %in% HH3$Director

  PROJECTION<-igraph::bipartite.projection(INTERLOCK)
  DIRECTORnet<-PROJECTION[[2]]

  DIR_NAME<-igraph::get.data.frame(DIRECTORnet,what="vertices")

  DIR_ATTR<-merge(x = DIR_NAME,y=Rdata2,by.x="name",by.y ="directors",
                  all.x = TRUE,all.y = FALSE )
  DIR_ATTR$company.id<-NULL
  DIR_ATTR$start.date<-NULL
  DIR_ATTR$end.date<-NULL
  DIR_ATTR<-unique(DIR_ATTR)

  DIR_ATTR2<-ITNr::reorder_df(DIR_ATTR,"name",DIR_NAME$name)

  igraph::V(DIRECTORnet)$nationality<-DIR_ATTR2$nationality

  igraph::V(DIRECTORnet)$birth.year<-DIR_ATTR2$birth.year


  return(DIRECTORnet)

}

