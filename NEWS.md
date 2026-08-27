# recruitR (development version)

* Restored the documented column schema after CollegeFootballData renamed
  and reordered several response fields:
  * `cfbd_team_talent()` again returns `school` (the API now sends `team`).
  * `cfbd_team_roster()` again returns snake_case names (`first_name`,
    `home_state`, `home_county_fips`, ...) rather than the API's camelCase.
  * `cfbd_recruiting_team()` again returns `year`, `rank`, `team`, `points`
    in the documented order.

# recruitR 0.0.3

* Updated to include CFBD API key methods

# recruitR 0.0.1

* Added a `NEWS.md` file to track changes to the package.
