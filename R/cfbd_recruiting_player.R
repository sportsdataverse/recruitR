#' @title 
#' **Get player recruiting rankings**
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}) - Minimum: 2000, Maximum: 2020 currently
#' @param team (\emph{String} optional): D-I Team
#' @param recruit_type (\emph{String} optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param state (\emph{String} optional): Two letter State abbreviation
#' @param position (\emph{String} optional): Position Group  - options include:\cr
#'  * Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE',  'OT', 'OG', 'OC', 'WR'\cr
#'  * Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'\cr
#'  * Special Teams: 'K', 'P'
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_recruiting_player()] - A data frame with 14 variables:
#' \describe{
#'   \item{`id`: integer.}{Referencing id - 247Sports.}
#'   \item{`athlete_id`}{Athlete referencing id.}
#'   \item{`recruit_type`: character.}{High School, Prep School, or Junior College.}
#'   \item{`year`: integer.}{Recruit class year.}
#'   \item{`ranking`: integer.}{Recruit Ranking.}
#'   \item{`name`: character.}{Recruit Name.}
#'   \item{`school`: character.}{School recruit attended.}
#'   \item{`committed_to`: character.}{School the recruit is committed to.}
#'   \item{`position`: character.}{Recruit position.}
#'   \item{`height`: double.}{Recruit height.}
#'   \item{`weight`: integer.}{Recruit weight.}
#'   \item{`stars`: integer.}{Recruit stars.}
#'   \item{`rating`: double.}{247 composite rating.}
#'   \item{`city`: character.}{Hometown of the recruit.}
#'   \item{`state_province`: character.}{Hometown state of the recruit.}
#'   \item{`country`: character.}{Hometown country of the recruit.}
#'   \item{`hometown_info_latitude`: character.}{Hometown latitude.}
#'   \item{`hometown_info_longitude`: character.}{Hometown longitude.}
#'   \item{`hometown_info_fips_code`: character.}{Hometown FIPS code.}
#' }
#' @source \url{https://api.collegefootballdata.com/recruiting/players}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'    cfbd_recruiting_player(2018, team = "Texas")
#'
#'    cfbd_recruiting_player(2016, recruit_type = "JUCO")
#'
#'    cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
#' }
#'
cfbd_recruiting_player <- function(year = NULL,
                                   team = NULL,
                                   recruit_type = "HighSchool",
                                   state = NULL,
                                   position = NULL,
                                   verbose = FALSE) {
  
  # Position Group vector to check arguments against
  pos_groups <- c(
    "PRO", "DUAL", "RB", "FB", "TE", "OT", "OG", "OC", "WR",
    "CB", "S", "OLB", "ILB", "WDE", "SDE", "DT", "K", "P"
  )
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
                            msg = "Enter valid year as a number (YYYY) - Min: 2000, Max: 2020"
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
  if (recruit_type != "HighSchool") {
    # Check if recruit_type is appropriate, if not HighSchool
    assertthat::assert_that(recruit_type %in% c("PrepSchool", "JUCO"),
                            msg = "Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO"
    )
  }
  if (!is.null(state)) {
    ## check if state is length 2
    assertthat::assert_that(nchar(state) == 2,
                            msg = "Enter valid 2-letter State abbreviation"
    )
  }
  if (!is.null(position)) {
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
                            msg = "Enter valid position group \nOffense: PRO, DUAL, RB, FB, TE, OT, OG, OC, WR\nDefense: CB, S, OLB, ILB, WDE, SDE, DT\nSpecial Teams: K, P"
    )
  }
  
  base_url <- "https://api.collegefootballdata.com/recruiting/players?"
  
  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&classification=", recruit_type,
    "&position=", position,
    "&state=", state
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
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names() %>% 
        as.data.frame()
      
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping player recruiting data..."))
      }
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
