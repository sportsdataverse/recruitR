#' @title
#' **Get composite team talent rankings for all teams in a given year**
#'
#' @description
#' Extracts team talent composite as sourced from 247 rankings
#' @param year (*Integer* optional): Year 4 digit format (*YYYY*)
#'
#' @return [cfbd_team_talent()] - A data frame with 3 variables:
#' \describe{
#'   \item{`year`: integer.}{Season for the talent rating.}
#'   \item{`school`: character.}{Team name.}
#'   \item{`talent`: double.}{Overall roster talent points (as determined by 247Sports).}
#' }
#' @keywords Team talent
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_talent())
#'
#'   try(cfbd_team_talent(year = 2018))
#' }
#'
cfbd_team_talent <- function(year = NULL) {
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  
  base_url <- "https://api.collegefootballdata.com/talent?"
  
  full_url <- paste0(
    base_url,
    "year=", year
  )
  
  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)
  
  
  df <- data.frame()
  tryCatch(
    expr = {
      
      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )
      
      # Check the result
      check_status(res)
      
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        as.data.frame() %>%
        mutate(talent = as.numeric(.data$talent))
      
      
      df <- df %>%
        make_recruitR_data("247sports team talent ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team talent data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}