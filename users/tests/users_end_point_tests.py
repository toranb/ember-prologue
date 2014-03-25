import json

from django.test import TestCase
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient

from users.models import User


class Test(TestCase):

    def setUp(self):
        User.objects.create_user(username='jrock', password='password', email="jrock@winning.com")
        super_user = User.objects.create_user(username='jarrod', password='password1', email="jarrod@winning.com")
        super_user.is_superuser = True
        super_user.save()
        self.regular_token = Token.objects.get(user__username='jrock')
        self.super_token = Token.objects.get(user__username='jarrod')
        self.client = APIClient()

    def tearDown(self):
        self.client.credentials()

    def test_valid_logged_in_basic_user_can_get_their_own_user_information(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        response = self.client.get("/api/users/current_user/")
        expected_response = '{"id": 1, "username": "jrock", "first_name": "", "last_name": "", "email": "jrock@winning.com"}'
        self.assertEqual(response.status_code, 200)
        self.assertEqual(expected_response, response.content)

    def test_valid_logged_in_basic_user_cannot_get_another_users_information(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        response = self.client.get("/api/users/2/")
        expected_response = '{"detail": "You do not have permission to perform this action."}'
        self.assertEqual(response.status_code, 403)
        self.assertEqual(expected_response, response.content)

    def test_valid_logged_in_basic_user_cannot_get_all_users_information(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        response = self.client.get("/api/users/")
        expected_response = '{"detail": "You do not have permission to perform this action."}'
        self.assertEqual(response.status_code, 403)
        self.assertEqual(expected_response, response.content)

    def test_valid_logged_in_super_user_can_get_all_users_information(self):
        self.client.login(username='jarrod', password='password1')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.super_token.key)
        response = self.client.get("/api/users/")
        json_response = json.loads(response.content)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(2, len(json_response))
        self.assertEqual('jrock', json_response[0]['username'])
        self.assertEqual('jarrod', json_response[1]['username'])


class UsersEndPointPostTest(TestCase):

    def test_non_logged_user_can_register_a_new_user(self):
        self.assertEqual(0, len(User.objects.all()))
        response = self.client.post("/api/users/", data={"username": "jrock", "first_name": "", "last_name": "", "email": "j@rock.com", "password": "pass"})
        self.assertEqual(response.status_code, 201)
        self.assertEqual(1, len(User.objects.all()))

    def test_cannot_create_user_with_an_existing_username(self):
        self.client.post("/api/users/", data={"username": "jrock", "first_name": "", "last_name": "", "email": "j@rock.com", "password": "pass"})
        response = self.client.post("/api/users/", data={"username": "jrock", "first_name": "", "last_name": "", "email": "j2@rock.com", "password": "pass"})
        self.assertEqual(response.status_code, 400)
        self.assertEqual('{"username": ["User with this Username already exists."]}', response.content)

    def test_error_returned_when_no_password_is_provided_in_an_attempt_to_register(self):
        response = self.client.post("/api/users/", data={"username": "jrock", "first_name": "", "last_name": "", "email": "j2@rock.com"})
        self.assertEqual(response.status_code, 400)
        self.assertEqual('{"password": ["This field is required."]}', response.content)
