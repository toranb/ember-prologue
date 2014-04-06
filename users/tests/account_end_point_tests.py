import re
import json

from django.test import TestCase
from django.core import mail
from django.core.urlresolvers import reverse
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient

from users.models import User, PasswordReset


class AccountEndPointResetPasswordTest(TestCase):

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


class AccountEndPointRcoverPasswordTest(TestCase):

    def setUp(self):
        self.user = User.objects.create_user(username='testUser', email='tester@testing.com', password='securepass')

    def test_email_is_sent_when_valid_email_address_is_used_to_request_password_change(self):
        response = self.client.post(reverse('account:password_reset'), data={"email": "tester@testing.com"})
        response_json = json.loads(response.content)
        expected_response = "An email containing instructions to reset your password has been sent to tester@testing.com"
        reset_keys = PasswordReset.objects.all()
        self.assertEquals(len(reset_keys), 1)
        self.assertEqual(len(mail.outbox), 1)
        self.assertEquals(mail.outbox[0].subject, 'Password reset request for: example.com')
        self.assertEquals(response_json['detail'], expected_response)

    def test_only_one_reset_key_is_created_when_password_reset_requested(self):
        self.client.post(reverse('account:password_reset'), data={"email": "tester@testing.com"})
        reset_keys = PasswordReset.objects.all()
        self.assertEquals(len(reset_keys), 1)

    def test_no_email_is_sent_when_invalid_email_address_is_used_to_request_password_change(self):
        response = self.client.post(reverse('account:password_reset'), data={"email": "fail@testing.com"}, follow=True)
        response_json = json.loads(response.content)
        self.assertEqual(len(mail.outbox), 0)
        self.assertEqual(400, response.status_code)
        self.assertEqual(response_json['email'][0], "Email address not verified for any user account")


class AccountEndPointPasswordRestEmailLinkTest(TestCase):

    def setUp(self):
        self.user = User.objects.create_user(username='testUser', email='tester@testing.com', password='securepass')
        self.reset_url = self.request_password_reset_and_extract_link_from_email()

    def test_correct_url_is_emailed_to_user_requesting_a_password_reset(self):
        # The full reset key will be different every time this is called but is tested in the following two tests
        self.assertEqual(self.reset_url[:43], "http://example.com/#/resetpassconfirm/1-3qj")

    def test_user_is_able_to_set_new_password_with_link_received_in_email_when_new_password_requested(self):
        uidb36 = self.reset_url[38:43]
        key = self.reset_url[44:]
        response = self.client.post(reverse("account:password_reset_key", kwargs={"uidb36": uidb36, "key": key}), data={"current_password": "securepass", "password1": "newPass", "password2": "newPass"})
        response_json = json.loads(response.content)
        self.assertEqual(response_json['detail'], "Password successfully changed.")
        users_token = Token.objects.get(user_id=self.user.pk)
        expected_response = '"token": "{0}"'.format(users_token)
        response = self.client.post("/api-token-auth/", {'username': 'testUser', 'password': 'newPass'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(expected_response, response.content[1:-1])

    def test_user_receives_an_error_message_when_the_same_password_is_not_entered_twice_on_the_reset_screen(self):
        uidb36 = self.reset_url[38:43]
        key = self.reset_url[44:]
        response = self.client.post(reverse("account:password_reset_key", kwargs={"uidb36": uidb36, "key": key}), data={"current_password": "securepass", "password1": "newPass", "password2": "XnewPassX"})
        response_json = json.loads(response.content)
        self.assertEquals(response_json['password2'][0], 'Password confirmation mismatch')

    def request_password_reset_and_extract_link_from_email(self):
        self.client.post(reverse('account:password_reset'), data={"email": "tester@testing.com"})
        url_regex = re.compile(r'http://.*')
        return url_regex.findall(mail.outbox[0].body)[0]
