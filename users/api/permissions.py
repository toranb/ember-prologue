from rest_framework import permissions


class IsSuperOrTargetUser(permissions.BasePermission):

    def has_permission(self, request, view):
        """Allow user to list all users if logged in user is superuser"""
        return view.action == 'retrieve' or request.user.is_superuser

    def has_object_permission(self, request, view, obj):
        """Allow logged in user to view own details, and staff to view all records"""
        return request.user.is_superuser or obj == request.user
