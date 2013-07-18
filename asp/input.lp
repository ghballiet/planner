% ==========================================
% PROGRAM INPUT
% ==========================================

% departments
dept(cs).         % computer science
dept(math).       % mathematics
dept(pols).       % political science
dept(engl).       % english
dept(chem).       % chemistry

% attributes
attr(polsa).      % political science
attr(ushist).     % us history
attr(human).      % humanities
attr(vpa).        % visual/performing arts
attr(igb).        % individual and group behavior
attr(sci).        % science

% hour contraints
#const hmin = 3.  % min hours
#const hmax = 21. % max hours

% courses
%     cs1411
course(cs1411).
in_dept(cs1411,cs).
course_hours(cs1411,4).

%     cs1412
course(cs1412).
in_dept(cs1412,cs).
course_hours(cs1412,4).
preq(cs1411,cs1412).

%     engl1301
course(engl1301).
in_dept(engl1301,engl).
course_hours(engl1301,3).

%     engl1302
course(engl1302).
in_dept(engl1302,engl).
course_hours(engl1302,3).
preq(engl1301,engl1302).

%     math1351
course(math1351).
in_dept(math1351,math).
course_hours(math1351,3).

%     math1352
course(math1352).
in_dept(math1352,math).
course_hours(math1352,3).
preq(math1351,math1352).

%     pols1301
course(pols1301).
in_dept(pols1301,pols).
course_hours(pols1301,3).
meets(pols1301,polsa).

%     pols1302
course(pols1302).
in_dept(pols1302,pols).
course_hours(pols1302,3).
meets(pols1302,polsa).
preq(pols1301,pols1302).

%     chem1301
course(chem1301).
in_dept(chem1301,chem).
course_hours(chem1301,3).
meets(chem1301,sci).
creq(chem1301,chem1107).

%     chem1107
course(chem1107).
in_dept(chem1107,chem).
course_hours(chem1107,1).
meets(chem1107,sci).
creq(chem1107,chem1301).

% degree plans
%     bs in cs
degree(bscs).
deg_in_dept(bscs,cs).
deg_req(bscs,cs1411).
deg_req(bscs,cs1412).
deg_req(bscs,engl1301).
deg_req(bscs,engl1302).
deg_req(bscs,math1351).
deg_req(bscs,math1352).
deg_attr_req(bscs,polsa,6).
deg_attr_req(bscs,sci,4).

% periods
period(p1).
starts(p1,800).
ends(p1,850).
day(p1,1).
day(p1,3).
day(p1,5).

period(p2).
starts(p2,900).
ends(p2,950).
day(p2,1).
day(p2,3).
day(p2,5).

period(p3).
starts(p3,1000).
ends(p3,1050).
day(p3,1).
day(p3,3).
day(p3,5).

period(p4).
starts(p4,1100).
ends(p4,1150).
day(p4,1).
day(p4,3).
day(p4,5).

period(p5).
starts(p5,1200).
ends(p5,1250).
day(p5,1).
day(p5,3).
day(p5,5).

period(p6).
starts(p6,1300).
ends(p6,1350).
day(p6,1).
day(p6,3).
day(p6,5).

period(p7).
starts(p7,800).
ends(p7,920).
day(p7,2).
day(p7,4).

% offerings
offering(o1).
offer_course(o1,cs1411).
offer_section(o1,1).
offer_pd(o1,p1).

offering(o2).
offer_course(o2,cs1411).
offer_section(o2,2).
offer_pd(o2,p3).

offering(o3).
offer_course(o3,cs1412).
offer_section(o3,1).
offer_pd(o3,p2).

offering(o4).
offer_course(o4,pols1301).
offer_section(o4,1).
offer_pd(o4,p1).

offering(o5).
offer_course(o5,pols1301).
offer_section(o5,2).
offer_pd(o5,p5).

offering(o6).
offer_course(o6,math1351).
offer_section(o6,1).
offer_pd(o6,p6).

offering(o7).
offer_course(o7,engl1302).
offer_section(o7,1).
offer_pd(o7,p7).

offering(o8).
offer_course(o8,pols1302).
offer_section(o8,1).
offer_pd(o8,p2).

offering(o9).
offer_course(o9,chem1301).
offer_section(o9,1).
offer_pd(o9,p5).

offering(o10).
offer_course(o10,chem1107).
offer_section(o10,1).
offer_pd(o10,p6).

% ==========================================
% EXAMPLES
% ==========================================

% Example: John is a new student in the CS
% department. He has never taken any courses
% before. 

student(john).
student_deg(john,bscs).

% Example: Mary is a returning CS student.
% She has taken a few courses.

student(mary).
student_deg(mary,bscs).
taken(mary,cs1411).
taken(mary,pols1301).
taken(mary,engl1301).
taken(mary,math1351).

selected(mary).

#hide.
#show total_hours/1, registered/4, missing_creq/2.