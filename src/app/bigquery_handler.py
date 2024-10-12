from google.cloud import bigquery

def get_data_from_bigquery():
    client = bigquery.Client()
    query = """
        SELECT id, value, timestamp
        FROM `your_project.analytics_dataset.analytics_table`
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
