# Flight Delay Prediction Project

## Overview

This repository contains the code and queries of Group 5's capstone project looking into the effects of weather at certain airports. We started by utilizing the data in previous assignments of the class such as the 2022 flight data. In addition to this, we used weather.api to pull active data from 4 major airports, O'Hare, LAX, JFK, and Atlanta. We also collected archived weather data from 2022 of weather conditions in the same airport. Using the archived weather data and the flight data from 2022, we constructed a machine learning model to predict whether a flight would be delayed depending on certain atmospheric conditions. This model coud then be paired to the weather.api data in order to have the model generate the likelihood that a flight to any of these given airports might be delayed based on current conditions.

## Directory Structure

### 1. `data_processing/`

This directory contains the scripts and requirements for processing the initial flight and weather data. The processed data is then used for training the prediction models.

- **Files:**
  - `README.md`: Documentation for the data processing steps.
  - `data_prep.sql`: SQL script to clean and prepare the flight and weather data.
  
- **Subdirectories:**
  - `move_flight/`: Python script and requirements for moving and processing flight data.
    - `main.py`: Script to handle the extraction and transformation of flight data.
    - `requirements.txt`: Dependencies required to run the `main.py` script.
  
  - `move_weather/`: Python script and requirements for moving and processing weather data.
    - `main.py`: Script to handle the extraction and transformation of weather data.
    - `requirements.txt`: Dependencies required to run the `main.py` script.

### 2. `opensky/`

This directory contains the script for integrating real-time flight data from the OpenSky API.

- **Files:**
  - `main.py`: Python script to connect to the OpenSky API, retrieve real-time flight data, and store it for model prediction.

### 3. `prediction_modeling/`

This directory contains SQL scripts for creating and evaluating the machine learning models that predict flight delays.

- **Files:**
  - `README.md`: Documentation for the prediction modeling steps and scripts.
  - `classification_model.sql`: SQL script to create a logistic regression model for classifying significant delays.
  - `flight_delay_model_creation.sql`: SQL script to create a logistic regression model using the OpenSky data.
  - `weather_prediction.sql`: SQL script to create a linear regression model for predicting the exact delay time.
  - `weather_prediction_xgboost.sql`: SQL script to create an XGBoost model for more accurate delay predictions.

### 4. `weatherapi/`

This directory contains the script for integrating real-time weather data from an external weather API.

- **Files:**
  - `main.py`: Python script to connect to a weather API, retrieve real-time weather data, and store it for model prediction.
  - `requirements.txt`: Dependencies required to run the `main.py` script.
  - `README.md`: Documentation for integrating and using the weather API in the project.

## Usage

1. **Data Processing:** Begin by running the scripts in the `data_processing` directory to prepare the flight and weather data. Ensure that all dependencies in `requirements.txt` files are installed.

2. **Real-time Data Integration:**
   - Use the scripts in the `opensky` directory to fetch and integrate real-time flight data.
   - Use the scripts in the `weatherapi` directory to fetch and integrate real-time weather data.

3. **Model Training and Evaluation:**
   - Run the SQL scripts in the `prediction_modeling` directory to create and evaluate models for predicting flight delays. Start with simpler models like `classification_model.sql` and `weather_prediction.sql`, then move on to the more complex `weather_prediction_xgboost.sql`.

4. **Prediction and Analysis:** Once the models are trained, use them to predict flight delays and analyze the results. The predictions can be used to inform stakeholders such as airlines and passengers.

## Requirements

- **Google Cloud Platform (GCP):** This project leverages GCP services such as BigQuery for data storage and model training.
- **Python 3.x:** Required for running the Python scripts in the `opensky`, `move_flight`, `move_weather`, and `weatherapi` directories.
- **APIs:** Access to the OpenSky API and a weather API (such as OpenWeatherMap or WeatherAPI) is necessary for real-time data integration.

## Conclusion

This project provides a comprehensive approach to predicting flight delays using historical data and real-time updates. By combining data processing, machine learning, and real-time data streaming, it offers valuable insights that can be used to improve decision-making in the aviation industry.

---

This README file gives a complete overview of your project structure, guiding users through each component and its purpose. Let me know if you need any changes or additional information!
