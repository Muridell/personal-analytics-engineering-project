{{
    config(
        materialized='table',
        schema = 'airline',
        tags = ['airline']
    )
}}


WITH passenger_satisfaction as (
SELECT  ID
        ,GENDER
        ,AGE
        ,CASE WHEN AGE BETWEEN 1 AND 12 THEN 'Children'
                WHEN AGE > 12 THEN 'Adult'
        END AGE_CATEGORY
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
        ,CASE WHEN AGE BETWEEN 1 AND 12 THEN 'Children'
                WHEN AGE > 12 THEN 'Adult'
        END 
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

SELECT *,
        CASE WHEN (ROUND(OVERALL_AVG_RATING,1) < 3.5) AND SATISFACTION = 'Neutral or Dissatisfied'
             THEN 'Rating correlates with Satisfaction'
             WHEN (ROUND(OVERALL_AVG_RATING,1) >= 3.5) AND SATISFACTION = 'Satisfied'
             THEN 'Rating correlates with Satisfaction'
             ELSE 'Rating does not correlates with Satisfaction'
        END RATING_SATISFACTON_COMPARISON
FROM passenger_satisfaction