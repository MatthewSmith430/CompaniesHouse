#' @title Rate Limiting Wrapper
#'
#' @description Takes any other function in the Companies House documentation and returns the same function with rate limiting.
#' Uses \code{trace} to listen in on the headers of each HTTP request. As it's quite noisy, consider running with
#' \code{suppressMessages()}.
#' @param func The function you want to add rate limiting to
#' @param buffer Optional. The amount of requests left before the wrapper will pause. Default is 5
#' @param silent Optional. Suppresses printed messages
#' @export
#' @return A function with rate limiting added
#' @examples \donttest{
#' PersonSearch.Rated <- RateLimitWrap(PersonSearch_limit_first)
#'
#' PersonSearch.Rated(person, mkey)
#' PersonSearch.Rated(person, mkey, silent = TRUE)
#' suppressMessages(PersonSearch.Rated(person, mkey))
#' }

RateLimitWrap <- function(func, ..., buffer = 5, silent = FALSE) {

  ratewrap <- function(..., silent = FALSE) {

    trace(httr::GET,
          where = func,
          print = FALSE,
          exit = function().value <<- returnValue())

    func.name <- match.call()[[1]]

    out <- tryCatch(
      {
        func(...)
      },
      error = function(e){
        if (grepl('parse', e$message, fixed = TRUE)) {

          # Indicates parse error, assuming no requests left

          time <- as.numeric(.value$headers$`x-ratelimit-reset`) - as.numeric(Sys.time())

          if (time > 300 || time < 1 ) {
            time <- 300
          }

          if (silent == FALSE) {
            print('No requests left. The following call may not have evaluated:')
            args <- paste0(names(formals(func)),
                           sep = ' = ',
                           unlist(list(...), use.names = FALSE))
            args <- paste0(args, collapse = ', ')
            print(paste0(func.name, '(', args, ')'))
            print(paste('Sleeping until', Sys.time() + time, 'then trying again.'))
          }

          Sys.sleep(time + 5)

          if (silent == FALSE) {
            print('Time\'s up! Trying again...')
          }

          func(...)

        } else {

          return(e)

        }
      }
    )

    if (as.numeric(.value$headers$`x-ratelimit-remain`) == 0) {

      time <- as.numeric(.value$headers$`x-ratelimit-reset`) - as.numeric(Sys.time())

      if (time > 300 || time < 1 ) {
        time <- 300
      }

      if (silent == FALSE) {
        print('No requests left. The following call may not have evaluated:')
        args <- paste0(names(formals(func)),
                       sep = ' = ',
                       unlist(list(...), use.names = FALSE))
        args <- paste0(args, collapse = ', ')
        print(paste0(func.name, '(', args, ')'))
        print(paste('Sleeping until', Sys.time() + time))
      }

      Sys.sleep(time + 5)

    } else if (as.numeric(.value$headers$`x-ratelimit-remain`) < buffer) {

      time <- as.numeric(.value$headers$`x-ratelimit-reset`) - as.numeric(Sys.time())

      if (time > 300 || time < 1 ) {
        time <- 300
      }

      if (silent == FALSE) {
        print(paste('Sleeping until', Sys.time() + time))
      }

      Sys.sleep(time + 5)

    } else {

      if (silent == FALSE) {
        print(paste(as.numeric(.value$headers$`x-ratelimit-remain`), 'requests left'))
      }

    }

    untrace(httr::GET)

    return(out)

  }

  return(ratewrap)

}
