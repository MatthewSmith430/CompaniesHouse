#' @title Company Data Extraction
#'
#' @description This function extracts company information based on a company number
#' @param company_number Company number
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company name, company number, postcode, SIC code for the company number
CompanyDataExtract <- function(company_number,mkey) {
  company_number<-as.character(company_number)
  FIRMurl<-paste0("https://api.companieshouse.gov.uk/company/",company_number)
  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)
  CPF<-JLfirm[[1]][[1]]=="company-profile-not-found"
  if (CPF==TRUE){
    myDf <- data.frame(
      company.number = company_number,
      company.name="company-profile-not-found",
      sic.code="NA",
      Date.of.Creation = "NA",
      company.type = "NA",
      company.status = ,
      address = "NA",
      locality = "NA",
      region = "NA",
      postcode = "NA")
  }else{
    if (length(JLfirm)<16){
      #DFfirm<-suppressWarnings(purrr::map_df(JLfirm,data.frame))
      DFfirm<-plyr::ldply(JLfirm,data.frame)

      DFfirm2<-t(DFfirm)
      DFfirm2<-as.data.frame(DFfirm2)
      R<-DFfirm2[1,]
      R<-unlist(R)
      R<-as.character(R)
      colnames(DFfirm2)<-R
      DFfirm2<-DFfirm2[-1,]
      K<-DFfirm2[1,]
      DFfirmNAMES<-empty2na(as.character(K$company_name))
      DFfirmSIC<-"NA"
      DFfirmNUMBER<-empty2na(as.character(K$company_number))
      DFfirmDateofCreation<-"NA"
      DFfirmTYPE<-"NA"#empty2na(as.character(DFfirm$type))
      DFfirmSTATUS<-"NA"#empty2na(as.character(DFfirm$company_status))
      DFfirmADDRESS<-"NA"#empty2na(as.character(DFfirm$registered_office_address.address_line_1))
      DFfirmLOCAL<-"NA"#empty2na(as.character(DFfirm$registered_office_address.locality))
      DFfirmREGION<-"NA"#empty2na(as.character(DFfirm$registered_office_address.region))
      DFfirmPOSTCODE<-"NA"#empty2na(as.character(DFfirm$registered_office_address.postal_code))

      myDf <- data.frame(
        company.number = DFfirmNUMBER,
        company.name=DFfirmNAMES,
        sic.code=DFfirmSIC,
        Date.of.Creation = DFfirmDateofCreation,
        company.type = DFfirmTYPE,
        company.status = DFfirmSTATUS,
        address = DFfirmADDRESS,
        locality = DFfirmLOCAL,
        region = DFfirmREGION,
        postcode = DFfirmPOSTCODE)
    }else{
      DFfirm<-data.frame(t(sapply(JLfirm,c)))

      ADDRESS_DATA<-DFfirm$registered_office_address
      ADDRESS_DATA<-plyr::ldply(ADDRESS_DATA,data.frame)
        #suppressWarnings(purrr::map_df(ADDRESS_DATA,data.frame))

      DFfirmNAMES<-as.character(DFfirm$company_name)
      DFfirmSIC<-empty2na(as.character(DFfirm$sic_codes[[1]][[1]]))
      DFfirmNUMBER<-empty2na(as.character(DFfirm$company_number))
      DFfirmDateofCreation<-empty2na(as.character(DFfirm$date_of_creation))
      DFfirmTYPE<-empty2na(as.character(DFfirm$type))
      DFfirmSTATUS<-empty2na(as.character(DFfirm$company_status))
      DFfirmADDRESS<-empty2na(as.character(ADDRESS_DATA$address_line_1))
      DFfirmLOCAL<-empty2na(as.character(ADDRESS_DATA$locality))
      DFfirmREGION<-empty2na(as.character(ADDRESS_DATA$region))
      DFfirmPOSTCODE<-empty2na(as.character(ADDRESS_DATA$postal_code))

      myDf <- data.frame(
        company.number = DFfirmNUMBER,
        company.name=DFfirmNAMES,
        sic.code=DFfirmSIC,
        Date.of.Creation = DFfirmDateofCreation,
        company.type = DFfirmTYPE,
        company.status = DFfirmSTATUS,
        address = DFfirmADDRESS,
        locality = DFfirmLOCAL,
        region = DFfirmREGION,
        postcode = DFfirmPOSTCODE)
    }

  }




  return(myDf)
}
