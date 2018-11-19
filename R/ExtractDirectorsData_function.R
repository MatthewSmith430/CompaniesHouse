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

  if (length(DFdirFORMER_NAME)==0){
    DFdirFORMER_NAME<-NA
  }else{DFdirFORMER_NAME<-DFdirFORMER_NAME}

  if (length(off_app2)==0){
    off_app2<-NA
  }else{off_app2<-off_app2}

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

 myDf$company.id<-as.character(myDf$company.id)
 myDf$director.id<-as.character(myDf$director.id)
 myDf$directors<-as.character(myDf$directors)
 myDf$start.date<-as.Date(myDf$start.date, format = "%Y-%m-%d")
 myDf$end.date<-as.Date(myDf$end.date, format = "%Y-%m-%d")
 myDf$occupation<-as.character(myDf$occupation)
 myDf$role<-as.character(myDf$role)
 myDf$residence<-as.character(myDf$residence)
 myDf$postcode<-as.character(myDf$postcode)
 myDf$nationality<-as.character(myDf$nationality)
 myDf$birth.year<-as.numeric(myDf$birth.year)
 myDf$birth.month<-as.numeric(myDf$birth.month)
 myDf$former.name<-as.character(myDf$former.name)
 myDf$download.date<-as.Date(myDf$download.date,format = "%d/%m/%Y %H:%M:%S")

 return(myDf)
}

