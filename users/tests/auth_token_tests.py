
from django.test import TestCase
from rest_framework.authtoken.models import Token

from users.models import User


class TokenAuthenticationTest(TestCase):

    def setUp(self):
        self.user = User.objects.create_user(username='jrock', password='password', email="jrock@winning.com")

    def test_user_with_valid_username_and_password_gets_auth_token(self):
        users_token = Token.objects.get(user_id=self.user.pk)
        expected_response = '"token": "{0}"'.format(users_token)
        response = self.client.post("/api-token-auth/", {'username': 'jrock', 'password': 'password'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(expected_response, response.content[1:-1])

    def test_user_with_invalid_username_and_password_does_not_get_auth_token(self):
        response = self.client.post("/api-token-auth/", {'username': 'wrong', 'password': 'password'})
        expected_response = '{"non_field_errors": ["Unable to login with provided credentials."]}'
        self.assertEqual(response.status_code, 400)
        self.assertEqual(expected_response, response.content)

    def test_user_with_valid_username_and_invalid_password_does_not_get_auth_token(self):
        response = self.client.post("/api-token-auth/", {'username': 'jrock', 'password': 'password1'})
        expected_response = '{"non_field_errors": ["Unable to login with provided credentials."]}'
        self.assertEqual(response.status_code, 400)
        self.assertEqual(expected_response, response.content)

    def test_user_with_invalid_username_and_valid_password_does_not_get_auth_token_y(self):
        response = self.client.post("/api-token-auth/", {'username': 'jrock1', 'password': 'password'})
        expected_response = '{"non_field_errors": ["Unable to login with provided credentials."]}'
        self.assertEqual(response.status_code, 400)
        self.assertEqual(expected_response, response.content)
