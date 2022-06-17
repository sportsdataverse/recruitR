#' @title
#' **Get player recruiting rankings**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) - Minimum: 2000, Maximum: 2020 currently
#' @param team (*String* optional): D-I Team
#' @param recruit_type (*String* optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param state (*String* optional): Two letter State abbreviation
#' @param position (*String* optional): Position Group  - options include:
#'  * Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE',  'OT', 'OG', 'OC', 'WR'
#'  * Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'
#'  * Special Teams: 'K', 'P'
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
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_player(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_player(2016, recruit_type = "JUCO"))
#'
#'   try(cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL"))
#' }
#'
cfbd_recruiting_player <- function(year = NULL,
                                   team = NULL,
                                   recruit_type = "HighSchool",
                                   state = NULL,
                                   position = NULL) {
  
  # Position Group vector to check arguments against
  pos_groups <- c(
    "PRO", "DUAL", "RB", "FB", "TE", "OT", "OG", "OC", "WR",
    "CB", "S", "OLB", "ILB", "WDE", "SDE", "DT", "K", "P"
  )
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
  if (!(recruit_type %in% c("HighSchool","PrepSchool", "JUCO"))) {
    # Check if recruit_type is appropriate, if not HighSchool
    cli::cli_abort("Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO")
  }
  if (!is.null(state) && nchar(state) != 2) {
    ## check if state is length 2
    cli::cli_abort("Enter valid 2-letter State abbreviation")
  }
  if (!is.null(position) && !(position %in% pos_groups)) {
    ## check if position in position group set
    cli::cli_abort("Enter valid position group \nOffense: PRO, DUAL, RB, FB, TE, OT, OG, OC, WR\nDefense: CB, S, OLB, ILB, WDE, SDE, DT\nSpecial Teams: K, P")
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
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names() %>%
        as.data.frame()
      
      
      df <- df %>%
        make_recruitR_data("Player recruiting info from CollegeFootballData.com",Sys.time())
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