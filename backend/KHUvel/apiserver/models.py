# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

class CourseTb(models.Model):
    class_code = models.CharField(primary_key=True, max_length=20)
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
        db_table = 'course_tb'


class PostTb(models.Model):
    post_id = models.AutoField(primary_key=True)
    class_code = models.CharField(max_length=20)
    author_id = models.CharField(max_length=20)
    title = models.CharField(max_length=255)
    content = models.TextField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True,auto_now_add=True)
    hit = models.PositiveIntegerField()
    flag = models.IntegerField(blank=True, null=True,default=1)
    def __unicode__(self):
        return self.title
    class Meta:
        managed = False
        db_table = 'post_tb'

class CommentTb(models.Model):
    comment_id = models.AutoField(primary_key=True)
    class_code = models.CharField(max_length=20)
    post_id = models.PositiveIntegerField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True,auto_now_add=True)
    author_id = models.CharField(max_length=20)
    content = models.TextField(blank=True, null=True)
    flag = models.IntegerField(blank=True, null=True, default=1)

    class Meta:
        managed = False
        db_table = 'comment_tb'

class UserTb(models.Model):
    klas_id = models.CharField(primary_key=True, max_length=20)
    naver_id = models.CharField(max_length=40, blank=True, null=True)
    class_2018_2 = models.CharField(max_length=400, blank=True, null=True)
    name =models.CharField(max_length=256, blank=True, null=True)
    lec = models.CharField(max_length=512, blank=True, null=True)
    work = models.CharField(max_length=512, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'user_tb'

class Test(models.Model):
    sno = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=10, blank=True, null=True)
    det = models.CharField(max_length=20, blank=True, null=True)
    addr = models.CharField(max_length=80, blank=True, null=True)
    tel = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'test'


