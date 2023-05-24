# Generated by Django 4.0.8 on 2023-05-22 15:09

from django.conf import settings
import django.contrib.gis.db.models.fields
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('ssn', models.CharField(max_length=13, primary_key=True, serialize=False, validators=[django.core.validators.RegexValidator(regex='[1-9]{1,1}[0-9]{12,12}')])),
                ('fname', models.CharField(max_length=30, validators=[django.core.validators.RegexValidator(regex='[a-zA-Zا-ي]')])),
                ('phone', models.CharField(max_length=12, validators=[django.core.validators.RegexValidator(regex='[0-9]{12,12}')])),
                ('photo', models.ImageField(upload_to='personal_images')),
                ('email', models.EmailField(max_length=254, null=True)),
                ('lname', models.CharField(max_length=30, null=True, validators=[django.core.validators.RegexValidator(regex='[a-zA-Zا-ي]')])),
                ('job', models.CharField(max_length=30, null=True, validators=[django.core.validators.RegexValidator(regex='[a-zA-Zا-ي]')])),
                ('is_staff', models.BooleanField(default=False)),
                ('is_active', models.BooleanField(default=True)),
                ('age', models.IntegerField(null=True)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='city',
            fields=[
                ('name', models.CharField(max_length=50)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
                ('location', django.contrib.gis.db.models.fields.GeometryField(geography=True, null=True, srid=4326)),
            ],
        ),
        migrations.CreateModel(
            name='farm_type',
            fields=[
                ('name', models.CharField(max_length=30)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='governorate',
            fields=[
                ('name', models.CharField(max_length=50)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='platoon',
            fields=[
                ('name', models.CharField(max_length=20)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='section_type',
            fields=[
                ('name', models.CharField(max_length=30)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='village',
            fields=[
                ('name', models.CharField(max_length=50)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
                ('location', django.contrib.gis.db.models.fields.GeometryField(geography=True, null=True, srid=4326)),
                ('city', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.city')),
            ],
        ),
        migrations.CreateModel(
            name='species',
            fields=[
                ('name', models.CharField(max_length=20)),
                ('id', models.AutoField(editable=False, primary_key=True, serialize=False)),
                ('platoon', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.platoon')),
            ],
        ),
        migrations.CreateModel(
            name='farm',
            fields=[
                ('farm_name', models.CharField(max_length=30, null=True)),
                ('id', models.CharField(max_length=40, primary_key=True, serialize=False)),
                ('number_of_workers', models.PositiveIntegerField()),
                ('playground', models.PositiveIntegerField()),
                ('huge_playground', models.PositiveIntegerField(null=True)),
                ('wards', models.PositiveIntegerField()),
                ('isolated_wards', models.PositiveIntegerField()),
                ('attached_area', models.PositiveIntegerField()),
                ('location', django.contrib.gis.db.models.fields.GeometryField(geography=True, null=True, srid=4326)),
                ('total_area_of_farm', models.PositiveIntegerField(null=True)),
                ('section_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.section_type')),
                ('village', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.village')),
            ],
        ),
        migrations.CreateModel(
            name='connect_farm_farmtype',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('farm', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.farm')),
                ('farm_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.farm_type')),
            ],
        ),
        migrations.CreateModel(
            name='connect_farm_farmer',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('total_cost', models.PositiveIntegerField()),
                ('farm', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.farm')),
                ('farmer', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='connect_animal_farm',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('animal_number', models.PositiveIntegerField()),
                ('is_male', models.BooleanField()),
                ('date', models.DateField(blank=True, null=True)),
                ('animal_sub_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.species')),
                ('farm_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.farm')),
            ],
        ),
        migrations.AddField(
            model_name='city',
            name='governorate',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.governorate'),
        ),
        migrations.AddField(
            model_name='user',
            name='location',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='digital_livestock.city'),
        ),
        migrations.AddField(
            model_name='user',
            name='user_permissions',
            field=models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions'),
        ),
        migrations.AddField(
            model_name='user',
            name='village',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='digital_livestock.village'),
        ),
        migrations.AddConstraint(
            model_name='connect_farm_farmtype',
            constraint=models.UniqueConstraint(fields=('farm', 'farm_type'), name='connect_farm_farmtype_uk'),
        ),
        migrations.AddConstraint(
            model_name='connect_farm_farmer',
            constraint=models.UniqueConstraint(fields=('farm', 'farmer'), name='connect_farm_farmer_uk'),
        ),
    ]
