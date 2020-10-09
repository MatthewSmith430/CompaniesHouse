#' @title Person Search Limit First
#'
#' @description This function gives a list of companies, their company numbers and other information that match the company search term - but only for the first item
#' @param person person search term
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode of limited number companies matching the search term (according to best match)
PersonSearch_limit_first <- function(person,mkey) {
  firmNAME<-gsub(" ", "+",person)
  firmNAME<-gsub("&","%26",firmNAME)
  #FIRMurl<-paste0("https://api.companieshouse.gov.uk/search/officers?q=",firmNAME)
  FIRMurl<-paste0("https://api.company-information.service.gov.uk/search/officers?q=",firmNAME)

  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)
  DFfirm<-as.data.frame(JLfirm)

  DFfirm<-DFfirm[1,]

  PERSON_ID<-DFfirm$items.links.self

  PS<-strsplit(PERSON_ID,"/")
  PS1<-unlist(PS)[3]

  PERSON_DATA<-indiv_ExtractDirectorsData(PS1,mkey)


  return(PERSON_DATA)
}
