{{
    config(
        materialized='table',
        schema = 'chess',
        tags = ['chess']
    )
}}

WITH WHITE AS (
    SELECT WHITE_ID PLAYER_ID
            ,GAME_ID
            ,RATED
            ,'White' PLAYED_AS
            ,TURNS
            ,VICTORY_STATUS
            ,WINNER
            ,CASE WHEN WINNER = 'White' THEN 'Won'
                  WHEN WINNER = 'Black' THEN 'Lost'
                  ELSE 'Draw'
             END GAME_RESULT
            ,TIME_INCREMENT GAME_TIME
            ,TIME_CONTROLS  GAME_TIME_CONTROL
            ,WHITE_RATING PLAYER_RATING
            ,OPENING_SHORTNAME OPENING_STYLE
            ,OPENING_VARIATION 
    FROM {{ref('games')}}
)
,BLACK AS (
    SELECT BLACK_ID PLAYER_ID
            ,GAME_ID
            ,RATED
            ,'Black' PLAYED_AS
            ,TURNS
            ,VICTORY_STATUS
            ,WINNER
            ,CASE WHEN WINNER = 'White' THEN 'Lost'
                  WHEN WINNER = 'Black' THEN 'Won'
                  ELSE 'Draw'
             END GAME_RESULT
            ,TIME_INCREMENT GAME_TIME
            ,TIME_CONTROLS  GAME_TIME_CONTROL
            ,BLACK_RATING PLAYER_RATING
            ,'N/A' OPENING_STYLE
            ,'N/A' OPENING_VARIATION 
    FROM {{ref('games')}}
) 
, PLAYERS AS (
    SELECT * FROM WHITE
    UNION ALL
    SELECT * FROM BLACK
)

SELECT * FROM PLAYERS