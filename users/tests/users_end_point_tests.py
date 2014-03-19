
from django.test import TestCase
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient

from users.models import User


class TokenAuthenticationTest(TestCase):

    def setUp(self):
        User.objects.create_user(username='jrock', password='password', email="jrock@winning.com")
        User.objects.create_user(username='jarrod', password='password1', email="jarrod@winning.com")
        token = Token.objects.get(user__username='jrock')
        self.client = APIClient()
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token.key)

    def tearDown(self):
        self.client.credentials()

    def test_valid_logged_in_basic_user_can_get_their_own_user_information(self):
        response = self.client.get("/api/users/current_user/")
        expected_response = '{"username": "jrock", "first_name": "", "last_name": "", "email": "jrock@winning.com"}'
        self.assertEqual(response.status_code, 200)
        self.assertEqual(expected_response, response.content)

    def test_valid_logged_in_basic_user_cannot_get_another_users_information(self):
        response = self.client.get("/api/users/2/")
        expected_response = '{"detail": "You do not have permission to perform this action."}'
        self.assertEqual(response.status_code, 403)
        self.assertEqual(expected_response, response.content)

    def test_valid_logged_in_basic_user_cannot_get_all_users_information(self):
        response = self.client.get("/api/users/")
        expected_response = '{"detail": "You do not have permission to perform this action."}'
        self.assertEqual(response.status_code, 403)
        self.assertEqual(expected_response, response.content)
