from django.shortcuts import render
from digital_livestock.models import *
from django.db.models import Count, F, Q 
from digital_livestock.pagination import  CustomePagenation
from django.http import FileResponse
from digital_livestock.backend import *
from digital_livestock.permission import *
from django.utils.html import strip_tags
# Create your views here.
import smtplib
from django.template.loader import render_to_string
from rest_framework.viewsets import ModelViewSet
from django.contrib.auth.models import  Group
from django.core.mail import send_mail
from django.core.mail import EmailMultiAlternatives
from django.conf import settings
from rest_framework import permissions
from django.db import connection
from rest_framework.decorators import api_view,authentication_classes,permission_classes,throttle_classes
from rest_framework.throttling import UserRateThrottle
from django.http.response import  JsonResponse
from rest_framework import response
from rest_framework.request import Request
from django.contrib.gis.gdal import DataSource
from .serializer import *
from django.contrib.gis.gdal.geometries import Polygon,Point
 
from django.contrib.gis.geos import GEOSGeometry
def set_geometry(obj:models.Model,dic1:dict[str,]):
 	if(dic1.get('geometry')!=None):
			 
			try:
				if(type(dic1.get('geometry'))==str):
	 
					import json
					from django.contrib.gis.geos import Point
					from django.contrib.gis.geos import GEOSGeometry
					data=json.loads(dic1.get('geometry'))
					setattr(obj,'location',GEOSGeometry( ( str(Point (*(data['point']['coordinates']))))))
				else:
					with open('m',mode='wb' ) as binary_file:
						binary_file.write(dic1.get('geometry').read())
					import zipfile
					
					try:
						with zipfile.ZipFile(file='m',mode='r') as zip_ref:
							zip_ref.extractall('targdir')
						dsource=DataSource('targdir')
						for d in dsource:
							list1=d.get_geoms()
							
							break
						
						muilt_plog= list1[0]
						
						if(len(list1)>100):
								
								count=100
						else:
								count=len(list1)
						for i in range(1,count):
							muilt_plog=muilt_plog.union(list1[i])
						setattr(obj,'location',str(muilt_plog))
					except:
						
						import json
						from django.contrib.gis.geos import GEOSGeometry
						try:
							with open('m')as f:
								data=f.read()
						except Exception as e:

							data=json.loads(dic1.get('geometry'))
						polygons=[]
						data=json.loads(data)
						if(len(data['features'])>100):
							count=100
						else:
							count=len(data['features'])
						for ft in range(0,count):
							geom_str=json.dumps( data['features'][ft]["geometry"] )
							 
							try:
								geom=GEOSGeometry(str(geom_str))
							except:
							 
								geom=Polygon.from_bbox(data['features'][0]["geometry"]["coordinates"][0][0] +data['features'][0]["geometry"]["coordinates"][0][2] )
								geom=GEOSGeometry( geom.geojson)
							polygons.append(geom)
							muilt_plog = polygons[0]	
							for poly in polygons:
								muilt_plog = muilt_plog.union(poly)
					
					setattr(obj,"location",muilt_plog)
			except Exception as e:
				return JsonResponse({'error':'خطأ في صيغة الملف'})


class OncePerDayUserThrottle(UserRateThrottle):
	rate = '1/day'
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def governorate_api(request :Request):
	print(request.headers.get("user_auth"));
	if(request.user.groups.filter(name__in=["admin","supervisor"]).count()  > 0 and (request.headers.get("userauth") in ["admin" ,"supervisor"]) ):
		q=Q()
	else:
		q=Q(id=request.user.location.city.governorate.id )

	ser1=governorateSerializer( instance= governorate.objects.all().filter(q),many=True)
	return response.Response(ser1.data)
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def city_api(request :Request):
	if(request.user.groups.all().filter(name="admin")):
		q=Q()
	else:
		q=Q(governorate__id=request.user.location.city.governorate.id )
	if(request.data['filter']!="-1"):
		ser1=citySerializer( instance= city.objects.all().filter(governorate=governorate.objects.get(id=request.data['filter'])).filter(q) ,many=True)
		return response.Response(ser1.data)
	else:
		return response.Response({"data":[]})
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def village_api(request :Request):
	if(request.user.groups.all().filter(name="admin")):
		q=Q()
	else:
		q=Q(city__governorate__id=request.user.location.city.governorate.id )
	if(request.data['filter']!="-1"):
		ser1=villageSerializer( instance= village.objects.all().filter(city=city.objects.get(id=request.data['filter'])).filter(q) ,many=True)
		return response.Response(ser1.data)
	else:
		return response.Response({"data":[]})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def animal_plotoon_api(request :Request):
	ser1=platoonSerializer( instance= platoon.objects.all()  ,many=True)
	return response.Response(ser1.data)

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def animal_species_api(request :Request):
	ser1=speciesSerializer( instance= species.objects.all().filter(platoon=platoon.objects.get(id=request.data['filter']))  ,many=True)
	return response.Response(ser1.data)


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def section_type_api(request :Request):
	ser1=section_typeSerializer( instance= section_type.objects.all()  ,many=True)
	return response.Response(ser1.data)
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_type_api(request :Request):
	ser1=farm_typeSerializer( instance= farm_type.objects.all()  ,many=True)
	return response.Response(ser1.data)
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
def login(request :Request):
	user1=User.objects.all().filter(ssn=request.data.get('ssn'))
	if(user1.count()>0):
		if(user1[0].check_password( request.data.get('password'))):
			return  JsonResponse({"token":True})
		return JsonResponse({"token":False})
	else:
		return JsonResponse({"token":False})

 

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def create_farmer(request :Request):
	request.data
	u=User.farmer.create_user(fname=request.data['fname'],ssn=request.data['ssn'],lname=request.data['lname'],password=request.data['password'],phone=request.data['phone'])
	return  JsonResponse({"token":"loop"})
 

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def modified_gavernorate(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		g1=governorate.objects.get(id=request.data['gavernorate']).delete()
		return  JsonResponse({"message":'تم مسح البيانات'})
	if(oper=='update'):
		g1=governorate.objects.get(id=request.data['gavernorate'])
		set_geometry(obj=g1,dic1=request.data)
		g1.name=request.data['new_name']
		g1.save()
		return  JsonResponse({"message":'تم تعديل البيانات'})

	if(oper=='insert'):
		g1=governorate()
		g1.name=request.data['new_name']
		set_geometry(obj=g1,dic1=request.data)
		g1.save()
		return JsonResponse({"message":'تم اضافة البيانات'})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def modified_city(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		g1=city.objects.get(id=request.data['city']).delete()
		return  JsonResponse({"message":'تم مسح البيانات'})

	if(oper=='update'):
		g1=city.objects.get(id=request.data['city'])
		g1.name=request.data['new_name']
		set_geometry(obj=g1,dic1=request.data)
		g1.save()
		return  JsonResponse({"message":'تم تعديل البيانات'})

	if(oper=='insert'):
		g1=city()
		g1.name=request.data['new_name']
		g1.governorate=city.objects.get(id=request.data['city']).governorate
		set_geometry(obj=g1,dic1=request.data)
		g1.save()
		return  JsonResponse({"message":'تم اضافة البيانات'})

	g1=citySerializer(instance=g1)
	return  response.Response(data=g1.data)

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def modified_village(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		g1=village.objects.get(id=request.data['village']).delete()
		return  JsonResponse({"message":"تم مسح البينات"})
	if(oper=='update'):
		g1=village.objects.get(id=request.data['village'])
		set_geometry(obj=g1,dic1=request.data)
		g1.name=request.data['new_name']
		g1.save()
		return  JsonResponse({"message":"تم تعديل البينات"})

	if(oper=='insert'):
		g1=village()
		g1.name=request.data['new_name']
		g1.city=city.objects.get(id=request.data['city'])
		set_geometry(obj=g1,dic1=request.data)
		g1.save()
		return  JsonResponse({"message":"تم اضافة البينات"})

	g1=villageSerializer(instance=g1)
	return  response.Response(data=g1.data)

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def test_geson(request :Request):
	f1= GEOSGeometry(str(request.data.get('filter') ))
	return JsonResponse({"llo":986})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_api(request :Request):
	if(request.data['operation']=='insert'):
		try:
			farm1=farm.objects.get(id=request.data['id'])
		except Exception as e:
			farm1=farm()
		dic1=request.data.dict()
		print(request.data)
		except1=set_geometry(obj=farm1,dic1=dic1)
		if(isinstance(except1,JsonResponse)):
			
			return except1
		farm1.attached_area=dic1['attached_area']
		if(dic1.get('farm_type')==None):
			return JsonResponse({'error':'اختارنوع للمزرعة'})


		import json
		dic1['farm_type']= json.loads(dic1['farm_type'])
		if(not isinstance ( dic1.get('farm_type')    ,type(list())|type( set)|type(tuple) )):
			return JsonResponse({'error':"the farm  type should be iterable type"})
		if(farm_type.objects.filter(name__in=dic1.get('farm_type')).count()!=len(dic1.get('farm_type')) or len(dic1.get('farm_type'))==0):
			return JsonResponse({'error':"the farm 12 should have valid farm type"})
		farm1.village=village.objects.get(id=dic1['village'])
		if(dic1.get("img")!=None):
			farm1.img= dic1['img'];
		for key,value in dic1.items() :
			if(key in [ "id",'isolated_wards','number_of_arc','number_of_workers_outer','number_of_workers_inner','playground','wards','total_area_of_farm','farm_name','huge_playground' ]):
				setattr(farm1,key,value)
		if(farm1.id==None):
			pass
			v1=""
			v1+=str(farm1.village.id)
			v1+=str(farm1.village.city.id)
			v1+=str(farm1.village.city.governorate.id)
		farm1.section_type=section_type.objects.get(id= dic1['section_type'])
		farm1.save()
		for i in set(dic1.get('farm_type')):
			try:
				con_farmm_farmt1=connect_farm_farmtype()
				con_farmm_farmt1.farm=farm1
				con_farmm_farmt1.farm_type=farm_type.objects.get(name=i)
				con_farmm_farmt1.save()
			except Exception as e:
				pass
		return JsonResponse({"message":'تم اضافة البيانات'})
	if(request.data['operation']=='delete'):

			if(request.data.get('id')==None):
				return JsonResponse({'message':'من فضلك ادخل كود المزرعة', })
			d1=farm.objects.all().filter(id=request.data.get('id')).delete()
			return JsonResponse({"message":"تم مسح البيانات"})
	if(request.data['operation']=='update'):
			if(request.data.get('id')==None):
				return JsonResponse({'error':'من فضلك ادخل كود المزرعة', })
			try: 
				d1=farm.objects.all().get(id=request.data.get('id'))
			except:
				return JsonResponse({'error':'الكود غير صحيح', })
			dic1=request.data.dict()
			for key  in dic1:
				
				if(key=='geometry' and dic1[key]!=""):
				 
					except1=set_geometry(obj=d1,dic1=dic1)
					
					if(isinstance(except1,JsonResponse)):
						return except1
					continue
				if(key=='farm_type'):
					import json
					connect_farm_farmtype.objects.all().filter(farm=farm.objects.get(id=request.data['id'])).delete()
					for i in set(json.loads(dic1.get('farm_type'))):
						con_farmm_farmt1=connect_farm_farmtype()
						con_farmm_farmt1.farm=d1
						con_farmm_farmt1.farm_type=farm_type.objects.get(name=i)
						con_farmm_farmt1.save()
					continue
				if(key=='section_type'):
					d1.section_type=section_type.objects.get(id= dic1['section_type'])
					d1.save()
					continue
				if(key=='village'):
					d1.village=village.objects.all().get( id=request.data.get('village'))
					continue
				setattr(d1,key,request.data[key])

			d1.save()

			return  JsonResponse({"message":"تم تعديل البينات"})
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def modified_species(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		try:
			g1=species.objects.get(id=request.data['species']).delete()
			return  JsonResponse({"message":'تم مسح البيانات'})
		except:
			return JsonResponse({"error":' اختار الفصيلة'})
	if(oper=='update'):
		try:
			g1=species.objects.get(id=request.data['species'])
			g1.save()
		except:
			return JsonResponse({"error":' اختار الفصيلة'})
		g1.name=request.data['new_name']
		g1.save()
		return JsonResponse({"message":'تم تعديل البيانات'})
	if(oper=='insert'):
		g1=species()
		
		if(request.data['new_name']=='' or request.data['new_name']==None):
				return JsonResponse({"error":'يجب ادخال الاسم'})
		g1.name=request.data['new_name']
		try:
			g1.platoon=platoon.objects.get(id=request.data['platoon']) 
			g1.save()
		except:
			return JsonResponse({"error":' اختار الفصيلة'})
		return JsonResponse({"message":'تم اضافة البيانات'})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def modified_platoon(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		try:
				g1=platoon.objects.get(id=request.data['platoon']).delete()
				return  JsonResponse({"message":'تم مسح البيانات'})
		except:
			return JsonResponse({"error":' اختار النوع'})
	if(oper=='update'):
		try:
			g1=platoon.objects.get(id=request.data['platoon'])
			if(request.data['new_name']=='' or request.data['new_name']==None):
				return JsonResponse({"error":'يجب ادخال الاسم'})
			g1.name=request.data['new_name']
			g1.save()
		except:
			return JsonResponse({"error":' اختار النوع'})
		return  JsonResponse({"message":'تم تعديل البيانات'})
	if(oper=='insert'):
		g1=platoon()
		if(request.data['new_name']=='' or request.data['new_name']==None):
				return JsonResponse({"error":'يجب ادخال الاسم'})
		g1.name=request.data['new_name']
		g1.save()
		return  JsonResponse({"message":'تم تعديل البيانات'})
	 
def rename(newname):
	def decorator(f):
		f.__name__ = newname
		return f
	return decorator


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
#@rename("tell me")
def farmer_api(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		import json
		dic1=request.data.dict()
		dic1.pop('operation')
		
		user1=User.farmer.filter(ssn=dic1['ssn'])
		if(len(user1)==0):
			return  JsonResponse({"error":'الرقم القومي غير صحيح'})
		else:
			if(user1[0].groups.all().count() > 1):
				user1[0].groups.remove(CustomeGroup.objects.get(name="farmer"))
			else:
				user1[0].delete()
			return  JsonResponse({"message":'تم مسح البيانات'})
	"""if(user1[0].is_superuser):
			return  JsonResponse({"error":'الرقم القومي غير صحيح'})"""
	if(oper=='update'):
		dic1=request.data.dict()
		dic1.pop('operation')
		user1=User.farmer.filter(ssn=dic1['ssn'])
		if(len(user1)==0):
			return  JsonResponse({"error":'الرقم القومي غير صحيح'})
		user1:User=User.farmer.get(ssn=int(request.data['ssn']))
		for key,value in dic1.items() :
			if(value ==None  and  key not in ['ssn','fnane','lname','email','password','phone','photo',"img"]):
				continue
			setattr(user1,key,value)
		user1.save()
		return JsonResponse({"message":"تم تعديل البيانات"})
	if(oper=='insert'):
		dic1=request.data.dict()
		dic1.pop('operation')
		if(User.objects.all().filter(email=dic1["email"]).exclude(ssn=dic1["ssn"]).count()>0):
			return  JsonResponse({"error":'من فضلك ادخل اميل اخر'})

		if(set(dic1).issubset(['ssn','fname','lname','email','password','phone','photo','job','age',"img"])):
			try:
				user1=User.objects.get(ssn=dic1["ssn"])
				for key,value in dic1.items() :
					if(value ==None  and  key not in ['ssn','fnane','lname','email','phone','photo',"img"]):
						continue
					setattr(user1,key,value)
			except Exception as e:
					user1=User.objects.create_user(**dic1)
					#return JsonResponse({"message":'تم حفظ البيانات'})
			user1.set_password(dic1["password"])
			user1.groups.add(CustomeGroup.objects.all().get(name="farmer"))
			user1.save()
			print(CustomeGroup.objects.all().get(name="farmer"))
	return JsonResponse({"message":'تم حفظ البيانات'})
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def add_farm_animal(request :Request):
	from datetime import datetime
	if(request.data['operation']=='insert'):
		if(request.data.get('date')!=None):
			date=datetime.strptime(request.data.get('date'),'%Y-%m-%d %H:%M:%S.%f').date()
			date=datetime(date.year,date.month,date.day,0,0,0)
			if (connect_animal_farm.objects.filter(animal_sub_type=species.objects.all().get(id=request.data['species']).id,date=date,is_male=request.data.get('is_male'),farm_id=farm.objects.get(id= request.data.get('farm_id')).id).count()!=0):
				connect_animal_farm1=connect_animal_farm.objects.get(animal_sub_type=species.objects.all().get(id=request.data['species']).id,date=date,is_male=request.data.get('is_male'),farm_id=farm.objects.get(id= request.data.get('farm_id')).id)
				connect_animal_farm1.animal_number=request.data.get('animal_number')
				connect_animal_farm1.date=date
				connect_animal_farm1.save()
				message='تم تعديل البيانات'
			else:
				connect_animal_farm1=connect_animal_farm()
				connect_animal_farm1.animal_number=request.data.get('animal_number')
				connect_animal_farm1.animal_sub_type=species.objects.get(id=request.data.get('species'))
				message='تم اضافة البيانات'
			#connect_animal_farm1.total_money=request.data.get('total_money')
			bool1=False
			if(request.data.get('is_male')=='1'):
				bool1=True
			connect_animal_farm1.is_male=bool1
			connect_animal_farm1.farm_id=farm.objects.get(id= request.data.get('farm_id'))
			connect_animal_farm1.date=date.date()
			connect_animal_farm1.save()
			user1=connectFarmAnimalSeralizer(instance= connect_animal_farm1)
			return  JsonResponse({'message':message})
		return JsonResponse({"errors":'من فضلك اختار تاريخ'})
	if(request.data['operation']=='delete'):
		date=datetime.strptime(request.data.get('date'),'%Y-%m-%d %H:%M:%S.%f').date()
		date=datetime(date.year,date.month,date.day,0,0,0)
		con1=connect_animal_farm.objects.get(date=date ,farm_id=farm.objects.get( id=request.data.get('farm_id')) ,is_male=request.data.get('is_male'),animal_sub_type=species.objects.get(id=request.data.get('species')))
		if(request.data['animal_number']!=None and request.data['animal_number']!= '' ):
		 
			con1.animal_number=int(request.data['animal_number'])
			con1.save()
			con1=connectFarmAnimalSeralizer(instance=con1)
		 
			return response.Response(data=con1.data)
		else:
			con1=con1.delete()
			return JsonResponse({"message":'تم مسح البيانات'})

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def get_locations_api(request :Request):
	if(request.user.groups.all().filter(name="admin")):
		q=Q()
	else:
		q=Q(id=request.user.location.id )
	g1=village.objects.all().filter(q)[0]
	 
	g1Seralizer= locatinSeralizer(instance=g1 )
	return response.Response(data=g1Seralizer.data)

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def get_animal(request :Request):
	try:
		g1=species.objects.all()[0]
		g1Seralizer= animalSeralizer(instance=g1)

		return response.Response(data=g1Seralizer.data)
	except Exception as e:
		g1=species.DoesNotExist()
		return JsonResponse({"error":None});
		

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def change_password_email(request :Request):
	if(User.objects.filter(ssn=request.data['ssn']).count()==0):
		return JsonResponse({"error":"login first"})
	u1=User.objects.get(ssn=request.data['ssn'])
	from uuid import uuid4
	code=uuid4()
	render(request,template_name='confirm_code.html', context={"code":code})
	html_content = render_to_string('confirm_code.html', context={"code":code},request=request).strip()
	subject = 'confirm email address'

	msg = EmailMultiAlternatives(subject,  "kkkkkkkk",from_email=settings.EMAIL_HOST_USER , to=[ u1.email],reply_to= [ u1.email])
	msg.content_subtype = 'html'  # Main content is text/html
	msg.attach_alternative(html_content, 'text/html')
	msg.mixed_subtype = 'related'
	 # This is critical, otherwise images will be displayed as attachments!
	msg.send( )
	import redis
	r=redis.Redis()
	#send_mail('change_password','the code is   '+str(code  ),settings.EMAIL_HOST_USER,[request.data.get('email')],fail_silently=False)
	r.setex(name=str(code  ),time=5*60,value=request.data.get('ssn'))
	return JsonResponse({"message":'تم ارسال الرسالة'})
'''
def change_password_email_template(request :Request):
	from uuid import uuid4
	import redis
	code=uuid4()
	r=redis.Redis()
	#send_mail('change_password','the code is   '+str(code  ),settings.EMAIL_HOST_USER,[request.data.get('email')],fail_silently=False)
	r.setex(name=str(code  ),time=5*60,value=request.data.get('email'))
	return render('confirm_code.html', context={"code":code},request=request)
'''

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def change_password_done(request :Request):
	import redis
	r=redis.Redis()
	ssn=r.get(request.data.get('code'))
	if(isinstance(ssn,bytes)):
		ssn=ssn.decode()
	if(ssn!=None):
		user=User.objects.get(ssn=ssn)
		user.set_password(request.data.get('password'))
		user.save()
	return JsonResponse({"message":'تم تغير كلمه المرور'})





@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def connect_farm_farmer_api(request :Request):
	if(request.data.get('operation')=='insert'):
		if(User.farmer.all().filter(ssn=request.data.get('farmer_id')).count()==0):
			return JsonResponse({"error":"هذا المربي غير مسجل" });
		try:
			connect_farm_farmer1=connect_farm_farmer()
			connect_farm_farmer1.farmer=User.farmer.get(ssn=request.data.get('farmer_id'))
			connect_farm_farmer1.farm=farm.objects.get(id=request.data.get('farm_id'))
			connect_farm_farmer1.total_cost=request.data.get('total_cost')
			connect_farm_farmer1.save()
			con1=connectFarmFarmerSeralizer(instance=connect_farm_farmer1)
			return JsonResponse({"message":"تم اضافة البيانات"})
		except:
			print("********************************"*45)
			print(request.data.get('farmer_id'));
			print(User.farmer.all().count())
			connect_farm_farmer1=connect_farm_farmer.objects.get(farmer_id=User.farmer.get(ssn=request.data.get('farmer_id')),farm=farm.objects.get(id=request.data.get('farm_id')))
			connect_farm_farmer1.total_cost=request.data.get('total_cost')
			con1=connectFarmFarmerSeralizer(instance=connect_farm_farmer1)
			return JsonResponse({"message":"تم تعديل البيانات"})
	if(request.data.get('operation')=='delete'):
		connect_farm_farmer1=connect_farm_farmer.objects.filter(farm=request.data.get('farm_id'),farmer=request.data.get('farmer_id')).delete()
		return JsonResponse({"message":"تم مسح البيانات"})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def admin_api(request :Request):
	oper=request.data['operation']
	if(oper=='delete'):
		import json
		dic1=request.data.dict()
		dic1.pop('operation')
		g_name=dic1.get("user_type")
		user1=User.objects.filter(ssn=dic1['ssn'])
		if(len(user1)==0):
			return  JsonResponse({"error":'it is not valid user ssn'})
		 
		else:
			if(user1[0].groups.all().count() > 1):
				user1[0].groups.remove( CustomeGroup.objects.all().get(name=g_name ) )
			else:
				user1[0].delete()
			return JsonResponse({"error":'تم مسح البيانات'})
	if(oper=='update'):
		dic1=request.data.dict()
		dic1.pop('operation')
		g_name=dic1.get("user_type")

		user1:User=User.objects.get(ssn=int(request.data['ssn']))
		for key,value in dic1.items() :
			if(key==g_name):
				if(g_name=="" and g_name):
					user1.groups.add(CustomeGroup.objects.all().get(name=g_name))

			if(key =='location' and value!=""):
				user1.location = village.objects.get(id=int(request.data['location']))
			if(value ==None  and  key not in ['ssn','fnane','lname','email','password','phone','photo']):
				continue
			setattr(user1,key,value)
   
		user1.save()
		return JsonResponse({"message":"تم تعديل البيانات"})
	if(oper=='insert'):
		dic1=request.data.dict()
		
		dic1.pop('operation')
		g_name=str(dic1.get("user_type") )
		dic1.pop("user_type")
		if(set(dic1).issubset(["user_type",'ssn','fname','lname','email','password','phone','photo','job','age',"location" ])):
			if(dic1["location"]!=None and dic1["location"]!=""):
				dic1["location"] =village.objects.all().get(id=dic1["location"])
			else:
				dic1.pop("location")
			try:
				user1=User.objects.create(**dic1)
			except Exception as e:
				user1=User.objects.all().get(ssn=dic1["ssn"])
			if(g_name):
					user1.groups.add(CustomeGroup.objects.all().get(name=g_name))
			else:
				pass
			return JsonResponse({"message":"تم اضافة البيانات"})

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def search_farm_api(request :Request):
	#import translate
	import typesense
	client = typesense.Client({
					'api_key': 'AA3jvgcuaEfuB3GAtWjNS3LG66404bd6KHOBK1YqstLgBTtT',
					'nodes': [{
							'host': 'localhost',
							'port': '8108',
							'protocol': 'http'
					}],
					'connection_timeout_seconds': 2
			})
	q=request.data.get('name')
	if(q==None):
		q="*"
	d1=client.collections['farm'].documents.search({"q":q,"query_by":"name","sort_by":"_text_match:desc","prioritize_exact_match":False,"pre_segmented_query":True})
	
	l1=[i['document']['id'] for i in d1['hits']]
	pagination=CustomePagenation()
	q=Q()
	if(request.data.get("ssn")!=None):
		print(request.headers.get("userauth"))
		if( request.headers.get("userauth")=="farmer" and request.user.groups.all().filter(name= request.headers.get("userauth")).count()>0):
			q=Q(**{"connect_farm_farmer__farmer":request.data.get("ssn")})
		else:
			q=Q(**{"connect_farm_farmer__farmer__village__city__governorate":request.user.location.city.governorate})
	p1=pagination.paginate_queryset(farm.objects.all().filter(Q(id__in= l1) &q) ,request)
	next=pagination.get_next_link()
	ser1=FarmListSerializer(instance=p1,many=True)

	return JsonResponse({"data":ser1.data,"next":next})

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def search_farmer_api(request :Request):
	import typesense
	client = typesense.Client({
					'api_key': 'AA3jvgcuaEfuB3GAtWjNS3LG66404bd6KHOBK1YqstLgBTtT',
					'nodes': [{
							'host': 'localhost',
							'port': '8108',
							'protocol': 'http'
					}],
					'connection_timeout_seconds': 2
			})
	q=request.data.get('name')
	
 
	if(q==None):
		q="*"
	d1=client.collections['farmer'].documents.search({"q":q,"query_by":"name","drop_tokens_threshold":1 ,"prioritize_exact_match":False,})
	#q=Q(**{"connect_farm_farmer__farmer__location__city__governorate__id":request.user.location.city.governorate.id})
 
	l1=[i['document']['id'] for i in d1['hits']]
	print(l1);
	pagination=CustomePagenation()
	p1=pagination.paginate_queryset(User.farmer.all().filter(ssn__in= l1,groups__name='farmer')  ,request)
	next=pagination.get_next_link()
	ser1=FarmerShowInfoSerializer(instance=p1,many=True)
	return JsonResponse({"data":ser1.data,"next":next})



@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def summary_governorate(request :Request):
	
	stat1=farm.objects.all().aggregate(village_count=Count("village__city__governorate__name"))
	stat2={"farm_meat":connect_farm_farmtype.objects.filter(farm_type__name__exact='انتاج لحوم').count()}
	stat3={"farm_milk":connect_farm_farmtype.objects.filter(farm_type__name__exact='انتاج البان').count()}
	stat4=User.farmer.all().aggregate(farmer_count=Count("ssn",Q(groups__name="farmer")))
	stat4={"farmer_count":connect_farm_farmer.objects.all().aggregate(farmer_count=Count("farmer__ssn"))["farmer_count"]+stat4["farmer_count"]}
	stat5={"total_cows":connect_animal_farm.objects.all().filter(animal_sub_type__platoon__name='الابقار').count()}
	stat6={"total_sheep":connect_animal_farm.objects.all().filter(animal_sub_type__platoon__name='الماعز').count()}
	stat7={"total_beauty":connect_animal_farm.objects.all().filter(animal_sub_type__platoon__name='الجمال').count()}
	stat8={"connect_animal_farm":list(connect_animal_farm.objects.all().values("animal_sub_type__platoon__name"  ).annotate(animal_number2=Sum("animal_number"),platoon=F("animal_sub_type__platoon__name")).values("animal_number2","platoon"))}
	print(stat8);
	stattest=governorate.objects.all().annotate(g_name=F('name'),farm_meat_gov=Count('city__village__farm__connect_farm_farmtype__farm__id',Q(city__village__farm__connect_farm_farmtype__farm_type__name__exact='انتاج لحوم')),farm_milk_gov=Count('city__village__farm__connect_farm_farmtype__farm__id',Q(city__village__farm__connect_farm_farmtype__farm_type__name__exact='انتاج البان')),total_villages=Count('city__village__farm')).values("g_name","total_villages","farm_meat_gov","farm_milk_gov")
	summary_info={"gov_data":list(  stattest )}|stat1|stat2|stat3|stat4|stat5|stat6|stat7|stat8
	return JsonResponse({"data":summary_info}) 


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def get_data_map(request :Request):
	import json
	l1  =json.loads(request.data["smallest"])+ json.loads(request.data["biggest"])
	f1=farm.objects.all().filter(location__intersects=str(Polygon.from_bbox( l1)))
	return response.Response( LocationSerializer(f1,many=True).data)
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def location_statistics(request):
	
	if(request.data.get("type")=="gov"):
	
		stattest=governorate.objects.all().values("name","city__village__farm__connect_farm_farmtype__farm_type__name").annotate(g_name=F("name"),count=Count('city__village__farm__connect_farm_farmtype__farm__id'),farm_type_name=F("city__village__farm__connect_farm_farmtype__farm_type__name")).values("g_name","farm_type_name","count")
		farm_type_query =governorate.objects.all().annotate(type=F("city__village__farm__connect_farm_farmtype__farm_type__name")).values(  "type").distinct()	
	elif(request.data.get("type")=="city"):
		stattest=city.objects.all().filter(governorate__id=request.data.get("id")).values("name","village__farm__connect_farm_farmtype__farm_type__name").annotate(g_name=F("name"),count=Count('village__farm__connect_farm_farmtype__farm__id'),farm_type_name=F("village__farm__connect_farm_farmtype__farm_type__name")).values("g_name","farm_type_name","count")
		farm_type_query =city.objects.all().filter(governorate__id=request.data.get("id")).annotate(type=F("village__farm__connect_farm_farmtype__farm_type__name")).values("village__farm__connect_farm_farmtype__farm_type__name")
	else:
		stattest=village.objects.all().filter(city__id=request.data.get("id")).annotate(g_name=F("name"),count=Count('farm__connect_farm_farmtype__farm__id'),farm_type_name=F("farm__connect_farm_farmtype__farm_type__name")).values("g_name","farm_type_name","count")
		farm_type_query =village.objects.all().filter(city__id=request.data.get("id")).annotate(type=F("farm__connect_farm_farmtype__farm_type__name")).values( "type")
	return JsonResponse( {"gov_data":list(stattest),"farm_type":list(farm_type_query)},safe=True )




@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_info_list(request):
	from datetime import datetime
	pagination=CustomePagenation()
	dic1={}
	query=Q()
	if(request.data.get("species")!=None and request.data.get("species")!=""):
		dic1["animal_sub_type"]=request.data.get("species")
	elif(request.data.get("platoon")!=None and request.data.get("platoon")!=""):
		dic1["animal_sub_type__platoon"]=request.data.get("platoon") 
	if(request.data.get("start_date")!=None and request.data.get("start_date")!=""):
		dic1["date__gte"]=  datetime.strptime(request.data.get("start_date")[:-4],'%Y-%m-%d %H:%M:%S')
	if(request.data.get("end_date")!=None and request.data.get("end_date")!=""):
		dic1["date__lte"]=datetime.strptime(request.data.get("end_date")[:-4],'%Y-%m-%d %H:%M:%S')
	for i in dic1:
		dic2=dict()
		dic2[i]=dic1[i]
		query=query&Q(**dic2)
	qs=connect_animal_farm.objects.all().filter(Q(farm_id=request.data.get('farm_id') )&query)
	p1=pagination.paginate_queryset(qs,request)
	ser1=connectFarmAnimalSeralizer(instance=p1,many=True)
	return JsonResponse( {"next":pagination.get_next_link(),"data": ser1.data})


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_info(request):
	qs=farm.objects.all().get(id=request.data.get('id'))
	ser1=FarmInfoShowSerializer( instance= qs )
	return response.Response( ser1.data )


@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_platoon_api(request):
	l1=list(connect_animal_farm.objects.all().filter(farm_id=request.data.get("farm_id")).values("animal_sub_type__platoon__name","animal_sub_type__platoon__id").annotate(id=F("animal_sub_type__platoon"),name=F("animal_sub_type__platoon__name")).values("name","id").distinct())
	return JsonResponse({"data":l1})

@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_species_api(request):
 	
	l1=list(connect_animal_farm.objects.all().filter(animal_sub_type__platoon__id=request.data.get("filter"),farm_id=request.data.get("farm_id")).values("animal_sub_type__name","animal_sub_type__id").annotate(id=F("animal_sub_type__id"),name=F("animal_sub_type__name")).values("name","id").distinct())
	return JsonResponse({"data":l1})
 
 
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def get_animal_farm(request :Request):
	try:
		l1=list(connect_animal_farm.objects.all().filter( farm_id=request.data.get("farm_id")).values("animal_sub_type__platoon","animal_sub_type__id").annotate(id=F("animal_sub_type__id"),platoon=F("animal_sub_type__platoon")).values("platoon","id").distinct())
		return JsonResponse({"id":l1[0]["id"],"platoon":l1[0]["platoon"]})
	except Exception as e:
		g1=species.DoesNotExist()
		return JsonResponse({"error":None});
		
@api_view(['GET' ])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def farm_map_bounder_api(request :Request):
	request.data
	u= governorate.objects.all().filter(id=request.user.location.city.governorate.id)[0].location.boundary.coords 
	return  JsonResponse({"map": u})

@api_view(['GET' ])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendTotp])
def img_farmer_api(request :Request):
	try:
		farm1=User.farmer.get(ssn=request.headers.get("ssn" ))
		
		return  FileResponse(open(farm1.img.path,"rb"))
	except Exception as e:
		return FileResponse(open("/home/mohamed/IdeaProjects/MainFinalProject/final_project_django/uploads/farmer_user/profile.png","rb"))
@api_view(['GET','POST'])
@permission_classes([CustomerAccessPermission])
@authentication_classes([CustomerBackendBasic])
def send_totpy_email(request :Request):
	if(User.objects.filter(ssn=request.headers['ssn']).count()==0):
		return JsonResponse({"error":"login first"})
	from uuid import uuid4
	code=uuid4()
	u1:User=User.objects.get(ssn=request.headers['ssn'])
	subject = 'confirm email address'
	code2=request.get_host()+"/"+"test_url/"+str(code)
	msg = EmailMultiAlternatives(subject,  "من فضلك اضغط علي الاينك\n"+code2,from_email=settings.EMAIL_HOST_USER , to=[u1.email ],reply_to= [request.data.get('email')])
	try:
		pyotpv1=totpyUsers.objects.get(user=User.objects.get(ssn=request.headers['ssn'])).totp
	except Exception as e:
		import pyotp
		pyotpv1=pyotp.random_base32()
		 
		totpyUsers.objects.create(totp=pyotpv1, user=User.objects.get(ssn=request.headers['ssn']))
		
 	 # This is critical, otherwise images will be displayed as attachments!
	import redis
	r=redis.Redis()
	#"http://"+request.get_host()+"/"+"test_url/"+str(code)
	#render(request,template_name='totp_email.html',)
	html_content = render_to_string('totp_email.html',  context={"url":"http://"+request.get_host()+"/"+"test_url/"+str(code)},request=request).strip()
	subject = 'confirm email address'
	send_mail(auth_password=settings.EMAIL_HOST_PASSWORD,subject=subject,recipient_list=[ u1.email],from_email =settings.EMAIL_HOST_USER, html_message= render_to_string('totp_email.html',  context={"url":"http://"+request.get_host()+"/"+"test_url/"+str(code)},request=request).strip(),message=None);
	print(u1.email);
	#send_mail('send totpy code','the url for totpy is\n'+  +"\t",settings.EMAIL_HOST_USER,[   u1.email],fail_silently=False)
	r.setex(name=str(code  ),time=5*60,value= pyotpv1)
	r.set(name=request.headers["ssn"],value=pyotpv1,ex=60*60)
	#msg.send( )
	return JsonResponse({"message":'تم ارسال الرسالة'})

def send_totpy_template(request ,id ):
	import redis
	r=redis.Redis()
	totpy=r.get( id)
	r.delete(id)
	try:
		return  render(request=request,template_name="totpy.html",context={"code":totpy.decode()},);
	except Exception as e:
		return    render(request=request,template_name="totpy_error.html",);

#NULL
@api_view(['GET' , ])
@permission_classes([ CustomerAccessPermission])
@authentication_classes([CustomerBackendBasic])
def check_totp_api(request :Request):
	try:
		totpy1=totpyUsers.objects.get(totp=request.headers.get("totp"),user=request.user)
		return JsonResponse({"find":True})
	except Exception as e:
		return JsonResponse({"find":False})
@api_view(['GET',"POST" ])
@permission_classes([permissions.IsAuthenticated])
@authentication_classes([CustomerBackendTotp])
def user_group_api(request :Request):
  return  response.Response(GroupSerializer( instance= request.user.groups.all(),many=True).data)

@api_view(['GET',"POST" ])
@permission_classes([permissions.AllowAny])
def create_totpy_code_for_paseto_api(request :Request):
	u1:User=User.objects.get(ssn=request.headers.get('ssn'))
	return response.Response();
"""
@api_view(['GET',"POST" ])
@permission_classes([permissions.IsAuthenticated])
@authentication_classes([CustomerBackendTotp])
def create_paseto_api(request :Request):
  my_key = SymmetricKey.generate(protocol=ProtocolVersion4)
			# create a paseto token that expires in 5 minutes (300 seconds)
  token = paseto.create(
				key=my_key,
				purpose='local',
				claims={'ssn':  request.user.ssn},
				exp_seconds=86400
			)
  return  response.Response(GroupSerializer( instance= request.user.groups.all(),many=True).data)

"""
@api_view(['GET',"POST" ])
@permission_classes([permissions.IsAuthenticated])
@authentication_classes([CustomerBackendTotp])
def search_google_map(request :Request):
	f1=farm.objects.all().filter(id__startswith=request.data["search"]);
	pagination=CustomePagenation()
	if(f1.count()>0):
		p1=pagination.paginate_queryset( f1 ,request)
		next=pagination.get_next_link()
		ser1=FarmerGoogleMapSerializer(instance=p1,many=True)
		return JsonResponse({"data":ser1.data,"next":next})
	import typesense
	client = typesense.Client({
					'api_key': 'AA3jvgcuaEfuB3GAtWjNS3LG66404bd6KHOBK1YqstLgBTtT',
					'nodes': [{
							'host': 'localhost',
							'port': '8108',
							'protocol': 'http'
					}],
					'connection_timeout_seconds': 2
			})
	q=request.data.get('name')
	if(q==None):
		q="*"
	d1=client.collections['farm'].documents.search({"q":q,"query_by":"name","sort_by":"_text_match:desc",#"prioritize_exact_match":False 
												 })
	print(d1);
	l1=[i['document']['id'] for i in d1['hits']]
	pagination=CustomePagenation()
	 
	p1=pagination.paginate_queryset(farm.objects.all().filter(Q(id__in= l1)  ) ,request)
	next=pagination.get_next_link()
	ser1=FarmerGoogleMapSerializer(instance=p1,many=True)
	return JsonResponse({"data":ser1.data,"next":next})