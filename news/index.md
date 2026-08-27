# Changelog

## recruitR (development version)

- Restored the documented column schema after CollegeFootballData
  renamed and reordered several response fields:
  - [`cfbd_team_talent()`](https://recruitR.sportsdataverse.org/reference/cfbd_team_talent.md)
    again returns `school` (the API now sends `team`).
  - [`cfbd_team_roster()`](https://recruitR.sportsdataverse.org/reference/cfbd_team_roster.md)
    again returns snake_case names (`first_name`, `home_state`,
    `home_county_fips`, …) rather than the API’s camelCase.
  - [`cfbd_recruiting_team()`](https://recruitR.sportsdataverse.org/reference/cfbd_recruiting_team.md)
    again returns `year`, `rank`, `team`, `points` in the documented
    order.
- [`cfbd_recruiting_position()`](https://recruitR.sportsdataverse.org/reference/cfbd_recruiting_position.md)
  no longer sends an empty `endYear=` when `end_year` is omitted.
  CollegeFootballData now rejects that with `Validation Failed`, so the
  documented `cfbd_recruiting_position(2018, team = "Texas")` call
  returned an empty data frame. The query is built from the supplied
  arguments only.

## recruitR 0.0.3

- Updated to include CFBD API key methods

## recruitR 0.0.1

- Added a `NEWS.md` file to track changes to the package.
