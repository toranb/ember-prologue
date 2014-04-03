from datetime import datetime

from django.db import models
from django.conf import settings
from django.utils.timezone import utc
from django.contrib.auth.models import AbstractUser
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
from django.utils.http import int_to_base36
from django.template.loader import render_to_string
from django.core.mail import send_mail
from django.contrib.auth.tokens import default_token_generator as token_generator
from django.contrib.sites.models import Site


class User(AbstractUser):

    class Meta:
        unique_together = ("email", )


@receiver(post_save, sender=User)
def create_auth_token_for_new_user(sender, instance, signal, created, **kwargs):
    if created:
        Token.objects.create(user=instance)


class PasswordResetManager(models.Manager):

    def create_for_user(self, user):
        """ create password reset for specified user """
        if type(user) is unicode:
            user = User.objects.get(email=user)
        temp_key = token_generator.make_token(user)
        password_reset = PasswordReset(user=user, temp_key=temp_key, email=user.email)
        password_reset.save()
        current_site = Site.objects.get_current()
        subject = "Password reset request for: {}".format(current_site.domain)
        message = render_to_string("users/password_reset_key_message.html", {
            "user": user,
            "uid": int_to_base36(user.id),
            "temp_key": temp_key,
            "domain": current_site.domain
        })
        send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [user.email])
        return password_reset


class PasswordReset(models.Model):
    """
    Password reset Key
    """
    user = models.ForeignKey(User, verbose_name="user")
    email = models.EmailField(max_length=75)
    temp_key = models.CharField("temp_key", max_length=100)
    timestamp = models.DateTimeField("timestamp", default=datetime.utcnow().replace(tzinfo=utc))
    reset = models.BooleanField("reset yet?", default=False)

    objects = PasswordResetManager()

    class Meta:
        verbose_name = 'password reset'
        verbose_name_plural = 'password resets'

    def __unicode__(self):
        return "{} (key={}, reset={})".format(self.user.username, self.temp_key, self.reset)
