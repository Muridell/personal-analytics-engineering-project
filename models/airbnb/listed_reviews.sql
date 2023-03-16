{{
    config(
        materialized='table',
        schema = 'airbnb',
        tags = ['airbnb']
    )
}}


WITH LISTINGS AS 
(
    SELECT * FROM {{ref('host_listings')}}
)

,REVIEWS AS
(
    SELECT * FROM {{ref('reviews')}}
)

,LISTED_REVIEWS AS
(
    SELECT  R.REVIEW_DATE,
            R.REVIEW_ID,
            R.REVIEWER_ID AS REVIEWER,
            L.LISTING_ID AS HOST_LISTING_ID,
            R.LISTING_ID AS REVIEW_LISTING_ID,
            L.LISTING_DESC,
            L.HOST,
            L.HOST_JOIN_DATE,
            L.HOST_LOCATION,
            L.HOST_RESPONSE_TIME,
            L.HOST_RESPONSE_RATE_PERCENT,
            L.HOST_ACCEPTANCE_RATE_PERCENT,
            L.HOST_IS_SUPERHOST,
            L.HOST_TOTAL_LISTINGS_COUNT,
            L.HOST_HAS_PROFILE_PIC,
            L.HOST_IDENTITY_VERIFIED,
            L.NEIGHBOURHOOD,
            L.DISTRICT,
            L.CITY,
            L.LATITUDE,
            L.LONGITUDE,
            L.PROPERTY_TYPE,
            L.ROOM_TYPE,
            L.ACCOMMODATES,
            L.BEDROOMS,
            L.AMENITIES,
            L.PRICE,
            L.MINIMUM_NIGHTS,
            L.MAXIMUM_NIGHTS,
            L.REVIEW_SCORES_RATING,
            L.REVIEW_SCORES_ACCURACY,
            L.REVIEW_SCORES_CLEANLINESS,
            L.REVIEW_SCORES_CHECKIN,
            L.REVIEW_SCORES_COMMUNICATION,
            L.REVIEW_SCORES_LOCATION,
            L.REVIEW_SCORES_VALUE,
            L.INSTANT_BOOKABLE
    FROM LISTINGS L
    RIGHT JOIN REVIEWS R
    ON L.LISTING_ID = R.LISTING_ID
)

SELECT * FROM LISTED_REVIEWS
ORDER BY 1 DESC
