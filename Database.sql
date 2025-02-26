-- Create Database
CREATE DATABASE IF NOT EXISTS Online_Registration_System;
USE Online_Registration_System;

-- Create Department Table
CREATE TABLE Department (
    Department_id CHAR(4) PRIMARY KEY,
    Department_name VARCHAR(25) NOT NULL
);
INSERT INTO Department (Department_id, Department_name)
VALUES 
    ('1000', 'School of Business'),
    ('2000', 'School of Arts');

-- Create Instructor Table
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
    ('INS1002', 'Michelle', 'Obama', '1000'),
    ('INS2001', 'Halle', 'Berry', '1000'),
    ('INS3001', 'Oprah', 'Winfrey', '2000'),
    ('INS4001', 'Barack', 'Obama', '2000'),
    ('INS5001', 'Beyoncé', 'Knowles', '2000');

-- Create Course Table
CREATE TABLE Course (
    Course_id CHAR(8) PRIMARY KEY,
    Department_id CHAR(4) NOT NULL,
    Course_name VARCHAR(50) NOT NULL,  -- Increased size to avoid truncation
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
CREATE TABLE Course_session (
    Course_id CHAR(8) NOT NULL,
    Section_id CHAR(3) NOT NULL,
    Instructor_id CHAR(10) NULL, -- Changed to allow NULL for ON DELETE SET NULL
    Modality_flag CHAR(1) NOT NULL CHECK (Modality_flag IN ('I', 'O', 'H')), 
    Max_students INTEGER NOT NULL CHECK (Max_students > 0),
    PRIMARY KEY (Course_id, Section_id),
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id) ON DELETE CASCADE,
    FOREIGN KEY (Instructor_id) REFERENCES Instructor(Instructor_id) ON DELETE SET NULL
);
INSERT INTO Course_session (Course_id, Section_id, Instructor_id, Modality_flag, Max_students)
VALUES 
    ('INFO370', '001', 'INS1001', 'I', 30),
    ('MGMT302', '001', 'INS2001', 'H', 40),
    ('CINE222', '001', 'INS3001', 'I', 20),
    ('ACCT360', '001', 'INS4001', 'O', 35),
    ('DANC235', '001', 'INS5001', 'I', 15),
    ('FASH319', '001', 'INS1002', 'H', 25);

-- Create Student Table
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
    ('STU10002', 'Serena', 'Williams', 'USA', 'N'),
    ('STU10003', 'Drake', 'Graham', 'CAN', 'Y'),
    ('STU10004', 'Rihanna', 'Fenty', 'BRB', 'N'),
    ('STU10005', 'Homer', 'Simpson', 'USA', 'Y'),
    ('STU10006', 'Zendaya', 'Coleman', 'USA', 'Y'),
    ('STU10007', 'LeBron', 'James', 'USA', 'Y'),
    ('STU10008', 'Dwayne', 'Johnson', 'USA', 'N'),
    ('STU10009', 'Beyoncé', 'Knowles', 'USA', 'Y'),
    ('STU10010', 'Nicki', 'Minaj', 'USA', 'Y');

-- Create Enrollment Table
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
    ('MGMT302', '001', 'STU10001'), -- Michael Scott in 2 classes
    ('CINE222', '001', 'STU10003'),
    ('ACCT360', '001', 'STU10004'),
    ('DANC235', '001', 'STU10005'),
    ('FASH319', '001', 'STU10002'),
    ('INFO370', '001', 'STU10006'),
    ('MGMT302', '001', 'STU10007'),
    ('CINE222', '001', 'STU10008'),
    ('ACCT360', '001', 'STU10009'),
    ('DANC235', '001', 'STU10010');
