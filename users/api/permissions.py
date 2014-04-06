from rest_framework import permissions


class IsSuperOrTargetUser(permissions.BasePermission):

    def has_permission(self, request, view):
        """Allow a user to list all users if they are a superuser"""
        return view.action == 'retrieve' or request.user.is_superuser

    def has_object_permission(self, request, view, obj):
        """Allow logged in user to view own details, and superuser to view all records"""
        return request.user.is_superuser or obj == request.user


class IsNotAuthenticated(permissions.IsAuthenticated):
    """Restrict access only to unauthenticated users"""
    def has_permission(self, request, view, obj=None):
        if request.user and request.user.is_authenticated():
            return False
        return True
