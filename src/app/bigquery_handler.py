import os
from google.cloud import bigquery
from google.oauth2 import service_account

# Cargar las credenciales de la variable de entorno
credentials_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')

if credentials_path is None:
    raise EnvironmentError("GOOGLE_APPLICATION_CREDENTIALS environment variable not set")

credentials = service_account.Credentials.from_service_account_file(credentials_path)

def get_data_from_bigquery():
    try:
        client = bigquery.Client(credentials=credentials)
        query = """
            SELECT data
            FROM `latam-challenge-devops.dataset_challenge.table_challenge`
            LIMIT 10
        """
        query_job = client.query(query)
        results = query_job.result()

        data = []
        for row in results:
            data.append({
                "data": row.data
            })
        return data
    except Exception as e:
        raise RuntimeError(f"Error fetching data from BigQuery: {e}")
