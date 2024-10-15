import logging
from flask import Flask, request, jsonify
from bigquery_handler import get_data_from_bigquery
from publisher import publish_message_to_topic


app = Flask(__name__)


if __name__ != "__main__":
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)

@app.route('/data', methods=['GET'])
def get_data():
    """
        Endpoint para extraer la data de una tabla de bigquery.

        Ejemplo de petición:
        GET /data
        [
            {"data": "hola mundo",}
            {"data": "Hola, este es un mensaje de prueba"}
        ]

        Respuesta:
        - 200 OK si el mensaje fue publicado exitosamente.
        - 500 Internal Server Error en caso de error al publicar el mensaje.
        """
    try:
        data = get_data_from_bigquery()
        app.logger.info("Datos recuperados exitosamente desde BigQuery")
        return jsonify(data), 200
    except Exception as e:
        app.logger.error(f"Error al obtener los datos: {str(e)}")
        return jsonify({"error": "Error al obtener los datos"}), 500


@app.route('/publish', methods=['POST'])
def publish_message():
    """
    Endpoint para publicar un mensaje en un tópico de Pub/Sub.
    Espera un JSON con los campos 'topic_id' y 'message'.

    Ejemplo de petición:
    POST /publish
    {
        "topic_id": "projects/{project_id}/topics/{topic_name}",
        "message": "Hola, este es un mensaje de prueba"
    }

    Respuesta:
    - 200 OK si el mensaje fue publicado exitosamente.
    - 400 Bad Request si los datos no son válidos.
    - 500 Internal Server Error en caso de error al publicar el mensaje.
    """
    try:
        # Validar los datos de entrada
        data = request.get_json()
        if not data or 'topic_id' not in data or 'message' not in data:
            return jsonify({"error": "Faltan datos requeridos (topic_id, message)"}), 400

        topic_id = data['topic_id']
        message = data['message']

        # Publicar el mensaje
        message_id = publish_message_to_topic(topic_id, message)

        # Respuesta exitosa
        return jsonify({"message": "Mensaje publicado con éxito", "message_id": message_id}), 200
    except RuntimeError as e:
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        return jsonify({"error": "Error interno del servidor"}), 500

if __name__ == "__main__":
    # Flask se ejecuta solo en modo de desarrollo
    app.run(host='0.0.0.0', port=8080, debug=True)
    app.logger.info("API iniciada!!!")
