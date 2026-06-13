# **Get composite team talent rankings for all teams in a given year**

Extracts team talent composite as sourced from 247 rankings

## Usage

``` r
cfbd_team_talent(year = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year 4 digit format (*YYYY*)

## Value

`cfbd_team_talent()` - A data frame with 3 variables:

- `year`: integer.:

  Season for the talent rating.

- `school`: character.:

  Team name.

- `talent`: double.:

  Overall roster talent points (as determined by 247Sports).

## Examples

``` r
# \donttest{
  try(cfbd_team_talent())
#> Request failed [400]. Retrying in 1.2 seconds...
#> Request failed [400]. Retrying in 1 seconds...
#> 2026-06-13 04:20:15.488073:Invalid arguments or no team talent data available!
#> data frame with 0 columns and 0 rows

  try(cfbd_team_talent(year = 2018))
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-06-13 04:20:15 UTC
#> # A tibble: 237 × 3
#>     year team          talent
#>    <int> <chr>          <dbl>
#>  1  2018 Ohio State      984.
#>  2  2018 Alabama         979.
#>  3  2018 Georgia         964 
#>  4  2018 USC             934.
#>  5  2018 Clemson         893.
#>  6  2018 LSU             890.
#>  7  2018 Florida State   889.
#>  8  2018 Michigan        862.
#>  9  2018 Texas           861.
#> 10  2018 Notre Dame      848.
#> # ℹ 227 more rows
# }
```
