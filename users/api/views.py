
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import generics
from rest_framework import exceptions
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.permissions import IsAuthenticated
from django.utils.http import base36_to_int

from users.models import User, PasswordReset
from users.api.permissions import IsSuperOrTargetUser, IsNotAuthenticated
from users.api.serializers import UserSerializer, ChangePasswordSerializer, ResetPasswordSerializer, ResetPasswordKeySerializer


class UserViewSet(viewsets.ModelViewSet):
    model = User
    serializer_class = UserSerializer

    def get_permissions(self):
        """Allow non-authenticated user to create via POST"""
        return (AllowAny() if self.request.method == 'POST' else IsSuperOrTargetUser()),

    def retrieve(self, request, pk=None):
        """If provided 'pk' is "current_user" return the current user."""
        if pk == 'current_user':
            return Response(UserSerializer(request.user).data)
        return super(UserViewSet, self).retrieve(request, pk)


class AccountPassword(generics.GenericAPIView):
    """
    Change password of the current user.

    Accepted parameters:
     * current_password
     * password1
     * password2
    """
    authentication_classes = (TokenAuthentication, SessionAuthentication)
    permission_classes = (IsAuthenticated,)
    serializer_class = ChangePasswordSerializer

    def post(self, request, format=None):
        """ validate password change operation and return result """
        serializer_class = self.get_serializer_class()
        serializer = serializer_class(data=request.DATA, instance=request.user)
        if serializer.is_valid():
            serializer.save()
            return Response({'detail': 'Password successfully changed'})
        return Response(serializer.errors, status=400)


class PasswordResetRequestKey(generics.GenericAPIView):
    """
    Sends an email to the user email address with a link to reset his password.

    Accepted parameters:
     * email
    """
    authentication_classes = (TokenAuthentication, SessionAuthentication)
    permission_classes = (IsNotAuthenticated,)
    serializer_class = ResetPasswordSerializer

    def post(self, request, format=None):
        serializer_class = self.get_serializer_class()
        serializer = serializer_class(data=request.DATA)
        # serializer = self.serializer_class(data=request.DATA)
        if serializer.is_valid():
            serializer.save()
            return Response({
                'detail': 'We just sent you the link with which you will able to reset your password at {}'.format(request.DATA.get('email'))
            })
        return Response(serializer.errors, status=400)

    def permission_denied(self, request):
        raise exceptions.PermissionDenied("You can't reset your password if you are already authenticated")


class PasswordResetFromKey(generics.GenericAPIView):
    """
    Reset password from key.

    The key must be part of the URL!
    Accepted parameters:
     * password1
     * password2
    """

    authentication_classes = (TokenAuthentication, SessionAuthentication)
    permission_classes = (IsNotAuthenticated,)
    serializer_class = ResetPasswordKeySerializer

    def post(self, request, uidb36, key, format=None):
        try:
            uid_int = base36_to_int(uidb36)
            password_reset_key = PasswordReset.objects.get(user_id=uid_int, temp_key=key, reset=False)
        except (ValueError, PasswordReset.DoesNotExist, AttributeError):
            return Response({'errors': 'Key Not Found'}, status=404)
        serializer = ResetPasswordKeySerializer(
            data=request.DATA,
            instance=password_reset_key
        )
        if serializer.is_valid():
            serializer.save()
            return Response({'detail': 'Password successfully changed.'})
        return Response(serializer.errors, status=400)

    def permission_denied(self, request):
        raise exceptions.PermissionDenied("You can't reset your password if you are already authenticated")
