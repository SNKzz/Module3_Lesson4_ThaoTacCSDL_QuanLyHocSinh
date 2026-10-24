create database manageStudents;

use manageStudents;
-- drop database manageStudents;

create table classes (
id int not null primary key auto_increment,
class char(10) not null,
teacher varchar(255) not null
);

create table students (
id int not null primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
gender tinyint not null comment '1-Male _ 0-Female _ ',
date_of_birth date not null,
id_class int not null,
notes text null,

foreign key (id_class) references classes(id)
);


create table scores (
id int not null primary key auto_increment,
id_student int not null, 
math_score float(3,1) not null default 0,
physic_score float(3,1) not null default 0,
chemistry_score float(3,1) not null default 0,
literature_score float(3,1) not null default 0,
average_score float(3,1) not null default 0,
classify varchar(20) not null,

foreign key (id_student) references students(id)
);


-- ========================== INSERT DATA INTO TABLES =========================
-- ===========================================
-- 1. INSERT classes - 9 classes - Execute queries in file data_students
-- ===========================================


-- ===========================================
-- 2. INSERT students - 28 stuidents / class (Total: 252 students) - Execute queries in file data_students
-- ===========================================


-- ===========================================
-- 3. INSERT score -  252 records - Execute queries in file data_scores
-- ===========================================


-- ========================== PRACTICE QUERY ==============================


-- 1. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), ngày sinh.
select id, concat(last_name, ' ', first_name) as full_name, date_of_birth from students;

-- 2. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), sinh ngày 20
select id, concat(last_name, ' ', first_name) as full_name, date_of_birth from students 
where substring(date_of_birth,9, 2) like '%20%';

-- 3. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), ngày sinh là 6/9/1999
select id, concat(last_name, ' ' , first_name) as full_name, date_of_birth from students
where date_of_birth like '%1999-09-06%';

-- 4. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), tên là NA
select id, concat(last_name, ' ' , first_name) as full_name from students 
where upper(first_name) like '%NA%';

-- 5. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), tên bắt đầu bằng chữ N
select id, concat(last_name, ' ', first_name) as full_name from students
where upper(substring(first_name, 1, 1)) like '%N%';

-- 6. Hiện danh sách sinh viên: mã hs, họ và tên (là 1 cột), trong tên có NA
select id, concat(last_name, ' ', first_name) as full_name from students
where lower(first_name) like lower('%NA%');

-- 7. Đếm số sinh viên tên bắt đầu bằng chữ N
select count(*) as total_students_having_name_start_N from students 
where upper(substring(first_name, 1, 1)) like '%N%';

-- 8. Hiện danh sách sinh viên: họ và tên (là 1 cột), ngày sinh, tên lớp, tên GVCN
select concat(students.last_name, ' ' , students.first_name) as full_name, 
students.date_of_birth as dob, 
classes.class, 
classes.teacher 
from students
join classes
on classes.id = students.id_class;

-- 9. Hiện danh sách sinh viên: họ và tên (là 1 cột), ngày sinh, điểm trung bình, xếp loại
select concat(students.last_name, ' ', students.first_name) as full_name, 
students.date_of_birth, 
scores.average_score, 
scores.classify
from students
join scores
on students.id = scores.id_student;

-- 10. Đếm số học sinh của mỗi lớp
select classes.class as name_class, 
count(*) as quantiy_students 
from classes
join students
on classes.id = students.id_class
group by classes.class;

-- 11. Hiện ra lớp có số lượng sinh viên > 5
select classes.class as name_class, 
count(*) as quantity_students 
from classes
join students 
on classes.id = students.id_class
group by classes.id having count(*) > 5;

-- 12. Hiện thông lớp có số lượng sinh viên nhiều nhất
-- Cách 1: sử dụng limit đi kèm order by
select classes.class as name_class, 
count(*) as max_quantity_students 
from classes
join students 
on classes.id = students.id_class
group by classes.id
order by quantity_students asc
limit 1;

-- Cách 2: sử dụng subquery (nested-queries) với max() (trường hợp có các records cùng max)

select classes.class as name_class,
count(*) as max_quantity_students 
from classes
join students
on classes.id = students.id_class
group by classes.id 
having max_quantity_students = (
select max(students_count) 
from (
select count(*) as students_count from classes join students on students.id_class = classes.id group by classes.id
) as tmp_quantity_students
);

-- 13. Tìm học sinh có điểm lớn nhất
select concat(students.last_name, ' ', students.first_name) as full_name, 
scores.average_score as max_average_score 
from students
join scores
on scores.id_student = students.id
having max_average_score = (
select max(avg_score) from (
select scores.id_student as id_student, scores.average_score as avg_score from scores
) as tmp_student_avg_score
);

-- 14. Hiện ra danh sách các học sinh có điểm tb > 8
select students.id as id_student, 
concat(students.last_name, ' ', students.first_name) as full_name, 
classes.class as class, 
students.gender as gender, 
students.date_of_birth as dob, 
scores.average_score as avg_score 
from students
join scores on scores.id_student = students.id
join classes on classes.id = students.id_class
having avg_score > 8
order by avg_score asc; 

-- 15. Tổng điểm tb của các bạn có tên bắt đầu bằng chữ NA

select students.first_name as names_student_na, scores.average_score as avg_scores from students 
join scores on scores.id_student = students.id
having upper(students.first_name) like '%NA%';

select sum(avg_scores) from (
select students.first_name as names_student_na, scores.average_score as avg_scores from students 
join scores on scores.id_student = students.id
having upper(students.first_name) like '%NA%'
) as tmp_avg_score_na;

-- 16. Hiện ra danh sách các học sinh có điểm tb > 5 và điểm toán > 8
select students.id as id_students,
concat(students.last_name, ' ', students.first_name) as full_name, 
classes.class as class,
students.gender as gender,	
students.date_of_birth as dob,
scores.math_score as math_score,
scores.average_score as avg_score 
from students 
join classes on classes.id = students.id_class
join scores on scores.id_student = students.id
having math_score > 8 and avg_score > 5
order by avg_score asc;

-- 17. Hiện ra danh sách các học sinh có xếp loại là giỏi

select * from scores;
select students.id as id_students,
concat(students.last_name, ' ', students.first_name) as full_name, 
classes.class as class,
students.gender as gender,
students.date_of_birth as dob,
scores.average_score as avg_score,
scores.classify as classify

from students
join classes on classes.id = students.id_class
join scores on scores.id_student = students.id
where upper(scores.classify) like upper('%Giỏi%')
order by avg_score asc;


-- 18. Đếm số lượng học sinh giỏi
select count(*) as sum_good_students from scores 
where upper(classify) like upper('%Giỏi%');


-- 19. Đếm số lượng học sinh giỏi của từng lớp
select classes.class as class, count(*) as total_good_students from students 
join scores on scores.id_student = students.id
join classes on students.id_class = classes.id

where upper(scores.classify) like upper('%Giỏi%')
group by classes.id;

-- 20. In ra các học sinh chưa tham gia thi
select students.id as id_student, 
concat(students.last_name, ' ', students.first_name) as full_name, 
classes.class as class,
students.gender as gender,
students.date_of_birth as dob,
scores.classify as status

from students
join classes on classes.id = students.id_class
join scores on scores.id_student = students.id

where upper(scores.classify) like upper('%Chưa thi%');

-- 21. In ra học sinh có điểm trung bình lớn nhất của từng lớp
select classes.class as class,
students.id as id_student,
concat(last_name, ' ', first_name) as full_name,
students.date_of_birth as dob,
scores.average_score as max_avg_score
from students

join classes on classes.id = students.id_class
join scores on scores.id_student = students.id

join (
select students.id_class as id_class,
max(scores.average_score) as max_avg
from students
join scores 
on scores.id_student = students.id
group by students.id_class
) as tmp_max_avg_per_class 
on tmp_max_avg_per_class.id_class = students.id_class and scores.average_score = tmp_max_avg_per_class.max_avg

-- where scores.average_score = (
-- select max(scores.average_score) from students
-- join scores on scores.id_student = students.id

-- where classes.id = students.id_class
-- )
order by classes.class



