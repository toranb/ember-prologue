from django.conf.urls import patterns, url
from api import views

urlpatterns = patterns(
    "",
    url(
        regex=r'^password_change$',
        view=views.AccountPassword.as_view(),
        name='password_change'
    ),
    url(
        regex=r'^password_reset$',
        view=views.PasswordResetRequestKey.as_view(),
        name='password_reset'
    ),
    url(
        regex=r'^password/reset/(?P<uidb36>[0-9A-Za-z]+)-(?P<key>.+)/$',
        view=views.PasswordResetFromKey.as_view(),
        name='password_reset_key'
    ),
)
