# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin sqlcustom [app_label]'
# into your database.
from __future__ import unicode_literals

from django.db import models


class Comment(models.Model):
    comment_id = models.IntegerField()
    class_code = models.CharField(max_length=20)
    post_id = models.IntegerField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True)
    author_id = models.CharField(max_length=20)
    content = models.TextField(blank=True, null=True)
    flag = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'comment'


class Course20182(models.Model):
    class_code = models.CharField(max_length=20)
    class_name = models.CharField(max_length=100)
    class_year = models.CharField(max_length=10, blank=True, null=True)
    quota = models.CharField(max_length=10, blank=True, null=True)
    instructor = models.CharField(max_length=100, blank=True, null=True)
    credit = models.CharField(max_length=10, blank=True, null=True)
    class_hour_room = models.CharField(max_length=500, blank=True, null=True)
    class_type = models.CharField(max_length=20, blank=True, null=True)
    class_lan = models.CharField(max_length=50, blank=True, null=True)
    notice = models.CharField(max_length=100, blank=True, null=True)
    campus = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'course_2018_2'


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class Post(models.Model):
    post_id = models.IntegerField()
    class_code = models.CharField(max_length=20)
    author_id = models.CharField(max_length=20)
    title = models.CharField(max_length=255)
    content = models.TextField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True)
    hit = models.IntegerField()
    flag = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'post'


class User(models.Model):
    klas_id = models.CharField(primary_key=True, max_length=20)
    naver_id = models.CharField(max_length=20, blank=True, null=True)
    lectures = models.CharField(max_length=512, blank=True, null=True)
    name = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user'
