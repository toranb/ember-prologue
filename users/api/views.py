
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import generics
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from rest_framework.permissions import IsAuthenticated

from users.models import User
from users.api.permissions import IsSuperOrTargetUser
from users.api.serializers import UserSerializer, ChangePasswordSerializer


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
    **Accepted parameters:**
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
            return Response({'detail': (u'Password successfully changed')})

        return Response(serializer.errors, status=400)

account_password_change = AccountPassword.as_view()
