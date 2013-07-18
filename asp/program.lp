% ==========================================
% PROGRAM INPUT
% ==========================================

% departments
dept(cs).         % computer science
dept(math).       % mathematics
dept(pols).       % political science
dept(engl).       % english

% attributes
attr(polsa).      % political science
attr(ushist).     % us history
attr(human).      % humanities
attr(vpa).        % visual/performing arts
attr(igb).        % individual and group behavior

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
#show total_hours/1, registered/4.

% ==========================================
% BEGIN PROGRAM
% ==========================================

hours(C,H) :- 
    course(C),
    course_hours(C,H).

hours(O,H) :-
    offering(O),
    offer_course(O,C),
    course_hours(C,H).

attr_hrs_met(S,A,H) :-
    H = [ taken(S,C) : meets(C,A) : hours(C,H2) = H2 ],
    student(S), attr(A).

attr_hrs_req(S,A,H) :-
    H = [ student_deg(S,D) : deg_attr_req(D,A,H2) = H2 ],
    student(S), attr(A), H > 0.

attr_hrs_missing(S,A,H) :- 
    attr_hrs_met(S,A,H2),
    attr_hrs_req(S,A,H1),
    student(S),
    degree(D),
    student_deg(S,D),
    H1 > H2,
    H = H1 - H2,
    H > 0.

course_meets_req(S,C) :-
    student(S),
    student_deg(S,D),
    course(C),
    deg_req(D,C),
    not taken(S,C).

course_meets_attrs(S,C) :- 
    student(S),
    course(C),
    attr(A),
    attr_hrs_missing(S,A,H),
    meets(C,A).

overlaps(M1,M2) :- 
    period(M1),
    period(M2),
    day(M1,Y),
    day(M2,Y),
    M1 != M2.

not_overlaps(M1,M2) :-
    overlaps(M1,M2),
    starts(M1,T1),
    ends(M1,T2),
    starts(M2,T3),
    ends(M2,T4),
    T1 > T4.

not_overlaps(M1,M2) :-
    overlaps(M1,M2),
    starts(M1,T1),
    ends(M1,T2),
    starts(M2,T3),
    ends(M2,T4),
    T3 > T2.

not_overlaps(M1,M2) :-
    not overlaps(M1,M2),
    period(M1),
    period(M2),
    M1 != M2.

conflict(O1,O2) :-
    offering(O1),
    offering(O2),
    O1 != O2,
    offer_pd(O1,M1),
    offer_pd(O2,M2),
    not not_overlaps(M1,M2).

conflict(O1,O2) :-
    offering(O1),
    offering(O2),
    O1 != O2,
    offer_course(O1,C),
    offer_course(O2,C).

may_register(S,O) :- 
    selected(S),
    student(S),
    offering(O),
    offer_course(O,C),
    course(C),
    course_meets_req(S,C).

may_register(S,O) :-
    selected(S),
    student(S),
    offering(O),
    offer_course(O,C),
    course(C),
    not course_meets_req(S,C),
    course_meets_attrs(S,C).

1 { register(S,O) : may_register(S,O) }.

registered(S,C,E,M) :-
    register(S,O),
    student(S),
    offering(O),
    offer_course(O,C),
    offer_section(O,E),
    offer_pd(O,M).

:- conflict. 
conflict :-
    register(S,O1),
    register(S,O2),
    conflict(O1,O2).

total_hours(H) :-
    H = [ register(S,O) : may_register(S,O) : hours(O,H2) = H2 ].

:- total_hours(H), H > hmax.
:- total_hours(H), H < hmin.