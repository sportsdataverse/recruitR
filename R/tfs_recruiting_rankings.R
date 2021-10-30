#' @title 
#' **Get 247 CFB Player Recruiting Rankings**
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}) - Minimum: 2000, Maximum: 2020 currently
#' @param recruit_type (\emph{String} optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param pages Number of pages
#'
#' @return [tfs_recruiting_rankings()] 
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
#'    tfs_recruiting_rankings(2022)
#'
#'    tfs_recruiting_rankings(2021)
#' }
#'
tfs_recruiting_rankings <- function(year,
                                   recruit_type = "HighSchool",
                                   pages=5) {
  
 
  # if (!is.null(year)) {
  #   ## check if year is numeric
  #   assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
  #                           msg = "Enter valid year as a number (YYYY) - Min: 2000, Max: 2020"
  #   )
  # }
  # if (!is.null(team)) {
  #   if (team == "San Jose State") {
  #     team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
  #   } else {
  #     # Encode team parameter for URL if not NULL
  #     team <- utils::URLencode(team, reserved = TRUE)
  #   }
  # }
  # if (recruit_type != "HighSchool") {
  #   # Check if recruit_type is appropriate, if not HighSchool
  #   assertthat::assert_that(recruit_type %in% c("PrepSchool", "JUCO"),
  #                           msg = "Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO"
  #   )
  # }
  # if (!is.null(state)) {
  #   ## check if state is length 2
  #   assertthat::assert_that(nchar(state) == 2,
  #                           msg = "Enter valid 2-letter State abbreviation"
  #   )
  # }
  # if (!is.null(position)) {
  #   ## check if position in position group set
  #   assertthat::assert_that(position %in% pos_groups,
  #                           msg = "Enter valid position group \nOffense: PRO, DUAL, RB, FB, TE, OT, OG, OC, WR\nDefense: CB, S, OLB, ILB, WDE, SDE, DT\nSpecial Teams: K, P"
  #   )
  # }
  
  base_url <- "https://247sports.com/Season/"
  
  
  ranks_df <- data.frame()
  tryCatch(
    expr = {
      ranks_df <- purrr::map_df(seq(1:pages),function(x){
        # Create full url using base and input arguments
        full_url <- paste0(base_url, 
                           year,"-Football/", 
                           "Recruits.json?", 
                           "Items=300",
                           "&Page=", x
        )
        
        # Create the GET request and set response as res
        res <- httr::RETRY("GET", full_url)
        
        # Check the result
        check_status(res)
        
        # Get the content and return it as data.frame
        df <- res %>%
          httr::content(as = "text", encoding = "UTF-8") %>%
          jsonlite::fromJSON(flatten=TRUE) %>%
          janitor::clean_names() %>% 
          as.data.frame()
        return(df)
      })
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no 247 recruiting rankings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(ranks_df)
}
