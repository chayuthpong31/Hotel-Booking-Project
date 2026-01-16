-- Create Gold_Agg_Daily_Booking Table
CREATE OR REPLACE TABLE GOLD_AGG_DAILY_BOOKING AS
    SELECT 
        check_in_date,
        COUNT(*) AS total_booking,
        SUM(total_amount) AS total_revenue
    FROM SILVER_HOTEL_BOOKING
    GROUP BY check_in_date;

SELECT * FROM GOLD_AGG_DAILY_BOOKING;

-- Create Gold_Agg_Hotel_City_Sales Table
CREATE OR REPLACE TABLE GOLD_AGG_HOTEL_CITY_SALES AS
    SELECT 
        hotel_city,
        COUNT(*) AS total_booking,
        SUM(total_amount) AS total_revenue
    FROM SILVER_HOTEL_BOOKING
    GROUP BY hotel_city;

SELECT * FROM GOLD_AGG_HOTEL_CITY_SALES;

-- Create Gold Cleaned Table
CREATE OR REPLACE TABLE GOLD_BOOKING_CLEAN AS
SELECT * FROM SILVER_HOTEL_BOOKING