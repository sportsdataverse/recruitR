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
#> 2026-11-09 20:52:01.666451: Invalid arguments or no 247 recruiting rankings data available!
#> data frame with 0 columns and 0 rows
# }
```
