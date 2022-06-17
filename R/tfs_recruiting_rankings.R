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
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'    try(tfs_recruiting_rankings(2022))
#' }
#'
tfs_recruiting_rankings <- function(year,
                                   recruit_type = "HighSchool",
                                   pages=5) {
  
 
  
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!(recruit_type %in% c("HighSchool","PrepSchool", "JUCO"))) {
    # Check if recruit_type is appropriate, if not HighSchool
    cli::cli_abort("Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO")
  }
  
  
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
      }) %>%
        make_recruitR_data("Player recruiting rankings from 247Sports.com",Sys.time())
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
