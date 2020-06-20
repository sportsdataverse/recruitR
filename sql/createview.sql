CREATE VIEW viewAnalysis AS 
SELECT
  ds.school_id,
    ds.school_name,
    ds.school_city,
    ds.school_st_abbr,
    ds.school_state,
    ds.school_zip,
    ds.school_region,
    ds.school_longitude,
    ds.school_latitude,
    ds.school_main_campus_flag,
    ds.school_size_category,
    ds.school_url,
    ds.school_control,
    ds.school_level,
    fs.school_admission_rate,
    fs.school_in_state_price,
    fs.school_out_state_price,
    fs.school_retention_rate,
    fs.school_graduation_rate_4yrs,
    fs.school_graduation_rate_6yrs,
    fs.school_federal_loan_rate,
    fs.school_students_with_any_loan,
    fs.school_median_debt_graduates,
    fs.school_median_debt_graduates_monthly_payments,
    fs.SAT_reading_25th_percentile,
    fs.SAT_reading_75th_percentile,
    fs.SAT_math_25th_percentile,
    fs.SAT_math_75th_percentile,
    fs.SAT_reading_midpoint,
    fs.SAT_math_midpoint,
    fs.ACT_composite_25th_percentile,
    fs.ACT_composite_75th_percentile,
    fs.ACT_english_25th_percentile,
    fs.ACT_english_75th_percentile,
    fs.ACT_math_25th_percentile,
    fs.ACT_math_75th_percentile,
    fs.ACT_composite_midpoint,
    fs.ACT_english_midpoint,
    fs.ACT_math_midpoint,
    sy.school_year_value,
    SUM(fg.school_points) AS school_points,
    SUM(fg.opponent_points) AS opponent_points,
    SUM(fg.school_win) AS school_wins,
    MIN(fg.school_rank) AS min_school_rank,
    MIN(fg.opponent_rank) AS min_opponent_rank,
    SUM(fg.bowl_flag) AS bowl_games,
  SUM(CASE WHEN (fg.bowl_flag = 1 AND fg.school_win = 1)
          THEN 1
      ELSE 0
      END) AS bowl_wins,
    SUM(fg.national_championship_flag) AS national_championship_games,
    SUM(CASE WHEN (fg.national_championship_flag = 1 AND fg.school_win = 1)
          THEN 1
      ELSE 0
      END) AS national_championship_wins,
    SUM(CASE WHEN (fg.school_game_site = 'home' AND fg.school_win = 1)
          THEN 1
          ELSE 0
          END) AS home_wins, 
    SUM(CASE WHEN (fg.school_game_site = 'home' AND fg.school_win = 0)
          THEN 1
          ELSE 0
          END) AS home_loses,
    SUM(CASE WHEN (fg.school_game_site = 'home')
          THEN 1
          ELSE 0
          END) AS home_games,
    SUM(CASE WHEN ((fg.school_game_site = 'away' OR fg.school_game_site = 'neutral' ) AND fg.school_win = 1)
          THEN 1
          ELSE 0
          END) AS road_wins,
    SUM(CASE WHEN ((fg.school_game_site = 'away' OR fg.school_game_site = 'neutral' ) AND  fg.school_win = 0)
          THEN 1
          ELSE 0
          END) AS road_loses,
    SUM(CASE WHEN (fg.school_game_site = 'away' OR fg.school_game_site = 'neutral' )
          THEN 1
          ELSE 0
          END) AS road_games,
    SUM(CASE WHEN (fg.opponent_rank IS NOT NULL AND fg.school_win = 1)
          THEN 1
          ELSE 0
          END) AS wins_against_ranked_opponents,
    SUM(CASE WHEN (fg.opponent_rank IS NOT NULL AND fg.school_win = 0)
          THEN 1
          ELSE 0
          END) AS loses_against_ranked_opponent,
    SUM(CASE WHEN (fg.opponent_rank IS NOT NULL)
          THEN 1
      ELSE 0
      END) AS games_against_ranked_opponent,
    SUM(fg.school_points) - SUM(fg.opponent_points) AS point_differential,
    COUNT(*) as total_games
FROM FootballSchoolDW.factGame AS fg
  INNER JOIN FootballSchoolDW.dimSchool AS ds
  ON fg.school_sk = ds.school_sk
  INNER JOIN FootballSchoolDW.dimDate AS dd
  ON dd.date_sk = fg.date_sk
  INNER JOIN FootballSchoolDW.dimSchoolYear AS sy
  ON dd.school_year_sk = sy.school_year_sk
  INNER JOIN FootballSchoolDW.factSchool AS fs
  ON fs.school_sk = ds.school_sk and fs.school_year_sk = sy.school_year_sk
  GROUP BY 
    ds.school_id,
    ds.school_name,
    ds.school_city,
    ds.school_st_abbr,
    ds.school_state,
    ds.school_zip,
    ds.school_region,
    ds.school_longitude,
    ds.school_latitude,
    ds.school_main_campus_flag,
    ds.school_size_category,
    ds.school_url,
    ds.school_control,
    ds.school_level,
    fs.school_admission_rate,
    fs.school_in_state_price,
    fs.school_out_state_price,
    fs.school_retention_rate,
    fs.school_graduation_rate_4yrs,
    fs.school_graduation_rate_6yrs,
    fs.school_federal_loan_rate,
    fs.school_students_with_any_loan,
    fs.school_median_debt_graduates,
    fs.school_median_debt_graduates_monthly_payments,
    fs.SAT_reading_25th_percentile,
    fs.SAT_reading_75th_percentile,
    fs.SAT_math_25th_percentile,
    fs.SAT_math_75th_percentile,
    fs.SAT_reading_midpoint,
    fs.SAT_math_midpoint,
    fs.ACT_composite_25th_percentile,
    fs.ACT_composite_75th_percentile,
    fs.ACT_english_25th_percentile,
    fs.ACT_english_75th_percentile,
    fs.ACT_math_25th_percentile,
    fs.ACT_math_75th_percentile,
    fs.ACT_composite_midpoint,
    fs.ACT_english_midpoint,
    fs.ACT_math_midpoint,
    sy.school_year_value
  ORDER BY sy.school_year_value