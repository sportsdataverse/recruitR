# **Get college football recruiting team rankings information.**

**Get college football recruiting team rankings information.**

## Usage

``` r
cfbd_recruiting_team(year = NULL, team = NULL)
```

## Arguments

- year:

  (*Integer* optional): Recruiting Class Year, 4 digit format (*YYYY*).
  *Note: 2000 is the minimum value*

- team:

  (*String* optional): Team - Select a valid team, D1 football

## Value

`cfbd_recruiting_team()` - A data frame with 4 variables:

- `year`: integer.:

  Recruiting class year.

- `rank`: integer.:

  Team Recruiting rank.

- `team`: character.:

  Recruiting Team.

- `points`: character.:

  Team talent points.

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_team(2018, team = "Texas"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── recruitR 0.0.3 ──
#> ℹ Data updated: 2026-08-27 17:53:42 UTC
#> # A tibble: 1 × 4
#>    year  rank team  points
#>   <int> <int> <chr>  <dbl>
#> 1  2018     3 Texas   300.

  try(cfbd_recruiting_team(2016, team = "Virginia"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── recruitR 0.0.3 ──
#> ℹ Data updated: 2026-08-27 17:53:42 UTC
#> # A tibble: 1 × 4
#>    year  rank team     points
#>   <int> <int> <chr>     <dbl>
#> 1  2016    63 Virginia   165.

  try(cfbd_recruiting_team(2016, team = "Texas A&M"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── recruitR 0.0.3 ──
#> ℹ Data updated: 2026-08-27 17:53:42 UTC
#> # A tibble: 1 × 4
#>    year  rank team      points
#>   <int> <int> <chr>      <dbl>
#> 1  2016    18 Texas A&M   239.

  try(cfbd_recruiting_team(2011))
#> ── Recruiting team rankings from CollegeFootballData.com ───── recruitR 0.0.3 ──
#> ℹ Data updated: 2026-08-27 17:53:42 UTC
#> # A tibble: 137 × 4
#>     year  rank team          points
#>    <int> <int> <chr>          <dbl>
#>  1  2011     1 Alabama         298.
#>  2  2011     2 Florida State   297.
#>  3  2011     3 USC             287.
#>  4  2011     4 Texas           284.
#>  5  2011     5 Auburn          281.
#>  6  2011     6 Ohio State      278.
#>  7  2011     7 Georgia         278.
#>  8  2011     8 LSU             273.
#>  9  2011     9 Notre Dame      271.
#> 10  2011    10 Clemson         270.
#> # ℹ 127 more rows
# }
```
