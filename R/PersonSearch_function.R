#' @title Person Search
#'
#' @description This function returns a dataframe of Company Officers who match a search string
#' @param person Person search term
#' @param mkey Authorisation key
#' @param perpage Optional. Items to return. Defaults to 100, can't exceed
#' @export
#' @return Dataframe listing name, appointment count, birth date columns, address columns and links

PersonSearch <- function(person, mkey, perpage = 100) {
  perpage <- as.numeric(perpage)
  stopifnot(is.character(person),
            is.character(mkey),
            perpage <= 100,
            perpage > 0)

  name <- gsub(' ', '+', person)
  name <- gsub('&', '%26', name)
  url <- paste0('https://api.companieshouse.gov.uk/search/officers?q=',
                name,
                '&items_per_page=',
                as.character(perpage))

  url.response <- httr::GET(url, httr::authenticate(mkey, ''))
  url.content <- httr::content(url.response, as = 'text')
  url.json <- jsonlite::fromJSON(url.content, flatten = TRUE)

  df <- as.data.frame(url.json)

  df.return <- df[ , c('items.title',
                       'items.matches.title',
                       'items.appointment_count',
                       'items.date_of_birth.month',
                       'items.date_of_birth.year',
                       'items.address.address_line_1',
                       'items.address.address_line_2',
                       'items.address.locality',
                       'items.address.premises',
                       'items.address.region',
                       'items.address.country',
                       'items.address.postal_code',
                       'items.links.self')]

  colnames(df.return) <- c('title',
                           'title_matches',
                           'appointment_count',
                           'dob_mo',
                           'dob_yr',
                           'address_line1',
                           'address_line2',
                           'address_locality',
                           'address_premises',
                           'address_region',
                           'address_country',
                           'address_postcode',
                           'links')

  return(df.return)

}
