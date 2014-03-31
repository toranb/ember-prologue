
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


class ChangePasswordSerializer(serializers.Serializer):
    current_password = serializers.CharField(help_text='Current Password')
    password1 = serializers.CharField(help_text='New Password')
    password2 = serializers.CharField(help_text='New Password (confirmation)')

    def validate_current_password(self, attrs, source):
        if self.object.has_usable_password() and not self.object.check_password(attrs.get("current_password")):
            raise serializers.ValidationError('Current password is not correct')
        return attrs

    def validate_password2(self, attrs, source):
        password_confirmation = attrs[source]
        password = attrs['password1']
        if password_confirmation != password:
            raise serializers.ValidationError('Password confirmation mismatch')
        return attrs

    def restore_object(self, attrs, instance=None):
        """ change password """
        if instance is not None:
            instance.set_password(attrs.get('password2'))
            return instance
        return User(**attrs)
