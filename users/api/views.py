
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.response import Response

from users.models import User
from users.api.permissions import IsSuperOrTargetUser
from users.api.serializers import UserSerializer


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
