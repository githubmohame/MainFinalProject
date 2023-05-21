from django.contrib import admin
from django.urls import path 
from .views import *
urlpatterns = [
    path('governorate', governorate_api ),
    path('village', village_api ),
    path('city', city_api ), 
     path('section_type', section_type_api ),
      path('farm_type', farm_type_api ),
      path('species',animal_species_api)
      ,path('platoon',animal_plotoon_api)
       ,path('check_password',login)
      ,path('create_farmer', create_farmer)
       ,path('create_farm', create_farm)
       ,path('modify_gavernorate',  modified_gavernorate)
       ,path('modify_city',  modified_city)
       ,path('modify_village',  modified_village)
        ,path('farm_api', farm_api)
        ,path('modified_species',modified_species)
        ,path('modified_platoon', modified_platoon)
        ,path('farmer_api',  farmer_api)
        ,path('add_farme_animal_api', add_farm_animal)
       ,path('location_api',   get_locations)
       ,path('animal_api',  get_animal)
       ,path('change_password_email',   change_password_email)
       ,path('change_password_done',   change_password_done)
       ,path('connect_farm_farmer_api', connect_farm_farmer_api)
      ,path('login_api',  login )
      ,path('admin_api',  admin_api)
      ,path('search_farm_api',   search_farm_api)
      ,path('search_farm_farmer_api', search_farmer_api)
       ,path('get_data_map',  get_data_map)
        ,path('summary_governorate',  summary_governorate),
        path('location_statistics',location_statistics),
    ]
