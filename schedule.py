from django.db import models
from plan.models import *
from plan.forms import *
import sys
import itertools


# NOTES
# ------------------------------------------------------------------------------
# This script should build a list of all possible schedules in a fairly
# effecient way and meet the same requirements as the ASP code. It takes three
# parameters:
#
# s    student id
# max  max hours
# min  min hours

def course_repeated(offerset):
    courses = []
    for o in offerset:
        if o.course in courses:
            return True
        else:
            courses.append(o.course)
    return False


def ineligible(offerset):
    creqs = []
    for o in offerset:
        for r in o.course.corequisites.all():
            if r not in creqs:
                creqs.append(r)
    for r in creqs:
        if r not in offerset:
            return True
    return False    


def taken(offerset,s):
    for o in offerset:
        if s.taken.filter(id=o.course.id).count() > 0:
            return True
    return False


def conflict(offerset):
    # generate all combinations of two courses which 
    # are in offerset
    subs = list(itertools.combinations(offerset,2))
    for s in subs:
        a = s[0]
        b = s[1]
        if a == b:
            return True
        if a.period == b.period:
            return True
        # check for the same day first
        if (a.period.day.all() & b.period.day.all()).count() > 0:
            if a.period.starts == b.period.starts and a.period.ends \
            == b.period.ends:
                return True
            if a.period.starts < b.period.starts:
                if a.period.ends < b.period.starts:
                    continue
            elif b.period.starts < a.period.starts:
                if b.period.ends < a.period.starts:
                    continue
            return True
    
    return False


# program entry point
s = None
hmin = None
hmax = None


# parse command line args
for i in sys.argv:
    if i == "test_shell.py" or i == "schedule":
        continue
    else:
        key = i.split('=')[0]
        if key == 's':
            s = i.split('=')[1]
        elif key == 'min':
            hmin = int(i.split('=')[1])
        elif key == 'max':
            hmax = int(i.split('=')[1])

if s == None or hmin == None or hmax == None:
    print "usage: schedule s=<id> min=<min> max=<max>"

# get selected student
student = Student.objects.get(id=s)

courses = []
offerings = None

# explicitly required and not taken
required = student.degree_plan.required_courses.exclude(id__in = \
student.taken.values_list('id',flat=True)).distinct()

# meets attributes
meets = Course.objects.filter(meets__id__in = \
student.degree_plan.required_attrs.all().values_list( \
'attribute__id',flat=True)).distinct()

# either meets attributes or is required and not taken
possible = (required | meets).distinct()

# check prerequisites
for c in possible:
    if c.prerequisites.count() > 0 and \
    c.prerequisites.exclude(id__in=student.taken.values_list( \
    'id',flat=True)).count() > 0:
        possible = possible.exclude(id=c.id)


# get all offerings for this group
offerings = Offering.objects.filter(course__in=possible)

# in order to make our guess computable, we'll enter an avg number of hours
# slightly lower than the actual average 
avg_hours = 2
num_classes = hmax/avg_hours

# generate all subsets of offerings
from itertools import combinations
subsets = [list(j) for i in range(num_classes+1) for j in combinations(offerings, i)
    if hmin <= sum(o.course.hours for o in j) <= hmax]

valid_sets = []

count = 0

print_iter = 500

for s in subsets:
    if not course_repeated(s) and not conflict(s) and not ineligible(s) and not taken(s,student):
        valid_sets.append(s)
    
    count += 1

print len(valid_sets)