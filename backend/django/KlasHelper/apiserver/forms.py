from django import forms
from .models import CommentTb,PostTb

class CommentForm(forms.ModelForm):
    class Meta :
        model = CommentTb
        fields = ('class_code','author_id','content')
class PostForm(forms.ModelForm):
    class Meta :
        model = PostTb
        fields = ('class_code','author_id','title','content',)