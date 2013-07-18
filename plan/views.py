import os
from plan import *
from plan.forms import *
from django.shortcuts import render_to_response
from django.http import HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.views import logout_then_login, login
from django.contrib.auth.decorators import login_required, user_passes_test
from django.template import RequestContext

def log(msg):
    from datetime import datetime    
    f = open("log.log","a")
    msg = "%s\t%s\n" % (datetime.now(),msg)
    f.write(msg)
    f.close()

def index(request):
    return render_to_response('index.html', {
        'PAGE_TITLE' : 'welcome',
    })

def form(request,otype,title):
    if request.method == 'POST':
        form = otype(request.POST)
        if form.is_valid():
            form.save()
    else:
        form = otype()

    items = otype.Meta.model.objects.all()
    return render_to_response('form.html', {
        'PAGE_TITLE' : title,
        'form' : form,
        'items' : items,
    })

def form_department(request):
    return form(request,DepartmentForm,'Department')

def form_attribute(request):
    return form(request,AttributeForm,'Attribute')

def form_degree(request):
    return form(request,DegreeForm,'Degree')

def form_course(request):
    return form(request,CourseForm,'Course')

def form_period_day(request):
    return form(request,PeriodDayForm,'Period Day')

def form_period(request):
    return form(request,PeriodForm,'Period')

def form_offering(request):
    return form(request,OfferingForm,'Offering')

def form_student(request):
    return form(request,StudentForm,'Student')

def view_item(request,otype,id,template):
    item = otype.objects.get(id=id)
    return render_to_response(template, {
        'PAGE_TITLE' : str(item),
        'item' : item,
    })

def department(request,id):
    return view_item(request,Department,id,'view_department.html')

def attribute(request,id):
    return view_item(request,Attribute,id,'view_attribute.html')

def degree(request,id):
    return view_item(request,Degree,id,'view_degree.html')

def course(request,id):
    return view_item(request,Course,id,'view_course.html')

def period_day(request,id):
    return view_item(request,PeriodDay,id,'view_period_day.html')

def period(request,id):
    return view_item(request,Period,id,'view_period.html')

def offering(request,id):
    return view_item(request,Offering,id,'view_offering.html')

def student(request,id):
    return view_item(request,Student,id,'view_student.html')

def asp(request):
    hmin = 3
    hmax = 21
    try:
        hmin = request.GET['hmin']
        hmax = request.GET['hmax']
    except:
        pass
    depts = Department.objects.all().order_by('id')
    attrs = Attribute.objects.all().order_by('id')
    courses = Course.objects.all().order_by('id')
    degrees = Degree.objects.all().order_by('id')
    periods = Period.objects.all().order_by('id')
    offerings = Offering.objects.all().order_by('id')
    students = Student.objects.all().order_by('id')
    return render_to_response('asp.html', {
        'PAGE_TITLE' : 'ASP Atoms',
        'depts' : depts,
        'attrs' : attrs,
        'courses' : courses,
        'degrees' : degrees,
        'periods' : periods,
        'offerings' : offerings,
        'students' : students,
        'hmin' : hmin,
        'hmax' : hmax,
    })
    
def write_asp(request,s,min,max):
    from django.http import HttpResponse
    
    OFILE = 'asp/.tmp/asp'
    RESULTS = 'asp/.tmp/results'
    
    os.system('rm' + RESULTS)
    
    student = Student.objects.get(id=s)
    f = open(OFILE,'a')    
    f.write('#hide.\n#show registered/5, total_hours/1.\n')
    f.write('#const hmin = %s.  %% min hours\n#const hmax = %s. %% max hours\n' % (min,max))    
    os.system('cat asp/prog.lp > ' + OFILE)
    f.write('\n\n')
    for d in Department.objects.all():
        f.write(d.asp())
    for a in Attribute.objects.all():
        f.write(a.asp())
    for c in Course.objects.all():
        f.write(c.asp())
    for g in Degree.objects.all():
        f.write(g.asp())
    for p in Period.objects.all():
        f.write(p.asp())
    for o in Offering.objects.all():
        f.write(o.asp())
    f.write(student.asp())
    f.close()
    
    os.system('gringo ' + OFILE + '| clasp --asp09 -n0 1>' + RESULTS + ' ; ./test_shell.py parse_asp &')
        
    return HttpResponseRedirect('/schedules/%d/1' % int(s))


def view_status(request):
    return render_to_response('view_status.html')

def status(request):
    from django.http import HttpResponse
    try:
        f = open('log.log','rx')
        s = f.read()
        f.close()
        return HttpResponse(s,mimetype='text/plain')
    except:
        return HttpResponse('Log not found.',mimetype='text/plain')

def results(request):
    schedules = Schedule.objects.all()
    return render_to_response('results.html', {
        'PAGE_TITLE' : 'Results',
        'schedules' : schedules,
    })

def results_paged(request,s,p):
    RESULTS_PER_PAGE = 50
    
    stu = Student.objects.get(id=s)
    schedules = Schedule.objects.get(student=stu)
    total = schedules.offerings.count()
    start = (int(p)-1)*RESULTS_PER_PAGE
    end = int(p)*RESULTS_PER_PAGE
    scheds = list(schedules)[start:end]
    start += 1
    msg = "Viewing results %d through " % start
    if end > total:
        msg += str(total)
    else:
        msg += str(end)
    msg += " of %d." % total
    
    maxpage = total/RESULTS_PER_PAGE
    if total % RESULTS_PER_PAGE > 0:
        maxpage += 1
    
    pages = range(1,maxpage + 1)
    
    return render_to_response('results_paged.html', {
        'PAGE_TITLE' : 'Results',
        'schedules' : scheds,
        'student' : stu,
        'start' : start,
        'end' : end,
        'total' : total,
        'msg' : msg,
        'pages' : pages,
        's' : s,
        'p' : p,
    })

def schedule(request,s,p):
    RPP = 50
    student = Student.objects.get(id=s)
    scheds = Schedule.objects.filter(student=student)
    total = len(scheds)
    
    start = (int(p)-1)*RPP
    end = int(p)*RPP
    scheds = scheds[start:end]
    start += 1
    msg = "Viewing results %d through " % start
    if end > total:
        msg += str(total)
    else:
        msg += str(end)
    
    maxpage = total / RPP 
    if total % RPP > 0:
        maxpage += 1
    
    pages = range(1,maxpage + 1)
    
    return render_to_response('schedules.html', {
        'PAGE_TITLE' : 'Schedules',
        'student' : student,
        'scheds' : scheds,
        'total' : total,
        'start' : start,
        'end' : end,
        'pages' : pages,
        'msg' : msg,
        'p' : int(p),
        's' : int(s),
    })

def plan(request):
    if request.method == "POST":
        student = request.POST['student']
        hmin = request.POST['hmin']
        hmax = request.POST['hmax']
        return write_asp(request,student,hmin,hmax)
        
    return render_to_response('plan.html', {
        'students' : Student.objects.all(),
    })

def calendar(request,s):
    sched = Schedule.objects.get(id=s)
    days = PeriodDay.objects.all()[0:5]
    hours = []
    for i in range(8,24):
        hours.append("%s:00" % i)
        hours.append("%s:30" % i)
    
    return render_to_response('calendar.html', {
        'PAGE_TITLE' : 'Calendar',
        'sched' : sched,
        'hours' : hours,
        'days' : days,
    })

def num_schedules(request):
    from django.http import HttpResponse
    return HttpResponse(Schedule.objects.count(),mimetype='text/plain')