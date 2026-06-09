# **Get 247 CFB Player Recruiting Rankings**

**Get 247 CFB Player Recruiting Rankings**

## Usage

``` r
tfs_recruiting_rankings(year, recruit_type = "HighSchool", pages = 5)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*) - Minimum: 2000,
  Maximum: 2020 currently

- recruit_type:

  (*String* optional): default API return is 'HighSchool', other options
  include 'JUCO' or 'PrepSchool' - For position group information

- pages:

  Number of pages

## Value

`tfs_recruiting_rankings()`

## Examples

``` r
# \donttest{
   try(tfs_recruiting_rankings(2022))
#> ── Player recruiting rankings from 247Sports.com ───────────── recruitR 0.0.3 ──
#> ℹ Data updated: 2026-06-09 23:44:00 UTC
#> # A tibble: 1,500 × 59
#>       key player_institution  year announcement_date signed_institution position
#>     <int>              <int> <int> <chr>                          <int>    <int>
#>  1 130361             236028  2022 NA                             24245       24
#>  2 129370             269103  2022 NA                             24029       61
#>  3 122923             225483  2022 10/19/2021 4:00:…              24024       14
#>  4 134954             245107  2022 NA                             24100       61
#>  5 120961             220045  2022 12/17/2021 12:30…              24257       24
#>  6 120724             219672  2022 NA                             24008       57
#>  7 130902             236760  2022 NA                             24046       59
#>  8 135466             245751  2022 2/2/2022 4:30:00…              24102       59
#>  9 125855             229784  2022 2/2/2022 1:30:00…              24029       61
#> 10 133187             242317  2022 2/2/2022 5:00:00…              24028       58
#> # ℹ 1,490 more rows
#> # ℹ 53 more variables: institution <int>, state <int>, player_sport <int>,
#> #   composite_strength <chr>, final_choice <int>,
#> #   highest_recruit_interest_event_type <chr>,
#> #   highest_recruit_interest_event <int>, committed_recruit_interest <int>,
#> #   committed_institution <int>, highest_recruit_interest <int>,
#> #   primary_player_position <int>, primary_position <int>, …
# }
```
