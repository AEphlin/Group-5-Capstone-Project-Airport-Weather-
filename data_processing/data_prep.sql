--CREATE OR REPLACE TABLE `carbide-sweep-428517-c0.historic_airport_weather.prepared_flight_data` AS
WITH flights AS (
  SELECT *,
    CASE
      WHEN _Origin_ LIKE '%ORD%' THEN 'ORD'
      WHEN _Origin_ LIKE '%ATL%' THEN 'ATL'
      WHEN _Origin_ LIKE '%JFK%' THEN 'JFK'
      WHEN _Origin_ LIKE '%LAX%' THEN 'LAX'
    END AS origin_airport,
    CASE
      WHEN _DestCityName_ LIKE '%ORD%' THEN 'ORD'
      WHEN _DestCityName_ LIKE '%ATL%' THEN 'ATL'
      WHEN _DestCityName_ LIKE '%JFK%' THEN 'JFK'
      WHEN _DestCityName_ LIKE '%LAX%' THEN 'LAX'
    END AS destination_airport
  FROM `carbide-sweep-428517-c0.lab3_bts.flights_2022` AS flights
)
SELECT
  flights._Year_ AS year,
  flights._Quarter_ AS quarter,
  flights._Month_ AS month,
  flights._DayofMonth_ AS day,
  flights._DayOfWeek_ AS day_of_week,
  flights._FlightDate_ AS flight_date,
  flights._Reporting_Airline_ AS airline,
  flights.origin_airport,
  flights.destination_airport,
  flights._CRSDepTime_ AS scheduled_departure_time,
  flights._DepTime_ AS actual_departure_time,
  flights._DepDelay_ AS departure_delay,
  SAFE_CAST(TRIM(REPLACE(flights._DepDelayMinutes_, '"', '')) AS FLOAT64) AS departure_delay_minutes,
  flights._ArrDelay_ AS arrival_delay,
  SAFE_CAST(TRIM(REPLACE(flights._ArrDelayMinutes_, '"', '')) AS FLOAT64) AS arrival_delay_minutes,
  flights._Distance_ AS flight_distance,
  
  -- Weather data (Origin airport weather)
  origin_weather.tavg AS origin_avg_temp,
  origin_weather.tmin AS origin_min_temp,
  origin_weather.tmax AS origin_max_temp,
  origin_weather.prcp AS origin_precipitation,
  origin_weather.snow AS origin_snow_depth,
  origin_weather.wspd AS origin_wind_speed,
  origin_weather.pres AS origin_air_pressure,
  -- Weather data (Destination airport weather)
  dest_weather.tavg AS dest_avg_temp,
  dest_weather.tmin AS dest_min_temp,
  dest_weather.tmax AS dest_max_temp,
  dest_weather.prcp AS dest_precipitation,
  dest_weather.snow AS dest_snow_depth,
  dest_weather.wspd AS dest_wind_speed,
  dest_weather.pres AS dest_air_pressure
  
FROM
  flights
  
LEFT JOIN
  `carbide-sweep-428517-c0.historic_airport_weather.airport_weather_2022` AS origin_weather
ON
  flights._FlightDate_ = origin_weather.date AND origin_airport = origin_weather.airport
  
LEFT JOIN
  `carbide-sweep-428517-c0.historic_airport_weather.airport_weather_2022` AS dest_weather
ON
  flights._FlightDate_ = dest_weather.date AND destination_airport = dest_weather.airport
WHERE origin_airport IN ('LAX','JFK','ORD','ATL') AND destination_airport IN ('LAX','JFK','ORD','ATL')

