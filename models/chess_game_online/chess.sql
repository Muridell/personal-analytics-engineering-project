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
        ,CASE WHEN TIME_INCREMENT IN ('1+0', '0+1', '2+1', '1+2', '1+1') THEN 'Bullet'
              WHEN TIME_INCREMENT IN ('3+0', '3+2', '2+3', '5+0', '5+3', '5+5', '5+2') THEN 'Blitz'
              WHEN TIME_INCREMENT IN ('10+0', '10+5', '5+10', '15+10', '15+2') THEN 'Rapid'
              WHEN TIME_INCREMENT IN ('30+0', '30+20', '20+0','60+0') THEN 'Classical'
              ELSE 'Custom'
         END TIME_CONTROLS
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