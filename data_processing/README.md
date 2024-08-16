# Flight and Weather Data Preparation

## Overview

This SQL script is designed to prepare a comprehensive dataset that combines flight information with corresponding weather data at both origin and destination airports. The data focuses on four major U.S. airports: Los Angeles International Airport (LAX), John F. Kennedy International Airport (JFK), Chicago O'Hare International Airport (ORD), and Hartsfield-Jackson Atlanta International Airport (ATL). The resulting dataset is stored in a BigQuery table for further analysis, including machine learning tasks such as predicting flight delays based on weather conditions.

## Query Breakdown

### 1. Data Extraction and Transformation

- **Flight Data:** The script starts by selecting relevant columns from the `flights_2022` table within the `lab3_bts` dataset. It filters flights based on the four specified airports, extracting information such as the origin, destination, airline, flight date, and delay times.
  
  - **Origin and Destination Airports:** The origin and destination airports are standardized using a `CASE` statement that matches the airport codes for ORD, ATL, JFK, and LAX.

### 2. Delay Calculations

- **Departure and Arrival Delays:** The query handles the `departure_delay_minutes` and `arrival_delay_minutes` by using the `SAFE_CAST`, `TRIM`, and `REPLACE` functions. This ensures that any extraneous characters (such as quotes) are removed, and the data is properly cast to `FLOAT64` for numerical operations.

### 3. Weather Data Integration

- **Weather Data:** The script joins the flight data with corresponding weather data from the `airport_weather_2022` table. This data includes average temperature, minimum and maximum temperature, precipitation, snow depth, wind speed, and air pressure for both the origin and destination airports.
  
  - **Join Conditions:** The joins are performed based on the flight date and airport code, ensuring that the correct weather data is matched with each flight.

### 4. Data Filtering

- **Airport Filtering:** The `WHERE` clause filters the results to include only flights where both the origin and destination are among the four specified airports (LAX, JFK, ORD, ATL).

### 5. Output

- **Resulting Table:** The final dataset is stored in the `prepared_flight_data` table within the `historic_airport_weather` dataset. This table can then be used for further analysis, such as predicting flight delays based on weather conditions.

## Usage

This script can be run in Google BigQuery. The resulting table will contain detailed flight and weather information that can be used for various analytical purposes, including machine learning models aimed at predicting flight delays.

## Key Considerations

- **Data Quality:** The script includes data cleaning steps to handle inconsistencies, such as extraneous quotes in delay time fields.
- **Modeling Potential:** The prepared dataset is particularly well-suited for predictive modeling tasks where weather data is a key factor in predicting flight delays.

## Prerequisites

- **Google BigQuery Access:** Ensure you have access to the relevant datasets in BigQuery.
- **BigQuery Storage:** The script creates a new table; ensure your project has sufficient storage capacity.

## Conclusion

This script is a robust tool for preparing a dataset that combines flight and weather data for major U.S. airports. By integrating historical weather data with flight information, it provides a solid foundation for predictive analysis and other data-driven insights.
