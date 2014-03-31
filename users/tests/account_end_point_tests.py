import json

from django.test import TestCase
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient

from users.models import User


class AccountEndPointPostTest(TestCase):

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

    def test_user_can_successfully_change_password(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        data = {"current_password": "password", "password1": "new-password", "password2": "new-password"}
        response = self.client.post("/api/account/password_change", data)
        response_json = json.loads(response.content)
        self.assertEqual(response_json['detail'], 'Password successfully changed')
        self.client.logout()
        self.client.login(username='jrock', password='new-password')
        self.assertIn("_auth_user_id", self.client.session)

    def test_error_received_when_entering_wrong_old_password(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        data = {"current_password": "XpasswordX", "password1": "new-password", "password2": "new-password"}
        response = self.client.post("/api/account/password_change", data)
        response_json = json.loads(response.content)
        self.assertEqual(response_json['current_password'][0], 'Current password is not correct')

    def test_error_received_when_new_password1_and_new_password2_fields_do_not_match(self):
        self.client.login(username='jrock', password='password')
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.regular_token.key)
        data = {"current_password": "password", "password1": "new-passwordX", "password2": "new-passwordY"}
        response = self.client.post("/api/account/password_change", data)
        response_json = json.loads(response.content)
        self.assertEqual(response_json['password2'][0], 'Password confirmation mismatch')
