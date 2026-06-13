# **Get college football position group recruiting information.**

**Get college football position group recruiting information.**

## Usage

``` r
cfbd_recruiting_position(
  start_year = NULL,
  end_year = NULL,
  team = NULL,
  conference = NULL
)
```

## Arguments

- start_year:

  (*Integer* optional): Start Year, 4 digit format (*YYYY*). *Note: 2000
  is the minimum value*

- end_year:

  (*Integer* optional): End Year, 4 digit format (*YYYY*). *Note: 2020
  is the maximum value currently*

- team:

  (*String* optional): Team - Select a valid team, D-I football

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_recruiting_position()` - A data frame with 7 variables:

- `team`: character.:

  Recruiting team.

- `conference`: character.:

  Recruiting team conference.

- `position_group`: character.:

  Position group of the recruits.

- `avg_rating`: double.:

  Average rating of the recruits in the position group.

- `total_rating`: double.:

  Sum of the ratings of the recruits in the position group.

- `commits`: integer.:

  Number of commits in the position group.

- `avg_stars`: double.:

  Average stars of the recruits in the position group.

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_position(2018, team = "Texas"))
#> Request failed [400]. Retrying in 1 seconds...
#> Request failed [400]. Retrying in 3.3 seconds...
#> 2026-06-13 04:20:10.856946: Invalid arguments or no position group recruiting data available!
#> data frame with 0 columns and 0 rows

  try(cfbd_recruiting_position(2016, 2020, team = "Virginia"))
#> ── Recruiting position group info from CollegeFootballData.com ─────────────────
#> ℹ Data updated: 2026-06-13 04:20:11 UTC
#> # A tibble: 16 × 7
#>    team     conference position_group avg_rating total_rating commits avg_stars
#>    <chr>    <chr>      <chr>               <dbl>        <dbl>   <dbl>     <dbl>
#>  1 Virginia ACC        Defensive Back      0.831         9.15      11      2.82
#>  2 Virginia ACC        Defensive Line      0.851         7.66       9      3.22
#>  3 Virginia ACC        Linebacker          0.848         7.63       9      3   
#>  4 Virginia ACC        Offensive Line      0.827         7.44       9      2.89
#>  5 Virginia ACC        Quarterback         0.853         1.71       2      3   
#>  6 Virginia ACC        Receiver            0.835        10.0       12      2.92
#>  7 Virginia ACC        Running Back        0.836         3.35       4      3   
#>  8 Virginia ACC        Special Teams       0.839         7.55       9      2.89
#>  9 Virginia ACC        All Positions       0.831         9.15      11      2.82
#> 10 Virginia ACC        All Positions       0.851         7.66       9      3.22
#> 11 Virginia ACC        All Positions       0.848         7.63       9      3   
#> 12 Virginia ACC        All Positions       0.827         7.44       9      2.89
#> 13 Virginia ACC        All Positions       0.853         1.71       2      3   
#> 14 Virginia ACC        All Positions       0.835        10.0       12      2.92
#> 15 Virginia ACC        All Positions       0.836         3.35       4      3   
#> 16 Virginia ACC        All Positions       0.839         7.55       9      2.89

  try(cfbd_recruiting_position(2015, 2020, conference = "SEC"))
#> ── Recruiting position group info from CollegeFootballData.com ─────────────────
#> ℹ Data updated: 2026-06-13 04:20:11 UTC
#> # A tibble: 224 × 7
#>    team     conference position_group avg_rating total_rating commits avg_stars
#>    <chr>    <chr>      <chr>               <dbl>        <dbl>   <dbl>     <dbl>
#>  1 Alabama  SEC        Defensive Back      0.950        20.9       22      4.05
#>  2 Alabama  SEC        Defensive Line      0.951        27.6       29      4.17
#>  3 Alabama  SEC        Linebacker          0.941        15.1       16      4   
#>  4 Alabama  SEC        Offensive Line      0.939        19.7       21      4.05
#>  5 Alabama  SEC        Quarterback         0.894         8.94      10      3.7 
#>  6 Alabama  SEC        Receiver            0.923        19.4       21      3.86
#>  7 Alabama  SEC        Running Back        0.919        13.8       15      3.8 
#>  8 Alabama  SEC        Special Teams       0.892         7.13       8      3.62
#>  9 Arkansas SEC        Defensive Back      0.861        13.8       16      3.25
#> 10 Arkansas SEC        Defensive Line      0.891        14.3       16      3.5 
#> # ℹ 214 more rows
# }
```
