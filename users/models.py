from django.db import models
from django.contrib.auth.models import AbstractUser
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token


class User(AbstractUser):
    pass


@receiver(post_save, sender=User)
def create_auth_token_for_new_user(sender, instance, signal, created, **kwargs):
    if created:
        Token.objects.create(user=instance)
