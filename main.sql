-- 创建用户表 (User)
CREATE TABLE IF NOT EXISTS `User` (
    `user_id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建课程表 (Course)
CREATE TABLE IF NOT EXISTS `Course` (
    `course_id` INT PRIMARY KEY AUTO_INCREMENT,
    `course_name` VARCHAR(100) NOT NULL,
    `course_desc` TEXT,
    `teacher_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`teacher_id`) REFERENCES `User`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建学生课程表 (StudentCourse)
CREATE TABLE IF NOT EXISTS `StudentCourse` (
    `student_id` INT,
    `course_id` INT,
    `enrolled_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`student_id`, `course_id`),
    FOREIGN KEY (`student_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`course_id`) REFERENCES `Course`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建作业表 (Assignment)
CREATE TABLE IF NOT EXISTS `Assignment` (
    `assignment_id` INT PRIMARY KEY AUTO_INCREMENT,
    `course_id` INT,
    `title` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `due_date` DATETIME,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`course_id`) REFERENCES `Course`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建提交作业表 (Submission)
CREATE TABLE IF NOT EXISTS `Submission` (
    `submission_id` INT PRIMARY KEY AUTO_INCREMENT,
    `assignment_id` INT,
    `student_id` INT,
    `file_path` VARCHAR(255) NOT NULL,
    `submitted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `grade` FLOAT,
    `feedback` TEXT,
    FOREIGN KEY (`assignment_id`) REFERENCES `Assignment`(`assignment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`student_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建成绩表 (Grade)
CREATE TABLE IF NOT EXISTS `Grade` (
    `grade_id` INT PRIMARY KEY AUTO_INCREMENT,
    `assignment_id` INT,
    `student_id` INT,
    `score` FLOAT,
    `feedback` TEXT,
    `graded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`assignment_id`) REFERENCES `Assignment`(`assignment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`student_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建管理员操作日志表 (AdminOperationLog)
CREATE TABLE IF NOT EXISTS `AdminOperationLog` (
    `log_id` INT PRIMARY KEY AUTO_INCREMENT,
    `admin_id` INT,
    `operation` VARCHAR(255) NOT NULL,
    `target_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`admin_id`) REFERENCES `User`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 插入用户数据
INSERT INTO `User` (`username`, `password`) VALUES 
    ('teacher_john', 'password123'),       -- user_id = 1
    ('teacher_jane', 'securepass456'),     -- user_id = 2
    ('student_alice', 'alicepass789'),     -- user_id = 3
    ('student_bob', 'bobpass012'),         -- user_id = 4
    ('student_charlie', 'charliepass345'), -- user_id = 5
    ('admin_admin', 'adminpass678');       -- user_id = 6

-- 插入课程数据
INSERT INTO `Course` (`course_name`, `course_desc`, `teacher_id`) VALUES 
    ('数据库系统', '介绍关系型数据库的基本概念和设计原则。', 1), -- course_id = 1
    ('编程基础', '学习编程的基本概念和实践。', 2);               -- course_id = 2

-- 插入学生选课数据
INSERT INTO `StudentCourse` (`student_id`, `course_id`) VALUES 
    (3, 1),
    (4, 1),
    (5, 1),
    (3, 2),
    (4, 2);

-- 插入作业数据
INSERT INTO `Assignment` (`course_id`, `title`, `description`, `due_date`) VALUES 
    (1, '关系数据库设计', '设计一个关系型数据库，用于管理图书馆藏书。', '2024-12-10 23:59:59'), -- assignment_id = 1
    (1, 'SQL 查询优化', '优化给定的SQL查询，提高其执行效率。', '2024-12-20 23:59:59'),       -- assignment_id = 2
    (2, '编程作业一', '完成一个简单的计算器程序。', '2024-12-15 23:59:59');                 -- assignment_id = 3

-- 插入作业提交数据
INSERT INTO `Submission` (`assignment_id`, `student_id`, `file_path`) VALUES 
    (1, 3, '/submissions/assignment1_alice.pdf'),   -- submission_id = 1
    (1, 4, '/submissions/assignment1_bob.pdf'),     -- submission_id = 2
    (2, 3, '/submissions/assignment2_alice.pdf'),   -- submission_id = 3
    (3, 3, '/submissions/assignment3_alice.zip'),   -- submission_id = 4
    (3, 4, '/submissions/assignment3_bob.zip');     -- submission_id = 5

-- 插入成绩数据
INSERT INTO `Grade` (`assignment_id`, `student_id`, `score`, `feedback`) VALUES 
    (1, 3, 95.0, '设计合理，规范性强。'),               -- grade_id = 1
    (1, 4, 88.5, '设计良好，但有部分冗余。'),           -- grade_id = 2
    (2, 3, 92.0, '优化有效，执行速度明显提升。'),       -- grade_id = 3
    (3, 3, 85.0, '功能基本实现，但代码风格需要改进。'), -- grade_id = 4
    (3, 4, 78.5, '完成度一般，存在多个错误。');         -- grade_id = 5

-- 插入管理员操作日志数据
INSERT INTO `AdminOperationLog` (`admin_id`, `operation`, `target_id`) VALUES 
    (6, '创建新课程：机器学习', NULL),            -- log_id = 1
    (6, '删除用户：student_charlie', 5),        -- log_id = 2
    (6, '更新课程描述：数据库系统', 1);          -- log_id = 3
