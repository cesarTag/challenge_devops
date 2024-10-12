from flask import Flask, jsonify
from app.bigquery_handler import get_data_from_bigquery

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    data = get_data_from_bigquery()
    return jsonify(data)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
