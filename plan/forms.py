from django.db import models
from django.forms import ModelForm
from plan.models import *

class DepartmentForm(ModelForm):
	class Meta:
		model = Department
	

class AttributeForm(ModelForm):
	class Meta:
		model = Attribute
	

class DegreeForm(ModelForm):
	class Meta:
		model = Degree
	

class CourseForm(ModelForm):
	class Meta:
		model = Course
	

class PeriodDayForm(ModelForm):
	class Meta:
		model = PeriodDay
	

class PeriodForm(ModelForm):
	class Meta:
		model = Period
	

class OfferingForm(ModelForm):
	class Meta:
		model = Offering
	

class StudentForm(ModelForm):
	class Meta:
		model = Student
	
