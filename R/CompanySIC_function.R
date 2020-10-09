#' @title Company SIC
#'
#' @description This function gives the company sector description - the SIC code.
#' @param coyno Company Number
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name and SIC code
CompanySIC <- function(coyno,mkey) {
  #FIRMurl<-paste0("https://api.companieshouse.gov.uk/company/",coyno)
  FIRMurl<-paste0("https://api.company-information.service.gov.uk/company/",coyno)

  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)

  return(JLfirm$sic_codes)
}
