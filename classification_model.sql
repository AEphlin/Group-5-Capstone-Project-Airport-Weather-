-- Step 1: Prepare Data and Create Label
CREATE OR REPLACE TABLE `carbide-sweep-428517-c0.historic_airport_weather.prepared_classification_data` AS
SELECT
  -- Time-related features
  year,
  quarter,
  month,
  day,
  day_of_week,
  scheduled_departure_time,
  
  -- Flight-related features
  origin_airport,
  destination_airport,
  
  -- Weather-related features (origin and destination)
  origin_avg_temp,
  origin_min_temp,
  origin_max_temp,
  origin_wind_speed,
  origin_air_pressure,
  dest_avg_temp,
  dest_min_temp,
  dest_max_temp,
  dest_wind_speed,
  dest_air_pressure,
  
  -- Create binary label
  IF(CAST(arrival_delay_minutes AS FLOAT64) > 1300, 1, 0) AS is_delay_greater_than_120

FROM
  `carbide-sweep-428517-c0.historic_airport_weather.prepared_flight_data`
WHERE
  arrival_delay_minutes IS NOT NULL
  AND SAFE_CAST(arrival_delay_minutes AS FLOAT64) IS NOT NULL;

-- Step 2: Create the Classification Model
CREATE OR REPLACE MODEL `carbide-sweep-428517-c0.historic_airport_weather.flight_delay_classification_model`
OPTIONS(model_type='logistic_reg', 
        input_label_cols=['is_delay_greater_than_120']) AS

SELECT
  -- Time-related features
  year,
  quarter,
  month,
  day,
  day_of_week,
  
  -- Flight-related features
  destination_airport,
  
  -- Weather-related features (origin and destination)
  dest_avg_temp,
  dest_min_temp,
  dest_max_temp,
  dest_wind_speed,
  dest_air_pressure,
  
  is_delay_greater_than_120
FROM
  `carbide-sweep-428517-c0.historic_airport_weather.prepared_classification_data`;
