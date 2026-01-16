-- Create Silver table
CREATE OR REPLACE TABLE SILVER_HOTEL_BOOKING (
    booking_id VARCHAR,
    hotel_id VARCHAR,
    hotel_city VARCHAR,
    customer_id VARCHAR,
    customer_name VARCHAR,
    customer_email VARCHAR,
    check_in_date DATE,
    check_out_date DATE,
    room_type STRING,
    num_guest INTEGER,
    total_amount DOUBLE,
    currency STRING,
    booking_status STRING
);

-- Validating Email and missing value
SELECT customer_email 
FROM BRONZE_HOTEL_BOOKING
WHERE customer_email NOT LIKE '%@%.%' OR customer_email IS NULL;

-- Validating Negative number in total_amount
SELECT total_amount
FROM BRONZE_HOTEL_BOOKING
WHERE total_amount <= 0 OR total_amount IS NULL;

-- Validating Negative number in num_guest
SELECT num_guest
FROM BRONZE_HOTEL_BOOKING
WHERE num_guest <= 0 OR num_guest IS NULL;

-- Validating the check_in_date is greater than check_out_date
SELECT TRY_CAST(check_in_date AS DATE), TRY_CAST(check_out_date AS DATE)
FROM BRONZE_HOTEL_BOOKING
WHERE TRY_CAST(check_in_date AS DATE) > TRY_CAST(check_out_date AS DATE)

-- Validating Booking status
SELECT DISTINCT TRIM(booking_status) AS booking_status
FROM BRONZE_HOTEL_BOOKING

-- Cleaned and Insert data into silver table
INSERT INTO SILVER_HOTEL_BOOKING
SELECT 
    booking_id,
    hotel_id ,
    INITCAP(TRIM(hotel_city)) as hotel_city ,
    customer_id ,
    INITCAP(TRIM(customer_name)) as customer_name ,
    CASE 
        WHEN TRIM(customer_email) NOT LIKE '%@%.%' THEN NULL
        ELSE LOWER(TRIM(customer_email))
    END as customer_email,
    CASE 
        WHEN TRY_TO_DATE(NULLIF(check_in_date,'')) IS NULL THEN NULL
        WHEN (TRY_TO_DATE(NULLIF(check_out_date,'')) IS NOT NULL) AND (TRY_TO_DATE(check_in_date) > TRY_TO_DATE(check_out_date)) THEN TRY_TO_DATE(check_out_date)
        ELSE TRY_TO_DATE(check_in_date)
    END AS check_in_date,
    CASE 
        WHEN TRY_TO_DATE(NULLIF(check_out_date, '')) IS NULL THEN NULL
        WHEN (TRY_TO_DATE(NULLIF(check_in_date, '')) IS NOT NULL) AND (TRY_TO_DATE(check_in_date) > TRY_TO_DATE(check_out_date)) THEN TRY_TO_DATE(check_in_date)
        ELSE TRY_TO_DATE(check_out_date)
    END AS check_out_date,
    INITCAP(TRIM(room_type)) AS room_type,
    ABS(num_guest) as num_guest,
    ABS(total_amount) as total_amount,
    UPPER(currency) as currency,
    CASE 
        WHEN booking_status IN ('Confirmeeed', 'Confirmed') THEN 'Confirmed'
        ELSE booking_status
    END AS booking_status
FROM BRONZE_HOTEL_BOOKING;

-- Check Data in silver table
SELECT * FROM SILVER_HOTEL_BOOKING;

-- Validating Email and missing value 
-- Expect: 0 rows
SELECT customer_email 
FROM SILVER_HOTEL_BOOKING   
WHERE customer_email NOT LIKE '%@%.%';

-- Validating Negative number in total_amount
-- Expect: 0 rows
SELECT total_amount
FROM SILVER_HOTEL_BOOKING
WHERE total_amount <= 0;

-- Validating Negative number in num_guest
-- Expect: 0 rows
SELECT num_guest
FROM SILVER_HOTEL_BOOKING
WHERE num_guest <= 0;

-- Validating the check_in_date is greater than check_out_date
-- Expect: 0 rows
SELECT TRY_CAST(check_in_date AS DATE), TRY_CAST(check_out_date AS DATE)
FROM SILVER_HOTEL_BOOKING
WHERE TRY_CAST(check_in_date AS DATE) > TRY_CAST(check_out_date AS DATE)

-- Validating Booking status
SELECT DISTINCT TRIM(booking_status) AS booking_status
FROM SILVER_HOTEL_BOOKING