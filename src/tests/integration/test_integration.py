import unittest
from unittest.mock import patch
from src.app.main import app

class TestIntegration(unittest.TestCase):

    @patch('app.main.get_data_from_bigquery')  # Mockeamos la función que obtiene datos de BigQuery
    def test_get_data_integration(self, mock_get_data):
        # Simulamos la respuesta de BigQuery
        mock_get_data.return_value = [{"data": "integration_test"}]

        with app.test_client() as client:
            response = client.get('/data')

            # Verificamos que la respuesta sea exitosa (200 OK)
            self.assertEqual(response.status_code, 200)

            # Verificamos que la respuesta sea el JSON esperado
            self.assertEqual(response.get_json(), [{"data": "integration_test"}])

    @patch('app.main.get_data_from_bigquery')  # Simulamos un fallo en BigQuery
    def test_get_data_integration_error(self, mock_get_data):
        # Simulamos que la función lanza una excepción
        mock_get_data.side_effect = Exception("Error en BigQuery")

        with app.test_client() as client:
            response = client.get('/data')

            # Verificamos que el status code sea 500 (Internal Server Error)
            self.assertEqual(response.status_code, 500)

            # Verificamos que el contenido de la respuesta tenga el error esperado
            self.assertEqual(response.get_json(), {"error": "Error al obtener los datos"})

if __name__ == '__main__':
    unittest.main()
