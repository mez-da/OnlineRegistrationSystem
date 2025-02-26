-- Create Database
CREATE DATABASE IF NOT EXISTS Online_Registration_System;
USE Online_Registration_System;

-- Create Department Table
DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    Department_id CHAR(4) PRIMARY KEY,
    Department_name VARCHAR(25) NOT NULL
);
INSERT INTO Department (Department_id, Department_name)
VALUES 
    ('1000', 'School of Business'),
    ('2000', 'School of Arts');

-- Create Instructor Table
DROP TABLE IF EXISTS Instructor;
CREATE TABLE Instructor (
    Instructor_id CHAR(10) PRIMARY KEY,
    Instructor_first_name VARCHAR(15) NOT NULL,
    Instructor_last_name VARCHAR(15) NOT NULL,
    Department_id CHAR(4) NOT NULL,
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id) ON DELETE CASCADE
);
INSERT INTO Instructor (Instructor_id, Instructor_first_name, Instructor_last_name, Department_id)
VALUES 
    ('INS1001', 'Elon', 'Musk', '1000'),
    ('INS1002', 'Alex', 'Ferguson', '1000'),
    ('INS2001', 'Halle', 'Berry', '1000'),
    ('INS3001', 'Jay', 'Z', '2000'),
    ('INS5001', 'Michael', 'Jackson', '2000'),
    ('INS6001', 'Jack', 'Sparrow', '2000'); 

-- Create Course Table
DROP TABLE IF EXISTS Course;
CREATE TABLE Course (
    Course_id CHAR(8) PRIMARY KEY,
    Department_id CHAR(4) NOT NULL,
    Course_name VARCHAR(50) NOT NULL,
    Credit_Hours INTEGER NOT NULL,
    Course_Type CHAR(1) NOT NULL CHECK (Course_Type IN ('C', 'E')),  
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
);
INSERT INTO Course (Course_id, Department_id, Course_name, Credit_Hours, Course_Type)
VALUES 
    ('INFO370', '1000', 'Data Communication 370', 4, 'C'),
    ('MGMT302', '1000', 'Management 302', 3, 'C'),
    ('CINE222', '2000', 'Cinema 222', 1, 'E'),
    ('ACCT360', '1000', 'Accounting 360', 4, 'C'),
    ('DANC235', '2000', 'Dance and Choreography', 3, 'E'),
    ('FASH319', '2000', 'Fashion Design', 3, 'E'),
    ('INFO463', '1000', 'Advanced Data Communication', 3, 'C'),
    ('SPCH320', '2000', 'Public Speaking Techniques', 3, 'E');

-- Create Prerequisites Table
DROP TABLE IF EXISTS Prerequisites;
CREATE TABLE Prerequisites (
    Course_id CHAR(8) NOT NULL,
    Prereq_course_id CHAR(8) NOT NULL,
    PRIMARY KEY (Course_id, Prereq_course_id),
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id) ON DELETE CASCADE,
    FOREIGN KEY (Prereq_course_id) REFERENCES Course(Course_id) ON DELETE CASCADE
);
INSERT INTO Prerequisites (Course_id, Prereq_course_id)
VALUES 
    ('INFO370', 'INFO463'),
    ('CINE222', 'SPCH320');

-- Create Course_session Table
DROP TABLE IF EXISTS Course_session;
CREATE TABLE Course_session (
    Course_id CHAR(8) NOT NULL,
    Section_id CHAR(3) NOT NULL,
    Instructor_id CHAR(10) NULL,
    Modality_flag CHAR(1) NOT NULL CHECK (Modality_flag IN ('I', 'O', 'H')), 
    Max_students INTEGER NOT NULL CHECK (Max_students > 0),
    PRIMARY KEY (Course_id, Section_id),
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_id) REFERENCES Instructor(Instructor_id) ON DELETE SET NULL
);
INSERT INTO Course_session (Course_id, Section_id, Instructor_id, Modality_flag, Max_students)
VALUES 
    ('INFO370', '001', 'INS1001', 'I', 30),
    ('MGMT302', '001', 'INS2001', 'H', 40), -- H = Hybrid
    ('CINE222', '001', 'INS3001', 'I', 20), -- I = InPerson
    ('ACCT360', '001', 'INS4001', 'O', 35), -- O = online
    ('DANC235', '001', 'INS5001', 'I', 15),
    ('FASH319', '001', 'INS6001', 'H', 25);

-- Create Student Table
DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
    Student_id CHAR(9) PRIMARY KEY,
    Student_first_name VARCHAR(15) NOT NULL,
    Student_last_name VARCHAR(15) NOT NULL,
    Student_country CHAR(5) NOT NULL,
    Student_resident_flag CHAR(1) NOT NULL CHECK (Student_resident_flag IN ('Y', 'N'))
);
INSERT INTO Student (Student_id, Student_first_name, Student_last_name, Student_country, Student_resident_flag)
VALUES 
    ('STU10001', 'Michael', 'Scott', 'USA', 'Y'),
    ('STU10002', 'Walter', 'Squarepants', 'PAC', 'N'),
    ('STU10003', 'Drake', 'Graham', 'CAN', 'Y'),
    ('STU10004', 'Gordon', 'Ramsay', 'UK', 'N'),
    ('STU10005', 'Homer', 'Simpson', 'USA', 'Y');

-- Create Enrollment Table
DROP TABLE IF EXISTS Enrollment;
CREATE TABLE Enrollment (
    Course_id CHAR(8) NOT NULL,
    Section_id CHAR(3) NOT NULL,
    Student_id CHAR(9) NOT NULL,
    PRIMARY KEY (Course_id, Section_id, Student_id),
    FOREIGN KEY (Course_id, Section_id) REFERENCES Course_session(Course_id, Section_id) ON DELETE CASCADE,
    FOREIGN KEY (Student_id) REFERENCES Student(Student_id) ON DELETE CASCADE
);
INSERT INTO Enrollment (Course_id, Section_id, Student_id)
VALUES 
    ('INFO370', '001', 'STU10001'),
    ('MGMT302', '001', 'STU10003'),
    ('CINE222', '001', 'STU10004'),
    ('ACCT360', '001', 'STU10005'),
    ('FASH319', '001', 'STU10002');  


