CREATE TABLE Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(255),
    Account_Type ENUM('Student', 'Club_Leader', 'Admin'),
    Date_Created DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Students (
    User_ID INT PRIMARY KEY,
    Grade_Level VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Club_Leaders (
    User_ID INT PRIMARY KEY,
    Role VARCHAR(50),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Admins (
    User_ID INT PRIMARY KEY,
    Admin_Level VARCHAR(20),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Clubs (
    Club_ID INT AUTO_INCREMENT PRIMARY KEY,
    Club_Name VARCHAR(100),
    Description TEXT,
    Category VARCHAR(50),
    Meeting_Time VARCHAR(100),
    Location VARCHAR(100),
    Size INT,
    Approval_Status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    Creation_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Club_Leader_ID INT,
    FOREIGN KEY (Club_Leader_ID) REFERENCES Club_Leaders(User_ID)
);

CREATE TABLE Membership_Requests (
    Request_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT,
    Club_ID INT,
    Status ENUM('Pending', 'Approved', 'Rejected', 'Cancelled') DEFAULT 'Pending',
    Request_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Review_Date DATETIME,
    Processed_By_Leader_ID INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(User_ID),
    FOREIGN KEY (Club_ID) REFERENCES Clubs(Club_ID),
    FOREIGN KEY (Processed_By_Leader_ID) REFERENCES Club_Leaders(User_ID)
);

CREATE TABLE Memberships (
    Membership_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT,
    Club_ID INT,
    Join_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Membership_Status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (Student_ID) REFERENCES Students(User_ID),
    FOREIGN KEY (Club_ID) REFERENCES Clubs(Club_ID)
);

CREATE TABLE Events (
    Club_ID INT,
    Event_Number INT,
    Event_Name VARCHAR(100),
    Description TEXT,
    Event_Date DATETIME,
    Location VARCHAR(100),
    PRIMARY KEY (Club_ID, Event_Number),
    FOREIGN KEY (Club_ID) REFERENCES Clubs(Club_ID)
);

CREATE TABLE Saved_Clubs (
    Saved_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT,
    Club_ID INT,
    Saved_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Club_ID) REFERENCES Clubs(Club_ID)
);

CREATE TABLE Messages (
    Message_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sender_ID INT,
    Receiver_ID INT,
    Content TEXT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Is_Read TINYINT(1) DEFAULT 0,
    FOREIGN KEY (Sender_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Receiver_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Saved_Events (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Club_ID INT NOT NULL,
    Saved_At DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_save (User_ID, Event_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

INSERT INTO Users (User_ID, First_Name, Last_Name, Email, Password, Account_Type) VALUES
(21, 'Alice', 'Smith', 'alice.smith@sjsu.edu', 'pw1', 'Student'),
(22, 'Bob', 'Johnson', 'bob.johnson@sjsu.edu', 'pw2', 'Student'),
(23, 'Charlie', 'Williams', 'charlie.williams@sjsu.edu', 'pw3', 'Student'),
(24, 'Dana', 'Brown', 'dana.brown@sjsu.edu', 'pw4', 'Student'),
(25, 'Eve', 'Jones', 'eve.jones@sjsu.edu', 'pw5', 'Student'),
(26, 'Liam', 'Nguyen', 'liam.nguyen@sjsu.edu', 'pw6', 'Student'),
(27, 'Mia', 'Patel', 'mia.patel@sjsu.edu', 'pw7', 'Student'),
(28, 'Noah', 'Kim', 'noah.kim@sjsu.edu', 'pw8', 'Student'),
(29, 'Emma', 'Lopez', 'emma.lopez@sjsu.edu', 'pw9', 'Student'),
(30, 'Ava', 'Chen', 'ava.chen@sjsu.edu', 'pw10', 'Student'),
(31, 'Frank', 'Garcia', 'frank.garcia@sjsu.edu', 'pw11', 'Club_Leader'),
(32, 'Grace', 'Miller', 'grace.miller@sjsu.edu', 'pw12', 'Club_Leader'),
(33, 'Hank', 'Davis', 'hank.davis@sjsu.edu', 'pw13', 'Club_Leader'),
(34, 'Olivia', 'Wang', 'olivia.wang@sjsu.edu', 'pw14', 'Club_Leader'),
(35, 'Sophia', 'Lee', 'sophia.lee@sjsu.edu', 'pw15', 'Club_Leader'),
(36, 'Ivy', 'Martinez', 'ivy.martinez@sjsu.edu', 'pw16', 'Admin'),
(37, 'Jack', 'Wilson', 'jack.wilson@sjsu.edu', 'pw17', 'Admin'),
(38, 'Emily', 'Scott', 'emily.scott@sjsu.edu', 'pw18', 'Admin'),
(39, 'Daniel', 'Green', 'daniel.green@sjsu.edu', 'pw19', 'Admin'),
(40, 'Charlotte', 'Young', 'charlotte.young@sjsu.edu', 'pw20', 'Admin');

INSERT INTO Students (User_ID, Grade_Level) VALUES
(21, 'Freshman'), (22, 'Sophomore'), (23, 'Junior'), (24, 'Senior'),
(25, 'Freshman'), (26, 'Sophomore'), (27, 'Junior'), (28, 'Senior'),
(29, 'Freshman'), (30, 'Sophomore');

INSERT INTO Club_Leaders (User_ID, Role) VALUES
(31, 'Leader'), (32, 'Leader'), (33, 'Leader'), (34, 'Leader'), (35, 'Leader');

INSERT INTO Admins (User_ID, Admin_Level) VALUES
(36, 'Standard'), (37, 'Standard'), (38, 'Standard'), (39, 'Standard'), (40, 'Standard');

INSERT INTO Clubs (Club_ID, Club_Name, Description, Category, Meeting_Time, Location, Size, Approval_Status, Club_Leader_ID) VALUES
(21, 'Chess Club', 'A club for chess enthusiasts', 'Games', 'Fridays 5 PM', 'Library, Basement Floor', 25, 'Approved', 31),
(22, 'Photography Club', 'Explore photography techniques', 'Arts', 'Wednesdays 3 PM', 'IS 219', 30, 'Approved', 32),
(23, 'Robotics Club', 'Build and program robots', 'Technology', 'Tuesdays 4 PM', 'ENGR 325', 20, 'Pending', 33),
(24, 'Fencing Club', 'Recreational Fencing', 'Sports', 'Tuesdays 4 PM', 'Event Center', 40, 'Approved', 34),
(25, 'DnD Club', 'A club to play DnD', 'Games', 'TBD', 'Online', 15, 'Approved', 32),
(26, 'Debate Club', 'Develop debating skills', 'Academic', 'Fridays 4 PM', 'SH 425', 35, 'Rejected', 33),
(27, 'Music Club', 'Practice and perform music', 'Performing Arts', 'Wednesdays 5 PM', 'MUS 106', 22, 'Approved', 34),
(28, 'Science Club', 'Explore scientific topics', 'Academic', 'Thursdays 3 PM', 'ENGR 320', 18, 'Approved', 35),
(29, 'Literature Club', 'Discuss books and writing', 'Arts', 'Mondays 3 PM', 'SH 102', 28, 'Approved', 31),
(30, 'Gaming Club', 'Video game tournaments', 'Games', 'Saturdays 1 PM', 'Online', 40, 'Pending', 35);

INSERT INTO Memberships (Student_ID, Club_ID, Membership_Status) VALUES
(31, 21, 'Active'), (32, 22, 'Active'), (33, 23, 'Active'),
(34, 24, 'Active'), (32, 25, 'Active'), (33, 26, 'Active'),
(34, 27, 'Active'), (35, 28, 'Active'), (31, 29, 'Active'), (35, 30, 'Active');
