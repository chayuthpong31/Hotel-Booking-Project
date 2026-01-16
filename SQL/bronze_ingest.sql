-- Create Bronze Table
CREATE OR REPLACE TABLE BRONZE_HOTEL_BOOKING (
    booking_id STRING,
    hotel_id STRING,
    hotel_city STRING,
    customer_id STRING,
    customer_name STRING,
    customer_email STRING,
    check_in_date STRING,
    check_out_date STRING,
    room_type STRING,
    num_guest STRING,
    total_amount STRING,
    currency STRING,
    booking_status STRING
);

-- Load data into table
COPY INTO BRONZE_HOTEL_BOOKING
FROM @STG_HOTEL_BOOKINGS 
FILE_FORMAT = (FORMAT_NAME = FF_CSV)
ON_ERROR = 'CONTINUE';

-- Check bronze table
SELECT * FROM BRONZE_HOTEL_BOOKING;