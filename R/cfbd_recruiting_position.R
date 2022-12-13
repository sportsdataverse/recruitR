#' @title
#' **Get college football position group recruiting information.**
#' @param start_year (*Integer* optional): Start Year, 4 digit format (*YYYY*). *Note: 2000 is the minimum value*
#' @param end_year (*Integer* optional): End Year,  4 digit format (*YYYY*). *Note: 2020 is the maximum value currently*
#' @param team (*String* optional): Team - Select a valid team, D-I football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_recruiting_position()] - A data frame with 7 variables:
#' \describe{
#'   \item{`team`: character.}{Recruiting team.}
#'   \item{`conference`: character.}{Recruiting team conference.}
#'   \item{`position_group`: character.}{Position group of the recruits.}
#'   \item{`avg_rating`: double.}{Average rating of the recruits in the position group.}
#'   \item{`total_rating`: double.}{Sum of the ratings of the recruits in the position group.}
#'   \item{`commits`: integer.}{Number of commits in the position group.}
#'   \item{`avg_stars`: double.}{Average stars of the recruits in the position group.}
#' }
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_position(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_position(2016, 2020, team = "Virginia"))
#'
#'   try(cfbd_recruiting_position(2015, 2020, conference = "SEC"))
#' }
#'
cfbd_recruiting_position <- function(start_year = NULL, end_year = NULL,
                                     team = NULL, conference = NULL) {
  if(!is.null(start_year)&& !is.numeric(start_year) && nchar(start_year) != 4){
    cli::cli_abort("Enter valid start_year as a number (YYYY)")
  }
  if(!is.null(end_year)&& !is.numeric(end_year) && nchar(end_year) != 4){
    cli::cli_abort("Enter valid end_year as a number (YYYY)")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  
  base_url <- "https://api.collegefootballdata.com/recruiting/groups?"
  
  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "startYear=",
    start_year,
    "&endYear=",
    end_year,
    "&team=",
    team,
    "&conference=",
    conference
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
        dplyr::rename(
          "position_group" = "positionGroup",
          "avg_rating" = "averageRating",
          "total_rating" = "totalRating",
          "avg_stars" = "averageStars"
        )
      
      
      df <- df %>%
        make_recruitR_data("Recruiting position group info from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no position group recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}