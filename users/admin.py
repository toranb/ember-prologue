from django.contrib import admin
from users.models import User, PasswordReset


class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'first_name', 'last_name', 'email', 'is_staff', 'is_superuser')


class PasswordResetAdmin(admin.ModelAdmin):
    list_display = ('user', 'timestamp', 'reset', 'temp_key')

admin.site.register(PasswordReset, PasswordResetAdmin)
admin.site.register(User, UserAdmin)
