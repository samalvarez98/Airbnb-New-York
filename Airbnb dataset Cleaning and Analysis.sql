--CLEANING DATASET

SELECT DISTINCT id, UPPER(TRIM(name)) AS House_name
FROM airbnb_data;

-- REMOVING NULLS IN HOUSE_NAME
SELECT UPPER(TRIM(name)) AS Property_name, *
FROM airbnb_data
WHERE name IS NOT NULL;


-- USING ISNULL TO REPLACE NULL VALUES FOR 'UNKNOWN' AND DATE IS FIXED TO THE RIGHT FORMAT
SELECT UPPER(TRIM(name)) AS Property_name, *, ISNULL(UPPER(TRIM(name)), 'Unknown') AS Property_name2, 
CAST(last_review AS DATE) AS last_review
FROM airbnb_data
ORDER BY Property_name2 DESC;

--FINDING DUPLICATES IN THE DATASET
WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                host_id, 
                latitude, 
                longitude
			ORDER BY 
                host_id, 
                latitude, 
                longitude
        ) row_num
    FROM airbnb_data
)
SELECT * FROM cte
WHERE row_num > 1;
-- NO DUPLICATES WERE FOUND 


-- Filtering the date to only airbnb's with a price below $200 in year 2019 USING SUBQURRIES IN THE WHERE AND SELECT CLAUSES w
SELECT ISNULL(UPPER(TRIM(name)), 'Unknown') AS Property_name, host_name, CONCAT(neighbourhood,', ', neighbourhood_group ) AS Neigh_borough , room_type,
CAST(last_review AS DATE) AS last_review, minimum_nights,
ROUND((SELECT AVG(minimum_nights) 
FROM airbnb_data), 2) AS AVG_MinimumNights_of_all_properties
FROM airbnb_data
WHERE price > 200 AND last_review LIKE '%2019%' AND minimum_nights <= (SELECT AVG(minimum_nights) 
FROM airbnb_data)
ORDER BY last_review;

--Total Number of Room_type by Neighbourhood_borough
SELECT CONCAT(neighbourhood,', ', neighbourhood_group ) AS Neigh_borough, room_type, COUNT(room_type) AS Number_of_RoomType
FROM airbnb_data
GROUP BY CONCAT(neighbourhood,', ', neighbourhood_group ), room_type
ORDER BY COUNT(room_type)DESC;

--Total Number of Room_type
SELECT  room_type, COUNT(room_type) AS Number_of_RoomType
FROM airbnb_data
GROUP BY room_type
ORDER BY COUNT(room_type)DESC;