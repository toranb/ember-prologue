
from django.conf.urls import patterns, include, url
from django.contrib import admin
from rest_framework import routers

from users.api import views

admin.autodiscover()
router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)

urlpatterns = patterns(
    '',
    url(r'^grappelli/', include('grappelli.urls')),
    url(r'^admin/', include(admin.site.urls)),
    # Allows the use of DRF browsable api pages with authentication
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^api-token-auth/', 'rest_framework.authtoken.views.obtain_auth_token'),
    url(r'^', include('overture.urls', namespace='overture')),
    url(r'^api/', include(router.urls))
)
