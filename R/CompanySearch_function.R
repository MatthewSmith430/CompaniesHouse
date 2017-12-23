#' @title Company Search
#'
#' @description This function gives a list of companies, their company numbers and other information that match the company search term
#' @param company Company name search term
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode of all companies matching the search term
CompanySearch <- function(company,mkey) {
  firmNAME<-gsub(" ", "+",company)
  FIRMurl<-paste0("https://api.companieshouse.gov.uk/search/companies?q=",firmNAME)
  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)
  DFfirm<-data.frame(JLfirm)

  DFfirmNAMES<-DFfirm$items.title
  DFfirmNUMBER<-as.character(DFfirm$items.company_number)
  DFfirmDateofCreation<-DFfirm$items.date_of_creation
  DFfirmTYPE<-DFfirm$items.company_type
  DFfirmSTATUS<-DFfirm$items.company_status
  DFfirmADDRESS<-DFfirm$items.address_snippet
  DFfirmCOUNTRY<-DFfirm$items.address.country
  DFfirmPOSTCODE<-DFfirm$items.address.postal_code

  myDf <- data.frame(
    id.search.term = company,
    company.name=DFfirmNAMES,
    company.number = DFfirmNUMBER,
    Date.of.Creation = DFfirmDateofCreation,
    company.type = DFfirmTYPE,
    company.status = DFfirmSTATUS,
    address = DFfirmADDRESS,
    country = DFfirmCOUNTRY,
    postcode = DFfirmPOSTCODE)

  return(myDf)
}
