.datatable.aware <- TRUE

#' @keywords Internal
#' @importFrom httr status_code
#'
check_status <- function(res) {
  
  x = status_code(res)
  
  if(x != 200) stop("The API returned an error", call. = FALSE)
  
}




# Progressively
#
# This function helps add progress-reporting to any function - given function `f()` and progressor `p()`, it will return a new function that calls `f()` and then (on-exiting) will call `p()` after every iteration.
#
# This is inspired by purrr's `safely`, `quietly`, and `possibly` function decorators.
# Taken from nflreadr
progressively <- function(f, p = NULL){
  if(!is.null(p) && !inherits(p, "progressor")) stop("`p` must be a progressor function!")
  if(is.null(p)) p <- function(...) NULL
  force(f)
  
  function(...){
    on.exit(p("loading..."))
    f(...)
  }
  
}


#' @title
#' **Load .csv / .csv.gz file from a remote connection**
#' @description
#' This is a thin wrapper on data.table::fread
#' @param ... passed to data.table::fread
#' @keywords Internal
#' @importFrom data.table fread
csv_from_url <- function(...){
  data.table::fread(...)
}


#' @title
#' **Load .rds file from a remote connection**
#' @param url a character url
#' @keywords Internal
#' @return a dataframe as created by [`readRDS()`]
#' @importFrom data.table data.table setDT
rds_from_url <- function(url) {
  con <- url(url)
  on.exit(close(con))
  load <- try(readRDS(con), silent = TRUE)
  
  if (inherits(load, "try-error")) {
    warning(paste0("Failed to readRDS from <", url, ">"), call. = FALSE)
    return(data.table::data.table())
  }
  
  data.table::setDT(load)
  return(load)
}
# read rds that has been pre-fetched
read_raw_rds <- function(raw) {
  con <- gzcon(rawConnection(raw))
  ret <- readRDS(con)
  close(con)
  return(ret)
}

# read qs files form an url
qs_from_url <- function(url) qs::qdeserialize(curl::curl_fetch_memory(url)$content)


# The function `message_completed` to create the green "...completed" message
# only exists to hide the option `in_builder` in dots
message_completed <- function(x, in_builder = FALSE) {
  if (isFALSE(in_builder)) {
    str <- paste0(my_time(), " | ", x)
    cli::cli_alert_success("{{.field {str}}}")
  } else if (in_builder) {
    cli::cli_alert_success("{my_time()} | {x}")
  }
}

user_message <- function(x, type) {
  if (type == "done") {
    cli::cli_alert_success("{my_time()} | {x}")
  } else if (type == "todo") {
    cli::cli_ul("{my_time()} | {x}")
  } else if (type == "info") {
    cli::cli_alert_info("{my_time()} | {x}")
  } else if (type == "oops") {
    cli::cli_alert_danger("{my_time()} | {x}")
  }
}

#' @import utils
utils::globalVariables(c("where"))


# check if a package is installed
is_installed <- function(pkg) requireNamespace(pkg, quietly = TRUE)


#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' @keywords internal
"_PACKAGE"

#' @importFrom Rcpp getRcppVersion
#' @importFrom RcppParallel defaultNumThreads
NULL


`%c%` <- function(x,y){
  ifelse(!is.na(x),x,y)
}

# custom mode function from https://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode/8189441
custom_mode <- function(x, na.rm = TRUE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

most_recent_cfb_season <- function() {
  dplyr::if_else(
    as.double(substr(Sys.Date(), 6, 7)) >= 9,
    as.double(substr(Sys.Date(), 1, 4)),
    as.double(substr(Sys.Date(), 1, 4)) - 1
  )
}
my_time <- function() strftime(Sys.time(), format = "%H:%M:%S")



rule_header <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      right = paste0("recruitR version ", utils::packageVersion("recruitR")),
      width = getOption("width")
    )
  )
}

rule_footer <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      width = getOption("width")
    )
  )
}
# take a time string of the format "MM:SS" and convert it to seconds
time_to_seconds <- function(time){
  as.numeric(strptime(time, format = "%M:%S")) -
    as.numeric(strptime("0", format = "%S"))
}

# Functions for custom class
# turn a data.frame into a tibble/recruitR_data
make_recruitR_data <- function(df,type,timestamp){
  out <- df %>%
    tidyr::as_tibble()
  
  class(out) <- c("recruitR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"recruitR_timestamp") <- timestamp
  attr(out,"recruitR_type") <- type
  return(out)
}

#' @export
#' @noRd
print.recruitR_data <- function(x,...) {
  cli::cli_rule(left = "{attr(x,'recruitR_type')}",right = "{.emph recruitR {utils::packageVersion('recruitR')}}")
  
  if(!is.null(attr(x,'recruitR_timestamp'))) {
    cli::cli_alert_info(
      "Data updated: {.field {format(attr(x,'recruitR_timestamp'), tz = Sys.timezone(), usetz = TRUE)}}"
    )
  }
  
  NextMethod(print,x)
  invisible(x)
}


# rbindlist but maintain attributes of last file, taken from nflreadr
rbindlist_with_attrs <- function(dflist){
  
  recruitR_timestamp <- attr(dflist[[length(dflist)]], "recruitR_timestamp")
  recruitR_type <- attr(dflist[[length(dflist)]], "recruitR_type")
  out <- data.table::rbindlist(dflist, use.names = TRUE, fill = TRUE)
  attr(out,"recruitR_timestamp") <- recruitR_timestamp
  attr(out,"recruitR_type") <- recruitR_type
  out
}
