from django.db import models
from django.core.validators import RegexValidator
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
import uuid
# Create your models here.

'''class for_what_use_animal(models.Model):
    name=models.CharField(max_length=20)
    id=models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    '''


class platoon(models.Model):
    name = models.CharField(max_length=20)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)


class species(models.Model):
    name = models.CharField(max_length=20)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    platoon = models.ForeignKey(platoon, on_delete=models.CASCADE)

    # country=models.CharField(max_length=20,null=True)
'''class connect_sub_animal_for_what(models.Model):
    animal_sub_type=models.ForeignKey(animal_sub_type,on_delete=models.CASCADE)
    for_what_use_animal=models.ForeignKey(for_what_use_animal,on_delete=models.CASCADE)
    '''


class governorate(models.Model):
    name = models.CharField(max_length=20)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)


class city(models.Model):
    name = models.CharField(max_length=20)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    governorate = models.ForeignKey(governorate, on_delete=models.CASCADE)


class village(models.Model):
    name = models.CharField(max_length=20)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    city = models.ForeignKey(city, on_delete=models.CASCADE)


class UserManager(BaseUserManager):
    def create_superuser(self, ssn, name, phone,  password, village=None, **other_fields):

        other_fields.setdefault('is_staff', True)
        other_fields.setdefault('is_superuser', True)
        other_fields.setdefault('is_active', True)

        if other_fields.get('is_staff') is not True:
            raise ValueError(
                'Superuser must be assigned to is_staff=True.')
        if other_fields.get('is_superuser') is not True:
            raise ValueError(
                'Superuser must be assigned to is_superuser=True.')

        return self.create_user(ssn, name, phone,  password, village, **other_fields)

    def create_user(self, ssn, name, phone, password, village=None, **other_fields):
        user = self.model(ssn=ssn, name=name, phone=phone, village=village)
        user.set_password(password)
        user.save()
        return user


class User(AbstractBaseUser, PermissionsMixin):
    ssn = models.CharField(max_length=13, primary_key=True, validators=[RegexValidator(regex='''[1-9]{1,1}[0-9]{12,12}''')])
    USERNAME_FIELD = 'ssn'
    REQUIRED_FIELDS = ['phone', 'name',]
    name = models.CharField(max_length=30, blank=False, validators=[
        RegexValidator(regex='''[a-zA-Z]''')
    ])
    phone = models.CharField(max_length=12, blank=False, validators=[
        RegexValidator(regex='''[0-9]{12,12}''')
    ])
    photo = models.ImageField(upload_to='personal_images')
    village = models.ForeignKey(village, null=True, on_delete=models.CASCADE)
    objects = UserManager()


class farm_type(models.Model):
    name = models.CharField(max_length=30, blank=False, null=False)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)


class section_type(models.Model):
    name = models.CharField(max_length=30, blank=False, null=False)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)


class farm(models.Model):
    number_of_arc = models.PositiveIntegerField(null=True)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    number_of_workers = models.PositiveIntegerField(null=False)
    playground = models.PositiveIntegerField(null=False)
    wards = models.PositiveIntegerField(null=False)
    isolated_wards = models.PositiveIntegerField(null=False)
    # google_map=models.URLField(null=True)
    farm_type = models.ForeignKey(farm_type, on_delete=models.CASCADE)
    section_type = models.ForeignKey(section_type, on_delete=models.CASCADE)
    village = models.ForeignKey(village, on_delete=models.CASCADE)
    attached_area = models.PositiveIntegerField(validators=[])
    """class Meta:
            constraints = [
                models.CheckConstraint(
                    check = models.Q(number_of_arc__gt=0)&models.Q(number_of_workers__gt=0)&models.Q(wards__gt=0)&models.Q(playground__gt=0), 
                    name = 'positive_ck',
                ),
            ]"""


class connect_animal_farm(models.Model):
    animal_sub_type = models.ForeignKey(
        species, on_delete=models.CASCADE)
    work_place = models.ForeignKey(farm, on_delete=models.CASCADE)
    animal_number = models.PositiveIntegerField(null=False)
    is_male = models.BooleanField(null=False, blank=False)
    total_money = models.PositiveIntegerField(validators=[])


'''
Ssn: 3010906121153
Phone: 010242159778
Name: mohamed


'''
