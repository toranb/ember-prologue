from django.conf.urls import patterns, url
from api import views

urlpatterns = patterns(
    "",
    url(
        regex=r'^password_change$',
        view=views.AccountPassword.as_view(),
        name='password_change'
    ),
)
