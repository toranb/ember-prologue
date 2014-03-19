from django.conf.urls import patterns, url
from  overture import views

urlpatterns = patterns(
    "",
    url(
        regex=r'^$',
        view=views.IndexView.as_view(),
        name='home'
    ),
    url(
        regex=r'^index/$',
        view=views.IndexView.as_view(),
        name='index'
    ),
)
