from flask import Flask, jsonify
from google.cloud import bigquery

app = Flask(__name__)
client = None##bigquery.Client()


@app.route('/data', methods=['GET'])
def get_data():
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

    return jsonify(data)

@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == "__main__":
    app.run()





    if __name__ == '__main__':
        app.run()
