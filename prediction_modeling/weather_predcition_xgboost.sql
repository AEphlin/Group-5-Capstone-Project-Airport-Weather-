CREATE OR REPLACE MODEL `carbide-sweep-428517-c0.historic_airport_weather.flight_delay_prediction_model_xgboost`
OPTIONS(model_type='boosted_tree_regressor', 
        input_label_cols=['arrival_delay_minutes'],
        max_iterations=100, 
        learn_rate=0.1) AS

SELECT
  -- Time-related features
  year,
  quarter,
  month,
  day,
  day_of_week,
  
  -- Flight-related features
  airline,
  origin_airport,
  destination_airport,
  scheduled_departure_time,
  flight_distance,
  
  -- Weather-related features (origin airport)
  origin_avg_temp,
  origin_min_temp,
  origin_max_temp,
  origin_precipitation,
  origin_snow_depth,
  origin_wind_speed,
  origin_air_pressure,
  
  -- Weather-related features (destination airport)
  dest_avg_temp,
  dest_min_temp,
  dest_max_temp,
  dest_precipitation,
  dest_snow_depth,
  dest_wind_speed,
  dest_air_pressure,
  CASE 
    WHEN scheduled_departure_time BETWEEN '00:00' AND '06:00' THEN 'Night'
    WHEN scheduled_departure_time BETWEEN '06:00' AND '12:00' THEN 'Morning'
    WHEN scheduled_departure_time BETWEEN '12:00' AND '18:00' THEN 'Afternoon'
    ELSE 'Evening'
  END AS departure_time_block,
  
  -- Label (Target Variable)
  CAST(arrival_delay_minutes AS FLOAT64) AS arrival_delay_minutes

FROM
  `carbide-sweep-428517-c0.historic_airport_weather.prepared_flight_data`

WHERE
  -- Filtering out rows with missing target values
  arrival_delay_minutes IS NOT NULL;
