#' @title Document List Extraction
#'
#' @description This function provides a list of document numbers & links a company number
#' @param company_number Company number
#' @param mkey Authorisation key
#' @export
#' @return Dataframe listing company number, date, docuemnt type, link, meta link  and meta ID
#'

doc_link_extract<-function(company_number, mkey){
  FIRMurl<-paste0("https://api.company-information.service.gov.uk/company/",#"https://api.companieshouse.gov.uk/company/",
                  company_number,
                  "/filing-history")
  firmTEST<-httr::GET(FIRMurl, httr::authenticate(mkey, ""))
  firmTEXT<-httr::content(firmTEST, as="text")
  JLfirm<-jsonlite::fromJSON(firmTEXT, flatten=TRUE)
  DFfirm<-JLfirm$items

  R<-colnames(DFfirm)
  R1a<-length(R)
  R1<-as.numeric(R1a)
  if (R1<12&&R1>0){
    DF_DOC<-data.frame(id=company_number,
                       date=ITNr::isEmpty(DFfirm$date),
                       doc_type=ITNr::isEmpty(DFfirm$description_values.description),
                       links=ITNr::isEmpty(DFfirm$links.self),
                       meta_link=ITNr::isEmpty(DFfirm$links.self))
  }else if (R1==0){
    DF_DOC<-data.frame(id=company_number,
                       date=Sys.time(),
                       doc_type="NA",
                       links="NA",
                       meta_link="NA")
  }else{
    DFfirm<-data.frame(JLfirm)
    doc_links<-ITNr::isEmpty(DFfirm$items.links.self)
    doc_met<-ITNr::isEmpty(DFfirm$items.links.document_metadata)
    DF_DOC<-data.frame(id=company_number,
                       date=ITNr::isEmpty(DFfirm$items.date),
                       doc_type=ITNr::isEmpty(DFfirm$items.description),
                       links=ITNr::isEmpty(doc_links),
                       meta_link=ITNr::isEmpty(doc_met)
    )
  }
  return(DF_DOC)
}
