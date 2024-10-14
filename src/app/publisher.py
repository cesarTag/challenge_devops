import os
import logging
from google.cloud import pubsub_v1
from google.api_core.exceptions import GoogleAPICallError, RetryError

# Configurar logging
logging.basicConfig(level=logging.INFO)

# Cargar la variable de entorno para las credenciales de Google Cloud
credentials_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')

if credentials_path is None:
	raise EnvironmentError("GOOGLE_APPLICATION_CREDENTIALS environment variable not set")

# Inicializar el publisher para Pub/Sub
publisher = pubsub_v1.PublisherClient()


def publish_message_to_topic(topic_id: str, message: str) -> str:
	"""
    Publica un mensaje a un tópico de Pub/Sub.

    Args:
        topic_id (str): El ID del tópico de Pub/Sub en el formato 'projects/{project_id}/topics/{topic_name}'.
        message (str): El mensaje a enviar al tópico.

    Returns:
        str: ID del mensaje publicado o un error si no pudo ser publicado.
    """
	try:
		# Convertir el mensaje a bytes
		message_data = message.encode("utf-8")
		future = publisher.publish(topic_id, message_data)
		message_id = future.result()
		logging.info(f"Mensaje publicado con ID: {message_id}")
		return message_id
	except (GoogleAPICallError, RetryError) as e:
		logging.error(f"Error al publicar el mensaje: {e}")
		raise RuntimeError(f"Error al publicar el mensaje en Pub/Sub: {e}")
