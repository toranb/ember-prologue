
from rest_framework import serializers

from users.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'password', 'username', 'first_name', 'last_name', 'email')
        write_only_fields = ('password',)

    def restore_object(self, attrs, instance=None):
        """Do not store the password in plain text"""
        user = super(UserSerializer, self).restore_object(attrs, instance)
        user.set_password(attrs['password'])
        return user
