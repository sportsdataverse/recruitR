#' @keywords Internal
#' @importFrom httr status_code
#'
check_status <- function(res) {
  
  x = status_code(res)
  
  if(x != 200) stop("The API returned an error", call. = FALSE) 
  
}