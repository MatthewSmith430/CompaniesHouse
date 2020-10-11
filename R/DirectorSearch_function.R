#' @title Director Search
#'
#' @description This function gives a list of direcotrs that match the search term
#' @param director_name Director name search term
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode of all companies matching the search term
DirectorSearch <- function(director_name,mkey) {
  firmNAME<-gsub(" ", "+",director_name)
  firmNAME<-gsub("&","%26",firmNAME)
  #FIRMurl<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME)
  FIRMurl<-paste0("https://api.company-information.service.gov.uk/search/officers?q=",firmNAME)

  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)

  MM<-JLfirm$total_results
  MM2<-MM/JLfirm$items_per_page
  MM2b<-ceiling(MM2)

  DFfirmL<-list()

  for (j in 1:MM2b){
    #FIRMurl2<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME,"&page_number=",j)
    FIRMurl2<-paste0("https://api.company-information.service.gov.uk/search/officers?q=",firmNAME,"&page_number=",j)

    firmTEST2<-httr::GET(FIRMurl2, httr::authenticate(mkey, ""))
    firmTEXT2<-httr::content(firmTEST2, as="text")
    JLfirm2<-jsonlite::fromJSON(firmTEXT2, flatten=TRUE)
    DFfirmL[[j]]<-JLfirm2
  }

  DFfirm<-plyr::ldply(DFfirmL,data.frame)
  DFfirm<-unique(DFfirm)
  #suppressWarnings(purrr::map_df(DFfirmL,data.frame))


  DFfirmNAMES<-DFfirm$items.title
  DFfirmADDRESS<-DFfirm$items.address_snippet
  #DFfirmCOUNTRY<-DFfirm$items.address.country
  DFfirmLOCAL<-DFfirm$items.address.locality
  DFmonth<-DFfirm$items.date_of_birth.month
  DFyear<-DFfirm$items.date_of_birth.year

  LINK1<-DFfirm$items.links.self
  LINK2<-gsub("/officers/","",LINK1)
  LINK3<-gsub("/appointments","",LINK2)

  myDf <- data.frame(
    id.search.term = director_name,
    director.id=LINK3,
    person.name=DFfirmNAMES,
    addess.snippet = DFfirmADDRESS,
    locality= DFfirmLOCAL,
    month.of.birth=DFmonth,
    year.of.birth=DFyear
    )

  return(myDf)
}
