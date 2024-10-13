from google.cloud import bigquery
from google.oauth2 import service_account

credentials = service_account.Credentials.from_service_account_file(
    '/Users/cesartag/PycharmProjects/challenge_devops/src/app/cuent_servicio_gcp/latam-challenge-devops-26284d5f8744.json')




def get_data_from_bigquery():
    client = bigquery.Client(credentials=credentials)
    query = """
        SELECT id, value, timestamp
        FROM `latam-challenge-devops.dataset_challenge.table_challenge`
        LIMIT 10
    """
    query_job = client.query(query)
    results = query_job.result()

    data = []
    for row in results:
        data.append({
            "id": row.id,
            "value": row.value,
            "timestamp": row.timestamp
        })
    return data
