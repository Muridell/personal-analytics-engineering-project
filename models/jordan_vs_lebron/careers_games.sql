

WITH TEAM AS(
    SELECT ABBREVIATION, CITY,
        ,CONCAT(CITY,' ',NICKNAME) TEAM_NAME
        ,ARENA
    FROM {{source('jordan_lebron', 'TEAMS')}}
)

,JOR_CAR AS (
    SELECT GAME SEASON_GAME_ID
        ,DATE GAME_DATE
        ,AGE
        ,TEAM
        ,OPP
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
        ,GAME_SCORE
    FROM {{source('jordan_lebron', 'JORDAN_CAREER')}}
)

SELECT * FROM JOR_CAR