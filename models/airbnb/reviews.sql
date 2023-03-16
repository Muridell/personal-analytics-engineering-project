{{
    config(
        materialized='table',
        schema = 'airbnb',
        tags = ['airbnb']
    )
}}

WITH REVIEWS AS
(
SELECT  DATE AS REVIEW_DATE,
        REVIEW_ID,
        LISTING_ID,
        REVIEWER_ID 
FROM 
{{ source('airbnb', 'REVIEWS') }}
)

SELECT * FROM REVIEWS
