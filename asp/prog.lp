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
    
missing_preq(S,C) :-
    student(S),
    course(C),
    course(C1),
    preq(C1,C),
    not taken(S,C1).
    
missing_creq(S,C) :-
    student(S),
    course(C),
    course(C1),
    creq(C,C1),
    register(S,O),
    offer_course(O,C),
    not register(S,O1),
    offer_course(O1,C1).

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
    
ineligible(S,O) :-
    offering(O),
    offer_course(O,C),
    student(S),
    missing_preq(S,C).
    
ineligible(S,O) :-
    offering(O),
    offer_course(O,C),
    student(S),
    taken(S,C).
    
ineligible(S,O) :-
    offering(O),
    student(S),
    offer_course(O,C),
    missing_creq(S,C).

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

registered(S,O,C,E,M) :-
    register(S,O),
    student(S),
    offering(O),
    offer_course(O,C),
    offer_section(O,E),
    offer_pd(O,M).

:- invalid.

invalid :-
    register(S,O1),
    register(S,O2),
    conflict(O1,O2).

invalid :-
    ineligible(S,O),
    register(S,O).

total_hours(H) :-
    H = [ register(S,O) : may_register(S,O) : offer_course(O,C) : course_hours(C,H2) = H2 ].

:- total_hours(H), H > hmax.
:- total_hours(H), H < hmin.