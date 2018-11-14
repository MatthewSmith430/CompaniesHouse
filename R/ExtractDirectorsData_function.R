#' @title Company Directors
#'
#' @description This function gives director information for a company. Including director name, occupation, date appointed, date resigned and residence.
#' @param coyno Company Number
#' @param mkey Authorisation key
#' @export
#' @return Dataframe director information

company_ExtractDirectorsData <- function(coyno,mkey) {
  murl <- paste0("https://api.companieshouse.gov.uk/company/", coyno, "/officers")
  dirlist <- httr::GET(murl, httr::authenticate(mkey, "")) #returns an R list object
  dirtext<-httr::content(dirlist, as="text")
  dirtextPARSED<-httr::content(dirlist, as="parsed")
  TR<-dirtextPARSED$total_results
  RPP<-dirtextPARSED$items_per_page
  A<-length(dirtextPARSED$items)
  if (A>0){
    H1<-ceiling(TR/RPP)
    DFdir_LIST2<-list()
    for (k in 1:H1){
      murl2 <- paste0("https://api.companieshouse.gov.uk/company/", coyno, "/officers","?page=",k)
      dirlist2 <- httr::GET(murl2, httr::authenticate(mkey, "")) #returns an R list object
      dirtext2<-httr::content(dirlist2, as="text")
      #dirtextPARSED2<-httr::content(dirlist2, as="parsed")
      JLdir2<-jsonlite::fromJSON(dirtext2,flatten=TRUE)
      DFdirB<-data.frame(JLdir2)
      DFdir_LIST2[[k]]<-DFdirB
    }

    DFdir<-plyr::ldply(DFdir_LIST2,data.frame)
  } else {
    JLdir<-jsonlite::fromJSON(dirtext, flatten=TRUE)
    json_data = sapply(JLdir,rbind)
    DFdir<-data.frame(json_data)
  }

  DFdirNAMES<-DFdir$items.name
  DFdirSTART<-DFdir$items.appointed_on
  DFdirEND<-DFdir$items.resigned_on
  DFdirROLE<-DFdir$items.officer_role
  DFdirOCCUPATION<-DFdir$items.occupation
  DFdirRESIDENCE<-DFdir$items.country_of_residence
  DFdirPOSTCODE<-DFdir$items.address.postal_code
  DFdirNATIONALITY<-DFdir$items.nationality
  #FN<-DFdir$items.former_names
  #FN2<-plyr::ldply(FN,data.frame)
  DFdirFORMER_NAME<-as.character(DFdir$items.former_names)
  DFdirBIRTH_YEAR<-DFdir$items.date_of_birth.year
  DFdirBIRTH_MONTH<-DFdir$items.date_of_birth.month
  DFdirdownload<-format(Sys.time(), "%d/%m/%Y  %X")
  DFdirDOWNLOADDATE<-DFdirdownload
  off_app<-DFdir$items.links.officer.appointments
  off_app1<-gsub("\\/officers/*","",off_app)
  off_app2<-gsub("/appointments.*","",off_app1)

  myDf <- data.frame(
    company.id = CheckNulls(coyno),
    director.id = CheckNulls(off_app2),
    directors = CheckNulls(DFdirNAMES),
    start.date = CheckNulls(DFdirSTART),
    end.date = CheckNulls(DFdirEND),
    occupation = CheckNulls(DFdirOCCUPATION),
    role = CheckNulls(DFdirROLE),
    residence = CheckNulls(DFdirRESIDENCE),
    postcode = CheckNulls(DFdirPOSTCODE),
    nationality=CheckNulls(DFdirNATIONALITY),
    birth.year=CheckNulls(DFdirBIRTH_YEAR),
    birth.month=CheckNulls(DFdirBIRTH_MONTH),
    former.name=CheckNulls(DFdirFORMER_NAME),
    download.date=CheckNulls(DFdirDOWNLOADDATE)
  )

  return(myDf)
}

