#' @title
#' **Get college football recruiting team rankings information.**
#' @param year (*Integer* optional): Recruiting Class Year, 4 digit format (*YYYY*). *Note: 2000 is the minimum value*
#' @param team (*String* optional): Team - Select a valid team, D1 football
#'
#' @return [cfbd_recruiting_team()] - A data frame with 4 variables:
#' \describe{
#'   \item{`year`: integer.}{Recruiting class year.}
#'   \item{`rank`: integer.}{Team Recruiting rank.}
#'   \item{`team`: character.}{Recruiting Team.}
#'   \item{`points`: character.}{Team talent points.}
#' }
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_team(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_team(2016, team = "Virginia"))
#'
#'   try(cfbd_recruiting_team(2016, team = "Texas A&M"))
#'
#'   try(cfbd_recruiting_team(2011))
#' }
#'
cfbd_recruiting_team <- function(year = NULL,
                                 team = NULL) {
  
  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
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
      
      
      df <- df %>%
        make_recruitR_data("Recruiting team rankings from CollegeFootballData.com",Sys.time())
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
