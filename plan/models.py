from django.db import models
from django.forms import ModelForm, ModelMultipleChoiceField
import os

OFILE = 'asp/.tmp/asp'

class Department(models.Model):
	name = models.CharField(max_length=500)
	abbreviation = models.CharField(max_length=4)
	
	class Meta:
		ordering = ['name','abbreviation']
	
	def asp(self):
	    return 'dept(dept%d).\n' % self.id
	
	def __str__(self):
		return self.name
	
	def __unicode__(self):
		return self.name
	

class Attribute(models.Model):
	name = models.CharField(max_length=500)
	
	class Meta:
		ordering = ['name']
	
	def asp(self):
	    return 'attr(attr%d).\n' % self.id
	
	def __str__(self):
		return self.name
	
	def __unicode__(self):
		return self.name
	

class Degree(models.Model):
	name = models.CharField(max_length=500)
	description = models.TextField()
	department = models.ForeignKey('Department')
	required_courses = models.ManyToManyField('Course')
	
	class Meta:
		ordering = ['name']
	
	def asp(self):
	    asp = 'degree(degree%d).\n' % self.id
	    asp += 'deg_in_dept(degree%d, dept%d).\n' % (self.id, self.department.id)
	    for c in self.required_courses.all():
	        asp += 'deg_req(degree%d, course%d).\n' % (self.id, c.id)
	    for a in self.required_attrs.all():
	        asp += 'deg_attr_req(degree%d, attr%d, %d).\n' % (self.id, a.attribute.id, a.hours)
	    return asp
	
	def __str__(self):
		return self.name
	
	def __unicode__(self):
		return self.name
	

class AttributeRequirement(models.Model):
    attribute = models.ForeignKey('Attribute')
    hours = models.IntegerField()
    degrees = models.ManyToManyField('Degree', related_name='required_attrs')
    
    class Meta:
        ordering = ['attribute__name','hours']
    
    def met_by(self):
        return self.attribute.course_set()
    
    def __str__(self):
        return str(self.hours) + ' / ' + str(self.attribute)
    
    def __unicode__(self):
        return str(self.hours) + ' / ' + str(self.attribute)
    

class Course(models.Model):
	department = models.ForeignKey('Department')
	number = models.CharField(max_length=4)
	name = models.CharField(max_length=100)	
	hours = models.IntegerField()
	meets = models.ManyToManyField('Attribute', blank=True)
	prerequisites = models.ManyToManyField('Course', related_name='preq', blank=True, symmetrical=False)
	corequisites = models.ManyToManyField('Course', related_name='creq', blank=True, symmetrical=True)
	
	class Meta:
		ordering = ['department__name','number']
	
	def asp(self):
	    asp = 'course(course%d).\n' % self.id
	    asp += 'course_number(course%d,%s).\n' % (self.id, self.number)
	    asp += 'in_dept(course%d, dept%d).\n' % (self.id, self.department.id)
	    asp += 'course_hours(course%d, %d).\n' % (self.id, self.hours)
	    for a in self.meets.all():
	        asp += 'meets(course%d, attr%d).\n' % (self.id, a.id)
	    for r in self.prerequisites.all():
	        asp += 'preq(course%d, course%d).\n' % (r.id, self.id)
	    for q in self.corequisites.all():
	        asp += 'creq(course%d, course%d).\n' % (self.id, q.id)
	    return asp
	
	def __str__(self):
		return self.department.abbreviation + str(self.number)
	
	def __unicode__(self):
		return self.department.abbreviation + str(self.number)
	

class PeriodDay(models.Model):
	PERIOD_DAYS = (
		('1','Monday'),
		('2','Tuesday'),
		('3','Wednesday'),
		('4','Thursday'),
		('5','Friday'),
		('6','Saturday'),
		('7','Sunday')
	)
	
	day = models.IntegerField(choices=PERIOD_DAYS)
	
	class Meta:
		ordering = ['day']
	
	def courses(self):
	    return Course.objects.filter(offering__period__day__id=self.id).distinct()
	
	def full_str(self):
		return str(self.PERIOD_DAYS[self.day-1][1])
	
	def abbr_str(self):
		if self.day not in (4,7):
			return str(self.PERIOD_DAYS[self.day-1][1][0])
		else:
			if self.day == 4:
				return 'R'
			else:
				return 'U'	
	
	def __str__(self):
		return self.full_str()
	
	def __unicode__(self):
		return self.full_str()
	

class Period(models.Model):
	starts = models.TimeField()
	ends = models.TimeField()
	day = models.ManyToManyField('PeriodDay')
	
	class Meta:
		ordering = ['starts','ends']
	
	def asp(self):
	    asp = 'period(period%d).\n' % self.id
	    asp += 'starts(period%d, %s).\n' % (self.id, str(self.starts.hour) + self.starts.strftime('%M'))
	    asp += 'ends(period%d, %s).\n' % (self.id, str(self.ends.hour) + self.ends.strftime('%M'))
	    for d in self.day.all():
	        asp += 'day(period%d, %d).\n' % (self.id, d.day)
	    return asp
	
	def __str__(self):
		name = ""
		name += self.starts.strftime("%H%M") + "-" + self.ends.strftime("%H%M") + " "
		for d in self.day.all():
			name += d.abbr_str()
		return name
	
	def __unicode__(self):
		name = ""
		name += self.starts.strftime("%H%M") + "-" + self.ends.strftime("%H%M") + " "		
		for d in self.day.all():
			name += d.abbr_str()
		return name

class Offering(models.Model):
	course = models.ForeignKey('Course')
	period = models.ForeignKey('Period')
	section = models.CharField(max_length=3)
	
	class Meta:
		ordering = ['course','section']
	
	def asp(self):
	    asp = 'offering(offering%d).\n' % self.id
	    asp += 'offer_course(offering%d, course%d).\n' % (self.id, self.course.id)
	    asp += 'offer_section(offering%d, s%s).\n' % (self.id, self.section)
	    asp += 'offer_pd(offering%d, period%d).\n' % (self.id, self.period.id)
	    return asp
	
	def __str__(self):
		return str(self.course) + "-" + str(self.section)
		
	def __unicode__(self):
		return str(self.course) + "-" + str(self.section)
	

class Student(models.Model):
	first_name = models.CharField(max_length = 500)
	last_name = models.CharField(max_length = 500)
	email = models.EmailField(max_length = 250)
	degree_plan = models.ForeignKey('Degree')
	taken = models.ManyToManyField('Course')
	
	class Meta:
		ordering = ['last_name','first_name','email']
	
	def asp(self):
	    asp = 'student(student%d).\n' % self.id
	    asp += 'selected(student%d).\n' % self.id
	    asp += 'student_deg(student%d, degree%d).\n' % (self.id, self.degree_plan.id)
	    for c in self.taken.all():
	        asp += 'taken(student%d, course%d).\n' % (self.id, c.id)
	    return asp
    
	def __str__(self):
		return self.first_name + " " + self.last_name + " (" + self.email + ")"
	
	def __unicode__(self):
		return self.first_name + " " + self.last_name + " (" + self.email + ")"
	

class Schedule(models.Model):
    student = models.ForeignKey('Student')
    offerings = models.ManyToManyField('Offering',symmetrical=False)
    hours = models.IntegerField()
    
    class Meta:
        ordering = ['hours',]
    
    
    def offer_list(self):
        return list(self.offerings.all())

    def __str__(self):
        s = ' '
        for o in self.offerings.all():
            s += str(o) + ' '
        return s
    
    def __unicode__(self):
        s = ' '
        for o in self.offerings.all():
            s += str(o) + ' '
        return s
    
