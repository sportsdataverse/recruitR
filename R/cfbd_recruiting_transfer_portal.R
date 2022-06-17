#' @title
#' **Get Transfer Portal Data**
#' @param year (*Integer* required): Year of the offseason (2021 would return transfer portal data starting from the end of the 2020 season), 4 digit format (*YYYY*).
#' @return [cfbd_recruiting_transfer_portal()] - A data frame with 11 variables:
#' \describe{
#'   \item{`season`:integer}{Season of transfer.}
#'   \item{`first_name`:character.}{Player's first name.}
#'   \item{`last_name`:character.}{Player's last name.}
#'   \item{`position`:character.}{Player position.}
#'   \item{`origin`:character.}{original team.}
#'   \item{`destination`:character.}{new team.}
#'   \item{`transfer_date`:character.}{Date of transfer.}
#'   \item{`rating`:character.}{Player's 247 transfer rating.}
#'   \item{`stars`:integer}{Player's star rating.}
#'   \item{`eligibilty`:character.}{Player's eligibilty status.}
#' }
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_transfer_portal(year = 2021))
#' }
cfbd_recruiting_transfer_portal <- function(year) {
  
  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  base_url <- "https://api.collegefootballdata.com/player/portal?"
  
  # Create full url using base and input arguments
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names() %>%
        dplyr::mutate(
          transfer_date = as.POSIXct(.data$transfer_date)
        )
      
      
      df <- df %>%
        make_recruitR_data("Transfer portal data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no transfer portal data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}