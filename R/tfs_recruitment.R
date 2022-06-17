#' @title 
#' **Get 247 Recruitment**
#' @param recruitment_id (\emph{Integer})
#' @return [tfs_recruitment()] 
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'    tfs_recruitment(recruitment_id = 130361)
#' }
#'
tfs_recruitment <- function(recruitment_id) {
  
  
  base_url <- "https://247sports.com/Recruitment/"
  
  
  full_url <- paste0(base_url, 
                     recruitment_id,".json?")
  
  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url)
  
  # Check the result
  check_status(res)
  df <- data.frame()
  tryCatch(
    expr = {
        # Get the content and return it as data.frame
        df <- t(unlist(res %>%
          httr::content(as = "text", encoding = "UTF-8") %>%
          jsonlite::fromJSON(simplifyVector = F,flatten=TRUE))) %>%
          as.data.frame() %>% 
          janitor::clean_names() 
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no 247 recruiting rankings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
