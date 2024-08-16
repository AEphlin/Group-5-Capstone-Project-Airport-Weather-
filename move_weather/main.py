from google.cloud import bigquery
from google.cloud import storage
import os

def append_to_bigquery(event, context):
    # Set up BigQuery and Storage clients
    bq_client = bigquery.Client()
    storage_client = storage.Client()

    # Parameters
    dataset_id = 'airport_weather'
    table_id = 'airport_weather_table'
    bucket_name = event['bucket']  # Use the correct key for the bucket name
    file_name = event['name']      # Use the correct key for the file name
    destination_bucket_name = 'weather_gov_data_processed'
    
    # Get the file from Cloud Storage
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    temp_file = f'/tmp/{file_name}'
    blob.download_to_filename(temp_file)

    # Load the CSV file into BigQuery
    table_ref = bq_client.dataset(dataset_id).table(table_id)
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        autodetect=True,  # Automatically detect schema
        skip_leading_rows=1  # Skip header row if CSV files have headers
    )

    with open(temp_file, "rb") as source_file:
        job = bq_client.load_table_from_file(
            source_file, table_ref, job_config=job_config
        )

    job.result()  # Wait for the job to complete

    # Move the file to the destination bucket
    destination_bucket = storage_client.bucket(destination_bucket_name)
    new_blob = bucket.copy_blob(blob, destination_bucket, new_name=file_name)
    
    # Delete the file from the source bucket
    blob.delete()

    # Remove the temporary file
    os.remove(temp_file)
    
    print(f"Loaded {file_name} into {dataset_id}.{table_id} and moved to {destination_bucket_name}")
