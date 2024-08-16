# Flight Delay Prediction Modeling

This repository contains SQL scripts for creating and evaluating models to predict flight delays using historical and real-time data. The models incorporate both flight-related and weather-related features, leveraging different machine learning algorithms to achieve the best predictive performance.

## Scripts Overview

### 1. Classification Model

**File:** `classification_model.sql`

This script prepares data and creates a logistic regression model to classify whether a flight will be delayed by more than 120 minutes.

- **Data Preparation:**
  - Selects time-related, flight-related, and weather-related features.
  - Creates a binary label (`is_delay_greater_than_120`) indicating whether a flight's arrival delay exceeds 120 minutes.
  
- **Model Creation:**
  - A logistic regression model is trained using the selected features to predict the binary delay outcome.

- **Key Features:**
  - Time: `year`, `quarter`, `month`, `day`, `day_of_week`
  - Flight: `origin_airport`, `destination_airport`
  - Weather: `origin_avg_temp`, `origin_wind_speed`, `dest_avg_temp`, `dest_wind_speed`

### 2. Flight Delay Model Creation

**File:** `flight_delay_model_creation.sql`

This script creates a logistic regression model to predict flight delays using specific flight-related features from the OpenSky dataset.

- **Model Creation:**
  - The model is trained with L1 and L2 regularization to predict whether a flight will be delayed.
  
- **Key Features:**
  - `baro_altitude`
  - `velocity`
  - `vertical_rate`
  - `delayed` (label)

### 3. Weather Prediction Model

**File:** `weather_prediction.sql`

This script creates a linear regression model to predict the exact delay time (in minutes) for flights based on weather conditions.

- **Model Creation:**
  - A linear regression model is trained to predict the `arrival_delay_minutes` using various weather-related and flight-related features.
  
- **Key Features:**
  - Time: `quarter`, `month`, `day`, `day_of_week`
  - Flight: `airline`, `origin_airport`, `destination_airport`, `flight_distance`
  - Weather: Temperature, precipitation, snow depth, wind speed, air pressure at both origin and destination airports

### 4. Weather Prediction with XGBoost

**File:** `weather_prediction_xgboost.sql`

This script creates a more advanced model using the XGBoost algorithm to predict flight delays with better accuracy.

- **Model Creation:**
  - An XGBoost model (boosted tree regressor) is trained to predict `arrival_delay_minutes`, incorporating more complex interactions between features.
  - The model includes up to 100 iterations and a learning rate of 0.1.
  
- **Key Features:**
  - Time: `year`, `quarter`, `month`, `day`, `day_of_week`
  - Flight: `airline`, `origin_airport`, `destination_airport`, `scheduled_departure_time`, `flight_distance`
  - Weather: Temperature, precipitation, snow depth, wind speed, air pressure at both origin and destination airports
  - Derived Feature: `departure_time_block` (categorizes scheduled departure time into Night, Morning, Afternoon, Evening)

## Usage

1. **Run the SQL scripts** in Google BigQuery to create the respective models.
2. **Use the models** for predicting flight delays based on the provided features.
3. **Evaluate the models** using the available metrics (e.g., precision, recall, F1 score) to assess their performance and choose the best one for deployment.

## Key Considerations

- **Data Quality:** Ensure that the input data is clean and properly formatted to avoid errors during model training.
- **Model Selection:** Choose between the logistic regression, linear regression, and XGBoost models based on the desired trade-off between interpretability and accuracy.
- **Feature Engineering:** Additional features or derived variables (like `departure_time_block`) can improve model performance.

## Conclusion

These scripts provide a comprehensive approach to predicting flight delays using a variety of machine learning models. By incorporating both flight-related and weather-related features, the models aim to provide accurate and actionable insights that can be used in real-time flight operations.
