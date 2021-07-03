#' @title 
#' **Get college football recruiting team rankings information.**
#' @param year (\emph{Integer} optional): Recruiting Class Year, 4 digit format (\emph{YYYY}). \emph{Note: 2000 is the minimum value}
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_recruiting_team()] - A data frame with 4 variables:
#' \describe{
#'   \item{`year`: integer.}{Recruiting class year.}
#'   \item{`rank`: integer.}{Team Recruiting rank.}
#'   \item{`team`: character.}{Recruiting Team.}
#'   \item{`points`: character.}{Team talent points.}
#' }
#' @source \url{https://api.collegefootballdata.com/recruiting/teams}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_recruiting_team(2018, team = "Texas")
#'
#' cfbd_recruiting_team(2016, team = "Virginia")
#'
#' cfbd_recruiting_team(2016, team = "Texas A&M")
#'
#' cfbd_recruiting_team(2011)
#' }
#'
cfbd_recruiting_team <- function(year = NULL,
                                 team = NULL,
                                 verbose = FALSE) {
  
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
                            msg = "Enter valid year as integer in 4 digit format (YYYY)\n Min: 2000, Max: 2020"
    )
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  
  base_url <- "https://api.collegefootballdata.com/recruiting/teams?"
  
  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team
  )
  
  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)
  
  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )
  
  # Check the result
  check_status(res)
  
  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        as.data.frame()
      
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team recruiting data..."))
      }
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
