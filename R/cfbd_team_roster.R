
#' @title
#' **Get team rosters**
#' @description
#' Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.
#'
#' @param year (*Integer* required): Year,  4 digit format (*YYYY*)
#' @param team (*String* optional): Team, select a valid team in D-I football
#'
#' @return [cfbd_team_roster()] - A data frame with 12 variables:
#' \describe{
#'   \item{`athlete_id`: character.}{Referencing athlete id.}
#'   \item{`first_name`: character.}{Athlete first name.}
#'   \item{`last_name`: character.}{Athlete last name.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`weight`: integer.}{Athlete weight.}
#'   \item{`height`: integer.}{Athlete height.}
#'   \item{`jersey`: integer.}{Athlete jersey number.}
#'   \item{`year`: integer.}{Athlete year.}
#'   \item{`position`: character.}{Athlete position.}
#'   \item{`home_city`: character.}{Hometown of the athlete.}
#'   \item{`home_state`: character.}{Hometown state of the athlete.}
#'   \item{`home_country`: character.}{Hometown country of the athlete.}
#'   \item{`home_latitude`: numeric.}{Hometown latitude.}
#'   \item{`home_longitude`: number.}{Hometown longitude.}
#'   \item{`home_county_fips`: integer.}{Hometown FIPS code.}
#'   \item{`headshot_url`: character}{Player ESPN headshot url.}
#' }
#' @keywords Team Roster
#' @importFrom dplyr rename mutate
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_roster(year = 2013, team = "Florida State"))
#' }
#'
cfbd_team_roster <- function(year, team = NULL) {
  team2 <- team
  
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  
  
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team1 parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  base_url <- "https://api.collegefootballdata.com/roster?"
  
  if (is.null(team)) {
    full_url <- paste0(
      base_url,
      "year=", year
    )
  } else {
    full_url <- paste0(
      base_url, "team=", team,
      "&year=", year
    )
  }
  
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
        dplyr::rename("athlete_id" = "id") %>%
        dplyr::mutate(headshot_url = paste0("https://a.espncdn.com/i/headshots/college-football/players/full/",.data$athlete_id,".png")) %>%
        as.data.frame()
      
      
      df <- df %>%
        make_recruitR_data("Team roster data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team roster data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
