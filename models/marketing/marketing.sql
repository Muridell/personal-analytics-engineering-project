{{
    config(
        materialized='table',
        schema = 'marketing',
        tags = ['marketing']
    )
}}

SELECT ID
        ,YEAR_BIRTH
        ,EDUCATION
        ,MARITAL_STATUS
        ,INCOME
        ,KIDHOME
        ,TEENHOME
        ,DT_CUSTOMER
        ,RECENCY
        ,MNT_WINES
        ,MNT_FRUITS
        ,MNT_MEAT_PRODUCTS
        ,MNT_FISH_PRODUCTS
        ,MNT_SWEET_PRODUCTS
        ,MNT_GOLD_PRODS
        ,NUM_DEALS_PURCHASES
        ,NUM_WEB_PURCHASES
        ,NUM_CATALOG_PURCHASES
        ,NUM_STORE_PURCHASES
        ,NUM_WEB_VISITS_MONTH
        ,ACCEPTED_CMP_3
        ,ACCEPTED_CMP_4
        ,ACCEPTED_CMP_5
        ,ACCEPTED_CMP_1
        ,ACCEPTED_CMP_2
        ,RESPONSE
        ,COMPLAIN
        ,COUNTRY
FROM {{source('marketing', 'MARKETING_DATA')}}