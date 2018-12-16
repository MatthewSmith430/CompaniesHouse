#' @title Company Search
#'
#' @description This function gives a list of companies, their company numbers and other information that match the company search term
#' @param company Company name search term
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode of all companies matching the search term
CompanySearch <- function(company,mkey) {
  firmNAME<-gsub(" ", "+",company)
  firmNAME<-gsub("&","%26",firmNAME)
  FIRMurl<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME)

  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)

  MM<-JLfirm$total_results
  MM2<-MM/JLfirm$items_per_page
  MM2b<-ceiling(MM2)

  DFfirmL<-list()

  for (j in 1:MM2b){
    FIRMurl2<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME,"&page_number=",j)

    firmTEST2<-httr::GET(FIRMurl2, httr::authenticate(mkey, ""))
    firmTEXT2<-httr::content(firmTEST2, as="text")
    JLfirm2<-jsonlite::fromJSON(firmTEXT2, flatten=TRUE)
    DFfirmL[[j]]<-JLfirm2
  }

  DFfirm<-plyr::ldply(DFfirmL,data.frame)

  DFfirmNAMES<-DFfirm$items.title
  DFfirmNUMBER<-as.character(DFfirm$items.company_number)
  DFfirmDateofCreation<-DFfirm$items.date_of_creation
  DFfirmTYPE<-DFfirm$items.company_type
  DFfirmSTATUS<-DFfirm$items.company_status
  DFfirmADDRESS<-DFfirm$items.address_snippet
  #DFfirmCOUNTRY<-DFfirm$items.address.country
  DFfirmLOCAL<-DFfirm$items.address.locality
  DFfirmPOSTCODE<-DFfirm$items.address.postal_code

  myDf <- data.frame(
    id.search.term = company,
    company.name=DFfirmNAMES,
    company.number = DFfirmNUMBER,
    Date.of.Creation = DFfirmDateofCreation,
    company.type = DFfirmTYPE,
    company.status = DFfirmSTATUS,
    address = DFfirmADDRESS,
    Locality = DFfirmLOCAL,
    postcode = DFfirmPOSTCODE)

  return(myDf)
}
