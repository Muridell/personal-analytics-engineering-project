{{
    config(
        materialized='table',
        schema = 'airbnb',
        tags = ['airbnb']
    )
}}


WITH passenger_satisfaction as (
SELECT  ID
        ,GENDER
        ,AGE
        ,CUSTOMER_TYPE
        ,TYPE_OF_TRAVEL
        ,CLASS
        ,FLIGHT_DISTANCE
        ,DEPARTURE_DELAY
        ,ARRIVAL_DELAY
        ,DEPARTURE_AND_ARRIVAL_TIME_CONVENIENCE
        ,EASE_OF_ONLINE_BOOKING
        ,CHECK_IN_SERVICE
        ,ONLINE_BOARDING
        ,GATE_LOCATION
        ,ON_BOARD_SERVICE
        ,SEAT_COMFORT
        ,LEG_ROOM_SERVICE
        ,CLEANLINESS
        ,FOOD_AND_DRINK
        ,IN_FLIGHT_SERVICE
        ,IN_FLIGHT_WIFI_SERVICE
        ,IN_FLIGHT_ENTERTAINMENT
        ,BAGGAGE_HANDLING
        ,SUM (DEPARTURE_AND_ARRIVAL_TIME_CONVENIENCE + EASE_OF_ONLINE_BOOKING
        +CHECK_IN_SERVICE + ONLINE_BOARDING + GATE_LOCATION + ON_BOARD_SERVICE
        + SEAT_COMFORT + LEG_ROOM_SERVICE + CLEANLINESS + FOOD_AND_DRINK
        + IN_FLIGHT_SERVICE + IN_FLIGHT_WIFI_SERVICE + IN_FLIGHT_ENTERTAINMENT + BAGGAGE_HANDLING
        )/14 OVERALL_AVG_RATING
        ,SATISFACTION
FROM
{{source('airline', 'AIRLINE_PASSENGER_SATISFACTION')}}
GROUP BY ID
        ,GENDER
        ,AGE
        ,CUSTOMER_TYPE
        ,TYPE_OF_TRAVEL
        ,CLASS
        ,FLIGHT_DISTANCE
        ,DEPARTURE_DELAY
        ,ARRIVAL_DELAY
        ,DEPARTURE_AND_ARRIVAL_TIME_CONVENIENCE
        ,EASE_OF_ONLINE_BOOKING
        ,CHECK_IN_SERVICE
        ,ONLINE_BOARDING
        ,GATE_LOCATION
        ,ON_BOARD_SERVICE
        ,SEAT_COMFORT
        ,LEG_ROOM_SERVICE
        ,CLEANLINESS
        ,FOOD_AND_DRINK
        ,IN_FLIGHT_SERVICE
        ,IN_FLIGHT_WIFI_SERVICE
        ,IN_FLIGHT_ENTERTAINMENT
        ,BAGGAGE_HANDLING
        ,SATISFACTION
)

SELECT *, ROUND(OVERALL_AVG_RATING, 1),
        CASE WHEN (ROUND(OVERALL_AVG_RATING,1) < 3.5) AND SATISFACTION = 'Neutral or Dissatisfied'
             THEN 'Rating correlates with Satisfaction'
             WHEN (ROUND(OVERALL_AVG_RATING,1) >= 3.5) AND SATISFACTION = 'Satisfied'
             THEN 'Rating correlates with Satisfaction'
             ELSE 'Rating does not correlates with Satisfaction'
        END RATING_SATISFACTON_COMPARISON
FROM passenger_satisfaction