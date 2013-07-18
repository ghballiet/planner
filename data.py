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

PERIOD_DAYS = (
	('1','Monday'),
	('2','Tuesday'),
	('3','Wednesday'),
	('4','Thursday'),
	('5','Friday'),
	('6','Saturday'),
	('7','Sunday')
)

log("STARTING RELOAD DATA SCRIPT")

# ===============
# = period days =
# ===============
log("Deleting period days...")
for p in PeriodDay.objects.all():
    p.delete()
    
log("Adding period days...")
for p in PERIOD_DAYS:
    PeriodDay(day=p[0]).save()    


    
# ===========
# = periods =
# ===========
log("Deleting periods...")
for r in Period.objects.all():
    r.delete()

log("Adding period days...")
for t in range(8,24):
    p = Period()
    p.starts = str(t) + ":00"
    p.ends = str(t) + ":50"
    p.save()
    for i in (1,3,5):
        p.day.add(PeriodDay.objects.get(day=i))
    p.save()
    if (t+1)%3 == 0 and t < 23:
        p = Period()
        p.starts = str(t) + ":00"
        p.ends = str(t+1) + ":20"
        p.save()
        for i in (2,4):
            p.day.add(PeriodDay.objects.get(day=i))
        p.save()
    elif t%3 == 0 and t < 23:
        p = Period()
        p.starts = str(t) + ":30"
        p.ends = str(t+1) + ":50"
        p.save()
        for i in (2,4):
            p.day.add(PeriodDay.objects.get(day=i))
        p.save()      



# ===============
# = departments =
# ===============
log("Deleting departments...")
for d in Department.objects.all():
    d.delete()

depts = (
    ('Computer Science','C S '),
    ('Mathematics','MATH'),
    ('English','ENGL'),
    ('Political Science','POLS'),
    ('Chemistry', 'CHEM'),
    ('Physics', 'PHYS'),
    ('Electrical Engineering', 'E E '),
    ('Biology','BIOL'),
)

log("Adding departments...")
for d in depts:
    Department(name=d[0],abbreviation=d[1]).save()



# ==============
# = attributes =
# ==============
log("Deleting attributes...")
for a in Attribute.objects.all():
    a.delete()

attrs = (
    'Political Science',
    'U.S. History',
    'Humanities',
    'Visual and Performing Arts',
    'Individual and Group Behavior',
    'Science',
    'English',
    'Technology'
)

log("Adding attributes...")
for a in attrs:
    Attribute(name=a).save()

# ===========
# = courses =
# ===========
log("Deleting courses...")
for c in Course.objects.all():
    c.delete()

courses = (
    ['C S ','1411',4,'Programming Principles I',[],[],[]],
    ['ENGL','1301',3,'Essentials of College Rhetoric',['English'],[],[]],
    ['MATH','1351',3,'Calculus I',[],[],[]],
    ['POLS','1301',3,'American Government and Organization',['Political Science'],[],[]],
    ['C S ','1412',4,'Programming Principles II',[],['Programming Principles I'],[]],
    ['C S ','1382',3,'Discrete Structures',[],['Programming Principles I'],[]],
    ['MATH','1352',3,'Calculus II',[],['Calculus I'],[]],
    ['ENGL','1302',3,'Advanced College Rhetoric',[],['Essentials of College Rhetoric'],[]],
    ['C S ','2413',4,'Data Structures',[],['Programming Principles II'],[]],
    ['PHYS','1408',4,'Principles of Physics I',['Science'],['Calculus I'],[]],
    ['MATH','2350',3,'Calculus III',[],['Calculus II'],[]],
    ['E E ','2372',3,'Modern Digital Systems Design',[],['Calculus I'],[]],
    ['C S ','2350',3,'Computer Organization and Assembly Language',[],['Modern Digital Systems Design'],[]],
    ['PHYS','2401',4,'Principles of Physics II',['Science'],['Principles of Physics I'],[]],
    ['MATH','2360',3,'Linear Algebra',[],['Calculus III'],[]],
    ['ENGL','2311',3,'Technical Writing',['English'],[],[]],
    ['CHEM','1307',3,'Principles of Chemistry I',['Science'],[],[]],
    ['CHEM','1107',1,'Principles of Chemistry I Lab',['Science'],[],['Principles of Chemistry I']],
    ['BIOL','1403',4,'Biology I',['Science'],[],[]]
)

log("Adding courses...")
for o in courses:
    c = Course()
    c.department = Department.objects.get(abbreviation=o[0])
    c.number = o[1]
    c.hours = o[2]
    c.name = o[3]
    c.save()
    for m in o[4]:
        c.meets.add(Attribute.objects.get(name=m))
    for p in o[5]:
        c.prerequisites.add(Course.objects.get(name=p))
    for q in o[6]:
        c.corequisites.add(Course.objects.get(name=q))
    c.save()


# ===========
# = degrees =
# ===========
log("Deleting degrees...")
for d in Degree.objects.all():
    d.delete()

degrees = [
    [ 'C S ','BS CS','Bacheolor of Science in Computer Science', [
        'Programming Principles I', 'Essentials of College Rhetoric', 'Calculus I',
        'American Government and Organization', 'Programming Principles II', 'Discrete Structures',
        'Calculus II', 'Advanced College Rhetoric', 'Data Structures', 'Principles of Physics I', 
        'Calculus III', 'Modern Digital Systems Design', 'Computer Organization and Assembly Language',
        'Principles of Physics II', 'Linear Algebra', 'Technical Writing'
        ]]
]

log("Adding degrees...")
for g in degrees:
    d = Degree()
    d.department = Department.objects.get(abbreviation=g[0])
    d.name = g[1]
    d.description = g[2]
    d.save()
    for r in g[3]:
        d.required_courses.add(Course.objects.get(name=r))
    d.save()
    

# ==========================
# = attribute requirements =
# ==========================
log("Deleting attribute requirements...")
AttributeRequirement.objects.all().delete()

attr_reqs = [
    ['Political Science', 6, ['BS CS']],
    ['Technology', 12, ['BS CS']],
    ['Science', 6, ['BS CS']]
]

log("Adding attribute requirements...")
for r in attr_reqs:
    a = AttributeRequirement()
    a.attribute = Attribute.objects.get(name=r[0])
    a.hours = r[1]
    a.save()
    for g in r[2]:
        a.degrees.add(Degree.objects.get(name=g))
    a.save()


# =============
# = offerings =
# =============
log("Deleting offerings...")
for o in Offering.objects.all():
    o.delete()

max_offerings = 3

log("Adding offerings...")
for f in Course.objects.all():
    for i in range(0,random.randint(1,max_offerings)):
        o = Offering()
        o.course = f
        per = Period.objects.get(id=random.randint(1,Period.objects.count()))
        o.period = per
        sec = "00%d" % (i+1)
        o.section = sec
        o.save()

# ============
# = students =
# ============
log("Deleting students...")
for s in Student.objects.all():
    s.delete()

stu = [
    ['John','Doe','john.doe@email.edu','BS CS',[]],
    ['Jane','Doe','jane.doe@email.edu','BS CS',['Programming Principles I','Calculus I','Calculus II','Calculus III','American Government and Organization']]
]
    
log("Adding students...")
for u in stu:
    s = Student()
    s.first_name = u[0]
    s.last_name = u[1]
    s.email = u[2]
    s.degree_plan = Degree.objects.get(name=u[3])
    s.save()
    for c in u[4]:
        s.taken.add(Course.objects.get(name=c))
    s.save()
    
# =============
# = schedules =
# =============
log("Clearing schedules...")
for s in Schedule.objects.all():
    s.delete()