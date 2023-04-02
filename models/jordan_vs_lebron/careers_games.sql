{{
    config(
        materialized='table',
        schema = 'lebron_vs_jordan',
        tags = ['lebron', 'jordan', 'basketball']
    )
}}

WITH TEAM AS(
    SELECT ABBREVIATION, CITY
        ,CONCAT(CITY,' ',NICKNAME) TEAM_NAME
        ,ARENA
    FROM {{source('jordan_lebron', 'TEAMS')}}
)

,JOR_CAR AS (
    SELECT 'Jordan' AS PLAYER
        ,GAME SEASON_GAME_ID
        ,DATE GAME_DATE
        ,AGE
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
    FROM {{source('jordan_lebron', 'JORDAN_CAREER')}} JC
    JOIN TEAM T
    ON JC.TEAM = T.ABBREVIATION 
    JOIN TEAM OPP
    ON JC.OPP = OPP.ABBREVIATION
)
,LEB_CAR AS (
    SELECT 'Lebron' AS PLAYER
        ,GAME SEASON_GAME_ID
        ,DATE GAME_DATE
        ,AGE
        ,TEAM
        ,T.TEAM_NAME LEBRON_TEAM
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
    FROM {{source('jordan_lebron', 'LEBRON_CAREER')}} LC
    LEFT JOIN TEAM T
    ON LC.TEAM = T.ABBREVIATION
    JOIN TEAM OPP
    ON LC.OPP = OPP.ABBREVIATION
)

SELECT * FROM LEB_CAR
UNION ALL
SELECT * FROM JOR_CAR
ORDER BY 2, 3