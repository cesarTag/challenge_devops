import unittest
from app.main import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_get_data(self):
        response = self.app.get('/data')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
