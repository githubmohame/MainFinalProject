# Generated by Django 4.1.3 on 2022-12-02 18:31

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('digital_livestock', '0004_for_what_use_animal_connect_sub_animal_for_what'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='animal_sub_type',
            name='what_produce',
        ),
    ]