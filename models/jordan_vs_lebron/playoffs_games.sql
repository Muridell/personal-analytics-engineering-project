{{
    config(
        materialized='table',
        schema = 'lebron_vs_jordan',
        tags = ['lebron', 'jordan', 'basketball', 'playoffs']
    )
}}

WITH TEAM AS(
    SELECT ABBREVIATION, CITY
        ,CONCAT(CITY,' ',NICKNAME) TEAM_NAME
        ,ARENA
    FROM {{source('jordan_lebron', 'TEAMS')}}
)

,JOR_PLAY AS (
    SELECT 'Jordan' AS PLAYER
        ,GAME SEASON_GAME_ID
        ,DATE GAME_DATE
        ,SERIES
        ,CASE WHEN SERIES = 'EC1' THEN 'Eastern Conference First Round'
              WHEN SERIES = 'ECS' THEN 'Eastern Conference Semifinals'
              WHEN SERIES = 'ECF' THEN 'Eastern Conference Finals'
              WHEN SERIES = 'FIN' THEN 'NBA Finals'
              WHEN SERIES = 'WC1' THEN 'Western Conference First Round'
              WHEN SERIES = 'WCS' THEN 'Western Conference Semifinals'
              WHEN SERIES = 'WCF' THEN 'Western Conference Finals'
         END SERIES_NAME
        ,SERIES_GAME
        ,TEAM
        ,T.TEAM_NAME JORDAN_TEAM
        ,OPP
        ,OPP.TEAM_NAME OPPONENT
        ,RESULT
        ,CASE WHEN RESULT LIKE '%W%' THEN 'Win'
              WHEN RESULT LIKE '%L%' THEN 'Lose'
              ELSE 'Draw'
         END GAME_RESULT
        ,MP MINUTES_PLAYED
        ,FG FIELD_GOALS
        ,FGA FIELD_GOALS_ATTEMPT
        ,FGP FIELD_GOALS_PERCENT
        ,THREE THREE_POINTS
        ,THREEATT THREE_POINTS_ATTEMPT
        ,NVL(THREEP,0) THREE_POINTS_PERCENT
        ,FT FREE_THROW
        ,FTA FREE_THROW_ATTEMPT
        ,FTP FREE_THROW_PERCENT
        ,ORB OFFENSIVE_REBOUND
        ,DRB DEFENSIVE_REBOUND
        ,TRB TOTAL_REBOUND
        ,AST ASSISTS
        ,STL STEALS
        ,BLK BLOCKS
        ,TOV TURNOVERS
        ,PTS POINTS
        ,GAME_SCORE PRODUCTIVITY
        ,'0.0'::INTEGER IMPACT
    FROM {{source('jordan_lebron', 'JORDAN_PLAYOFFS')}} JP
    JOIN TEAM T
    ON JP.TEAM = T.ABBREVIATION 
    JOIN TEAM OPP
    ON JP.OPP = OPP.ABBREVIATION
)
,LEB_PLAY AS (
    SELECT 'Lebron' AS PLAYER
        ,GAME SEASON_GAME_ID
        ,DATE GAME_DATE
        ,SERIES
        ,CASE WHEN SERIES = 'EC1' THEN 'Eastern Conference First Round'
              WHEN SERIES = 'ECS' THEN 'Eastern Conference Semifinals'
              WHEN SERIES = 'ECF' THEN 'Eastern Conference Finals'
              WHEN SERIES = 'FIN' THEN 'NBA Finals'
              WHEN SERIES = 'WC1' THEN 'Western Conference First Round'
              WHEN SERIES = 'WCS' THEN 'Western Conference Semifinals'
              WHEN SERIES = 'WCF' THEN 'Western Conference Finals'
         END SERIES_NAME
        ,SERIES_GAME
        ,TEAM
        ,T.TEAM_NAME JORDAN_TEAM
        ,OPP
        ,OPP.TEAM_NAME OPPONENT
        ,RESULT
        ,CASE WHEN RESULT LIKE '%W%' THEN 'Win'
              WHEN RESULT LIKE '%L%' THEN 'Lose'
              ELSE 'Draw'
         END GAME_RESULT
        ,MP MINUTES_PLAYED
        ,FG FIELD_GOALS
        ,FGA FIELD_GOALS_ATTEMPT
        ,FGP FIELD_GOALS_PERCENT
        ,THREE THREE_POINTS
        ,THREEATT THREE_POINTS_ATTEMPT
        ,NVL(THREEP,0) THREE_POINTS_PERCENT
        ,FT FREE_THROW
        ,FTA FREE_THROW_ATTEMPT
        ,FTP FREE_THROW_PERCENT
        ,ORB OFFENSIVE_REBOUND
        ,DRB DEFENSIVE_REBOUND
        ,TRB TOTAL_REBOUND
        ,AST ASSISTS
        ,STL STEALS
        ,BLK BLOCKS
        ,TOV TURNOVERS
        ,PTS POINTS
        ,GAME_SCORE PRODUCTIVITY
        ,PLUS_MINUS IMPACT
    FROM {{source('jordan_lebron', 'LEBRON_PLAYOFFS')}} LP
    LEFT JOIN TEAM T
    ON LP.TEAM = T.ABBREVIATION
    JOIN TEAM OPP
    ON LP.OPP = OPP.ABBREVIATION
)

SELECT * FROM LEB_PLAY
UNION ALL
SELECT * FROM JOR_PLAY
ORDER BY 2, 3