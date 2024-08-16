CREATE OR REPLACE MODEL `carbide-sweep-428517-c0.historic_airport_weather.flight_delay_prediction_model`
OPTIONS(model_type='linear_reg', 
        input_label_cols=['arrival_delay_minutes']) AS

SELECT
  quarter,
  month,
  day,
  day_of_week,
  
  -- Flight-related features
  airline,
  origin_airport,
  destination_airport,
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
  
  -- Label (Target Variable)
  CAST(arrival_delay_minutes AS FLOAT64) AS arrival_delay_minutes

FROM
  `carbide-sweep-428517-c0.historic_airport_weather.prepared_flight_data`

WHERE
  -- Filtering out rows with missing target values
  arrival_delay_minutes IS NOT NULL;
