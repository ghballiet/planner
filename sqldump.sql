BEGIN TRANSACTION;
CREATE TABLE "plan_attribute" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(500) NOT NULL
);
INSERT INTO "plan_attribute" VALUES(1,'Political Science');
INSERT INTO "plan_attribute" VALUES(2,'U.S. History');
INSERT INTO "plan_attribute" VALUES(3,'Humanities');
INSERT INTO "plan_attribute" VALUES(4,'Visual and Performing Arts');
INSERT INTO "plan_attribute" VALUES(5,'Individual and Group Behavior');
INSERT INTO "plan_attribute" VALUES(6,'Science');
INSERT INTO "plan_attribute" VALUES(7,'English');
INSERT INTO "plan_attribute" VALUES(8,'Technology');
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_attributerequirement" (
    "id" integer NOT NULL PRIMARY KEY,
    "attribute_id" integer NOT NULL REFERENCES "plan_attribute" ("id"),
    "hours" integer NOT NULL
);
INSERT INTO "plan_attributerequirement" VALUES(1,1,6);
INSERT INTO "plan_attributerequirement" VALUES(2,8,12);
INSERT INTO "plan_attributerequirement" VALUES(3,6,6);
CREATE INDEX "plan_attributerequirement_attribute_id" ON "plan_attributerequirement" ("attribute_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_attributerequirement_degrees" (
    "id" integer NOT NULL PRIMARY KEY,
    "attributerequirement_id" integer NOT NULL,
    "degree_id" integer NOT NULL REFERENCES "plan_degree" ("id"),
    UNIQUE ("attributerequirement_id", "degree_id")
);
INSERT INTO "plan_attributerequirement_degrees" VALUES(1,1,1);
INSERT INTO "plan_attributerequirement_degrees" VALUES(2,2,1);
INSERT INTO "plan_attributerequirement_degrees" VALUES(3,3,1);
CREATE INDEX "plan_attributerequirement_degrees_attributerequirement_id" ON "plan_attributerequirement_degrees" ("attributerequirement_id");
CREATE INDEX "plan_attributerequirement_degrees_degree_id" ON "plan_attributerequirement_degrees" ("degree_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_course" (
    "id" integer NOT NULL PRIMARY KEY,
    "department_id" integer NOT NULL REFERENCES "plan_department" ("id"),
    "number" varchar(4) NOT NULL,
    "name" varchar(100) NOT NULL,
    "hours" integer NOT NULL
);
INSERT INTO "plan_course" VALUES(1,1,'1411','Programming Principles I',4);
INSERT INTO "plan_course" VALUES(2,3,'1301','Essentials of College Rhetoric',3);
INSERT INTO "plan_course" VALUES(3,2,'1351','Calculus I',3);
INSERT INTO "plan_course" VALUES(4,4,'1301','American Government and Organization',3);
INSERT INTO "plan_course" VALUES(5,1,'1412','Programming Principles II',4);
INSERT INTO "plan_course" VALUES(6,1,'1382','Discrete Structures',3);
INSERT INTO "plan_course" VALUES(7,2,'1352','Calculus II',3);
INSERT INTO "plan_course" VALUES(8,3,'1302','Advanced College Rhetoric',3);
INSERT INTO "plan_course" VALUES(9,1,'2413','Data Structures',4);
INSERT INTO "plan_course" VALUES(10,6,'1408','Principles of Physics I',4);
INSERT INTO "plan_course" VALUES(11,2,'2350','Calculus III',3);
INSERT INTO "plan_course" VALUES(12,7,'2372','Modern Digital Systems Design',3);
INSERT INTO "plan_course" VALUES(13,1,'2350','Computer Organization and Assembly Language',3);
INSERT INTO "plan_course" VALUES(14,6,'2401','Principles of Physics II',4);
INSERT INTO "plan_course" VALUES(15,2,'2360','Linear Algebra',3);
INSERT INTO "plan_course" VALUES(16,3,'2311','Technical Writing',3);
INSERT INTO "plan_course" VALUES(17,5,'1307','Principles of Chemistry I',3);
INSERT INTO "plan_course" VALUES(18,5,'1107','Principles of Chemistry I Lab',1);
INSERT INTO "plan_course" VALUES(19,8,'1403','Biology I',4);
CREATE INDEX "plan_course_department_id" ON "plan_course" ("department_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_course_corequisites" (
    "id" integer NOT NULL PRIMARY KEY,
    "from_course_id" integer NOT NULL,
    "to_course_id" integer NOT NULL,
    UNIQUE ("from_course_id", "to_course_id")
);
INSERT INTO "plan_course_corequisites" VALUES(1,18,17);
INSERT INTO "plan_course_corequisites" VALUES(2,17,18);
CREATE INDEX "plan_course_corequisites_from_course_id" ON "plan_course_corequisites" ("from_course_id");
CREATE INDEX "plan_course_corequisites_to_course_id" ON "plan_course_corequisites" ("to_course_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_course_meets" (
    "id" integer NOT NULL PRIMARY KEY,
    "course_id" integer NOT NULL,
    "attribute_id" integer NOT NULL REFERENCES "plan_attribute" ("id"),
    UNIQUE ("course_id", "attribute_id")
);
INSERT INTO "plan_course_meets" VALUES(1,2,7);
INSERT INTO "plan_course_meets" VALUES(2,4,1);
INSERT INTO "plan_course_meets" VALUES(3,10,6);
INSERT INTO "plan_course_meets" VALUES(4,14,6);
INSERT INTO "plan_course_meets" VALUES(5,16,7);
INSERT INTO "plan_course_meets" VALUES(6,17,6);
INSERT INTO "plan_course_meets" VALUES(7,18,6);
INSERT INTO "plan_course_meets" VALUES(8,19,6);
CREATE INDEX "plan_course_meets_course_id" ON "plan_course_meets" ("course_id");
CREATE INDEX "plan_course_meets_attribute_id" ON "plan_course_meets" ("attribute_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_course_prerequisites" (
    "id" integer NOT NULL PRIMARY KEY,
    "from_course_id" integer NOT NULL,
    "to_course_id" integer NOT NULL,
    UNIQUE ("from_course_id", "to_course_id")
);
INSERT INTO "plan_course_prerequisites" VALUES(1,5,1);
INSERT INTO "plan_course_prerequisites" VALUES(2,6,1);
INSERT INTO "plan_course_prerequisites" VALUES(3,7,3);
INSERT INTO "plan_course_prerequisites" VALUES(4,8,2);
INSERT INTO "plan_course_prerequisites" VALUES(5,9,5);
INSERT INTO "plan_course_prerequisites" VALUES(6,10,3);
INSERT INTO "plan_course_prerequisites" VALUES(7,11,7);
INSERT INTO "plan_course_prerequisites" VALUES(8,12,3);
INSERT INTO "plan_course_prerequisites" VALUES(9,13,12);
INSERT INTO "plan_course_prerequisites" VALUES(10,14,10);
INSERT INTO "plan_course_prerequisites" VALUES(11,15,11);
CREATE INDEX "plan_course_prerequisites_from_course_id" ON "plan_course_prerequisites" ("from_course_id");
CREATE INDEX "plan_course_prerequisites_to_course_id" ON "plan_course_prerequisites" ("to_course_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_degree" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(500) NOT NULL,
    "description" text NOT NULL,
    "department_id" integer NOT NULL REFERENCES "plan_department" ("id")
);
INSERT INTO "plan_degree" VALUES(1,'BS CS','Bacheolor of Science in Computer Science',1);
CREATE INDEX "plan_degree_department_id" ON "plan_degree" ("department_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_degree_required_courses" (
    "id" integer NOT NULL PRIMARY KEY,
    "degree_id" integer NOT NULL,
    "course_id" integer NOT NULL,
    UNIQUE ("degree_id", "course_id")
);
INSERT INTO "plan_degree_required_courses" VALUES(1,1,1);
INSERT INTO "plan_degree_required_courses" VALUES(2,1,2);
INSERT INTO "plan_degree_required_courses" VALUES(3,1,3);
INSERT INTO "plan_degree_required_courses" VALUES(4,1,4);
INSERT INTO "plan_degree_required_courses" VALUES(5,1,5);
INSERT INTO "plan_degree_required_courses" VALUES(6,1,6);
INSERT INTO "plan_degree_required_courses" VALUES(7,1,7);
INSERT INTO "plan_degree_required_courses" VALUES(8,1,8);
INSERT INTO "plan_degree_required_courses" VALUES(9,1,9);
INSERT INTO "plan_degree_required_courses" VALUES(10,1,10);
INSERT INTO "plan_degree_required_courses" VALUES(11,1,11);
INSERT INTO "plan_degree_required_courses" VALUES(12,1,12);
INSERT INTO "plan_degree_required_courses" VALUES(13,1,13);
INSERT INTO "plan_degree_required_courses" VALUES(14,1,14);
INSERT INTO "plan_degree_required_courses" VALUES(15,1,15);
INSERT INTO "plan_degree_required_courses" VALUES(16,1,16);
CREATE INDEX "plan_degree_required_courses_degree_id" ON "plan_degree_required_courses" ("degree_id");
CREATE INDEX "plan_degree_required_courses_course_id" ON "plan_degree_required_courses" ("course_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_department" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(500) NOT NULL,
    "abbreviation" varchar(4) NOT NULL
);
INSERT INTO "plan_department" VALUES(1,'Computer Science','C S ');
INSERT INTO "plan_department" VALUES(2,'Mathematics','MATH');
INSERT INTO "plan_department" VALUES(3,'English','ENGL');
INSERT INTO "plan_department" VALUES(4,'Political Science','POLS');
INSERT INTO "plan_department" VALUES(5,'Chemistry','CHEM');
INSERT INTO "plan_department" VALUES(6,'Physics','PHYS');
INSERT INTO "plan_department" VALUES(7,'Electrical Engineering','E E ');
INSERT INTO "plan_department" VALUES(8,'Biology','BIOL');
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_offering" (
    "id" integer NOT NULL PRIMARY KEY,
    "course_id" integer NOT NULL REFERENCES "plan_course" ("id"),
    "period_id" integer NOT NULL REFERENCES "plan_period" ("id"),
    "section" varchar(3) NOT NULL
);
INSERT INTO "plan_offering" VALUES(1,19,26,'001');
INSERT INTO "plan_offering" VALUES(2,18,19,'001');
INSERT INTO "plan_offering" VALUES(3,18,9,'002');
INSERT INTO "plan_offering" VALUES(4,17,24,'001');
INSERT INTO "plan_offering" VALUES(5,17,1,'002');
INSERT INTO "plan_offering" VALUES(6,6,12,'001');
INSERT INTO "plan_offering" VALUES(7,6,26,'002');
INSERT INTO "plan_offering" VALUES(8,6,7,'003');
INSERT INTO "plan_offering" VALUES(9,1,10,'001');
INSERT INTO "plan_offering" VALUES(10,1,18,'002');
INSERT INTO "plan_offering" VALUES(11,1,20,'003');
INSERT INTO "plan_offering" VALUES(12,5,8,'001');
INSERT INTO "plan_offering" VALUES(13,5,14,'002');
INSERT INTO "plan_offering" VALUES(14,5,17,'003');
INSERT INTO "plan_offering" VALUES(15,13,2,'001');
INSERT INTO "plan_offering" VALUES(16,9,8,'001');
INSERT INTO "plan_offering" VALUES(17,12,10,'001');
INSERT INTO "plan_offering" VALUES(18,2,6,'001');
INSERT INTO "plan_offering" VALUES(19,2,23,'002');
INSERT INTO "plan_offering" VALUES(20,8,22,'001');
INSERT INTO "plan_offering" VALUES(21,8,18,'002');
INSERT INTO "plan_offering" VALUES(22,8,17,'003');
INSERT INTO "plan_offering" VALUES(23,16,13,'001');
INSERT INTO "plan_offering" VALUES(24,16,5,'002');
INSERT INTO "plan_offering" VALUES(25,3,18,'001');
INSERT INTO "plan_offering" VALUES(26,3,24,'002');
INSERT INTO "plan_offering" VALUES(27,3,23,'003');
INSERT INTO "plan_offering" VALUES(28,7,3,'001');
INSERT INTO "plan_offering" VALUES(29,7,25,'002');
INSERT INTO "plan_offering" VALUES(30,11,12,'001');
INSERT INTO "plan_offering" VALUES(31,11,25,'002');
INSERT INTO "plan_offering" VALUES(32,15,7,'001');
INSERT INTO "plan_offering" VALUES(33,15,14,'002');
INSERT INTO "plan_offering" VALUES(34,10,11,'001');
INSERT INTO "plan_offering" VALUES(35,10,5,'002');
INSERT INTO "plan_offering" VALUES(36,10,26,'003');
INSERT INTO "plan_offering" VALUES(37,14,25,'001');
INSERT INTO "plan_offering" VALUES(38,4,17,'001');
CREATE INDEX "plan_offering_course_id" ON "plan_offering" ("course_id");
CREATE INDEX "plan_offering_period_id" ON "plan_offering" ("period_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_period" (
    "id" integer NOT NULL PRIMARY KEY,
    "starts" time NOT NULL,
    "ends" time NOT NULL
);
INSERT INTO "plan_period" VALUES(1,'08:00:00','08:50:00');
INSERT INTO "plan_period" VALUES(2,'08:00:00','09:20:00');
INSERT INTO "plan_period" VALUES(3,'09:00:00','09:50:00');
INSERT INTO "plan_period" VALUES(4,'09:30:00','10:50:00');
INSERT INTO "plan_period" VALUES(5,'10:00:00','10:50:00');
INSERT INTO "plan_period" VALUES(6,'11:00:00','11:50:00');
INSERT INTO "plan_period" VALUES(7,'11:00:00','12:20:00');
INSERT INTO "plan_period" VALUES(8,'12:00:00','12:50:00');
INSERT INTO "plan_period" VALUES(9,'12:30:00','13:50:00');
INSERT INTO "plan_period" VALUES(10,'13:00:00','13:50:00');
INSERT INTO "plan_period" VALUES(11,'14:00:00','14:50:00');
INSERT INTO "plan_period" VALUES(12,'14:00:00','15:20:00');
INSERT INTO "plan_period" VALUES(13,'15:00:00','15:50:00');
INSERT INTO "plan_period" VALUES(14,'15:30:00','16:50:00');
INSERT INTO "plan_period" VALUES(15,'16:00:00','16:50:00');
INSERT INTO "plan_period" VALUES(16,'17:00:00','17:50:00');
INSERT INTO "plan_period" VALUES(17,'17:00:00','18:20:00');
INSERT INTO "plan_period" VALUES(18,'18:00:00','18:50:00');
INSERT INTO "plan_period" VALUES(19,'18:30:00','19:50:00');
INSERT INTO "plan_period" VALUES(20,'19:00:00','19:50:00');
INSERT INTO "plan_period" VALUES(21,'20:00:00','20:50:00');
INSERT INTO "plan_period" VALUES(22,'20:00:00','21:20:00');
INSERT INTO "plan_period" VALUES(23,'21:00:00','21:50:00');
INSERT INTO "plan_period" VALUES(24,'21:30:00','22:50:00');
INSERT INTO "plan_period" VALUES(25,'22:00:00','22:50:00');
INSERT INTO "plan_period" VALUES(26,'23:00:00','23:50:00');
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_period_day" (
    "id" integer NOT NULL PRIMARY KEY,
    "period_id" integer NOT NULL,
    "periodday_id" integer NOT NULL REFERENCES "plan_periodday" ("id"),
    UNIQUE ("period_id", "periodday_id")
);
INSERT INTO "plan_period_day" VALUES(1,1,1);
INSERT INTO "plan_period_day" VALUES(2,1,3);
INSERT INTO "plan_period_day" VALUES(3,1,5);
INSERT INTO "plan_period_day" VALUES(4,2,2);
INSERT INTO "plan_period_day" VALUES(5,2,4);
INSERT INTO "plan_period_day" VALUES(6,3,1);
INSERT INTO "plan_period_day" VALUES(7,3,3);
INSERT INTO "plan_period_day" VALUES(8,3,5);
INSERT INTO "plan_period_day" VALUES(9,4,2);
INSERT INTO "plan_period_day" VALUES(10,4,4);
INSERT INTO "plan_period_day" VALUES(11,5,1);
INSERT INTO "plan_period_day" VALUES(12,5,3);
INSERT INTO "plan_period_day" VALUES(13,5,5);
INSERT INTO "plan_period_day" VALUES(14,6,1);
INSERT INTO "plan_period_day" VALUES(15,6,3);
INSERT INTO "plan_period_day" VALUES(16,6,5);
INSERT INTO "plan_period_day" VALUES(17,7,2);
INSERT INTO "plan_period_day" VALUES(18,7,4);
INSERT INTO "plan_period_day" VALUES(19,8,1);
INSERT INTO "plan_period_day" VALUES(20,8,3);
INSERT INTO "plan_period_day" VALUES(21,8,5);
INSERT INTO "plan_period_day" VALUES(22,9,2);
INSERT INTO "plan_period_day" VALUES(23,9,4);
INSERT INTO "plan_period_day" VALUES(24,10,1);
INSERT INTO "plan_period_day" VALUES(25,10,3);
INSERT INTO "plan_period_day" VALUES(26,10,5);
INSERT INTO "plan_period_day" VALUES(27,11,1);
INSERT INTO "plan_period_day" VALUES(28,11,3);
INSERT INTO "plan_period_day" VALUES(29,11,5);
INSERT INTO "plan_period_day" VALUES(30,12,2);
INSERT INTO "plan_period_day" VALUES(31,12,4);
INSERT INTO "plan_period_day" VALUES(32,13,1);
INSERT INTO "plan_period_day" VALUES(33,13,3);
INSERT INTO "plan_period_day" VALUES(34,13,5);
INSERT INTO "plan_period_day" VALUES(35,14,2);
INSERT INTO "plan_period_day" VALUES(36,14,4);
INSERT INTO "plan_period_day" VALUES(37,15,1);
INSERT INTO "plan_period_day" VALUES(38,15,3);
INSERT INTO "plan_period_day" VALUES(39,15,5);
INSERT INTO "plan_period_day" VALUES(40,16,1);
INSERT INTO "plan_period_day" VALUES(41,16,3);
INSERT INTO "plan_period_day" VALUES(42,16,5);
INSERT INTO "plan_period_day" VALUES(43,17,2);
INSERT INTO "plan_period_day" VALUES(44,17,4);
INSERT INTO "plan_period_day" VALUES(45,18,1);
INSERT INTO "plan_period_day" VALUES(46,18,3);
INSERT INTO "plan_period_day" VALUES(47,18,5);
INSERT INTO "plan_period_day" VALUES(48,19,2);
INSERT INTO "plan_period_day" VALUES(49,19,4);
INSERT INTO "plan_period_day" VALUES(50,20,1);
INSERT INTO "plan_period_day" VALUES(51,20,3);
INSERT INTO "plan_period_day" VALUES(52,20,5);
INSERT INTO "plan_period_day" VALUES(53,21,1);
INSERT INTO "plan_period_day" VALUES(54,21,3);
INSERT INTO "plan_period_day" VALUES(55,21,5);
INSERT INTO "plan_period_day" VALUES(56,22,2);
INSERT INTO "plan_period_day" VALUES(57,22,4);
INSERT INTO "plan_period_day" VALUES(58,23,1);
INSERT INTO "plan_period_day" VALUES(59,23,3);
INSERT INTO "plan_period_day" VALUES(60,23,5);
INSERT INTO "plan_period_day" VALUES(61,24,2);
INSERT INTO "plan_period_day" VALUES(62,24,4);
INSERT INTO "plan_period_day" VALUES(63,25,1);
INSERT INTO "plan_period_day" VALUES(64,25,3);
INSERT INTO "plan_period_day" VALUES(65,25,5);
INSERT INTO "plan_period_day" VALUES(66,26,1);
INSERT INTO "plan_period_day" VALUES(67,26,3);
INSERT INTO "plan_period_day" VALUES(68,26,5);
CREATE INDEX "plan_period_day_period_id" ON "plan_period_day" ("period_id");
CREATE INDEX "plan_period_day_periodday_id" ON "plan_period_day" ("periodday_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_periodday" (
    "id" integer NOT NULL PRIMARY KEY,
    "day" integer NOT NULL
);
INSERT INTO "plan_periodday" VALUES(1,1);
INSERT INTO "plan_periodday" VALUES(2,2);
INSERT INTO "plan_periodday" VALUES(3,3);
INSERT INTO "plan_periodday" VALUES(4,4);
INSERT INTO "plan_periodday" VALUES(5,5);
INSERT INTO "plan_periodday" VALUES(6,6);
INSERT INTO "plan_periodday" VALUES(7,7);
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_student" (
    "id" integer NOT NULL PRIMARY KEY,
    "first_name" varchar(500) NOT NULL,
    "last_name" varchar(500) NOT NULL,
    "email" varchar(250) NOT NULL,
    "degree_plan_id" integer NOT NULL REFERENCES "plan_degree" ("id")
);
INSERT INTO "plan_student" VALUES(1,'John','Doe','john.doe@email.edu',1);
INSERT INTO "plan_student" VALUES(2,'Jane','Doe','jane.doe@email.edu',1);
CREATE INDEX "plan_student_degree_plan_id" ON "plan_student" ("degree_plan_id");
COMMIT;
BEGIN TRANSACTION;
CREATE TABLE "plan_student_taken" (
    "id" integer NOT NULL PRIMARY KEY,
    "student_id" integer NOT NULL,
    "course_id" integer NOT NULL REFERENCES "plan_course" ("id"),
    UNIQUE ("student_id", "course_id")
);
INSERT INTO "plan_student_taken" VALUES(1,2,1);
INSERT INTO "plan_student_taken" VALUES(2,2,3);
INSERT INTO "plan_student_taken" VALUES(3,2,7);
INSERT INTO "plan_student_taken" VALUES(4,2,11);
INSERT INTO "plan_student_taken" VALUES(5,2,4);
CREATE INDEX "plan_student_taken_student_id" ON "plan_student_taken" ("student_id");
CREATE INDEX "plan_student_taken_course_id" ON "plan_student_taken" ("course_id");
COMMIT;
