#' @title Director Search Limit
#'
#' @description This function gives a list of direcotrs that match the search term - but only for the first page
#' @param director_name Director name search term
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode of all companies matching the search term
DirectorSearch_limit <- function(director_name,mkey) {
  firmNAME<-gsub(" ", "+",director_name)
  firmNAME<-gsub("&","%26",firmNAME)
  #FIRMurl<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME)
  FIRMurl<-paste0("https://api.company-information.service.gov.uk/search/officers?q=",firmNAME)

  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)
  DFfirm<-as.data.frame(JLfirm)
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
