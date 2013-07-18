from django.db import models
from plan.models import *
from plan.forms import *
from datetime import datetime
import random

def log(msg):
    f = open("log.log","a")
    msg = "%s\t%s\n" % (datetime.now(),msg)
    f.write(msg)
    f.close()

log("Processing file...")
f = open('asp/.tmp/results','r')

Schedule.objects.all().delete()
print Schedule.objects.count()
print len(Schedule.objects.all().distinct())

alloffs = []

for line in f:
    if line.strip() == '':
        break
    parts = line.split(' ')
    
    x = {}
    offs = []
    stu = None
    hrs = 0
            
    for p in parts:
        t = p.partition('(')[0]
        if t == 'total_hours':
            h = p.partition('(')[2].replace(').','')
            hrs = h
        else:
            a = p.partition('(')[2].replace(').','').split(',')
            if not a == ['']:
                sid = a[0].replace('student','')
                oid = a[1].replace('offering','')
                stu = sid
                offs.append(oid)
    
    x['s'] = stu
    x['h'] = hrs
    x['o'] = offs
    alloffs.append(x)
    
f.close()
count = 1

print len(alloffs)

for o in alloffs:
    s = Schedule()
    s.student = Student.objects.get(id=o['s'])
    s.hours = o['h']
    s.save()
    for f in o['o']:
        s.offerings.add(Offering.objects.get(id=f))
    
    

print Schedule.objects.count()
print len(Schedule.objects.all().distinct())
log('Done.')