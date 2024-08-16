import os
import requests
import csv
import datetime
from google.cloud import storage

def get_weather_data(api_key, airport_codes):
    base_url = "http://api.weatherapi.com/v1/current.json"
    weather_data = []

    for code in airport_codes:
        params = {
            'key': api_key,
            'q': code,
            'aqi': 'no'
        }
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        data = response.json()

        weather_info = {
            'airport': code,
            'last_updated': data['current']['last_updated'],
            'last_updated_epoch': data['current']['last_updated_epoch'],
            'temp_c': data['current']['temp_c'],
            'temp_f': data['current']['temp_f'],
            'feelslike_c': data['current']['feelslike_c'],
            'feelslike_f': data['current']['feelslike_f'],
            'windchill_c': data['current'].get('windchill_c'),
            'windchill_f': data['current'].get('windchill_f'),
            'heatindex_c': data['current'].get('heatindex_c'),
            'heatindex_f': data['current'].get('heatindex_f'),
            'dewpoint_c': data['current']['dewpoint_c'],
            'dewpoint_f': data['current']['dewpoint_f'],
            'condition_text': data['current']['condition']['text'],
            'condition_icon': data['current']['condition']['icon'],
            'condition_code': data['current']['condition']['code'],
            'wind_mph': data['current']['wind_mph'],
            'wind_kph': data['current']['wind_kph'],
            'wind_degree': data['current']['wind_degree'],
            'wind_dir': data['current']['wind_dir'],
            'pressure_mb': data['current']['pressure_mb'],
            'pressure_in': data['current']['pressure_in'],
            'precip_mm': data['current']['precip_mm'],
            'precip_in': data['current']['precip_in'],
            'humidity': data['current']['humidity'],
            'cloud': data['current']['cloud'],
            'is_day': data['current']['is_day'],
            'uv': data['current']['uv'],
            'gust_mph': data['current']['gust_mph'],
            'gust_kph': data['current']['gust_kph']
        }
        weather_data.append(weather_info)

    return weather_data

def save_to_gcs(bucket_name, weather_data):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    filename = f"weather_data_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    blob = bucket.blob(filename)

    with blob.open("w", newline='') as csvfile:
        fieldnames = [
            'airport', 'last_updated', 'last_updated_epoch', 'temp_c', 'temp_f', 'feelslike_c', 'feelslike_f',
            'windchill_c', 'windchill_f', 'heatindex_c', 'heatindex_f', 'dewpoint_c', 'dewpoint_f', 
            'condition_text', 'condition_icon', 'condition_code', 'wind_mph', 'wind_kph', 'wind_degree', 
            'wind_dir', 'pressure_mb', 'pressure_in', 'precip_mm', 'precip_in', 'humidity', 'cloud', 
            'is_day', 'uv', 'gust_mph', 'gust_kph'
        ]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for data in weather_data:
            writer.writerow(data)

def weather_to_gcs(request):
    api_key = "30d363fb6cd542ab847120617241408"
    airport_codes = ["JFK", "LAX", "ORD", "ATL"]
    bucket_name = "weather_gov_data"

    weather_data = get_weather_data(api_key, airport_codes)
    save_to_gcs(bucket_name, weather_data)
    return "Weather data saved to GCS", 200
