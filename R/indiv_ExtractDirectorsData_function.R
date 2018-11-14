#' @title Individual Directors
#'
#' @description This function gives director information for an individuals.Includes what boards they sit on etc.
#' @param director_id director id
#' @param mkey Authorisation key
#' @export
#' @return Dataframe director information
#
indiv_ExtractDirectorsData<-function(director_id,mkey){
  murl<-paste0("https://api.companieshouse.gov.uk/officers/",director_id,"/appointments")
  dirlist <- httr::GET(murl, httr::authenticate(mkey, "")) #returns an R list object
  dirtext<-httr::content(dirlist, as="text")
  dirtextPARSED<-httr::content(dirlist, as="parsed")
  TR<-dirtextPARSED$total_results
  RPP<-dirtextPARSED$items_per_page
  A<-length(dirtextPARSED$items)
  H1<-ceiling(TR/RPP)
  DFdir_LIST2<-list()

  for (k in 1:H1){
    murl2 <- paste0("https://api.companieshouse.gov.uk/officers/",director_id,"/appointments","?page=",k)
    dirlist2 <- httr::GET(murl2, httr::authenticate(mkey, "")) #returns an R list object
    dirtext2<-httr::content(dirlist2, as="text")
    #dirtextPARSED2<-httr::content(dirlist2, as="parsed")
    JLdir2<-jsonlite::fromJSON(dirtext2,flatten=TRUE)
    DFdirB<-data.frame(JLdir2)
    DFdir_LIST2[[k]]<-DFdirB
  }

  DFdir<-plyr::ldply(DFdir_LIST2,data.frame)

  DFdirNAMES<-DFdir$items.name
  DFdirSTART<-DFdir$items.appointed_on
  DFdirEND<-DFdir$items.resigned_on
  DFdirROLE<-DFdir$items.officer_role
  DFdirOCCUPATION<-DFdir$items.occupation
  DFdirRESIDENCE<-DFdir$items.country_of_residence
  DFdirPOSTCODE<-DFdir$items.address.postal_code
  DFdirNATIONALITY<-DFdir$items.nationality
  DFdirBIRTH_YEAR<-DFdir$date_of_birth.year
  DFdirBIRTH_MONTH<-DFdir$date_of_birth.month
  DFdirFORENAME<-DFdir$items.name_elements.forename
  DFdirSURNAME<-DFdir$items.name_elements.surname
  DFdirCOMPANYname<-DFdir$items.appointed_to.company_name
  DFdirCOMPANYid<-DFdir$items.appointed_to.company_number
  DFdirAPP<-DFdir$kind
  DFdirdownload<-format(Sys.time(), "%d/%m/%Y  %X")
  DFdirDOWNLOADDATE<-DFdirdownload

  myDf <- data.frame(
    company.id = CheckNulls(DFdirCOMPANYid),
    comapny.name=CheckNulls(DFdirCOMPANYname),
    director.id = CheckNulls(director_id),
    directors = CheckNulls(DFdirNAMES),
    director.forename=CheckNulls(DFdirFORENAME),
    director.surname=CheckNulls(DFdirSURNAME),
    start.date = CheckNulls(DFdirSTART),
    end.date = CheckNulls(DFdirEND),
    occupation = CheckNulls(DFdirOCCUPATION),
    role = CheckNulls(DFdirROLE),
    residence = CheckNulls(DFdirRESIDENCE),
    postcode = CheckNulls(DFdirPOSTCODE),
    nationality=CheckNulls(DFdirNATIONALITY),
    birth.year=CheckNulls(DFdirBIRTH_YEAR),
    birth.month=CheckNulls(DFdirBIRTH_MONTH),
    appointment.kind=CheckNulls(DFdirAPP),
    download.date=CheckNulls(DFdirDOWNLOADDATE)
  )

  return(myDf)
}
