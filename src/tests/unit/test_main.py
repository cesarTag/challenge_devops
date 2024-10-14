import unittest
from unittest.mock import patch
from src.app.main import app  # Importa el objeto 'app' desde src/app/main.py
from src.app.bigquery_handler import get_data_from_bigquery


class TestMain(unittest.TestCase):

	@patch('app.main.get_data_from_bigquery')  # Mockeamos la función de BigQuery en el módulo main
	def test_get_data(self, mock_get_data):
		# Simulamos la respuesta de la función mockeada
		mock_get_data.return_value = [{"data": "mocked_data"}]

		# Hacemos una llamada GET al endpoint /data
		with app.test_client() as client:
			response = client.get('/data')

			# Verificamos que el status code sea 200 (OK)
			self.assertEqual(response.status_code, 200)

			# Verificamos que la respuesta sea en formato JSON y tenga el valor esperado
			self.assertEqual(response.get_json(), [{"data": "mocked_data"}])

	@patch('app.main.get_data_from_bigquery')  # Mockeamos la función de BigQuery
	def test_get_data_error(self, mock_get_data):
		# Simulamos que la función lanza una excepción
		mock_get_data.side_effect = Exception("Error en BigQuery")

		# Hacemos una llamada GET al endpoint /data
		with app.test_client() as client:
			response = client.get('/data')

			# Verificamos que el status code sea 500 (Internal Server Error)
			self.assertEqual(response.status_code, 500)

			# Verificamos que el contenido de la respuesta tenga el error esperado
			self.assertEqual(response.get_json(), {"error": "Error al obtener los datos"})


if __name__ == '__main__':
	unittest.main()
