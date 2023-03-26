{{
    config(
        materialized='table',
        schema = 'mexico_toys',
        tags = ['mexico_toys']
    )
}}

WITH SALES AS (
    SELECT SALE_ID
            ,DATE SALES_DATE
            ,STORE_ID
            ,PRODUCT_ID
            ,UNITS
    FROM {{source('toys', 'SALES')}} 
)
,STORES AS(
    SELECT STORE_ID
            ,STORE_NAME
            ,STORE_CITY
            ,STORE_LOCATION
            ,STORE_OPEN_DATE
    FROM {{source('toys', 'STORES')}}
)
,PRODUCTS AS (
    SELECT PRODUCT_ID
            ,PRODUCT_NAME
            ,PRODUCT_CATEGORY
            ,PRODUCT_COST
            ,PRODUCT_PRICE
    FROM {{source('toys', 'PRODUCTS')}}
)

SELECT SALE_ID,  SALES_DATE, 
        STORE_NAME, STORE_CITY, STORE_LOCATION, STORE_OPEN_DATE,
        PRODUCT_NAME, PRODUCT_CATEGORY, REPLACE(PRODUCT_COST,'$','')::INTEGER PRODUCT_COST, 
        REPLACE(PRODUCT_PRICE,'$','')::INTEGER PRODUCT_PRICE,
        UNITS,
        ((REPLACE(PRODUCT_COST,'$','')::INTEGER) * UNITS) COST_PRICE,
        ((REPLACE(PRODUCT_PRICE,'$','')::INTEGER) * UNITS) RETAIL_SELLING_PRICE,
        (((REPLACE(PRODUCT_PRICE,'$','')::INTEGER) - (REPLACE(PRODUCT_COST,'$','')::INTEGER))* UNITS) PROFIT_LOSS
FROM SALES S
JOIN STORES ST
ON S.STORE_ID = ST.STORE_ID
JOIN PRODUCTS P
ON S.PRODUCT_ID = P.PRODUCT_ID
