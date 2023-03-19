{{
    config(
        materialized='table',
        schema = 'chess',
        tags = ['chess']
    )
}}


WITH CHESS AS
(
    SELECT GAME_ID
        ,RATED
        ,TURNS
        ,VICTORY_STATUS
        ,WINNER
        ,TIME_INCREMENT
        ,WHITE_ID
        ,WHITE_RATING
        ,BLACK_ID
        ,BLACK_RATING
        ,MOVES
        ,OPENING_CODE
        ,OPENING_MOVES
        ,OPENING_FULLNAME
        ,OPENING_SHORTNAME
        ,OPENING_RESPONSE
        ,OPENING_VARIATION
    FROM 
    {{source('chess','CHESS_GAMES')}}
)

SELECT * FROM CHESS