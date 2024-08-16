import requests
import json
import pandas as pd
from google.cloud import storage
from datetime import datetime
 
def download_opensky_data(request):
    # OpenSky API endpoint
    opensky_url = 'https://opensky-network.org/api/states/all'
 
    try:
        # Make the API request
        response = requests.get(opensky_url)
 
        # Check if the request was successful
        if response.status_code == 200:
            data = response.json()
 
            # Generate a unique file name
            current_time = datetime.now().strftime('%Y%m%d%H%M%S')
            json_file_name = f"opensky_data_{current_time}.json"
            csv_file_name = f"opensky_data_{current_time}.csv"
 
            # Save the JSON data to Cloud Storage
            #save_to_gcs(data, json_file_name, 'application/json')
 
            # Convert JSON to CSV and save to Cloud Storage
            save_csv_to_gcs(data, csv_file_name)
 
            return f"Data successfully saved to {json_file_name} and {csv_file_name}", 200
        else:
            return f"Failed to fetch data: {response.status_code}", response.status_code
 
    except requests.exceptions.RequestException as e:
        return f"Error fetching data: {e}", 500
 
def save_to_gcs(data, file_name, content_type):
    # Initialize the Cloud Storage client
    client = storage.Client()
    bucket_name = "opensky-lab5"
 
    try:
        bucket = client.bucket(bucket_name)
 
        # Create a new blob and upload the data
        blob = bucket.blob(file_name)
        blob.upload_from_string(
            data=json.dumps(data),
            content_type=content_type
        )
 
    except Exception as e:
        print(f"Error saving data to Cloud Storage: {e}")
        raise
 
def save_csv_to_gcs(data, file_name):
    # Initialize the Cloud Storage client
    client = storage.Client()
    bucket_name = "opensky-lab5"
 
    try:
        # Extract the "states" data
        states_data = data.get('states', [])
 
        # Define the columns based on the provided data structure
        columns = ["icao24", "callsign", "origin_country", "time_position", "last_contact",
                   "longitude", "latitude", "baro_altitude", "on_ground", "velocity",
                   "true_track", "vertical_rate", "sensors", "geo_altitude", "squawk",
                   "spi", "position_source"]
 
        # Convert the nested array to a DataFrame
        df = pd.DataFrame(states_data, columns=columns)
 
        # Convert the DataFrame to a CSV string
        csv_data = df.to_csv(index=False)
 
        # Upload the CSV data to Cloud Storage
        bucket = client.bucket(bucket_name)
        blob = bucket.blob(file_name)
        blob.upload_from_string(csv_data, content_type='text/csv')
 
    except Exception as e:
        print(f"Error saving CSV data to Cloud Storage: {e}")
        raise

