
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import generics
from rest_framework import exceptions
from rest_framework import status
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

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.DATA, files=request.FILES)

        if serializer.is_valid():
            if self.check_if_existing_user_has_same_data(request):
                return Response({'detail': 'That email address is already registered'}, status=status.HTTP_400_BAD_REQUEST)
            self.pre_save(serializer.object)
            self.object = serializer.save(force_insert=True)
            self.post_save(self.object, created=True)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def check_if_existing_user_has_same_data(self, request):
        user = User.objects.filter(email=request.DATA['email'])
        if user:
            return True


class AccountPassword(generics.GenericAPIView):
    """
    Change password of the current user.

    @PARAMETERS
     - current_password
     - password1
     - password2
    """
    authentication_classes = (TokenAuthentication, SessionAuthentication)
    permission_classes = (IsAuthenticated,)
    serializer_class = ChangePasswordSerializer

    def post(self, request, format=None):
        serializer_class = self.get_serializer_class()
        serializer = serializer_class(data=request.DATA, instance=request.user)
        if serializer.is_valid():
            serializer.save()
            return Response({'detail': 'Password successfully changed'})
        return Response(serializer.errors, status=400)


class PasswordResetRequestKey(generics.GenericAPIView):
    """
    Sends an email to the user email address with a link to reset password.

    @PARAMETERS:
     - email
    """
    authentication_classes = (TokenAuthentication, SessionAuthentication)
    permission_classes = (IsNotAuthenticated,)
    serializer_class = ResetPasswordSerializer

    def post(self, request, format=None):
        serializer_class = self.get_serializer_class()
        serializer = serializer_class(data=request.DATA)
        if serializer.is_valid():
            serializer.save()
            response = {'detail': 'An email containing instructions to reset your password has been sent to {}'.format(request.DATA.get('email'))}
            return Response(response)
        return Response(serializer.errors, status=400)

    def permission_denied(self, request):
        raise exceptions.PermissionDenied("You can't reset your password if you are already authenticated")


class PasswordResetFromKey(generics.GenericAPIView):
    """
    Reset password from key.

    The key must be part of the URL!
    @PARAMETERS:
     - password1
     - password2
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
        serializer = ResetPasswordKeySerializer(data=request.DATA, instance=password_reset_key)
        if serializer.is_valid():
            serializer.save()
            return Response({'detail': 'Password successfully changed.'})
        return Response(serializer.errors, status=400)

    def permission_denied(self, request):
        raise exceptions.PermissionDenied("You can't reset your password if you are already authenticated")
