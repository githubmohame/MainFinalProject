from rest_framework  import serializers
from digital_livestock.models import *
from django.db.models import  Sum
from django.db.models import  F,Count
from django.contrib.auth.models import Group
class governorateSerializer(serializers.ModelSerializer):
    class Meta:
        model=governorate
        fields=['name','id']
        
class citySerializer(serializers.ModelSerializer):
    class Meta:
        model=city
        fields=['name','id']

class villageSerializer(serializers.ModelSerializer):
    class Meta:
        model=village
        fields=['name','id']
        
class platoonSerializer(serializers.ModelSerializer):
    class Meta:
        model=platoon
        fields=['name','id']
        
class speciesSerializer(serializers.ModelSerializer):
    class Meta:
        model=species
        fields=['name','id']
        
class section_typeSerializer(serializers.ModelSerializer):
        class Meta:
            model=section_type
            fields=['name','id']
class farm_typeSerializer(serializers.ModelSerializer):
        class Meta:
            model=farm_type
            fields=['name','id']

class FarmerSerializer(serializers.ModelSerializer):
    class Meta:
            model=User
            fields=['fname','lname','email','phone','ssn','password']
class FarmSerializer(serializers.ModelSerializer):
    class Meta:
            model=farm
            fields="__all__"


class connectFarmAnimalSeralizer(serializers.ModelSerializer):
    class Meta:
            model=connect_animal_farm
            fields="__all__"

class citySeralizer(serializers.ModelSerializer):
    class Meta:
            
            model=city
            fields= ['id' ,'governorate_id' ]



class locatinSeralizer(serializers.ModelSerializer):
    city = citySeralizer(many=False, read_only=True)
    class Meta:
            
            model=village
            fields= ['id' , 'city']


class animalSeralizer(serializers.ModelSerializer):
     class Meta:
            
            model=species
            fields= ['id' , 'platoon']


class connectFarmFarmerSeralizer(serializers.ModelSerializer):
     class Meta:
            model=connect_farm_farmer
            fields= ['farm' , 'farmer','total_cost']



class governorateFarmListSerializer(serializers.ModelSerializer):
    class Meta:
        model=governorate
        fields=['name' ]
        
class cityFarmListSerializer(serializers.ModelSerializer):
    governorate=governorateFarmListSerializer()
    class Meta:
        model=city
        fields=['name' ,'governorate',]

class villageSerializerTest(serializers.ModelSerializer):
    #city=cityFarmListSerializer()
    class Meta:
        model=village
        fields=['name'  ]
class villageFarmListSerializer(serializers.ModelSerializer):
    city=cityFarmListSerializer()
    class Meta:
        model=village
        fields=['name' ,'city']

class section_typeFarmListSerializer(serializers.ModelSerializer):
        class Meta:
            model=section_type
            fields=['name' ]
class FarmListSerializer(serializers.ModelSerializer):
    village=villageFarmListSerializer()
    section_type=section_typeFarmListSerializer()
    class Meta:
            model=farm
            fields=['farm_name','number_of_workers_inner',"number_of_workers_outer",'village','id','section_type']

class LocationSerializer(serializers.ModelSerializer):
    location=serializers.SerializerMethodField()
    center=serializers.SerializerMethodField()
    total_cost_farm=serializers.SerializerMethodField()
    section_type=section_typeFarmListSerializer()
    class Meta:
        model=farm
        fields=["location","center","id","farm_name","total_cost_farm",
                "total_area_of_farm",
                "section_type","number_of_workers_inner","number_of_workers_outer"]
    def get_location(self,obj:farm):
        if(obj.location==None):
            return None
        if(obj.location.geom_type=="Point"):
            return None
        if(obj.location.geom_type!="MultiPolygon"):
            return obj.location.geojson
        return  obj.location.geojson
    def get_center(self,obj:farm):
        if(obj.location==None):
            return None
        if(obj.location.geom_type=="Point"):
            return  obj.location.geojson
        return  obj.location.point_on_surface.geojson
    def get_total_cost_farm(self,obj:farm):
        pass
        c1=connect_farm_farmer.objects.all().filter(farm=obj.id).aggregate(c=Sum("total_cost"))["c"]
        if(c1):
            return c1
        else:
            return 0;
        
        
class connectFarmAnimalSeralizer(serializers.ModelSerializer):
    animal_sub_type=speciesSerializer()
    class Meta:
            model=connect_animal_farm
            exclude=["id" ]

class cityFarmInfoSerializerTest(serializers.ModelSerializer):
    governorate=governorateFarmListSerializer()
    class Meta:
        model=city
        fields=['name' ,"governorate" ]

class villageFarmInfoSerializerTest(serializers.ModelSerializer):
    city=cityFarmInfoSerializerTest()
    class Meta:
        model=village
        fields=['name' ,"city" ]

class PlatoonInfoShow(serializers.ModelSerializer):
    class Meta:
            model=platoon
            fields = ['name', ] 
class SpeciesFarmInfoShow():
    platoon=PlatoonInfoShow()
    class Meta:
            model=species
            fields = ['platoon', ]
class ConnectFarmAnimalFarmInfoShow(serializers.ModelSerializer):
    animal_sub_type=SpeciesFarmInfoShow()
    class Meta:
            model=connect_animal_farm
            fields =  ["animal_sub_type","animal_number"]
class FarmInfoShowSerializer(serializers.ModelSerializer):

    section_type=section_typeFarmListSerializer()
    village=villageFarmInfoSerializerTest()
    location=serializers.SerializerMethodField()
    total_cost=serializers.SerializerMethodField()
    center=serializers.SerializerMethodField()
    connect_animal_farm=serializers.SerializerMethodField()
    class Meta:
            model=farm
            fields = '__all__'
    def get_location(self,obj:farm):
        if(obj.location==None):
            return None
        if(obj.location.geom_type=="Point"):
            return None
        if(obj.location.geom_type!="MultiPolygon"):
            return obj.location.geojson
        return  obj.location.geojson
    
    def get_connect_animal_farm(self,obj:farm):
        d=connect_animal_farm.objects.all().filter(farm_id=obj.id).values("animal_sub_type__platoon__name").annotate(animal_number2=Sum("animal_number"),platoon=F("animal_sub_type__platoon__name")).values("animal_number2","platoon")
        #ConnectFarmAnimalFarmInfoShow( instance=connect_animal_farm.objects.all().filter(farm_id=obj.id).values("animal_sub_type","animal_number")).data
        return d 
    def get_center(self,obj:farm):
        if(obj.location==None):
            return None
        if(obj.location.geom_type=="Point"):
            return  obj.location.geojson
        return  obj.location.point_on_surface.geojson
    location=serializers.SerializerMethodField()
    def get_location(self,obj:farm):
        return obj.location.geojson
    
    def get_total_cost(self,obj:farm):
        pass
        return connect_farm_farmer.objects.all().filter(farm=obj.id).aggregate(c=Sum("total_cost"))["c"]
class FarmerShowInfoSerializer(serializers.ModelSerializer):
    farm_count= serializers.SerializerMethodField()
    total_cost=serializers.SerializerMethodField()
    def get_farm_count(self,obj:User):
        return connect_farm_farmer.objects.all().filter(farmer=obj.ssn).count();
    def get_total_cost(self,obj:farm):
        pass
        return connect_farm_farmer.objects.all().filter(farmer=obj.ssn).aggregate(c=Sum("total_cost"))["c"]
    class Meta:
            model=User
            fields=['fname','lname','phone',"ssn" ,"farm_count" ,"total_cost","img"]
            
            
            
class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        pass
        model=CustomeGroup
        fields=["name","ar_name"]
        

class FarmerGoogleMapSerializer(serializers.ModelSerializer):
    village=villageFarmInfoSerializerTest()
    def get_center(self,obj:farm):
        if(obj.location==None):
            return None
        if(obj.location.geom_type=="Point"):
            return  obj.location.geojson
        return  obj.location.point_on_surface.geojson
    center=serializers.SerializerMethodField()
    class Meta:
            model=farm
            fields=["farm_name","id" ,"village" ,"center"]