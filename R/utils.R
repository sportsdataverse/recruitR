#' Utilities and Helpers for package
#' @keywords internal
#' @importFrom attempt "stop_if_not"
#' @importFrom curl "has_internet"
#'
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

#' Check Status Function
#' @keywords internal
#' @importFrom httr "status_code"
#'

check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}
