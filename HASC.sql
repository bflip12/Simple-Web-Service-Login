/******************************************************************************/
-- Script: HASC.sql
-- Author: Brian Minaji
-- Date: May 25, 2015
-- Description: Create HASC Database objects with players not assigned to teams
/******************************************************************************/

-- Setting NOCOUNT ON suppresses completion messages for each INSERT
SET NOCOUNT ON

-- Set date format to month, day, year
SET DATEFORMAT mdy;

-- Make the master database the current database
USE master

-- If database HASC exists, drop it
IF EXISTS ( SELECT * FROM sysdatabases WHERE name = 'HASC' )
  DROP DATABASE HASC;
GO

-- Create the HASC database
CREATE DATABASE HASC;
GO

-- Make the HASC database the current database
USE HASC;

-- Create Divisions table
CREATE TABLE Divisions ( 
	DivisionID INT ,
	DivisionName VARCHAR(50) , 
	TeamsMade BIT , 
	CONSTRAINT PK_Divisions PRIMARY KEY ( DivisionID ) ) ; 

-- Create Provinces table
CREATE TABLE Provinces ( 
	ProvinceID CHAR(2) , 
	ProvinceName VARCHAR(50) , 
	CONSTRAINT PK_Provinces PRIMARY KEY ( ProvinceID ) ) ; 

-- Create Skills table
CREATE TABLE Skills ( 
	SkillLevel CHAR(1) , 
	SkillDescription VARCHAR(50) , 
	CONSTRAINT PK_Skills PRIMARY KEY ( SkillLevel ) ) ; 

-- Create Teams table
CREATE TABLE Teams (
	TeamID INT ,
	TeamName VARCHAR(50) ,
	JerseyColour VARCHAR(50) ,
	DivisionID INT ,
	CONSTRAINT PK_Teams PRIMARY KEY ( TeamID ),
	CONSTRAINT FK_Divisions_Teams FOREIGN KEY ( DivisionID ) REFERENCES Divisions ( DivisionID ) ) ;

-- Create Persons table
CREATE TABLE Persons (
	PersonID INT ,
	FirstName VARCHAR(50) ,
	LastName VARCHAR(50) ,
	DivisionID INT ,
	Email VARCHAR(50) ,
	Gender CHAR(1) ,
	BirthDate DATE ,
	AddressLine1 VARCHAR(50) ,
	AddressLine2 VARCHAR(50) ,
	City VARCHAR(50) ,
	ProvinceID CHAR(2) ,
	PostalCode CHAR(7) ,
	Phone VARCHAR(20) ,
	Player BIT ,
	SkillLevel CHAR(1) , 
	TeamID INT ,
	JerseyNumber INT , 
	Coach BIT ,
	CoachingExperience VARCHAR(500) ,
	Referee BIT ,
	RefereeExperience VARCHAR(500) ,
	Administrator BIT ,
	UserPassword VARCHAR(20) ,
	CONSTRAINT PK_Persons PRIMARY KEY ( PersonID ) ,
	CONSTRAINT FK_Divisions_Persons FOREIGN KEY ( DivisionID ) REFERENCES Divisions ( DivisionID ) ,
	CONSTRAINT FK_Provinces_Persons FOREIGN KEY ( ProvinceID ) REFERENCES Provinces ( ProvinceID ) ,
	CONSTRAINT FK_Skills_Persons FOREIGN KEY ( SkillLevel ) REFERENCES Skills ( SkillLevel ) ,
	CONSTRAINT FK_Teams_Persons FOREIGN KEY ( TeamID ) REFERENCES Teams ( TeamID ) ) ; 

-- Create Games table
CREATE TABLE Games ( 
	GameID INT ,
	GameDate DATE ,
	Field VARCHAR(50) ,
	HomeTeamID INT ,
	HomeTeamScore INT ,
	AwayTeamID INT ,
	AwayTeamScore INT ,
	RefereeID INT , 
	GameNotes VARCHAR(1000) , 
	CONSTRAINT PK_Games PRIMARY KEY ( GameID ) ,
	CONSTRAINT FK_HomeTeam_Games FOREIGN KEY ( HomeTeamID ) REFERENCES Teams ( TeamID ) ,
	CONSTRAINT FK_AwayTeam_Games FOREIGN KEY ( AwayTeamID ) REFERENCES Teams ( TeamID ) ,
	CONSTRAINT FK_Referee_Games FOREIGN KEY ( RefereeID ) REFERENCES Persons ( PersonID ) ) ; 
GO

-- Create Coaches view
CREATE VIEW Coaches
AS
SELECT PersonID AS CoachID,
       FirstName,
       LastName,
       Email,
       Gender,
       BirthDate,
       AddressLine1,
       AddressLine2,
       City,
       ProvinceID,
       PostalCode,
       Phone,
       TeamID,
       CoachingExperience,
       UserPassword
FROM Persons
WHERE Coach = 'True';
GO

-- Create Players view
CREATE VIEW Players
AS
SELECT PersonID AS PlayerID,
       FirstName,
       LastName,
       DivisionID,
       Email,
       Gender,
       BirthDate,
       AddressLine1,
       AddressLine2,
       City,
       ProvinceID,
       PostalCode,
       Phone,
       SkillLevel,
       TeamID,
       JerseyNumber,
       UserPassword
FROM Persons
WHERE Player = 'True';
GO

-- Create Referees view
CREATE VIEW Referees
AS
SELECT PersonID AS RefereeID,
       FirstName,
       LastName,
       Email,
       Gender,
       BirthDate,
       AddressLine1,
       AddressLine2,
       City,
       ProvinceID,
       PostalCode,
       Phone,
       RefereeExperience,
       UserPassword
FROM Persons
WHERE Referee = 'True';
GO

-- Insert Divisions records
INSERT INTO Divisions VALUES( 1 , 'Female - Under 35' , 'False' );
INSERT INTO Divisions VALUES( 2 , 'Male - Under 35' , 'False' );
INSERT INTO Divisions VALUES( 3 , 'Female - 35 & Over' , 'False' );
INSERT INTO Divisions VALUES( 4 , 'Male - 35 & Over' , 'False' );
INSERT INTO Divisions VALUES( 5 , 'Mixed' , 'False' );
GO

-- Insert Provinces records
INSERT INTO Provinces VALUES( 'AB' , 'Alberta' );
INSERT INTO Provinces VALUES( 'BC' , 'British Columbia' );
INSERT INTO Provinces VALUES( 'MB' , 'Manitoba' );
INSERT INTO Provinces VALUES( 'NB' , 'New Brunswick' );
INSERT INTO Provinces VALUES( 'NL' , 'Newfoundland and Labrador' );
INSERT INTO Provinces VALUES( 'NT' , 'Northwest Territories' );
INSERT INTO Provinces VALUES( 'NS' , 'Nova Scotia' );
INSERT INTO Provinces VALUES( 'NU' , 'Nunavut' );
INSERT INTO Provinces VALUES( 'ON' , 'Ontario' );
INSERT INTO Provinces VALUES( 'PE' , 'Prince Edward Island' );
INSERT INTO Provinces VALUES( 'QC' , 'Quebec' );
INSERT INTO Provinces VALUES( 'SK' , 'Saskatchewan' );
INSERT INTO Provinces VALUES( 'YT' , 'Yukon' );
GO

-- Insert Skills records
INSERT INTO Skills VALUES( 'A' , 'Well above average' );
INSERT INTO Skills VALUES( 'B' , 'Above average' );
INSERT INTO Skills VALUES( 'C' , 'Average' );
INSERT INTO Skills VALUES( 'D' , 'Below average' );
INSERT INTO Skills VALUES( 'E' , 'Well below average' );
GO

-- Insert Teams records
INSERT INTO Teams VALUES( 1 , 'Black Cats' , 'Black' , 1 );
INSERT INTO Teams VALUES( 2 , 'Blues' , 'Blue' , 1 );
INSERT INTO Teams VALUES( 3 , 'Lions' , 'Gold' , 1 );
INSERT INTO Teams VALUES( 4 , 'Red Dragons' , 'Red' , 1 );
INSERT INTO Teams VALUES( 5 , 'Foxes' , 'Gold' , 2 );
INSERT INTO Teams VALUES( 6 , 'Pirates' , 'Black' , 2 );
INSERT INTO Teams VALUES( 7 , 'Rebels' , 'Blue' , 2 );
INSERT INTO Teams VALUES( 8 , 'Terriers' , 'White' , 2 );
INSERT INTO Teams VALUES( 9 , 'Bulls' , 'Black' , 3 );
INSERT INTO Teams VALUES( 10 , 'Gunners' , 'Red' , 3 );
INSERT INTO Teams VALUES( 11 , 'Harriers' , 'White' , 3 );
INSERT INTO Teams VALUES( 12 , 'Vikings' , 'Blue' , 3 );
INSERT INTO Teams VALUES( 13 , 'Eagles' , 'White' , 4 );
INSERT INTO Teams VALUES( 14 , 'Red Devils' , 'Red' , 4 );
INSERT INTO Teams VALUES( 15 , 'Tigers' , 'Gold' , 4 );
INSERT INTO Teams VALUES( 16 , 'Wolves' , 'Black' , 4 );
INSERT INTO Teams VALUES( 17 , 'Cardinals' , 'Red' , 5 );
INSERT INTO Teams VALUES( 18 , 'Hornets' , 'Gold' , 5 );
INSERT INTO Teams VALUES( 19 , 'Saints' , 'White' , 5 );
INSERT INTO Teams VALUES( 20 , 'Spurs' , 'Blue' , 5 );
GO

-- Insert Persons records
INSERT INTO Persons VALUES( 1 , 'Greg' , 'House' , NULL , 'ghouse@gmail.com' , 'M' , '5/15/1963' , '221B Baker Street' , NULL , 'Hamilton' , 'ON' , 'L8N 3T3' , '905-555-1234' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'False' , NULL , 'True' , 'cuddy' );
INSERT INTO Persons VALUES( 2 , 'Marlene' , 'Hamilton' , 3 , 'marlene.hamilton@rogers.com' , 'F' , '6/17/1970' , '25 Huntley St.' , NULL , 'St. Catharines' , 'ON' , 'L8L 5X8' , '905-580-8030' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seagulls' );
INSERT INTO Persons VALUES( 3 , 'Judith' , 'Collins' , 3 , 'judith.collins@hotmail.com' , 'F' , '12/9/1970' , '156 East 25Th Street' , NULL , 'Hamilton' , 'ON' , 'L9C 5L2' , '905-166-4580' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 4 , 'Dennis' , 'McPhee' , 2 , 'dennis_mcphee@rogers.com' , 'M' , '12/19/1983' , '187 Young St' , NULL , 'Hamilton' , 'ON' , 'L8Y 2N3' , '905-955-1550' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 5 , 'Samantha' , 'Stacey' , 3 , 'l-packs@email.com' , 'F' , '9/6/1966' , '2232 Stanley Ave' , NULL , 'Burlington' , 'ON' , 'L7R 2S3' , '905-803-4458' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'chairboys' );
INSERT INTO Persons VALUES( 6 , 'Sarah' , 'Bernhard' , 3 , 's.bernhard@netaccess.on.ca' , 'F' , '2/3/1972' , '25 Curlew Drive' , NULL , 'Hamilton' , 'ON' , 'L2T 1K5' , '905-194-4490' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 7 , 'Dom' , 'Rily' , 5 , 'drily@canada.ca' , 'M' , '5/18/1968' , '2 Kintire Dr.' , NULL , 'Hamilton' , 'ON' , 'L4M 2C4' , '905-592-9039' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bluebirds' );
INSERT INTO Persons VALUES( 8 , 'James' , 'Boyd' , 5 , 'jboyd@cogeco.ca' , 'M' , '9/4/1977' , '7 Crestwood Drive' , NULL , 'Hamilton' , 'ON' , 'L9A 3Y6' , '905-305-2916' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 9 , 'Sarah' , 'Brown' , 1 , 'sbrown@quickclic.net' , 'F' , '1/8/1982' , '760 Mohawk Road West' , NULL , 'Hamilton' , 'ON' , 'L9C 6P6' , '905-497-9151' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'riversiders' );
INSERT INTO Persons VALUES( 10 , 'Bill' , 'Brenzill' , 4 , 'b_brenzill@netaccess.on.ca' , 'M' , '9/13/1977' , '14 Normanhurst' , NULL , 'Hamilton' , 'ON' , 'L9A 4W5' , '905-941-2121' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shaymen' );
INSERT INTO Persons VALUES( 11 , 'Jonathan' , 'Murray' , 2 , 'jonathanm@rogers.com' , 'M' , '2/13/1984' , '1214 Waterford Rd' , NULL , 'Hamilton' , 'ON' , 'L4J 2B6' , '905-283-3810' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'daggers' );
INSERT INTO Persons VALUES( 12 , 'Olivia' , 'Barber' , NULL , 'oliviab@rogers.com' , 'F' , '6/8/1956' , '19 Rosewood Crt.' , NULL , 'Rockford' , 'ON' , 'L9B 4C1' , '905-761-5581' , 'False' , NULL , 19 , NULL , 'True' , 'Coached last year for first time' , 'False' , NULL , 'False' , 'seasiders' );
INSERT INTO Persons VALUES( 13 , 'Ravishing' , 'Rude' , 2 , 'rrude@yahoo.ca' , 'M' , '5/11/1980' , '99 Broadview Rd.' , NULL , 'Hamilton' , 'ON' , 'L9A 1G1' , '905-224-1506' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pensioners' );
INSERT INTO Persons VALUES( 14 , 'Aimee' , 'Nelson' , 3 , 'aimeen@mountaincable.net' , 'F' , '12/17/1977' , '183 Provinces' , NULL , 'Hamilton' , 'ON' , 'L9A 4L6' , '905-989-7945' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spurs' );
INSERT INTO Persons VALUES( 15 , 'Samuel' , 'Paul' , 2 , 's_paul@cogeco.ca' , 'M' , '1/30/1988' , '36 Adair Avenue' , NULL , 'Hamilton' , 'ON' , 'L8H 1L3' , '905-315-9077' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 16 , 'Jim' , 'Higgins' , 4 , 'jhiggins@gmail.com' , 'M' , '4/2/1966' , '15 Tonks Street' , NULL , 'Hamilton' , 'ON' , 'L3E 3T4' , '905-762-6562' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 17 , 'Lisa' , 'Black' , 1 , 'lisab@rogers.com' , 'F' , '10/10/1980' , '22 Jackson Avenue' , NULL , 'Hamilton' , 'ON' , 'L8F 1Z8' , '905-409-3142' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'quakers' );
INSERT INTO Persons VALUES( 18 , 'Mary' , 'Gossage' , 1 , 'm.gossage@quickclic.net' , 'F' , '3/9/1984' , '123 Shady Lane' , NULL , 'Beamsville' , 'ON' , 'L5S 2Z9' , '905-791-8143' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 19 , 'Jeff' , 'Horn' , 5 , 'jeffh@mountaincable.net' , 'M' , '8/12/1973' , '476 Tumbleweed Cres' , NULL , 'Hamilton' , 'ON' , 'L8P 4N3' , '905-450-3945' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pompey' );
INSERT INTO Persons VALUES( 20 , 'Chris' , 'Ko' , 1 , 'chrisk@mountaincable.net' , 'F' , '1/4/1993' , '15 Rosewater Dr.' , NULL , 'Hamilton' , 'ON' , 'L2C 1G7' , '905-905-3576' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'vikings' );
INSERT INTO Persons VALUES( 21 , 'Scott' , 'Flinders' , 5 , 's_flinders@mail.com' , 'M' , '3/11/1985' , '239 Walker St.' , NULL , 'Hamilton' , 'ON' , 'L5P 2K5' , '905-705-2044' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'swans' );
INSERT INTO Persons VALUES( 22 , 'Susan' , 'Langley' , 1 , 's.langley@gmail.com' , 'F' , '2/2/1993' , '12 Drury Road' , NULL , 'Hamilton' , 'ON' , 'L8W 2P6' , '905-300-6783' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gulls' );
INSERT INTO Persons VALUES( 23 , 'Robert' , 'Walters' , 5 , 'r_walters@netaccess.on.ca' , 'M' , '11/16/1993' , '87 Queen St. N.' , NULL , 'Hamilton' , 'ON' , 'L5W 1Z1' , '905-774-6195' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'dollyblues' );
INSERT INTO Persons VALUES( 24 , 'Bill' , 'Ackerman' , 5 , 'b_ackerman@gmail.com' , 'M' , '3/18/1973' , '180 Bowman Ave' , NULL , 'Burlington' , 'ON' , 'L8M 7E1' , '905-132-6029' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bantams' );
INSERT INTO Persons VALUES( 25 , 'Pat' , 'Cruz' , 3 , 'patc@hotmail.com' , 'F' , '8/2/1975' , '21 Main Street W' , NULL , 'Hamilton' , 'ON' , 'L8H 2Z1' , '905-541-4730' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'harriers' );
INSERT INTO Persons VALUES( 26 , 'Mary' , 'Mortan' , 3 , 'mary.mortan@hotmail.com' , 'F' , '3/2/1976' , '79 Young St' , NULL , 'Hamilton' , 'ON' , 'L6H 2G5' , '905-578-8969' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'grecians' );
INSERT INTO Persons VALUES( 27 , 'Jim' , 'Ford' , NULL , 'jimf@mountaincable.net' , 'M' , '7/14/1982' , '27 John Street S' , NULL , 'Hamilton' , 'ON' , 'L9C 3X4' , '905-724-6776' , 'False' , NULL , 18 , NULL , 'True' , 'Provincially certified' , 'False' , NULL , 'False' , 'quakers' );
INSERT INTO Persons VALUES( 28 , 'Jamie' , 'Rose' , 2 , 'j.rose@canada.ca' , 'M' , '2/8/1982' , '44 Chatman St.' , NULL , 'Hamilton' , 'ON' , 'L8M 3P1' , '905-433-2143' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shakers' );
INSERT INTO Persons VALUES( 29 , 'Mildred' , 'Miller' , 3 , 'mildred_miller@sympatico.ca' , 'F' , '2/6/1974' , '14 Maple Street' , NULL , 'Hamilton' , 'ON' , 'L9C 2S9' , '905-164-6532' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'diamonds' );
INSERT INTO Persons VALUES( 30 , 'Susan' , 'Hamilton' , 1 , 'shamilton@mail.com' , 'F' , '4/3/1994' , '103 Provice St. S.' , NULL , 'Hamilton' , 'ON' , 'L8H 4H7' , '905-387-8021' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 31 , 'Martha' , 'Gullie' , 1 , 'mgullie@gmail.com' , 'F' , '8/18/1985' , '28 Gloucester' , NULL , 'Hamilton' , 'ON' , 'L8G 1P1' , '905-750-3812' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spireites' );
INSERT INTO Persons VALUES( 32 , 'Fred' , 'Steerman' , 2 , 'fsteerman@cogeco.ca' , 'M' , '6/6/1989' , '27 Pearl Street' , NULL , 'Hamilton' , 'ON' , 'L8P 3N2' , '905-620-7304' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cottagers' );
INSERT INTO Persons VALUES( 33 , 'Hazel' , 'Young' , 1 , 'hazel.young@porchlight.ca' , 'F' , '3/7/1985' , '312 Pickford Way' , NULL , 'Milton' , 'ON' , 'L6P 3G4' , '905-950-4901' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 34 , 'Nina' , 'Kaur' , 3 , 'nkaur@gmail.com' , 'F' , '10/2/1967' , '645 Barton St. E.' , NULL , 'Stoney Creek' , 'ON' , 'L8G 1B4' , '905-291-1344' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'royals' );
INSERT INTO Persons VALUES( 35 , 'Mark' , 'Banks' , 5 , 'mark_banks@porchlight.ca' , 'M' , '1/14/1978' , '27 Birchwood Place' , NULL , 'Carlisle' , 'ON' , 'L0R 2H0' , '905-444-3434' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 36 , 'Edna' , 'Babit' , 3 , 'ebabit@cogeco.ca' , 'F' , '7/2/1973' , '43 James St. W.' , NULL , 'Ancaster' , 'ON' , 'L2M 7A8' , '905-315-4715' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lambs' );
INSERT INTO Persons VALUES( 37 , 'Larry' , 'Garwood' , 2 , 'l.garwood@mail.com' , 'M' , '4/6/1987' , '253 Dudhope Street' , NULL , 'Hamilton' , 'ON' , 'L4T 2VP' , '905-282-9416' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blackcats' );
INSERT INTO Persons VALUES( 38 , 'Barry' , 'Cross' , 5 , 'barry_cross@home.com' , 'M' , '4/13/1987' , '287 DeRRy Road' , NULL , 'Mississauga' , 'ON' , 'L0J 1K0' , '905-555-1542' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brummagem' );
INSERT INTO Persons VALUES( 39 , 'Micheal' , 'Robin' , 2 , 'michealr@home.com' , 'M' , '8/17/1991' , '37 Webbling' , NULL , 'Brantford' , 'ON' , 'N5N L9H' , '519-165-9151' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trotters' );
INSERT INTO Persons VALUES( 40 , 'Jeff' , 'McNaughton' , 4 , 'jmcnaughton@netaccess.on.ca' , 'M' , '1/15/1966' , '620 Windsor Ave.' , NULL , 'Dundas' , 'ON' , 'L8N 3G1' , '905-753-3426' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'superhoops' );
INSERT INTO Persons VALUES( 41 , 'Douglas' , 'Fleming' , NULL , 'dfleming@canada.ca' , 'M' , '4/9/1978' , '303 Mud St E.' , NULL , 'Stoney Creek' , 'ON' , 'L8B 7Z3' , '905-317-6274' , 'False' , NULL , 10 , NULL , 'True' , 'None' , 'False' , NULL , 'False' , 'cumbrians' );
INSERT INTO Persons VALUES( 42 , 'Zachary' , 'Hamilton' , 4 , 'zachary_hamilton@mountaincable.net' , 'M' , '9/15/1971' , '120 Scenic Drive' , NULL , 'Hamilton' , 'ON' , 'L9C 3T8' , '905-897-8064' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 43 , 'Paul' , 'Andi' , 2 , 'paul.andi@hotmail.com' , 'M' , '12/3/1983' , '249 Beemer Avenue' , NULL , 'Ancaster' , 'ON' , 'L2M 7A8' , '905-912-4463' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 44 , 'Donna' , 'Jenson' , NULL , 'donnaj@email.com' , 'F' , '3/15/1982' , '137 Glencedar Drive' , NULL , 'Oakville' , 'ON' , 'L8K 5K3' , '905-505-3027' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'None' , 'False' , 'monkeyhangers' );
INSERT INTO Persons VALUES( 45 , 'Rena' , 'Kidney' , 3 , 'rkidney@canada.ca' , 'F' , '4/6/1975' , '21 Filter Rd.' , NULL , 'Hamilton' , 'ON' , 'L0R 101' , '905-318-3833' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 46 , 'Heather' , 'Morossin' , 1 , 'h_morossin@quickclic.net' , 'F' , '8/2/1993' , '135 Iroquois Ave.' , NULL , 'Ancaster' , 'ON' , 'L9G 1EO' , '905-872-3408' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yellows' );
INSERT INTO Persons VALUES( 47 , 'Claire' , 'Stack' , 3 , 'c.stack@netaccess.on.ca' , 'F' , '11/6/1972' , '136 Pineridge Crescent' , NULL , 'Carlisle' , 'ON' , 'L0R 2H0' , '905-953-1280' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'foxes' );
INSERT INTO Persons VALUES( 48 , 'John' , 'Smith' , 2 , 'john.smith@hotmail.com' , 'M' , '7/17/1993' , '426 King St W' , NULL , 'Hamilton' , 'ON' , 'L8P 1B7' , '905-394-4481' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'quakers' );
INSERT INTO Persons VALUES( 49 , 'Carol' , 'Watson' , 5 , 'c.watson@yahoo.ca' , 'F' , '2/8/1994' , '80 Sanitorium Rd.' , NULL , 'Hamilton' , 'ON' , 'L7S 4X1' , '905-110-5814' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 50 , 'Alan' , 'Jackson' , 5 , 'a_jackson@cogeco.ca' , 'M' , '3/9/1967' , '4093 Gardiner Street' , NULL , 'Hamilton' , 'ON' , 'L8W 2B2' , '905-540-8658' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 51 , 'Nikki' , 'James' , 3 , 'n_james@mail.com' , 'F' , '8/7/1976' , '14 Turner St.' , NULL , 'Hamilton' , 'ON' , 'L4T 2K2' , '905-324-1839' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hornets' );
INSERT INTO Persons VALUES( 52 , 'Pete' , 'Michels' , 4 , 'pete.michels@hotmail.com' , 'M' , '4/15/1968' , '33 1St Ave. W.' , NULL , 'Guelph' , 'ON' , 'N1G 8W7' , '519-954-8672' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'clarets' );
INSERT INTO Persons VALUES( 53 , 'Jamie' , 'McBride' , 2 , 'j_mcbride@quickclic.net' , 'M' , '8/13/1987' , '112 Picton Blvd' , NULL , 'Hamilton' , 'ON' , 'L9A 7J6' , '905-335-3341' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stanley' );
INSERT INTO Persons VALUES( 54 , 'Janea' , 'Jones' , 5 , 'janeaj@email.com' , 'F' , '3/2/1986' , '309 King Street East' , NULL , 'Hamilton' , 'ON' , 'L9K 3Y1' , '905-667-8660' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brewers' );
INSERT INTO Persons VALUES( 55 , 'Abbie' , 'Neal' , 1 , 'abbie_neal@home.com' , 'F' , '2/6/1988' , '3364 Poaridise Rd.' , NULL , 'Burlington' , 'ON' , 'L7M 2R4' , '905-622-5056' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lilywhites' );
INSERT INTO Persons VALUES( 56 , 'Kelly' , 'Jones' , 3 , 'kelly.jones@sympatico.ca' , 'F' , '1/8/1976' , '44 King St W.' , NULL , 'Hamilton' , 'ON' , 'L9V 7C8' , '905-187-6822' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pensioners' );
INSERT INTO Persons VALUES( 57 , 'Emma' , 'Mathewes' , 3 , 'emma_mathewes@porchlight.ca' , 'F' , '10/31/1972' , '70 Second Street' , NULL , 'Ancaster' , 'ON' , 'L4R 2JR' , '905-247-9214' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'citizens' );
INSERT INTO Persons VALUES( 58 , 'Allan' , 'Wright' , 4 , 'allanw@sympatico.ca' , 'M' , '1/17/1967' , '92 Louth St.' , NULL , 'St. Catharines' , 'ON' , 'L8S 5V5' , '905-208-8697' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 59 , 'Christyne' , 'Rogers' , 1 , 'christyne_rogers@rogers.com' , 'F' , '1/8/1983' , '321 Rangers Court' , NULL , 'Hamilton' , 'ON' , 'L5Z 6I6' , '905-174-8679' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 60 , 'Lili' , 'Mollon' , 1 , 'l.mollon@yahoo.ca' , 'F' , '8/5/1993' , '211 Temple Mead Dr.' , NULL , 'Hamilton' , 'ON' , 'L5C 1S2' , '905-263-4453' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terriers' );
INSERT INTO Persons VALUES( 61 , 'Helen' , 'Cooper' , 1 , 'helenc@rogers.com' , 'F' , '7/12/1992' , '1435 Victoria Ave N' , NULL , 'Hamilton' , 'ON' , 'L8S 1K9' , '905-663-2792' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lillywhites' );
INSERT INTO Persons VALUES( 62 , 'Nick' , 'Teen' , 4 , 'n.teen@netaccess.on.ca' , 'M' , '7/9/1967' , '24 Bay St.North' , NULL , 'Hamilton' , 'ON' , 'L7R 2PZ' , '905-967-1945' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 63 , 'Lyrad' , 'Daryl' , 1 , 'lyradd@sympatico.ca' , 'F' , '2/12/1982' , '187 King St. W' , NULL , 'Hamilton' , 'ON' , 'L7M 2J2' , '905-474-2468' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hammers' );
INSERT INTO Persons VALUES( 64 , 'David' , 'Jones' , 5 , 'djones@canada.ca' , 'M' , '1/19/1979' , '14 Maple Ave' , NULL , 'Caledonia' , 'ON' , 'L0T WS5' , '905-226-7048' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'fleet' );
INSERT INTO Persons VALUES( 65 , 'Edwin' , 'Alverrez' , 4 , 'e_alverrez@rogers.com' , 'M' , '10/3/1968' , '212 Catatumbo Dr.' , NULL , 'Hamilton' , 'ON' , 'L8R 2H2' , '905-339-7254' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 66 , 'Alfred' , 'Jones' , 2 , 'a_jones@quickclic.net' , 'M' , '12/10/1987' , '16 Virginia Ave.' , NULL , 'Hamilton' , 'ON' , 'L9C 6W1' , '905-596-8338' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'daggers' );
INSERT INTO Persons VALUES( 67 , 'John' , 'Marcus' , 4 , 'j.marcus@gmail.com' , 'M' , '7/16/1967' , '27 Welsley St.' , NULL , 'Hamilton' , 'ON' , 'L7C 5G4' , '905-239-5402' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'toffees' );
INSERT INTO Persons VALUES( 68 , 'Mary' , 'Evans' , 1 , 'm_evans@canada.ca' , 'F' , '3/6/1986' , '47 Hadeland Ave' , NULL , 'Hamilton' , 'ON' , 'L6L 3Z4' , '905-935-8115' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yellows' );
INSERT INTO Persons VALUES( 69 , 'David' , 'Smith' , 4 , 'd_smith@yahoo.ca' , 'M' , '12/9/1977' , '15 John Street South' , NULL , 'Hamilton' , 'ON' , 'L8K 2N2' , '905-930-1550' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'railwaymen' );
INSERT INTO Persons VALUES( 70 , 'Deninger' , 'Heinz' , 2 , 'deninger_heinz@rogers.com' , 'M' , '8/6/1991' , '124 Cranbrook Drive' , NULL , 'Hamilton' , 'ON' , 'L0A 1A0' , '905-143-4906' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddragons' );
INSERT INTO Persons VALUES( 71 , 'Jennifer' , 'Brown' , 3 , 'j.brown@yahoo.ca' , 'F' , '2/14/1969' , '28 Wilson St.' , NULL , 'Hamilton' , 'ON' , 'L8P 3M4' , '905-592-8312' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mightywhites' );
INSERT INTO Persons VALUES( 72 , 'Julia' , 'Marshall' , 5 , 'julia.marshall@mountaincable.net' , 'F' , '5/31/1976' , '304 East 16Th St.' , NULL , 'Hamilton' , 'ON' , 'L8V 3Z6' , '905-503-5091' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'monkeyhangers' );
INSERT INTO Persons VALUES( 73 , 'John' , 'Doe' , 5 , 'john.doe@email.com' , 'M' , '9/25/1972' , '196 Caroline Street' , NULL , 'Hamilton' , 'ON' , 'L8T 5T6' , '905-993-5563' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cobblers' );
INSERT INTO Persons VALUES( 74 , 'Grant' , 'Lane' , NULL , 'g_lane@quickclic.net' , 'M' , '10/6/1987' , '12 Bender Ave.' , NULL , 'Dundas' , 'ON' , 'L8T 4S6' , '905-353-5830' , 'False' , NULL , 11 , NULL , 'True' , 'Provincially certified' , 'False' , NULL , 'False' , 'lillywhites' );
INSERT INTO Persons VALUES( 75 , 'Ima' , 'Tester' , 3 , 'imat@sympatico.ca' , 'F' , '2/5/1969' , '1234 Mainstreet' , NULL , 'Hamilton' , 'ON' , 'L8G 5T6' , '905-603-8730' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'addicks' );
INSERT INTO Persons VALUES( 76 , 'Peter' , 'Piper' , 5 , 'p_piper@netaccess.on.ca' , 'M' , '7/9/1966' , '12559 E. 76Th St.' , NULL , 'Hamilton' , 'ON' , 'L7M 2J2' , '905-144-2317' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'eagles' );
INSERT INTO Persons VALUES( 77 , 'Annabel' , 'Catarino' , 3 , 'a.catarino@mail.com' , 'F' , '12/11/1976' , '121 Ontario St' , NULL , 'Hamilton' , 'ON' , 'L9G 2F3' , '905-708-4879' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'riversiders' );
INSERT INTO Persons VALUES( 78 , 'Edward' , 'Williams' , 2 , 'edward.williams@sympatico.ca' , 'M' , '1/16/1994' , '149 Memorial Dr.' , NULL , 'Brantford' , 'ON' , 'N3S 5S5' , '519-168-7410' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blades' );
INSERT INTO Persons VALUES( 79 , 'Paul' , 'Marshall' , 5 , 'p.marshall@netaccess.on.ca' , 'M' , '2/1/1971' , '222 Acacia Ave.' , NULL , 'Hamilton' , 'ON' , 'L9G 2F3' , '905-185-7977' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'addicks' );
INSERT INTO Persons VALUES( 80 , 'Rick' , 'Davies' , 4 , 'rick_davies@mountaincable.net' , 'M' , '6/5/1975' , '24 Stuart Street' , NULL , 'Hamilton' , 'ON' , 'L5T 6A9' , '905-601-7914' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'valiants' );
INSERT INTO Persons VALUES( 81 , 'James' , 'Sanders' , 5 , 'jamess@hotmail.com' , 'M' , '7/12/1988' , '26 Orchard Street' , NULL , 'Hamilton' , 'ON' , 'L4P 6P6' , '905-231-5575' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'canaries' );
INSERT INTO Persons VALUES( 82 , 'Anne' , 'Smith' , 1 , 'a.smith@cogeco.ca' , 'F' , '9/9/1993' , '96 Nebo Rd.' , NULL , 'Hamilton' , 'ON' , 'L8T 1T3' , '905-315-1080' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'fleet' );
INSERT INTO Persons VALUES( 83 , 'Rusty' , 'Peterson' , 4 , 'rusty.peterson@mountaincable.net' , 'M' , '1/6/1971' , '26 Fifth St' , NULL , 'Caledonia' , 'ON' , 'L9T 3P2' , '905-263-7583' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 84 , 'Jennifer' , 'Jones' , NULL , 'jennifer.jones@home.com' , 'F' , '2/22/1987' , '2103 Main Street' , NULL , 'Hamilton' , 'ON' , 'L2R 6N1' , '905-959-2521' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Refereed last year for first time' , 'False' , 'cardinals' );
INSERT INTO Persons VALUES( 85 , 'Jason' , 'Carleton' , 2 , 'jcarleton@cogeco.ca' , 'M' , '11/14/1983' , '641 Townsend Dr.' , NULL , 'Burlington' , 'ON' , 'L9J 2T6' , '905-496-7120' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cobblers' );
INSERT INTO Persons VALUES( 86 , 'Kellya' , 'Barber' , 1 , 'k_barber@canada.ca' , 'F' , '9/1/1992' , '76 Bell Cres' , NULL , 'Oakville' , 'ON' , 'L0A 1N0' , '905-402-3097' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 87 , 'Marie' , 'Brown' , 3 , 'marieb@email.com' , 'F' , '7/8/1976' , '210 Lakeview Road' , NULL , 'Burlington' , 'ON' , 'L2I 2J3' , '905-866-6114' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'chairboys' );
INSERT INTO Persons VALUES( 88 , 'Albert' , 'Green' , 5 , 'a.green@yahoo.ca' , 'M' , '5/15/1982' , '17 Craven Cres' , NULL , 'Hamilton' , 'ON' , 'L8C 7B7' , '905-359-5941' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 89 , 'Share' , 'McGill' , 2 , 'smcgill@cogeco.ca' , 'M' , '8/16/1990' , '24 Jamine Ave' , NULL , 'Hamilton' , 'ON' , 'L2Z 4A3' , '905-846-4399' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'citizens' );
INSERT INTO Persons VALUES( 90 , 'Dorianne' , 'Browning' , 3 , 'dorianne.browning@home.com' , 'F' , '5/9/1967' , '1758 Villa Maire N' , NULL , 'Hamilton' , 'ON' , 'L4Z 6O2' , '905-910-6691' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bluebirds' );
INSERT INTO Persons VALUES( 91 , 'Stella' , 'Steen' , 3 , 'stella_steen@email.com' , 'F' , '7/5/1967' , '176 Marylebone St.' , NULL , 'Hamilton' , 'ON' , 'L7P 3G6' , '905-678-4136' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'fleet' );
INSERT INTO Persons VALUES( 92 , 'Mary' , 'Cross' , 3 , 'm_cross@mail.com' , 'F' , '12/10/1966' , '55 East 49Th St' , NULL , 'Dundas' , 'ON' , 'L0S 2H0' , '905-245-6955' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'toffees' );
INSERT INTO Persons VALUES( 93 , 'Tim' , 'Coomb' , 4 , 'tcoomb@mail.com' , 'M' , '6/8/1972' , '74 South Park Ave' , NULL , 'Hamilton' , 'ON' , 'L8T 4Y4' , '905-491-3590' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gunners' );
INSERT INTO Persons VALUES( 94 , 'John' , 'Goodwin' , 2 , 'john_goodwin@hotmail.com' , 'M' , '11/4/1994' , '7 Birdland Court' , NULL , 'Hamilton' , 'ON' , 'LHI RCO' , '905-469-9447' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rebels' );
INSERT INTO Persons VALUES( 95 , 'Jane' , 'Smith' , 1 , 'janes@rogers.com' , 'F' , '11/13/1980' , '1 John Street' , NULL , 'Hamilton' , 'ON' , 'L8K 3J2' , '905-156-2505' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trickytrees' );
INSERT INTO Persons VALUES( 96 , 'Edna' , 'Duke' , 3 , 'e_duke@yahoo.ca' , 'F' , '1/15/1977' , 'Winding Way' , NULL , 'Hamilton' , 'ON' , 'L5V 2Z8' , '905-360-9150' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cottagers' );
INSERT INTO Persons VALUES( 97 , 'Rosemary' , 'Shaw' , 3 , 'rosemary_shaw@sympatico.ca' , 'F' , '5/4/1972' , '486 Milgrove Rd.' , NULL , 'Milgrove' , 'ON' , 'L8L 4R2' , '905-193-9747' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 98 , 'Sandy' , 'Bochco' , 4 , 'sbochco@quickclic.net' , 'M' , '9/7/1972' , '555 Water Edge Rd.' , NULL , 'Paris' , 'ON' , 'L8P ZR5' , '905-920-5554' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mariners' );
INSERT INTO Persons VALUES( 99 , 'Jennifer' , 'Nasso' , 1 , 'j_nasso@netaccess.on.ca' , 'F' , '5/11/1982' , '27 Londonstreet North' , NULL , 'Hamilton' , 'ON' , 'L8H 4B9' , '905-976-1215' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 100 , 'Marvin' , 'Stanley' , 2 , 'marvin.stanley@porchlight.ca' , 'M' , '8/14/1986' , '5 Fennel W' , NULL , 'Hamilton' , 'ON' , 'L0H 0H0' , '905-659-6886' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yidarmy' );
INSERT INTO Persons VALUES( 101 , 'Paula' , 'Harris' , 1 , 'paula_harris@sympatico.ca' , 'F' , '12/3/1985' , '28 Madison St.' , NULL , 'Burlington' , 'ON' , 'L7X 2B5' , '905-844-8476' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'wolves' );
INSERT INTO Persons VALUES( 102 , 'Harry' , 'Smith' , 2 , 'harry_smith@hotmail.com' , 'M' , '10/16/1989' , '42 Earl Street' , NULL , 'Hamilton' , 'ON' , 'L8S 4G1' , '905-480-3034' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mightywhites' );
INSERT INTO Persons VALUES( 103 , 'Steve' , 'Ferraro' , 2 , 'steve_ferraro@porchlight.ca' , 'M' , '5/8/1989' , '85 Walnut East' , NULL , 'Hamilton' , 'ON' , 'L8P 1C5' , '905-185-7753' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lilywhites' );
INSERT INTO Persons VALUES( 104 , 'Ida' , 'Jones' , 1 , 'ida_jones@rogers.com' , 'F' , '12/17/1985' , '32 Talbot Street' , NULL , 'Cayuga' , 'ON' , 'L0A 1E0' , '905-364-4595' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'swans' );
INSERT INTO Persons VALUES( 105 , 'Teresa' , 'Hamilton' , 5 , 'teresa_hamilton@hotmail.com' , 'F' , '8/19/1974' , '102 Province Street South' , NULL , 'Hamilton' , 'ON' , 'L8H 4H7' , '905-345-9715' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bulls' );
INSERT INTO Persons VALUES( 106 , 'Joe' , 'Piatek' , 4 , 'joe.piatek@porchlight.ca' , 'M' , '12/1/1969' , '55 Upper James' , NULL , 'Cambridge' , 'ON' , 'N1R 5T3' , '519-776-9331' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'railwaymen' );
INSERT INTO Persons VALUES( 107 , 'Steele' , 'Amanda' , 5 , 'samanda@yahoo.ca' , 'F' , '1/14/1985' , '293 Kirby Ave.' , NULL , 'Hamilton' , 'ON' , 'L5N 2P8' , '905-170-9029' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'villans' );
INSERT INTO Persons VALUES( 108 , 'Ian' , 'Nolan' , 4 , 'ian_nolan@email.com' , 'M' , '8/8/1967' , '23 Roach Rd.' , NULL , 'Ancaster' , 'ON' , 'L2M 7A8' , '905-822-8340' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stanley' );
INSERT INTO Persons VALUES( 109 , 'Naomi' , 'Allen' , 5 , 'n_allen@cogeco.ca' , 'F' , '8/11/1985' , '2211 Robinhood Lane' , NULL , 'Hamilton' , 'ON' , 'L5M 4E1' , '905-756-1673' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brewers' );
INSERT INTO Persons VALUES( 110 , 'Andrea' , 'Lane' , NULL , 'andrea.lane@email.com' , 'F' , '5/10/1979' , '16 Maple Ave.' , NULL , 'Cayuga' , 'ON' , 'L6M 2Z6' , '905-148-8600' , 'False' , NULL , 6 , NULL , 'True' , 'Provincially certified' , 'False' , NULL , 'False' , 'stags' );
INSERT INTO Persons VALUES( 111 , 'Robert' , 'Wilson' , 4 , 'rwilson@quickclic.net' , 'M' , '10/16/1966' , '27 Cardinal Drive' , NULL , 'Hamilton' , 'ON' , 'L1T 6M3' , '905-726-7412' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimpers' );
INSERT INTO Persons VALUES( 112 , 'Marie' , 'Sharpe' , 3 , 'm.sharpe@cogeco.ca' , 'F' , '10/6/1969' , '133 Cross St.' , 'Apt. 310' , 'Hamilton' , 'ON' , 'L8Z 2B6' , '905-255-5647' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bluebirds' );
INSERT INTO Persons VALUES( 113 , 'Edna' , 'Fesuk' , 5 , 'e.fesuk@yahoo.ca' , 'F' , '12/5/1980' , 'Winding Way' , NULL , 'Hamilton' , 'ON' , 'L5V 2Z8' , '905-896-5410' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 114 , 'Tom' , 'Alana' , 2 , 'toma@porchlight.ca' , 'M' , '10/9/1981' , '100 Bay Street' , NULL , 'Hamilton' , 'ON' , 'L6C 4V4' , '905-344-7495' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shots' );
INSERT INTO Persons VALUES( 115 , 'Joe' , 'Stanley' , NULL , 'jstanley@canada.ca' , 'M' , '3/1/1968' , '29 Blake Street' , NULL , 'Hamilton' , 'ON' , 'L42 357' , '905-684-4308' , 'False' , NULL , 17 , NULL , 'True' , 'About 5 years' , 'False' , NULL , 'False' , 'rebels' );
INSERT INTO Persons VALUES( 116 , 'Kim' , 'Desrochers' , 1 , 'kim_desrochers@sympatico.ca' , 'F' , '5/13/1983' , '66 Pickering Pkwy' , NULL , 'Hamilton' , 'ON' , 'L8K 1S2' , '905-366-5554' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 117 , 'Donald' , 'Dokken' , NULL , 'donald.dokken@hotmail.com' , 'M' , '2/14/1967' , '653 Dunsdon Ave.' , NULL , 'Brantford' , 'ON' , 'N3T 5L5' , '519-874-7456' , 'False' , NULL , 4 , NULL , 'True' , 'Coached last year for first time' , 'False' , NULL , 'False' , 'blackcats' );
INSERT INTO Persons VALUES( 118 , 'Matthew' , 'Cook' , 4 , 'm.cook@quickclic.net' , 'M' , '9/10/1972' , '328 Birland Ave' , NULL , 'Hamilton' , 'ON' , 'L2Z 1W0' , '905-707-6691' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stags' );
INSERT INTO Persons VALUES( 119 , 'Steve' , 'Teen' , 4 , 's.teen@mail.com' , 'M' , '10/13/1966' , '24 Bay St. North' , NULL , 'Hamilton' , 'ON' , 'L7R 2PZ' , '905-598-6617' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'millers' );
INSERT INTO Persons VALUES( 120 , 'Albert' , 'Mann' , 4 , 'a_mann@netaccess.on.ca' , 'M' , '9/4/1974' , '452 Balmoral' , 'Apt 21' , 'Hamilton' , 'ON' , 'L2E 4Y9' , '905-740-8813' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 121 , 'Bruce' , 'Smith' , 4 , 'bruces@porchlight.ca' , 'M' , '10/3/1972' , '78 Fiona Cres.' , NULL , 'Hamilton' , 'ON' , 'L4K 4W3' , '905-104-3878' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 122 , 'Bob' , 'Thompson' , 2 , 'b.thompson@canada.ca' , 'M' , '9/6/1984' , '1630 Mohawk Rd. W' , NULL , 'Stoney Creek' , 'ON' , 'L4W 5V6' , '905-651-6419' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'silkmen' );
INSERT INTO Persons VALUES( 123 , 'Wende' , 'Baker' , NULL , 'w_baker@canada.ca' , 'F' , '12/13/1972' , '649 Vine St.' , NULL , 'Grimsby' , 'ON' , 'L4N 3T2' , '905-266-5789' , 'False' , NULL , 9 , NULL , 'True' , 'Provincially certified' , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 124 , 'Edith' , 'Walmsly' , 3 , 'edith_walmsly@home.com' , 'F' , '8/2/1967' , '242 Howe Ave' , NULL , 'Hamilton' , 'ON' , 'L2C 6T3' , '905-882-7355' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'potters' );
INSERT INTO Persons VALUES( 125 , 'John' , 'Bobbit' , 2 , 'j_bobbit@quickclic.net' , 'M' , '5/3/1994' , '17 Skyway Drive' , NULL , 'Hamilton' , 'ON' , 'L8N 3N7' , '905-678-9802' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gulls' );
INSERT INTO Persons VALUES( 126 , 'Jan' , 'Lox' , 1 , 'jan.lox@rogers.com' , 'F' , '6/2/1983' , '2 Peel St.' , NULL , 'Paris' , 'ON' , 'N3K 4K7' , '519-312-8342' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'clarets' );
INSERT INTO Persons VALUES( 127 , 'Mildred' , 'Hopsmire' , 3 , 'mhopsmire@canada.ca' , 'F' , '12/9/1975' , '48 James Cres.' , 'Apt. 4' , 'Hamilton' , 'ON' , 'L4J 3J2' , '905-597-5700' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cottagers' );
INSERT INTO Persons VALUES( 128 , 'Agnes' , 'Smith' , NULL , 'asmith@gmail.com' , 'F' , '9/5/1984' , '125 Queen St.' , NULL , 'Hamilton' , 'ON' , 'L8H 5Y9' , '905-117-9410' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'About 5 years' , 'False' , 'brewers' );
INSERT INTO Persons VALUES( 129 , 'Samantha' , 'Gullie' , 3 , 'samantha.gullie@email.com' , 'F' , '5/15/1976' , '28 Gloucester' , NULL , 'Hamilton' , 'ON' , 'L8H 1H3' , '905-837-3168' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cherries' );
INSERT INTO Persons VALUES( 130 , 'Susan' , 'James' , 1 , 's_james@canada.ca' , 'F' , '5/18/1981' , '24 Maple Avenue' , NULL , 'Ancaster' , 'ON' , 'L9H 2P2' , '905-277-4066' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saddlers' );
INSERT INTO Persons VALUES( 131 , 'Keith' , 'Alfonso' , 4 , 'keith.alfonso@email.com' , 'M' , '10/31/1977' , '123 Edgar Blvd.' , NULL , 'Cambridge' , 'ON' , 'N3N 5G5' , '519-638-5602' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 132 , 'Morgan' , 'Boeker' , 1 , 'mboeker@gmail.com' , 'F' , '1/14/1992' , '50 Ranwood Dr.' , NULL , 'Hamilton' , 'ON' , 'L8W 1W6' , '905-496-7479' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gills' );
INSERT INTO Persons VALUES( 133 , 'Sarah' , 'Abraham' , 3 , 's.abraham@gmail.com' , 'F' , '3/6/1977' , '12-245 Violet Terrace' , NULL , 'Hamilton' , 'ON' , 'L9A 1G4' , '905-748-2301' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'baggies' );
INSERT INTO Persons VALUES( 134 , 'Keith' , 'Redding' , 4 , 'keith.redding@porchlight.ca' , 'M' , '4/12/1975' , '245 Highgate Street' , NULL , 'Stoney Creek' , 'ON' , 'L5A 2N5' , '905-564-1810' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 135 , 'Bart' , 'Davies' , 5 , 'bartd@email.com' , 'M' , '1/8/1982' , '400 Lake Street' , NULL , 'Beamsville' , 'ON' , 'L8R 6S2' , '905-541-9993' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'monkeyhangers' );
INSERT INTO Persons VALUES( 136 , 'Caitlin' , 'German' , 3 , 'c.german@gmail.com' , 'F' , '5/13/1977' , '1491 Berry Street' , NULL , 'Brantford' , 'ON' , 'N3D 2L3' , '519-373-2036' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 137 , 'Amy' , 'Wilson' , 1 , 'a_wilson@gmail.com' , 'F' , '11/8/1994' , '126 Arlington Ave.' , NULL , 'Hamilton' , 'ON' , 'L6V 6F4' , '905-340-4422' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'irons' );
INSERT INTO Persons VALUES( 138 , 'Robert' , 'Christian' , 4 , 'robert.christian@home.com' , 'M' , '9/11/1976' , '44 Church St.' , NULL , 'Smithville' , 'ON' , 'L5O 1A8' , '905-896-2364' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'addicks' );
INSERT INTO Persons VALUES( 139 , 'Peter' , 'Jones' , 1 , 'peter_jones@rogers.com' , 'F' , '6/5/1981' , '1295 Wood Ave' , NULL , 'Oakville' , 'ON' , 'L7L 5L2' , '905-325-8233' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 140 , 'Stephanie' , 'Chase' , 5 , 'stephanie.chase@hotmail.com' , 'F' , '12/5/1982' , '401 Maple Avenue' , NULL , 'Burlington' , 'ON' , 'L7S 2E8' , '905-510-4848' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrews' );
INSERT INTO Persons VALUES( 141 , 'Andrea' , 'Baylis' , 3 , 'abaylis@quickclic.net' , 'F' , '9/3/1975' , '24 Wise Crescent' , NULL , 'Hamilton' , 'ON' , 'L8T 2L6' , '905-673-7364' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 142 , 'Piper' , 'Peter' , 2 , 'p.peter@cogeco.ca' , 'M' , '2/12/1982' , '12559 E. 76Th St.' , NULL , 'Hamilton' , 'ON' , 'L9T 3P2' , '905-995-9027' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spurs' );
INSERT INTO Persons VALUES( 143 , 'Laura' , 'Miller' , 3 , 'lmiller@quickclic.net' , 'F' , '1/14/1970' , '328 Wellington Street North' , NULL , 'Hamilton' , 'ON' , 'L3W 2G9' , '905-448-9737' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'dollyblues' );
INSERT INTO Persons VALUES( 144 , 'Rose' , 'Johnson' , 3 , 'rosej@email.com' , 'F' , '2/6/1974' , '73 Green Cedar Dr' , NULL , 'Hamilton' , 'ON' , 'L8T 4R9' , '905-156-8296' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'glovers' );
INSERT INTO Persons VALUES( 145 , 'Amber' , 'McNeill' , 5 , 'amberm@porchlight.ca' , 'F' , '6/2/1991' , '246 Leslie St.' , NULL , 'Hargersville' , 'ON' , 'L8G 2G5' , '905-804-7536' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 146 , 'Romal' , 'Rackham' , 5 , 'rrackham@cogeco.ca' , 'F' , '8/8/1994' , '16 34 St.' , NULL , 'Brantford' , 'ON' , 'N3T 1C6' , '519-166-7574' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimpers' );
INSERT INTO Persons VALUES( 147 , 'Brad' , 'Jarvis' , 4 , 'brad.jarvis@mountaincable.net' , 'M' , '12/10/1967' , '25 Carincroft' , NULL , 'Oakville' , 'ON' , 'L9T 3P2' , '905-572-2156' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'millers' );
INSERT INTO Persons VALUES( 148 , 'Albert' , 'Fox' , 2 , 'a_fox@mail.com' , 'M' , '11/16/1990' , '148 Bold Street East' , NULL , 'Hamilton' , 'ON' , 'L3P 2S5' , '905-757-2442' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brewers' );
INSERT INTO Persons VALUES( 149 , 'Ann' , 'Rexia' , 3 , 'arexia@mail.com' , 'F' , '10/11/1968' , '124 Reed Lane' , NULL , 'Hamilton' , 'ON' , 'L8J 1X7' , '905-638-2519' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bantams' );
INSERT INTO Persons VALUES( 150 , 'John' , 'Brown' , 4 , 'j_brown@gmail.com' , 'M' , '9/3/1966' , '67 Hunter Ave.' , NULL , 'Hamilton' , 'ON' , 'L8J 1H3' , '905-143-9238' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'superhoops' );
INSERT INTO Persons VALUES( 151 , 'Evan' , 'Walker' , 4 , 'e.walker@gmail.com' , 'M' , '6/16/1972' , '49 Dundurn St.' , NULL , 'Hamilton' , 'ON' , 'L4P 2Z5' , '905-992-5163' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tykes' );
INSERT INTO Persons VALUES( 152 , 'Jeff' , 'Jones' , 2 , 'j_jones@gmail.com' , 'M' , '8/2/1988' , '23 Auburn Cres.' , NULL , 'Hamilton' , 'ON' , 'L7N 6D9' , '905-830-3980' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'grecians' );
INSERT INTO Persons VALUES( 153 , 'Donna' , 'Richmond' , NULL , 'donna_richmond@mountaincable.net' , 'F' , '5/19/1981' , '100 Milkyway Drive' , NULL , 'Hamilton' , 'ON' , 'L8G 2W7' , '905-655-8294' , 'False' , NULL , 15 , NULL , 'True' , 'Coached kids' , 'False' , NULL , 'False' , 'royals' );
INSERT INTO Persons VALUES( 154 , 'Martin' , 'Gleason' , 2 , 'marting@rogers.com' , 'M' , '9/13/1992' , '67 Garside Ave.' , NULL , 'Hamilton' , 'ON' , 'L8W 1Z3' , '905-636-3268' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 155 , 'Cong' , 'Barsar' , 5 , 'congb@rogers.com' , 'M' , '1/30/1968' , '11 Bolvey Dr' , NULL , 'Hamilton' , 'ON' , 'L9K 4W5' , '905-669-3751' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spireites' );
INSERT INTO Persons VALUES( 156 , 'Gerry' , 'Adamson' , NULL , 'gerry.adamson@porchlight.ca' , 'M' , '9/20/1964' , 'Golflink Road' , NULL , 'Brantford' , 'ON' , 'N6E 7H0' , '519-216-8945' , 'False' , NULL , 1 , NULL , 'True' , 'About 5 years' , 'False' , NULL , 'False' , 'superhoops' );
INSERT INTO Persons VALUES( 157 , 'Edward' , 'Hughson' , NULL , 'edward_hughson@sympatico.ca' , 'M' , '10/11/1982' , '119 Upper James' , NULL , 'Hamilton' , 'ON' , 'L8J 1A7' , '905-799-6782' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'About 5 years' , 'False' , 'silkmen' );
INSERT INTO Persons VALUES( 158 , 'Jennifer' , 'Bond' , 1 , 'j_bond@quickclic.net' , 'F' , '5/5/1993' , '69 Marigold Lane' , NULL , 'Milton' , 'ON' , 'L8R 2V7' , '905-508-6137' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 159 , 'Karen' , 'Desrochers' , 3 , 'karen_desrochers@home.com' , 'F' , '9/17/1972' , '66 Pickering Pkwy' , NULL , 'Hamilton' , 'ON' , 'L6H 9Z1' , '905-930-6533' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trotters' );
INSERT INTO Persons VALUES( 160 , 'Donald' , 'Montaque' , 5 , 'd.montaque@yahoo.ca' , 'M' , '1/7/1975' , '172 Debora Dr.' , NULL , 'Hamilton' , 'ON' , 'L9C 6P3' , '905-629-8055' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lions' );
INSERT INTO Persons VALUES( 161 , 'Karen' , 'Marshall' , 3 , 'kmarshall@gmail.com' , 'F' , '2/10/1978' , '154 Gordon Ave' , NULL , 'Hamilton' , 'ON' , 'L9A 4W7' , '905-300-2527' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cobblers' );
INSERT INTO Persons VALUES( 162 , 'Edmund' , 'Risier' , 2 , 'e_risier@netaccess.on.ca' , 'M' , '4/9/1984' , '261 Crabtree Avenue' , NULL , 'Milton' , 'ON' , 'L7R 4ZL' , '905-511-3267' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'villans' );
INSERT INTO Persons VALUES( 163 , 'Robert' , 'Wight' , 5 , 'robertw@mountaincable.net' , 'M' , '9/5/1994' , '21 Hunters Lane' , NULL , 'Dundas' , 'ON' , 'L9H 9H0' , '905-694-3102' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shakers' );
INSERT INTO Persons VALUES( 164 , 'David' , 'Moore' , 2 , 'david_moore@email.com' , 'M' , '3/9/1984' , 'R.R.#2' , NULL , 'Paris' , 'ON' , 'N3L 3E2' , '519-111-5419' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'irons' );
INSERT INTO Persons VALUES( 165 , 'Agnieszka' , 'Zaszkowska' , 3 , 'agnieszka.zaszkowska@rogers.com' , 'F' , '12/4/1970' , '20 Erie Ave - 705' , NULL , 'Hamilton' , 'ON' , 'L8N 2W6' , '905-840-1281' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lambs' );
INSERT INTO Persons VALUES( 166 , 'Melissa' , 'McPhee' , 1 , 'melissam@mountaincable.net' , 'F' , '7/15/1980' , '78 Shannon Drive' , NULL , 'Cambridge' , 'ON' , 'N2C 4P0' , '519-593-3220' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mariners' );
INSERT INTO Persons VALUES( 167 , 'Roberto' , 'Jakobson' , 2 , 'roberto.jakobson@sympatico.ca' , 'M' , '10/12/1982' , '604 King Albert Ave.' , NULL , 'Dundas' , 'ON' , 'L3K 1P2' , '905-224-4643' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddragons' );
INSERT INTO Persons VALUES( 168 , 'Dylan' , 'Spence' , NULL , 'dylan_spence@sympatico.ca' , 'M' , '11/20/1978' , '175 Limeridge Rd. W.' , NULL , 'Hamilton' , 'ON' , 'L8E 3K1' , '905-963-6496' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Refereed kids' , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 169 , 'David' , 'Johns' , 2 , 'd_johns@yahoo.ca' , 'M' , '4/2/1987' , '654 Maple Drive' , NULL , 'Brantford' , 'ON' , 'N0F 2Q5' , '519-384-7764' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spurs' );
INSERT INTO Persons VALUES( 170 , 'Bob' , 'Beat' , 4 , 'bob.beat@email.com' , 'M' , '4/2/1971' , '100 Main St. E.' , NULL , 'Hamilton' , 'ON' , 'L2R 6N1' , '905-407-6143' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'toffees' );
INSERT INTO Persons VALUES( 171 , 'Brant' , 'Scott' , 4 , 'brant_scott@email.com' , 'M' , '1/13/1974' , '1234 Burlington St.' , NULL , 'Hamilton' , 'ON' , 'L8H 1H3' , '905-620-2822' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'grecians' );
INSERT INTO Persons VALUES( 172 , 'Sharlene' , 'Rogers' , 5 , 's.rogers@quickclic.net' , 'F' , '5/4/1971' , '22 Mcnab St. N' , NULL , 'Hamilton' , 'ON' , 'L8P 1C5' , '905-986-8862' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 173 , 'Nick' , 'Quitter' , 4 , 'n_quitter@netaccess.on.ca' , 'M' , '10/8/1972' , '66 Candy Street' , NULL , 'Hamilton' , 'ON' , 'L8S 7T4' , '905-748-2364' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terriers' );
INSERT INTO Persons VALUES( 174 , 'Thomas' , 'Wells' , 2 , 'thomas_wells@home.com' , 'M' , '6/10/1993' , '56 George St S.' , NULL , 'Paris' , 'ON' , 'L2L 5M9' , '905-842-8263' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 175 , 'Robert' , 'Boutilier' , 4 , 'robertb@rogers.com' , 'M' , '4/1/1973' , '259 Balmoral Ave N' , NULL , 'Hamilton' , 'ON' , 'L8L 7S3' , '905-862-3163' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 176 , 'Sam' , 'Peters' , 4 , 's.peters@gmail.com' , 'M' , '2/12/1968' , '127 Kissenger Ave' , NULL , 'Hamilton' , 'ON' , 'L8T 4Z2' , '905-581-8704' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rebels' );
INSERT INTO Persons VALUES( 177 , 'Joe' , 'Smith' , 5 , 'joe.smith@rogers.com' , 'M' , '6/5/1992' , '777 Queen St. S' , NULL , 'Hamilton' , 'ON' , 'L9C 6P6' , '905-202-4164' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mightywhites' );
INSERT INTO Persons VALUES( 178 , 'Clara' , 'Jones' , 1 , 'clara_jones@porchlight.ca' , 'F' , '3/6/1985' , '97 Blue Crescent' , NULL , 'Hamilton' , 'ON' , 'L4B 5A3' , '905-325-6977' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'daggers' );
INSERT INTO Persons VALUES( 179 , 'Gerry' , 'Ackman' , 4 , 'gerrya@hotmail.com' , 'M' , '6/15/1973' , '27 West Ave.' , NULL , 'Hamilton' , 'ON' , 'L8P 1W8' , '905-589-6573' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 180 , 'Sharon' , 'Duggan' , 5 , 'sduggan@cogeco.ca' , 'F' , '10/16/1981' , '42 Park St.' , NULL , 'Hamilton' , 'ON' , 'L9H 6L7' , '905-675-7962' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'baggies' );
INSERT INTO Persons VALUES( 181 , 'Jaqueline' , 'Handey' , 3 , 'jhandey@cogeco.ca' , 'F' , '5/8/1978' , '114 Alton St.' , 'Apt. 207' , 'Hamilton' , 'ON' , 'L9C 5D9' , '905-638-4004' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 182 , 'James' , 'Strong' , NULL , 'j_strong@netaccess.on.ca' , 'M' , '1/27/1974' , '81 Knox Street' , NULL , 'Dundas' , 'ON' , 'L9G 3R9' , '905-282-9418' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'None' , 'False' , 'shrimpers' );
INSERT INTO Persons VALUES( 183 , 'Sally' , 'Cookson' , 1 , 'sally.cookson@rogers.com' , 'F' , '9/1/1993' , '4 Melbwrock' , NULL , 'Grimsby' , 'ON' , 'L8T 5A3' , '905-769-2893' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'silkmen' );
INSERT INTO Persons VALUES( 184 , 'Tom' , 'Andrews' , 2 , 'tom_andrews@home.com' , 'M' , '3/3/1991' , '14 Main St.' , NULL , 'Grimsby' , 'ON' , 'L3M 4F7' , '905-825-6879' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 185 , 'Lilian' , 'Bunker' , 1 , 'lilianb@email.com' , 'F' , '10/12/1982' , '16 Drury Lane' , NULL , 'Burlington' , 'ON' , 'L8M 7E1' , '905-400-2633' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 186 , 'Erica' , 'Bulop' , 1 , 'e_bulop@yahoo.ca' , 'F' , '11/10/1988' , '3 Fieldgrove Dr.' , NULL , 'Hepworth' , 'ON' , 'L5T 6L7' , '905-367-1719' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hammers' );
INSERT INTO Persons VALUES( 187 , 'Edna' , 'McDougall' , 1 , 'e_mcdougall@gmail.com' , 'F' , '9/17/1989' , '26 Terrace Ave' , NULL , 'Hamilton' , 'ON' , 'L4T 2N6' , '905-505-8125' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'diamonds' );
INSERT INTO Persons VALUES( 188 , 'Howard' , 'Johnson' , 5 , 'howard_johnson@mountaincable.net' , 'M' , '3/10/1991' , '69 Atlantic Ave.' , NULL , 'Hamilton' , 'ON' , 'L9R 5S3' , '905-261-9778' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 189 , 'Mark' , 'Cummings' , 4 , 'mark_cummings@rogers.com' , 'M' , '5/12/1972' , '32 Pine Drive' , NULL , 'Stoney Creek' , 'ON' , 'L8G 4A6' , '905-381-8416' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tykes' );
INSERT INTO Persons VALUES( 190 , 'Carol' , 'Marker' , 3 , 'carol.marker@sympatico.ca' , 'F' , '10/14/1968' , '141 Jackson Ave. E.' , NULL , 'Hamilton' , 'ON' , 'L8K 1A4' , '905-413-5747' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tractorboys' );
INSERT INTO Persons VALUES( 191 , 'Stephene' , 'Miller' , 2 , 's.miller@gmail.com' , 'M' , '2/11/1992' , '836 Upper Wentworth Ave.' , NULL , 'Hamilton' , 'ON' , 'L8V 3M9' , '905-691-2106' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seagulls' );
INSERT INTO Persons VALUES( 192 , 'James' , 'Henderson' , NULL , 'jamesh@porchlight.ca' , 'M' , '7/3/1984' , '52 Elm Crescent' , NULL , 'Hamilton' , 'ON' , 'L1X 3R6' , '905-360-3897' , 'False' , NULL , 12 , NULL , 'True' , 'Coached kids' , 'False' , NULL , 'False' , 'diamonds' );
INSERT INTO Persons VALUES( 193 , 'Mike' , 'Myers' , 4 , 'mikem@sympatico.ca' , 'M' , '8/2/1976' , '21 Angel St.' , NULL , 'Hamilton' , 'ON' , 'L8T 5A3' , '905-674-1098' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trickytrees' );
INSERT INTO Persons VALUES( 194 , 'Victor' , 'Newman' , 4 , 'victorn@mountaincable.net' , 'M' , '11/8/1968' , '51 Queen St.' , NULL , 'Hamilton' , 'ON' , 'L8V 3E8' , '905-987-8047' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'villans' );
INSERT INTO Persons VALUES( 195 , 'Mark' , 'Stevenson' , 2 , 'mstevenson@quickclic.net' , 'M' , '7/9/1991' , '180 Glencastle Dr.' , NULL , 'Stoney Creek' , 'ON' , 'L8G 4A8' , '905-848-5336' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trickytrees' );
INSERT INTO Persons VALUES( 196 , 'Cynthia' , 'Stack' , 1 , 'cynthia_stack@porchlight.ca' , 'F' , '10/4/1984' , '136 Pine Ridge Crescent' , NULL , 'Carlisle' , 'ON' , 'L0R 2H0' , '905-951-1306' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'harriers' );
INSERT INTO Persons VALUES( 197 , 'Mary' , 'Williams' , 3 , 'm_williams@mail.com' , 'F' , '4/9/1974' , '175 Tragina Ave.' , NULL , 'Hamilton' , 'ON' , 'L8N 2H9' , '905-371-5227' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'wolves' );
INSERT INTO Persons VALUES( 198 , 'Paula' , 'Papuse' , 3 , 'paulap@home.com' , 'F' , '10/16/1968' , '123 Stork Lane.' , NULL , 'Burlington' , 'ON' , 'L9G 3T3' , '905-998-3425' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hornets' );
INSERT INTO Persons VALUES( 199 , 'James' , 'Ready' , 2 , 'james.ready@sympatico.ca' , 'M' , '6/16/1982' , '1320 Yates St.' , NULL , 'Hamilton' , 'ON' , 'L6L 3Z4' , '905-356-1521' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 200 , 'Fred' , 'Adams' , 4 , 'f.adams@quickclic.net' , 'M' , '8/18/1968' , '79 Maple, Ave.' , NULL , 'Hamilton' , 'ON' , 'L7P 4S7' , '905-909-6602' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 201 , 'Sue' , 'Wright' , 1 , 'swright@netaccess.on.ca' , 'F' , '6/10/1994' , '3 Herkimer' , NULL , 'Hamilton' , 'ON' , 'L0C 6R3' , '905-362-8567' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cherries' );
INSERT INTO Persons VALUES( 202 , 'Scott' , 'Lamb' , 2 , 'scottl@porchlight.ca' , 'M' , '10/10/1983' , '1275 Maple Cross' , NULL , 'Ancaster' , 'ON' , 'L4N 1P5' , '905-616-4704' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trickytrees' );
INSERT INTO Persons VALUES( 203 , 'Lathisha' , 'Denbleyker' , 1 , 'lathisha_denbleyker@email.com' , 'F' , '4/15/1993' , '16 Parkview Dr.' , NULL , 'Hamilton' , 'ON' , 'L8T 5T6' , '905-558-5944' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 204 , 'Tanya' , 'Jones' , 3 , 'tjones@canada.ca' , 'F' , '10/2/1971' , '14 Parkway Lane' , NULL , 'Hamilton' , 'ON' , 'L2L 4V6' , '905-814-2807' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seagulls' );
INSERT INTO Persons VALUES( 205 , 'Alyssa' , 'Crane' , 5 , 'a_crane@cogeco.ca' , 'F' , '6/9/1966' , '27 Main E' , NULL , 'Hamilton' , 'ON' , 'L5N 7O7' , '905-184-4073' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 206 , 'David' , 'Peterson' , 5 , 'd.peterson@netaccess.on.ca' , 'M' , '7/10/1967' , '76 Bay St' , NULL , 'Hamilton' , 'ON' , 'L5Z 6I6' , '905-658-7653' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'irons' );
INSERT INTO Persons VALUES( 207 , 'John' , 'Jones' , 2 , 'j.jones@quickclic.net' , 'M' , '9/14/1992' , '275 Brant Ave.' , NULL , 'Hamilton' , 'ON' , 'L8P 1S4' , '905-879-5728' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stanley' );
INSERT INTO Persons VALUES( 208 , 'Martha' , 'Clark' , 1 , 'm_clark@yahoo.ca' , 'F' , '8/8/1984' , '977 Kenmore Cr' , NULL , 'Hamilton' , 'ON' , 'L8N 4C2' , '905-321-2342' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pensioners' );
INSERT INTO Persons VALUES( 209 , 'Sally' , 'Duke' , 5 , 'sally_duke@hotmail.com' , 'F' , '6/3/1972' , 'Winding Way' , NULL , 'Hamilton' , 'ON' , 'L5V 2Z8' , '905-222-6901' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pirates' );
INSERT INTO Persons VALUES( 210 , 'Julie' , 'Martin' , 3 , 'juliem@home.com' , 'F' , '5/12/1973' , '251 Queen St.' , NULL , 'Hamilton' , 'ON' , 'L8N 3W7' , '905-383-9167' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lilywhites' );
INSERT INTO Persons VALUES( 211 , 'Kim' , 'Fow' , 1 , 'kimf@home.com' , 'F' , '10/10/1988' , '10 Dover Dr' , NULL , 'Hamilton' , 'ON' , 'L3T 1J1' , '905-831-6526' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 212 , 'Henry' , 'Brown' , 4 , 'h_brown@cogeco.ca' , 'M' , '5/17/1977' , '72 Vivian Circle.' , NULL , 'Hamilton' , 'ON' , 'L9C 2B3' , '905-230-3306' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 213 , 'Sharon' , 'Montgomerie' , 5 , 's.montgomerie@canada.ca' , 'F' , '4/15/1975' , '68 Pecan Drive' , NULL , 'Stoney Creek' , 'ON' , 'L8T 2T3' , '905-807-4465' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 214 , 'Joe' , 'Docherty' , 2 , 'j_docherty@quickclic.net' , 'M' , '4/7/1990' , '42 Weir Street' , NULL , 'Hamilton' , 'ON' , 'L9H 1C7' , '905-369-1960' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lillywhites' );
INSERT INTO Persons VALUES( 215 , 'Sara' , 'Cole' , 3 , 's.cole@netaccess.on.ca' , 'F' , '5/6/1976' , '226 Melvern Street' , NULL , 'Guelph' , 'ON' , 'N4T 5P4' , '519-777-7880' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'sandgrounders' );
INSERT INTO Persons VALUES( 216 , 'Trish' , 'Drumm' , 5 , 'trish_drumm@home.com' , 'F' , '3/31/1988' , '101 Bellview Ave.' , NULL , 'Mississauga' , 'ON' , 'L4B 9S6' , '905-127-7823' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hammers' );
INSERT INTO Persons VALUES( 217 , 'Jason' , 'Smithers' , 5 , 'jasons@mountaincable.net' , 'M' , '8/17/1990' , '32 Water Street' , NULL , 'Hamilton' , 'ON' , 'L0A 1K8' , '905-473-6812' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 218 , 'Steven' , 'Smith' , 4 , 'steven.smith@email.com' , 'M' , '5/5/1977' , '11 Maplewood Drive' , NULL , 'Brantford' , 'ON' , 'N3T 3T1' , '519-241-8978' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trotters' );
INSERT INTO Persons VALUES( 219 , 'Daniel' , 'Wilimin' , 4 , 'dwilimin@mail.com' , 'M' , '5/10/1969' , '31 Chilton Cres' , NULL , 'Hamilton' , 'ON' , 'L2G 4P3' , '905-487-5418' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tykes' );
INSERT INTO Persons VALUES( 220 , 'Danielle' , 'Neal' , 1 , 'danielle.neal@home.com' , 'F' , '1/2/1988' , '3364 Paridise Rd.' , NULL , 'Burlington' , 'ON' , 'L7M 2R4' , '905-638-7916' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 221 , 'Esther' , 'Welland' , 3 , 'e.welland@canada.ca' , 'F' , '9/11/1968' , '19 Emerald Ave.' , NULL , 'Hamilton' , 'ON' , 'L3O F0D' , '905-761-8238' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'foxes' );
INSERT INTO Persons VALUES( 222 , 'Kate' , 'Stanson' , 1 , 'kates@email.com' , 'F' , '10/4/1983' , '12 Markland Street' , NULL , 'Hamilton' , 'ON' , 'L8P 2J8' , '905-133-4512' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 223 , 'Ken' , 'Newton' , 4 , 'ken.newton@email.com' , 'M' , '8/6/1971' , '260 King Street W' , NULL , 'Hamilton' , 'ON' , 'L8P 1J6' , '905-133-7919' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tykes' );
INSERT INTO Persons VALUES( 224 , 'Thomas' , 'Ball' , 5 , 't_ball@cogeco.ca' , 'M' , '9/2/1968' , '32 Westwood Dr.' , NULL , 'Hamilton' , 'ON' , 'L8T 3Y7' , '905-741-6424' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 225 , 'Erik' , 'Johnson' , 2 , 'erik.johnson@rogers.com' , 'M' , '10/13/1986' , '152 Riverside Drive' , NULL , 'Oakville' , 'ON' , 'L4J 1Q2' , '905-699-3821' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'potters' );
INSERT INTO Persons VALUES( 226 , 'Nickolas' , 'Koebel' , 4 , 'nickolas.koebel@sympatico.ca' , 'M' , '6/1/1973' , '52 Scott Rd.' , NULL , 'Cambridge' , 'ON' , 'N3C 1A8' , '519-508-9763' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 227 , 'Francine' , 'Fine' , 1 , 'francinef@mountaincable.net' , 'F' , '3/11/1993' , '38 Corinthian Dr.' , NULL , 'Stoney Creek' , 'ON' , 'L8J 4V7' , '905-239-9130' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lions' );
INSERT INTO Persons VALUES( 228 , 'Carl' , 'Henderson' , 5 , 'chenderson@mail.com' , 'M' , '4/1/1980' , '1795 Second St.' , NULL , 'Mississauga' , 'ON' , 'L5L 2S4' , '905-786-9220' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'minstermen' );
INSERT INTO Persons VALUES( 229 , 'Mary' , 'Carpenter' , NULL , 'm.carpenter@gmail.com' , 'F' , '12/26/1965' , '1 Main Street' , NULL , 'Hamilton' , 'ON' , 'L0R 125' , '905-650-6987' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Refereed kids' , 'False' , 'bulls' );
INSERT INTO Persons VALUES( 230 , 'Robert' , 'Newly' , 2 , 'robert_newly@email.com' , 'M' , '8/19/1986' , '19 Humber St' , NULL , 'Hamilton' , 'ON' , 'L8N 253' , '905-775-5396' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 231 , 'Susan' , 'Martin' , 3 , 'smartin@yahoo.ca' , 'F' , '11/11/1976' , '251 Queen Street' , NULL , 'Hamilton' , 'ON' , 'L8N 3W7' , '905-255-8491' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 232 , 'Myrtle' , 'Heywood' , NULL , 'myrtle.heywood@sympatico.ca' , 'F' , '10/3/1981' , '87 Barnes Avenue' , NULL , 'Brantford' , 'ON' , 'N3R 4Y9' , '519-400-4199' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'About 5 years' , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 233 , 'Fred' , 'Jones' , 2 , 'f_jones@canada.ca' , 'M' , '3/13/1982' , '26 Henderson Road' , NULL , 'Burlington' , 'ON' , 'L7X 2B5' , '905-166-1090' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 234 , 'Jane' , 'Douglas' , 3 , 'jdouglas@quickclic.net' , 'F' , '9/6/1972' , '75 Queen St South' , NULL , 'Hamilton' , 'ON' , 'L8J 4S3' , '905-679-4103' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 235 , 'Andrea' , 'Cooper' , 3 , 'a_cooper@netaccess.on.ca' , 'F' , '5/13/1977' , '88 George Street' , NULL , 'Hamilton' , 'ON' , 'L1S 4N5' , '905-975-5480' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gunners' );
INSERT INTO Persons VALUES( 236 , 'Alex' , 'McMurray' , 2 , 'alexm@rogers.com' , 'M' , '10/11/1984' , '6211 Montgomerey Drive' , NULL , 'Burlington' , 'ON' , 'L3X 2L6' , '905-855-5292' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 237 , 'Henry' , 'Bigtoe' , 5 , 'henryb@home.com' , 'M' , '12/16/1983' , '59 Davenport Road N' , NULL , 'Hamilton' , 'ON' , 'L45 8B2' , '905-769-1301' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'wolves' );
INSERT INTO Persons VALUES( 238 , 'Elroy' , 'McNeil' , 2 , 'elroy.mcneil@sympatico.ca' , 'M' , '2/15/1994' , '733 Oxford Ave.' , NULL , 'Hamilton' , 'ON' , 'L5S 3L1' , '905-503-1209' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mightywhites' );
INSERT INTO Persons VALUES( 239 , 'Carol' , 'Jackson' , 1 , 'c.jackson@mail.com' , 'F' , '9/6/1987' , '1412 Avenue Rd.' , NULL , 'Hamilton' , 'ON' , 'L8P 6E4' , '905-979-8493' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'harriers' );
INSERT INTO Persons VALUES( 240 , 'Anne' , 'Devereaux' , 3 , 'a_devereaux@yahoo.ca' , 'F' , '11/14/1967' , '1337 Woodvalve Place' , NULL , 'Burlington' , 'ON' , 'L7M 1H2' , '905-894-7483' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 241 , 'Allan' , 'Ryley' , 2 , 'a_ryley@quickclic.net' , 'M' , '9/8/1990' , '375 Adsworth Dr.' , NULL , 'Burlington' , 'ON' , 'L7L 2R3' , '905-754-1772' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrews' );
INSERT INTO Persons VALUES( 242 , 'Mary' , 'Tweeters' , 1 , 'mtweeters@yahoo.ca' , 'F' , '5/16/1985' , '1875 Finch Drive' , NULL , 'Hamilton' , 'ON' , 'L8V 6T2' , '905-273-5180' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pirates' );
INSERT INTO Persons VALUES( 243 , 'Evans' , 'Kari' , 5 , 'evans_kari@porchlight.ca' , 'F' , '2/7/1972' , '2241 Sandlewood' , NULL , 'Burlington' , 'ON' , 'L2A 1B9' , '905-808-7467' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'clarets' );
INSERT INTO Persons VALUES( 244 , 'Patric' , 'Swayze' , 4 , 'patric_swayze@sympatico.ca' , 'M' , '9/15/1968' , '269 York Blvd.' , NULL , 'Hamilton' , 'ON' , 'L3Z T2H' , '905-378-5190' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cherries' );
INSERT INTO Persons VALUES( 245 , 'Baillie' , 'Marshall' , 5 , 'b_marshall@mail.com' , 'M' , '3/7/1981' , '44 Hallmark St' , NULL , 'Burlington' , 'ON' , 'L2C 4Y1' , '905-716-4451' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lambs' );
INSERT INTO Persons VALUES( 246 , 'Carol' , 'Jones' , 3 , 'cjones@gmail.com' , 'F' , '5/15/1977' , '152 Barton Street' , NULL , 'Hamilton' , 'ON' , 'L6T 3M5' , '905-139-6072' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'dollyblues' );
INSERT INTO Persons VALUES( 247 , 'Joan' , 'McClement' , 3 , 'j.mcclement@canada.ca' , 'F' , '10/3/1974' , '169 Burke St.' , NULL , 'Stoney Creek' , 'ON' , 'L8M 6X6' , '905-929-8425' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gunners' );
INSERT INTO Persons VALUES( 248 , 'Joshua' , 'Kane' , 4 , 'joshua.kane@porchlight.ca' , 'M' , '8/31/1977' , '11 Melrose Ave.' , NULL , 'Grimsby' , 'ON' , 'L3M 1G7' , '905-907-8032' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 249 , 'Ona' , 'Bugliosa' , 3 , 'obugliosa@cogeco.ca' , 'F' , '3/16/1976' , '2715 Mondamiin Ave.' , NULL , 'Hamilton' , 'ON' , 'L8P 4Y1' , '905-742-3929' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 250 , 'Johnny' , 'Map' , 2 , 'j.map@netaccess.on.ca' , 'M' , '1/10/1988' , '70 Apple Drive' , NULL , 'Hamilton' , 'ON' , 'L5N 5R7' , '905-837-5054' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stags' );
INSERT INTO Persons VALUES( 251 , 'Doris' , 'Lewis' , 3 , 'dorisl@email.com' , 'F' , '12/13/1976' , '15 Row Ave.' , NULL , 'Hamilton' , 'ON' , 'L8K 2B5' , '905-533-4811' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 252 , 'Jenn' , 'Craig' , NULL , 'jenn.craig@rogers.com' , 'F' , '12/7/1992' , '33 Elm Street' , NULL , 'Hamilton' , 'ON' , 'L5G 7L9' , '905-347-2876' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Provincially certified' , 'False' , 'millers' );
INSERT INTO Persons VALUES( 253 , 'Mel' , 'Brousseaux' , 2 , 'mel.brousseaux@mountaincable.net' , 'M' , '8/2/1986' , '173 Charlton Ave W.' , NULL , 'Hamilton' , 'ON' , 'L8P 6E4' , '905-472-4322' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shakers' );
INSERT INTO Persons VALUES( 254 , 'Paul' , 'Gordon' , 2 , 'p_gordon@netaccess.on.ca' , 'M' , '7/16/1991' , '10 Green Road' , NULL , 'Grimsby' , 'ON' , 'L3M 5B4' , '905-778-7311' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blackcats' );
INSERT INTO Persons VALUES( 255 , 'Diane' , 'Brown' , 1 , 'd.brown@yahoo.ca' , 'F' , '5/17/1986' , '19 Maple Rd' , NULL , 'Hamilton' , 'ON' , 'L5Z 6I6' , '905-301-3547' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blackcats' );
INSERT INTO Persons VALUES( 256 , 'Susan' , 'McEaton' , 1 , 'smceaton@quickclic.net' , 'F' , '3/2/1991' , '203 Windslow Place' , NULL , 'Hamilton' , 'ON' , 'L58 2B9' , '905-913-8844' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yidarmy' );
INSERT INTO Persons VALUES( 257 , 'Jim' , 'Brock' , 2 , 'jbrock@yahoo.ca' , 'M' , '5/13/1985' , '18 Camel Avenue' , NULL , 'Hamilton' , 'ON' , 'L4T 1N6' , '905-944-8170' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'trotters' );
INSERT INTO Persons VALUES( 258 , 'Nathan' , 'Heaslip' , 4 , 'nathan_heaslip@email.com' , 'M' , '4/4/1967' , '235 Jane Street' , NULL , 'Hamilton' , 'ON' , 'L8N 2N4' , '905-493-5399' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tractorboys' );
INSERT INTO Persons VALUES( 259 , 'David' , 'Thompson' , 2 , 'david_thompson@porchlight.ca' , 'M' , '3/16/1986' , '752 Upper James St.' , NULL , 'Hamilton' , 'ON' , 'L8N 3T2' , '905-731-6009' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saddlers' );
INSERT INTO Persons VALUES( 260 , 'John' , 'Faulkner' , 5 , 'johnf@porchlight.ca' , 'M' , '6/8/1977' , '1121 Jacob St.' , NULL , 'Smithville' , 'ON' , 'L2V 3B4' , '905-404-5983' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'minstermen' );
INSERT INTO Persons VALUES( 261 , 'Jeff' , 'Campbell' , 2 , 'jeff.campbell@email.com' , 'M' , '10/31/1988' , '606 Main Street East' , NULL , 'Hamilton' , 'ON' , 'L8H 1S2' , '905-622-8371' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seagulls' );
INSERT INTO Persons VALUES( 262 , 'Larry' , 'Wray' , 2 , 'l_wray@yahoo.ca' , 'M' , '7/11/1989' , '82 Ann Street' , NULL , 'Caledonia' , 'ON' , 'L4B 1H5' , '905-336-1161' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'foxes' );
INSERT INTO Persons VALUES( 263 , 'John' , 'Lee' , 4 , 'john.lee@hotmail.com' , 'M' , '6/15/1977' , '208 Tragina Ave. N.' , NULL , 'Hamilton' , 'ON' , 'L8H 5E1' , '905-304-4088' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cottagers' );
INSERT INTO Persons VALUES( 264 , 'Angela' , 'Bindra' , 1 , 'a_bindra@quickclic.net' , 'F' , '11/15/1980' , '1104 Stinson Street' , NULL , 'Georgetown' , 'ON' , 'L9F 5H3' , '905-830-2832' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'riversiders' );
INSERT INTO Persons VALUES( 265 , 'Kitty' , 'Hawk' , 1 , 'k_hawk@cogeco.ca' , 'F' , '9/14/1989' , '51 Center Lane' , NULL , 'Paris' , 'ON' , 'L8H 5Y9' , '905-442-4854' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terriers' );
INSERT INTO Persons VALUES( 266 , 'Stephen' , 'Samson' , 4 , 's_samson@mail.com' , 'M' , '7/8/1971' , '466 Elison Drive' , NULL , 'Hamilton' , 'ON' , 'L2R 6N1' , '905-432-8426' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spireites' );
INSERT INTO Persons VALUES( 267 , 'Sarah' , 'Marsh' , 3 , 'smarsh@mail.com' , 'F' , '5/15/1972' , '23 Oakland Ave.' , NULL , 'Hamilton' , 'ON' , 'L9C 2S5' , '905-793-4513' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terras' );
INSERT INTO Persons VALUES( 268 , 'Pedro' , 'Kampan' , 2 , 'pedro_kampan@hotmail.com' , 'M' , '3/2/1985' , '75 Athena Dr' , NULL , 'Hamilton' , 'ON' , 'L9V 5N7' , '905-611-3202' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'glovers' );
INSERT INTO Persons VALUES( 269 , 'David' , 'Wilson' , 2 , 'david_wilson@hotmail.com' , 'M' , '10/11/1987' , '142 Folkstone Dr.' , NULL , 'Hamilton' , 'ON' , 'L8T 5N3' , '905-194-7641' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'monkeyhangers' );
INSERT INTO Persons VALUES( 270 , 'Irma' , 'Dione' , 1 , 'irmad@porchlight.ca' , 'F' , '2/6/1993' , '100 WaRRen Rd.' , NULL , 'Beamsville' , 'ON' , 'L1D 2B3' , '905-263-3059' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shakers' );
INSERT INTO Persons VALUES( 271 , 'Jane' , 'Wood' , 3 , 'jane_wood@mountaincable.net' , 'F' , '2/1/1966' , '328 Taylor Rd.' , NULL , 'Ancaster' , 'ON' , 'L8P 2J3' , '905-814-1617' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'glovers' );
INSERT INTO Persons VALUES( 272 , 'Joeseph' , 'Tennyson' , 2 , 'joesepht@rogers.com' , 'M' , '10/18/1980' , '21 East 10Th' , NULL , 'Hamilton' , 'ON' , 'L9C 4T7' , '905-727-2508' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brummagem' );
INSERT INTO Persons VALUES( 273 , 'Brenda' , 'While' , 3 , 'brendaw@hotmail.com' , 'F' , '4/2/1972' , '33 Caroline St.' , NULL , 'Hamilton' , 'ON' , 'L5M 6R1' , '905-562-5030' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bulls' );
INSERT INTO Persons VALUES( 274 , 'Lynn' , 'Conor' , 1 , 'lynnc@sympatico.ca' , 'F' , '7/8/1984' , '13 Caroline St.' , NULL , 'Hamilton' , 'ON' , 'L6L 5L3' , '905-797-4375' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cumbrians' );
INSERT INTO Persons VALUES( 275 , 'Brian' , 'Smith' , 4 , 'brians@porchlight.ca' , 'M' , '6/4/1978' , '52 Burbank Street' , NULL , 'Hamilton' , 'ON' , 'L4M 1M1' , '905-922-4198' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 276 , 'Donald' , 'Munn' , 4 , 'donaldm@email.com' , 'M' , '1/11/1969' , '50 Applewood' , NULL , 'Hamilton' , 'ON' , 'L9H 3Z2' , '905-854-1747' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'redimps' );
INSERT INTO Persons VALUES( 277 , 'Roxanne' , 'Murray' , 3 , 'roxanne_murray@home.com' , 'F' , '9/9/1974' , '73 Daniels Avenue' , NULL , 'Cambridge' , 'ON' , 'N1R 2Z9' , '519-231-5421' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'harriers' );
INSERT INTO Persons VALUES( 278 , 'Colleen' , 'Reid' , 1 , 'colleen_reid@hotmail.com' , 'F' , '6/4/1989' , '28 Park Road' , NULL , 'Orangeville' , 'ON' , 'L3M 4T9' , '905-419-8032' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cardinals' );
INSERT INTO Persons VALUES( 279 , 'George' , 'Farrell' , 4 , 'gfarrell@cogeco.ca' , 'M' , '5/4/1967' , '724 Oak St.' , NULL , 'Hamilton' , 'ON' , 'L7V 3B6' , '905-253-3478' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bulls' );
INSERT INTO Persons VALUES( 280 , 'Steven' , 'Coates' , 5 , 's.coates@netaccess.on.ca' , 'M' , '1/15/1989' , '357 Washington Avenue' , NULL , 'Hamilton' , 'ON' , 'L8P 1X5' , '905-150-8397' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hoops' );
INSERT INTO Persons VALUES( 281 , 'Isaac' , 'Sagan' , 2 , 'isaac.sagan@rogers.com' , 'M' , '12/1/1992' , '64 Welbourne Ave' , NULL , 'Hamilton' , 'ON' , 'L8H 5Y9' , '905-215-3613' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 282 , 'Margaret' , 'Wilson' , 5 , 'mwilson@netaccess.on.ca' , 'F' , '12/9/1979' , '316 Maberfoyle Dr.' , NULL , 'Hamilton' , 'ON' , 'L8M 1T4' , '905-738-6940' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'toffees' );
INSERT INTO Persons VALUES( 283 , 'Sarah' , 'Gough' , 1 , 'sarah.gough@porchlight.ca' , 'F' , '12/8/1985' , '48 Pleasant Avenue' , NULL , 'Hamilton' , 'ON' , 'L9C 4M7' , '905-934-2501' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bluebirds' );
INSERT INTO Persons VALUES( 284 , 'Tim' , 'Marks' , 4 , 'tim_marks@rogers.com' , 'M' , '11/9/1973' , '21 Heikmer Ave E.' , NULL , 'Hamilton' , 'ON' , 'L36 1Z2' , '905-352-1534' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cumbrians' );
INSERT INTO Persons VALUES( 285 , 'John' , 'Morrison' , 5 , 'jmorrison@netaccess.on.ca' , 'M' , '10/5/1984' , '17 Crocus Dr.' , NULL , 'Caledonia' , 'ON' , 'L0A 9C7' , '905-295-4574' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yidarmy' );
INSERT INTO Persons VALUES( 286 , 'Angela' , 'Page' , NULL , 'a.page@mail.com' , 'F' , '9/2/1993' , '10 Bold Road' , NULL , 'Hamilton' , 'ON' , 'L1T T4C' , '905-258-8892' , 'False' , NULL , 8 , NULL , 'True' , 'None' , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 287 , 'Henry' , 'Robinson' , 5 , 'h.robinson@mail.com' , 'M' , '12/9/1971' , '205 King Street West' , NULL , 'Oakville' , 'ON' , 'L2N 7P1' , '905-168-4986' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 288 , 'Rudy' , 'Glove' , 1 , 'r.glove@mail.com' , 'F' , '5/9/1989' , '360 Emerald Street South' , NULL , 'Hamilton' , 'ON' , 'L8K 5S7' , '905-180-7175' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 289 , 'Crawford' , 'Joan' , 3 , 'c_joan@mail.com' , 'F' , '5/18/1969' , '432 Cederdale Ave.' , NULL , 'Hamilton' , 'ON' , 'L7H 7P7' , '905-356-7353' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seasiders' );
INSERT INTO Persons VALUES( 290 , 'Sandra' , 'Johnson' , 1 , 'sjohnson@netaccess.on.ca' , 'F' , '2/12/1985' , '476 Dickson St.' , 'Apt 3' , 'Cambridge' , 'ON' , 'N2H 2J3' , '519-334-8461' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 291 , 'Philip' , 'McDonald' , 2 , 'p_mcdonald@cogeco.ca' , 'M' , '7/2/1987' , '73 Henley Drive' , NULL , 'Stoney Creek' , 'ON' , 'L8E 3T1' , '905-383-3956' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pirates' );
INSERT INTO Persons VALUES( 292 , 'Joan' , 'Martin' , 5 , 'joan.martin@mountaincable.net' , 'F' , '6/2/1980' , '2764 James St.' , NULL , 'Burlington' , 'ON' , 'L2V K55' , '905-824-8167' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blades' );
INSERT INTO Persons VALUES( 293 , 'Richard' , 'Collin' , 2 , 'r.collin@yahoo.ca' , 'M' , '4/4/1986' , '48 Wilson Ave.' , NULL , 'Milton' , 'ON' , 'L9T 2Y3' , '905-597-8997' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brummagem' );
INSERT INTO Persons VALUES( 294 , 'Steven' , 'Fields' , 2 , 'steven_fields@porchlight.ca' , 'M' , '12/11/1991' , '136 Ocean Blvd' , NULL , 'Hamilton' , 'ON' , 'L7M 2J2' , '905-876-5341' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'redimps' );
INSERT INTO Persons VALUES( 295 , 'Irene' , 'Kaur' , 5 , 'i.kaur@canada.ca' , 'F' , '10/2/1984' , '845 Barton St. E.' , NULL , 'Stoney Creek' , 'ON' , 'L8G 1B4' , '905-412-8705' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'vikings' );
INSERT INTO Persons VALUES( 296 , 'Peter' , 'Roncato' , 2 , 'p_roncato@cogeco.ca' , 'M' , '6/5/1983' , '670 Main Street West' , NULL , 'Hamilton' , 'ON' , 'L8W 5N9' , '905-192-8468' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 297 , 'Karen' , 'Gold' , 3 , 'kareng@home.com' , 'F' , '5/14/1972' , '926 East Ave' , NULL , 'St. Catharines' , 'ON' , 'L9B 1V6' , '905-627-8288' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shots' );
INSERT INTO Persons VALUES( 298 , 'Judy' , 'Watson' , 1 , 'judy_watson@hotmail.com' , 'F' , '12/10/1991' , '644 Meadow Street' , NULL , 'Hamilton' , 'ON' , 'L8P 7S6' , '905-447-3755' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 299 , 'Felicia' , 'Peterson' , 1 , 'feliciap@hotmail.com' , 'F' , '3/6/1992' , '490 Hwy #8' , NULL , 'Stoney Creek' , 'ON' , 'L8G 1G6' , '905-863-1717' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lillywhites' );
INSERT INTO Persons VALUES( 300 , 'Sue' , 'Spancer' , 1 , 'sspancer@canada.ca' , 'F' , '6/7/1989' , '10 Bamburgh Curde' , NULL , 'Hamilton' , 'ON' , 'L7W 3G7' , '905-617-3575' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 301 , 'Carol' , 'Wood' , 5 , 'cwood@canada.ca' , 'F' , '1/30/1988' , '42 Melville St.' , NULL , 'Hamilton' , 'ON' , 'L3L 2R7' , '905-316-1369' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'brummagem' );
INSERT INTO Persons VALUES( 302 , 'Robert' , 'Black' , 2 , 'r_black@mail.com' , 'M' , '3/12/1986' , '52 Walnut St.' , NULL , 'Hamilton' , 'ON' , 'L9G 1V3' , '905-381-5296' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'canaries' );
INSERT INTO Persons VALUES( 303 , 'Elizabeth' , 'Patterson' , 1 , 'e.patterson@netaccess.on.ca' , 'F' , '1/9/1980' , '42 Elgin Dr.' , NULL , 'St. Catharines' , 'ON' , 'L8R 4W2' , '905-766-3481' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 304 , 'Jocelyn' , 'Richardson' , 1 , 'j_richardson@canada.ca' , 'F' , '3/5/1980' , '644 Main Street West' , 'Apt 122' , 'Hamilton' , 'ON' , 'L5J 1Z2' , '905-807-1135' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'superhoops' );
INSERT INTO Persons VALUES( 305 , 'John' , 'Cox' , NULL , 'jcox@yahoo.ca' , 'M' , '5/6/1989' , '5 Tom St.' , NULL , 'Paris' , 'ON' , 'N3T 4T7' , '519-982-7847' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Refereed last year for first time' , 'False' , 'mariners' );
INSERT INTO Persons VALUES( 306 , 'Joe' , 'Buddy' , 4 , 'joe.buddy@porchlight.ca' , 'M' , '8/13/1975' , '132 Green St.' , NULL , 'Hamilton' , 'ON' , 'L8P 3T4' , '905-176-9006' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'quakers' );
INSERT INTO Persons VALUES( 307 , 'Helen' , 'Zaborsky' , 5 , 'helen.zaborsky@home.com' , 'F' , '1/4/1987' , '1376 Kennedy Ave.,' , NULL , 'Hamilton' , 'ON' , 'L5X 2S1' , '905-524-2299' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tractorboys' );
INSERT INTO Persons VALUES( 308 , 'Alice' , 'Cooke' , NULL , 'a.cooke@quickclic.net' , 'F' , '8/17/1968' , '123 History Lane' , NULL , 'Hamilton' , 'ON' , 'L9B 6R2' , '905-517-4101' , 'False' , NULL , 14 , NULL , 'True' , 'About 5 years' , 'False' , NULL , 'False' , 'sandgrounders' );
INSERT INTO Persons VALUES( 309 , 'Donald' , 'Watkins' , 4 , 'donald.watkins@porchlight.ca' , 'M' , '6/8/1977' , '72 Mockingbird Lane' , NULL , 'Mississauga' , 'ON' , 'L5L 2K9' , '905-235-3638' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'vikings' );
INSERT INTO Persons VALUES( 310 , 'Jean' , 'Harrow' , 5 , 'j.harrow@cogeco.ca' , 'F' , '1/31/1977' , '569 Main St W.' , NULL , 'Hamilton' , 'ON' , 'L9B 7H2' , '905-947-8001' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 311 , 'Paul' , 'Jones' , 2 , 'p.jones@quickclic.net' , 'M' , '9/18/1983' , '31 Orange Bay Crt' , NULL , 'Hamilton' , 'ON' , 'L8N 3P5' , '905-812-1353' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 312 , 'Jack' , 'Sentry' , 2 , 'j.sentry@quickclic.net' , 'M' , '5/14/1984' , '51 Renton Rd.' , NULL , 'Hamilton' , 'ON' , 'L5N 5I7' , '905-704-8149' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cardinals' );
INSERT INTO Persons VALUES( 313 , 'Keith' , 'McGulland' , NULL , 'k_mcgulland@cogeco.ca' , 'M' , '3/5/1972' , '157 Mary St. N.' , NULL , 'Hamilton' , 'ON' , 'L8K 4Z8' , '905-174-4227' , 'False' , NULL , 7 , NULL , 'True' , 'Coached last year for first time' , 'False' , NULL , 'False' , 'hoops' );
INSERT INTO Persons VALUES( 314 , 'Frank' , 'Jones' , 5 , 'f.jones@cogeco.ca' , 'M' , '4/3/1976' , '95 Main Street' , NULL , 'Hamilton' , 'ON' , 'L9C 6T5' , '905-747-5583' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimps' );
INSERT INTO Persons VALUES( 315 , 'Mary' , 'Jones' , 1 , 'mary_jones@sympatico.ca' , 'F' , '8/7/1982' , '17 Carlile St.' , NULL , 'Hamilton' , 'ON' , 'L8W 1W7' , '905-977-7219' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lilywhites' );
INSERT INTO Persons VALUES( 316 , 'Dan' , 'Heywood' , 2 , 'd_heywood@canada.ca' , 'M' , '3/14/1986' , '415 Locust St' , NULL , 'Burlington' , 'ON' , 'L7M 2J2' , '905-699-3360' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'millers' );
INSERT INTO Persons VALUES( 317 , 'Jennifer' , 'Gahan' , 1 , 'j.gahan@cogeco.ca' , 'F' , '11/4/1985' , '101 Mode Avenue' , NULL , 'Hamilton' , 'ON' , 'L6M 2Z5' , '905-333-3623' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 318 , 'Jay' , 'Jones' , 4 , 'j_jones@canada.ca' , 'M' , '1/14/1975' , '29 Valley Rd.' , NULL , 'Hamilton' , 'ON' , 'L6N 4B3' , '905-726-5015' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'swans' );
INSERT INTO Persons VALUES( 319 , 'Mark' , 'Laforme' , 5 , 'markl@sympatico.ca' , 'M' , '6/18/1986' , '28 Main Street' , NULL , 'Hamilton' , 'ON' , 'L0A 1P0' , '905-458-9661' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'addicks' );
INSERT INTO Persons VALUES( 320 , 'Todd' , 'Vanderkloet' , 4 , 'todd.vanderkloet@porchlight.ca' , 'M' , '9/11/1971' , '1068 Telfer' , NULL , 'Hamilton' , 'ON' , 'L9C 2T7' , '905-251-3366' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cobblers' );
INSERT INTO Persons VALUES( 321 , 'Gertrude' , 'Jones' , 1 , 'gertrude_jones@email.com' , 'F' , '11/7/1989' , '422 Rexdale Drive' , NULL , 'Beamsville' , 'ON' , 'L2P 6O1' , '905-742-3032' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shaymen' );
INSERT INTO Persons VALUES( 322 , 'John' , 'Tellis' , 2 , 'j_tellis@gmail.com' , 'M' , '3/9/1983' , '82 Argyle St.' , NULL , 'Hamilton' , 'ON' , 'L2O 5A0' , '905-926-4819' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gulls' );
INSERT INTO Persons VALUES( 323 , 'Manuel' , 'Nelso' , 4 , 'mnelso@quickclic.net' , 'M' , '2/2/1971' , '28 Emperor Cres' , NULL , 'Ancaster' , 'ON' , 'L8P 2Z4' , '905-509-8996' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'canaries' );
INSERT INTO Persons VALUES( 324 , 'Donna' , 'Hill' , 3 , 'd_hill@gmail.com' , 'F' , '9/3/1976' , '62 Graham Ave. S.' , NULL , 'Hamilton' , 'ON' , 'L1C 3S4' , '905-930-1450' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 325 , 'Mike' , 'Smith' , 4 , 'mikes@home.com' , 'M' , '8/31/1976' , '1670 Bloor St. E.' , NULL , 'Hamilton' , 'ON' , 'L8M 4Q2' , '905-195-6942' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hammers' );
INSERT INTO Persons VALUES( 326 , 'Dean' , 'Nocita' , 2 , 'deann@hotmail.com' , 'M' , '10/5/1986' , '77 Skyler Place' , NULL , 'Burlington' , 'ON' , 'L9A 1T3' , '905-900-1067' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gulls' );
INSERT INTO Persons VALUES( 327 , 'Jim' , 'Jones' , 5 , 'jim_jones@mountaincable.net' , 'M' , '4/8/1993' , '21 Province Street' , NULL , 'Hamilton' , 'ON' , 'L8K 2R6' , '905-604-7743' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'minstermen' );
INSERT INTO Persons VALUES( 328 , 'Sandra' , 'Browning' , 1 , 's_browning@quickclic.net' , 'F' , '6/11/1984' , '58 Oak Ave.' , NULL , 'Hamilton' , 'ON' , 'L4Z 6O2' , '905-309-7537' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 329 , 'Zoe' , 'Clark' , 5 , 'z.clark@mail.com' , 'M' , '6/10/1983' , '16 Parkview Blvd.' , NULL , 'Hamilton' , 'ON' , 'L9T 3P2' , '905-414-7365' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saddlers' );
INSERT INTO Persons VALUES( 330 , 'Sam' , 'Small' , 2 , 'ssmall@gmail.com' , 'M' , '5/17/1988' , '22 Avenue Street' , NULL , 'Hamilton' , 'ON' , 'L4G 1K8' , '905-963-8286' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrews' );
INSERT INTO Persons VALUES( 331 , 'Joan' , 'Edwards' , 3 , 'j.edwards@yahoo.ca' , 'F' , '7/16/1975' , '1250 Upper James St.' , NULL , 'Hamilton' , 'ON' , 'L4T 2X5' , '905-139-9813' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'eagles' );
INSERT INTO Persons VALUES( 332 , 'Julie' , 'McClure' , 5 , 'j_mcclure@gmail.com' , 'F' , '7/12/1992' , '214 Bentworth Dr' , NULL , 'Ancaster' , 'ON' , 'L2M 7A8' , '905-878-8144' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 333 , 'Paul' , 'Paines' , 2 , 'p.paines@gmail.com' , 'M' , '11/11/1990' , '16 Olive Avenue' , NULL , 'Stoney Creek' , 'ON' , 'L8P 4R8' , '905-614-2354' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 334 , 'Walter' , 'Lark' , 2 , 'walterl@home.com' , 'M' , '5/2/1981' , '623 Iroquois Road' , NULL , 'Niagara Falls' , 'ON' , 'L1V 3T2' , '905-253-7677' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'sandgrounders' );
INSERT INTO Persons VALUES( 335 , 'Lily' , 'Learch' , 3 , 'llearch@netaccess.on.ca' , 'F' , '4/9/1976' , '42 Governors Rd' , NULL , 'Dundas' , 'ON' , 'L8L 1L8' , '905-746-3889' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'chairboys' );
INSERT INTO Persons VALUES( 336 , 'Philip' , 'Marcos' , 2 , 'philipm@porchlight.ca' , 'M' , '9/3/1994' , '47 Rose Drive' , NULL , 'Fruitland' , 'ON' , 'L4K 3Z7' , '905-687-8629' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'citizens' );
INSERT INTO Persons VALUES( 337 , 'Troy' , 'Jenson' , 5 , 'troy.jenson@mountaincable.net' , 'M' , '6/16/1994' , '275 New Street' , NULL , 'Burlington' , 'ON' , 'L7S 2E8' , '905-707-3438' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'eagles' );
INSERT INTO Persons VALUES( 338 , 'Rick' , 'Rico' , 2 , 'rrico@yahoo.ca' , 'M' , '10/2/1985' , '3 Macadamian Drive' , NULL , 'Caledonia' , 'ON' , 'L0A 9C7' , '905-627-2100' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 339 , 'George' , 'Williams' , 2 , 'georgew@home.com' , 'M' , '6/12/1994' , '1173 Meadowbrook Ave.' , NULL , 'Ancaster' , 'ON' , 'L2K 4N7' , '905-934-8104' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gunners' );
INSERT INTO Persons VALUES( 340 , 'Tom' , 'Jones' , 2 , 'tjones@mail.com' , 'M' , '2/10/1985' , '13 Deadend Lane' , NULL , 'Hamilton' , 'ON' , 'L8N 6T7' , '905-233-8563' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'mariners' );
INSERT INTO Persons VALUES( 341 , 'Martha' , 'Sanderson' , 5 , 'msanderson@yahoo.ca' , 'F' , '10/9/1977' , '123 Main St. East' , NULL , 'Hamilton' , 'ON' , 'L2A 3B4' , '905-419-5673' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 342 , 'Michael' , 'Jones' , 5 , 'm_jones@canada.ca' , 'M' , '11/16/1994' , '32 Hester Rd.' , NULL , 'Hamilton' , 'ON' , 'L8R 3T4' , '905-703-8011' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'eagles' );
INSERT INTO Persons VALUES( 343 , 'Joanne' , 'Miller' , 5 , 'j.miller@canada.ca' , 'F' , '5/18/1978' , 'RR#6' , NULL , 'Hamilton' , 'ON' , 'L3A 3Z9' , '905-442-6168' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'dollyblues' );
INSERT INTO Persons VALUES( 344 , 'Chris' , 'Neil' , 5 , 'cneil@netaccess.on.ca' , 'M' , '7/12/1969' , '29 Baker' , NULL , 'Hamilton' , 'ON' , 'L2S 1E0' , '905-260-2966' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'fleet' );
INSERT INTO Persons VALUES( 345 , 'Jill' , 'Smith' , 1 , 'j_smith@canada.ca' , 'F' , '7/5/1989' , '11 John St. S.' , NULL , 'Hamilton' , 'ON' , 'L0Y 1X1' , '905-703-4066' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seasiders' );
INSERT INTO Persons VALUES( 346 , 'Marion' , 'Makham' , 3 , 'marion.makham@porchlight.ca' , 'F' , '5/7/1973' , '274 Danskin Lane' , NULL , 'Hamilton' , 'ON' , 'L2H 0H0' , '905-158-6666' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shots' );
INSERT INTO Persons VALUES( 347 , 'Timothy' , 'Stone' , 2 , 'timothy.stone@rogers.com' , 'M' , '9/6/1988' , '25 Kelm St N' , NULL , 'Hamilton' , 'ON' , 'L8T 3Z6' , '905-740-3417' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'railwaymen' );
INSERT INTO Persons VALUES( 348 , 'Polly' , 'Brown' , 5 , 'p_brown@gmail.com' , 'F' , '1/12/1979' , '87 Bay St S' , NULL , 'Hamilton' , 'ON' , 'L8H 1P8' , '905-220-3251' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'silkmen' );
INSERT INTO Persons VALUES( 349 , 'Jake' , 'Singer' , 4 , 'jake.singer@hotmail.com' , 'M' , '11/17/1973' , '587 Safron Street' , 'Apt 3' , 'Hamilton' , 'ON' , 'L8C 5T6' , '905-369-8272' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'sandgrounders' );
INSERT INTO Persons VALUES( 350 , 'Emily' , 'Peterson' , NULL , 'emilyp@hotmail.com' , 'F' , '7/21/1983' , '19 East 18Th Street' , NULL , 'Hamilton' , 'ON' , 'L9A 3P6' , '905-127-6169' , 'False' , NULL , 5 , NULL , 'True' , 'About 5 years' , 'False' , NULL , 'False' , 'citizens' );
INSERT INTO Persons VALUES( 351 , 'Ann-Marie' , 'Twelves' , 1 , 'ann-marie.twelves@home.com' , 'F' , '9/2/1986' , '56 Billings Ave' , NULL , 'Hamilton' , 'ON' , 'L3M 4L7' , '905-438-4598' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 352 , 'Joan' , 'Welsh' , 1 , 'joanw@sympatico.ca' , 'F' , '10/10/1989' , '74 Augusta Avenue' , NULL , 'Hamilton' , 'ON' , 'L8N 1R2' , '905-558-7735' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pirates' );
INSERT INTO Persons VALUES( 353 , 'John' , 'Smith' , 5 , 'j.smith@yahoo.ca' , 'M' , '9/8/1987' , '15 Mohawk Rd. W.' , NULL , 'Hamilton' , 'ON' , 'L8V 3V8' , '905-592-4348' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blades' );
INSERT INTO Persons VALUES( 354 , 'Charlene' , 'Brown' , 3 , 'c_brown@gmail.com' , 'F' , '11/5/1969' , '191 Chandlier Dr. E' , NULL , 'Hamilton' , 'ON' , 'L52 6I6' , '905-889-5793' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rebels' );
INSERT INTO Persons VALUES( 355 , 'Sharon' , 'Nelson' , NULL , 'sharon_nelson@mountaincable.net' , 'F' , '5/14/1967' , '183 Provinces' , NULL , 'Hamilton' , 'ON' , 'L9A 4L6' , '905-717-7418' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Refereed last year for first time' , 'False' , 'spurs' );
INSERT INTO Persons VALUES( 356 , 'Randy' , 'Carr' , 2 , 'rcarr@canada.ca' , 'M' , '11/4/1983' , '27 Mayhurst Ave.' , NULL , 'Hamilton' , 'ON' , 'L8M 3K7' , '905-196-7406' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'grecians' );
INSERT INTO Persons VALUES( 357 , 'Craig' , 'Ariss' , 2 , 'craig_ariss@home.com' , 'M' , '8/16/1991' , '48 Polyword Dr' , NULL , 'Ancaster' , 'ON' , 'L8P 2J3' , '905-670-1543' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hornets' );
INSERT INTO Persons VALUES( 358 , 'Susan' , 'Thomas' , 3 , 's.thomas@quickclic.net' , 'F' , '7/12/1971' , '21 Dune St.' , NULL , 'Hamilton' , 'ON' , 'L9V 4A2' , '905-645-2691' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimps' );
INSERT INTO Persons VALUES( 359 , 'Christopher' , 'Clavin' , 2 , 'christopher_clavin@porchlight.ca' , 'M' , '1/12/1985' , '14 Walnut Cres.' , NULL , 'Hamilton' , 'ON' , 'L8T 1Z4' , '905-622-7924' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'redimps' );
INSERT INTO Persons VALUES( 360 , 'William' , 'Bailey' , 5 , 'w.bailey@cogeco.ca' , 'M' , '6/18/1974' , 'RR 1' , NULL , 'Dundas' , 'ON' , 'L2K 1S1' , '905-400-3618' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimps' );
INSERT INTO Persons VALUES( 361 , 'Ranjit' , 'Shammit' , NULL , 'ranjit_shammit@hotmail.com' , 'M' , '3/24/1957' , '20 Lairs Lane' , NULL , 'Burlington' , 'ON' , 'L9C 7S8' , '905-901-6116' , 'False' , NULL , 20 , NULL , 'True' , 'Coached kids' , 'False' , NULL , 'False' , 'pompey' );
INSERT INTO Persons VALUES( 362 , 'Joyce' , 'Simpson' , 3 , 'joyce_simpson@hotmail.com' , 'F' , '1/3/1978' , '129 Irwin' , NULL , 'Burlington' , 'ON' , 'L5J 1Z6' , '905-916-3757' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'valiants' );
INSERT INTO Persons VALUES( 363 , 'Phipps' , 'Poe' , 5 , 'phipps.poe@hotmail.com' , 'F' , '6/14/1993' , '20 Monk St. E.' , NULL , 'Hamilton' , 'ON' , 'L8Z 2B6' , '905-374-6585' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'railwaymen' );
INSERT INTO Persons VALUES( 364 , 'Maude' , 'Ross' , 5 , 'maude_ross@email.com' , 'F' , '6/5/1983' , '159 Sunhaven Bldv' , NULL , 'Hamilton' , 'ON' , 'L8V 1G2' , '905-620-8422' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'royals' );
INSERT INTO Persons VALUES( 365 , 'Bill' , 'Watson' , 2 , 'billw@sympatico.ca' , 'M' , '11/12/1983' , '220 Main Street' , NULL , 'Hamilton' , 'ON' , 'L8P 1J1' , '905-955-4210' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blades' );
INSERT INTO Persons VALUES( 366 , 'Hillary' , 'Brown' , 3 , 'h.brown@gmail.com' , 'F' , '10/15/1970' , '45 Bluebird Ave.' , NULL , 'Hamilton' , 'ON' , 'L6A 4W3' , '905-783-7450' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'yellows' );
INSERT INTO Persons VALUES( 367 , 'Andrea' , 'Robinson' , 1 , 'a_robinson@yahoo.ca' , 'F' , '9/9/1984' , '162 Margaret Street' , NULL , 'Ancaster' , 'ON' , 'L8P 2J3' , '905-599-5091' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 368 , 'Elizabeth' , 'Manley' , 1 , 'e_manley@quickclic.net' , 'F' , '3/6/1988' , '2040 Roxanne Drive' , NULL , 'Hamilton' , 'ON' , 'L9C 2K3' , '905-777-8197' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'diamonds' );
INSERT INTO Persons VALUES( 369 , 'Brandon' , 'Florence' , 4 , 'brandonf@rogers.com' , 'M' , '11/3/1973' , '240 Duke Street East' , NULL , 'Hamilton' , 'ON' , 'L9Z 6A7' , '905-360-6317' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'chairboys' );
INSERT INTO Persons VALUES( 370 , 'Jeanie' , 'Selva' , 3 , 'jeanie_selva@home.com' , 'F' , '12/10/1975' , '20 Mountain Ave. S.' , NULL , 'Stoney Creek' , 'ON' , 'L8G 3T3' , '905-716-4456' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'redimps' );
INSERT INTO Persons VALUES( 371 , 'Matthew' , 'Shaw' , 4 , 'matthew.shaw@sympatico.ca' , 'M' , '4/7/1969' , '115 Upper Gave Ave.' , NULL , 'Hamilton' , 'ON' , 'L8V 1N7' , '905-198-5470' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terras' );
INSERT INTO Persons VALUES( 372 , 'Mary' , 'Henderson' , 5 , 'm.henderson@mail.com' , 'F' , '1/30/1974' , '49 Single Ave. N' , NULL , 'Hamilton' , 'ON' , 'L8L 5K2' , '905-961-9379' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 373 , 'Bell' , 'George' , 4 , 'b_george@cogeco.ca' , 'M' , '3/4/1976' , '4 Broad St.' , NULL , 'Hamilton' , 'ON' , 'L8G 2V1' , '905-774-1991' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 374 , 'Bryan' , 'Oom' , 5 , 'boom@mail.com' , 'M' , '8/6/1971' , '276 Main St.' , NULL , 'Beamsville' , 'ON' , 'L4K 2A3' , '905-866-9129' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 375 , 'Andrew' , 'Windsor' , 4 , 'a.windsor@netaccess.on.ca' , 'M' , '8/1/1976' , '11 FeRRis Street' , NULL , 'Hamilton' , 'ON' , 'L8N 3B2' , '905-179-8740' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'canaries' );
INSERT INTO Persons VALUES( 376 , 'Juhn' , 'Wild' , 5 , 'juhn.wild@rogers.com' , 'M' , '12/11/1968' , '638 King St. W.' , NULL , 'Hamilton' , 'ON' , 'L8G 1P1' , '905-652-7136' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimps' );
INSERT INTO Persons VALUES( 377 , 'John' , 'Carter' , 4 , 'j.carter@mail.com' , 'M' , '4/6/1978' , '171 Victor Boulevard' , NULL , 'Hamilton' , 'ON' , 'L9C 4V1' , '905-929-9808' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 378 , 'James' , 'Morrison' , 4 , 'j_morrison@gmail.com' , 'M' , '12/1/1969' , '31 St Augustine Ave.' , NULL , 'Hamilton' , 'ON' , 'L8S 6H1' , '905-691-2709' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'baggies' );
INSERT INTO Persons VALUES( 379 , 'William' , 'Fold' , 5 , 'w_fold@mail.com' , 'M' , '3/5/1986' , '1121 Stonechurch' , NULL , 'Hamilton' , 'ON' , 'L9C 101' , '905-294-8833' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'seasiders' );
INSERT INTO Persons VALUES( 380 , 'Thelma' , 'Troy' , 1 , 'ttroy@gmail.com' , 'F' , '1/30/1981' , '111 Main Street' , NULL , 'Hamilton' , 'ON' , 'L8P 3B7' , '905-726-5329' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lambs' );
INSERT INTO Persons VALUES( 381 , 'Mark' , 'Carmen' , 4 , 'm.carmen@canada.ca' , 'M' , '7/10/1977' , '93 Walker Drive' , NULL , 'Cambridge' , 'ON' , 'N1R 6Z8' , '519-759-7931' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddragons' );
INSERT INTO Persons VALUES( 382 , 'Alfred' , 'Foneboneski' , 5 , 'afoneboneski@cogeco.ca' , 'M' , '6/17/1972' , '23 Main Street' , NULL , 'Beamsville' , 'ON' , 'L5B 7YR' , '905-444-5680' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'spireites' );
INSERT INTO Persons VALUES( 383 , 'Amanda' , 'Green' , 3 , 'amanda_green@email.com' , 'F' , '4/13/1971' , '77 Avondale Lane' , NULL , 'Ancaster' , 'ON' , 'L2K 4N7' , '905-746-3502' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'foxes' );
INSERT INTO Persons VALUES( 384 , 'Genna' , 'Lewis' , 5 , 'g_lewis@yahoo.ca' , 'F' , '1/5/1973' , '111B Baker St.' , NULL , 'Burlington' , 'ON' , 'L8B 1R7' , '905-743-7870' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddevils' );
INSERT INTO Persons VALUES( 385 , 'Stephanie' , 'Cronos' , 3 , 'stephaniec@porchlight.ca' , 'F' , '12/9/1967' , '4427 Duxbury Court' , NULL , 'Hamilton' , 'ON' , 'L9J 2T6' , '905-725-9293' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'valiants' );
INSERT INTO Persons VALUES( 386 , 'Maria' , 'Jones' , NULL , 'mariaj@home.com' , 'F' , '7/8/1986' , '29 Parkville Road' , NULL , 'Grimsby' , 'ON' , 'L0M 1G0' , '905-670-3255' , 'False' , NULL , 16 , NULL , 'True' , 'None' , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 387 , 'Edgar' , 'Case' , 2 , 'edgar.case@hotmail.com' , 'M' , '1/19/1991' , '791 King Rd.' , NULL , 'Burlington' , 'ON' , 'L2G 4N5' , '905-882-9414' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hoops' );
INSERT INTO Persons VALUES( 388 , 'John' , 'Williams' , 2 , 'johnw@hotmail.com' , 'M' , '5/11/1981' , '241 Main St. E.' , NULL , 'Hamilton' , 'ON' , 'L8T 3X7' , '905-432-3713' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrimpers' );
INSERT INTO Persons VALUES( 389 , 'Ellen' , 'Marshall' , 1 , 'emarshall@mail.com' , 'F' , '6/15/1990' , '304 East 16Th Street' , NULL , 'Hamilton' , 'ON' , 'L8V 3Z6' , '905-895-1490' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terriers' );
INSERT INTO Persons VALUES( 390 , 'Roland' , 'James' , NULL , 'rjames@netaccess.on.ca' , 'M' , '8/6/1965' , '316 Westaway Dr.' , NULL , 'Brantford' , 'ON' , 'N8C 2S4' , '519-389-8954' , 'False' , NULL , 3 , NULL , 'True' , 'About 5 years' , 'False' , NULL , 'False' , 'baggies' );
INSERT INTO Persons VALUES( 391 , 'Rene' , 'Lachance' , 4 , 'rlachance@netaccess.on.ca' , 'M' , '7/10/1968' , '1531 Bold Street' , NULL , 'Hamilton' , 'ON' , 'L8P 3S4' , '905-770-9870' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'royals' );
INSERT INTO Persons VALUES( 392 , 'Joslin' , 'Springer' , 3 , 'joslin_springer@home.com' , 'F' , '4/4/1973' , '14 Crockett St.' , NULL , 'Hamilton' , 'ON' , 'L1B 4C0' , '905-241-9974' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'minstermen' );
INSERT INTO Persons VALUES( 393 , 'Mark' , 'Hamilton' , 4 , 'mark.hamilton@email.com' , 'M' , '9/4/1975' , '1241 Geneva Crs' , NULL , 'Stainer' , 'ON' , 'L3G 4G8' , '905-127-1488' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cumbrians' );
INSERT INTO Persons VALUES( 394 , 'Kate' , 'Mary' , 3 , 'kmary@mail.com' , 'F' , '4/6/1970' , '83 York St' , NULL , 'Hamilton' , 'ON' , 'L8T 2C7' , '905-649-8173' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 395 , 'Elizabeth' , 'Quinn' , 1 , 'elizabethq@sympatico.ca' , 'F' , '10/9/1987' , '1 Chester Place' , NULL , 'Hamilton' , 'ON' , 'L8G 4K9' , '905-901-6001' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'rovers' );
INSERT INTO Persons VALUES( 396 , 'Ken' , 'Rogers' , 4 , 'kenr@email.com' , 'M' , '8/11/1971' , '32 John Street West' , NULL , 'Hamilton' , 'ON' , 'L2T 2P4' , '905-536-7597' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'valiants' );
INSERT INTO Persons VALUES( 397 , 'Jeremy' , 'Smith' , 4 , 'j.smith@cogeco.ca' , 'M' , '5/11/1967' , '692 Queen St.' , NULL , 'Burlington' , 'ON' , 'L7G 1F2' , '905-756-9060' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hoops' );
INSERT INTO Persons VALUES( 398 , 'Mary' , 'MacKenzie' , 1 , 'marym@sympatico.ca' , 'F' , '11/7/1986' , '74 Carmichael Dr.' , NULL , 'Hamilton' , 'ON' , 'L8C 423' , '905-254-7587' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 399 , 'Patrick' , 'Meorschfelder' , 4 , 'pmeorschfelder@yahoo.ca' , 'M' , '1/31/1968' , '67 Pleasant Avenue' , NULL , 'Burlington' , 'ON' , 'L3N 6H5' , '905-695-4131' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stags' );
INSERT INTO Persons VALUES( 400 , 'David' , 'James' , 5 , 'd.james@cogeco.ca' , 'M' , '7/3/1989' , '14 Landsdown Ct.' , NULL , 'Hamilton' , 'ON' , 'L0R 1H2' , '905-389-1970' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lions' );
INSERT INTO Persons VALUES( 401 , 'Barry' , 'Kowalski' , 5 , 'barry.kowalski@mountaincable.net' , 'M' , '3/16/1977' , '383 Cardinal Ave' , NULL , 'Hamilton' , 'ON' , 'L9C 6A3' , '905-371-9385' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bantams' );
INSERT INTO Persons VALUES( 402 , 'Kelly' , 'Bowman' , 3 , 'kelly_bowman@sympatico.ca' , 'F' , '2/11/1972' , '2207 Kentmere Dr' , NULL , 'Burlington' , 'ON' , 'L8M 6X3' , '905-908-7145' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'latics' );
INSERT INTO Persons VALUES( 403 , 'Polly' , 'Postpartum' , 1 , 'ppostpartum@netaccess.on.ca' , 'F' , '4/12/1983' , '25 Screech Street' , NULL , 'Hamilton' , 'ON' , 'L8T 5A3' , '905-270-6498' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 404 , 'Andrea' , 'Brown' , 3 , 'andreab@home.com' , 'F' , '7/15/1969' , '235 King St. W.' , NULL , 'Hamilton' , 'ON' , 'L9C 2S5' , '905-676-6428' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pensioners' );
INSERT INTO Persons VALUES( 405 , 'Marianna' , 'Talbott' , 1 , 'm.talbott@yahoo.ca' , 'F' , '12/13/1984' , '19 Prince Phillip Dr' , NULL , 'Ancaster' , 'ON' , 'L4N 1P5' , '905-266-3250' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pompey' );
INSERT INTO Persons VALUES( 406 , 'Murieles' , 'Kolla' , 3 , 'm.kolla@mail.com' , 'F' , '6/12/1967' , '27 Applewood Dr. S.W.' , NULL , 'Dunnville' , 'ON' , 'L4T 7B5' , '905-798-8675' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 407 , 'Mark' , 'Johnson' , 2 , 'mjohnson@gmail.com' , 'M' , '10/8/1980' , '95 Goldsmith Drive' , NULL , 'Hamilton' , 'ON' , 'L5V 2L6' , '905-538-8643' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tigers' );
INSERT INTO Persons VALUES( 408 , 'Sally' , 'Feldman' , 5 , 's.feldman@quickclic.net' , 'F' , '3/9/1993' , '200 Grass Rd' , NULL , 'Hamilton' , 'ON' , 'L8N 3P5' , '905-515-5447' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'potters' );
INSERT INTO Persons VALUES( 409 , 'Fred' , 'Jones' , 2 , 'fred_jones@mountaincable.net' , 'M' , '12/4/1985' , '20 King Street W' , NULL , 'Hamilton' , 'ON' , 'L8L 2Y8' , '905-104-7102' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 410 , 'Casandra' , 'Williams' , 1 , 'c.williams@netaccess.on.ca' , 'F' , '12/9/1984' , '2 Vacation Lane' , NULL , 'Smithville' , 'ON' , 'L6T 6X9' , '905-684-3317' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gills' );
INSERT INTO Persons VALUES( 411 , 'Ken' , 'Barbarino' , 2 , 'ken_barbarino@sympatico.ca' , 'M' , '11/4/1992' , '18 Krafty Crt' , NULL , 'Hamilton' , 'ON' , 'L9B 2K4' , '905-576-2375' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shots' );
INSERT INTO Persons VALUES( 412 , 'Robert' , 'Scott' , 4 , 'r.scott@canada.ca' , 'M' , '10/18/1968' , '57 Lawfield Drive' , NULL , 'Hamilton' , 'ON' , 'L8P 4C6' , '905-806-8120' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hatters' );
INSERT INTO Persons VALUES( 413 , 'Herb' , 'Black' , 4 , 'h_black@yahoo.ca' , 'M' , '3/5/1968' , '24 Henderson Rd.' , NULL , 'Burlington' , 'ON' , 'L7X 2B5' , '905-400-9976' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'hornets' );
INSERT INTO Persons VALUES( 414 , 'Terry' , 'Eden' , 3 , 'teden@quickclic.net' , 'F' , '11/12/1966' , '36 Paris Avenue' , NULL , 'Hamilton' , 'ON' , 'L8T 5A3' , '905-767-1878' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 415 , 'Irene' , 'McClure' , 5 , 'irene_mcclure@mountaincable.net' , 'F' , '9/17/1975' , '214 Bentworth Dr' , NULL , 'Ancaster' , 'ON' , 'L2M 7A8' , '905-541-4359' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'blues' );
INSERT INTO Persons VALUES( 416 , 'Joe' , 'Beaton' , 4 , 'jbeaton@gmail.com' , 'M' , '7/2/1968' , '14 Fraser Street' , NULL , 'Hamilton' , 'ON' , 'L5Z 6I6' , '905-957-5186' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'skyblues' );
INSERT INTO Persons VALUES( 417 , 'Smith' , 'Margaret' , 1 , 'smith_margaret@mountaincable.net' , 'F' , '6/8/1993' , '542 Laneway Drive' , NULL , 'Hamilton' , 'ON' , 'L0R 1L0' , '905-125-8190' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 418 , 'May' , 'Simdos' , 1 , 'may.simdos@sympatico.ca' , 'F' , '11/18/1990' , '731 Hantingtons Dr' , 'Apt 203' , 'Stoney Creek' , 'ON' , 'L7L 5A4' , '905-426-7745' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'clarets' );
INSERT INTO Persons VALUES( 419 , 'John' , 'Adamson' , 2 , 'j_adamson@mail.com' , 'M' , '4/15/1981' , '203 Golflink Road' , NULL , 'Brantford' , 'ON' , 'N7E 7H0' , '519-148-8664' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shaymen' );
INSERT INTO Persons VALUES( 420 , 'Phyllisk' , 'Lloyd' , 1 , 'p.lloyd@quickclic.net' , 'F' , '7/17/1984' , '140 King Street East' , NULL , 'Dundas' , 'ON' , 'L8N 3G1' , '905-175-2200' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'daggers' );
INSERT INTO Persons VALUES( 421 , 'Jerry' , 'Smith' , 4 , 'jerry.smith@email.com' , 'M' , '7/10/1974' , '10 Queen Victoria' , NULL , 'Hamilton' , 'ON' , 'L8D 213' , '905-815-4571' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saints' );
INSERT INTO Persons VALUES( 422 , 'Fred' , 'Jones' , 2 , 'fred_jones@mountaincable.net' , 'M' , '3/1/1989' , '27 Welsley St.' , NULL , 'Hamilton' , 'ON' , 'L7C 5G4' , '905-437-8513' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shrews' );
INSERT INTO Persons VALUES( 423 , 'Mark' , 'Jones' , 4 , 'mjones@canada.ca' , 'M' , '12/9/1971' , '112 Green St' , NULL , 'Hamilton' , 'ON' , 'L9A 1G4' , '905-510-7689' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'swans' );
INSERT INTO Persons VALUES( 424 , 'Gabriella' , 'Giatony' , 3 , 'gabriella_giatony@sympatico.ca' , 'F' , '10/4/1968' , '1367 Balton Place' , NULL , 'Dundas' , 'ON' , 'L3D 6G9' , '905-134-3618' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'riversiders' );
INSERT INTO Persons VALUES( 425 , 'Martha' , 'Dumont' , 3 , 'martha.dumont@rogers.com' , 'F' , '1/1/1977' , '664 Breechwood' , NULL , 'Hamilton' , 'ON' , 'L6L 3V9' , '905-567-4717' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'magpies' );
INSERT INTO Persons VALUES( 426 , 'David' , 'Clark' , 2 , 'david.clark@mountaincable.net' , 'M' , '2/12/1989' , '182 Meadowlark Ave.' , NULL , 'Oakville' , 'ON' , 'L3Z 5G7' , '905-961-4001' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'reddragons' );
INSERT INTO Persons VALUES( 427 , 'Stan' , 'Wilkin' , 2 , 'stan_wilkin@hotmail.com' , 'M' , '10/14/1993' , '27 Young St.' , NULL , 'Hamilton' , 'ON' , 'L5H 9B6' , '905-208-9037' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pompey' );
INSERT INTO Persons VALUES( 428 , 'Andrea' , 'Wilson' , 1 , 'andrea_wilson@porchlight.ca' , 'F' , '5/8/1994' , '111 Main Street W' , NULL , 'Hamilton' , 'ON' , 'L8N 1K1' , '905-632-1025' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'stanley' );
INSERT INTO Persons VALUES( 429 , 'Michelle' , 'Mutt' , 1 , 'michellem@mountaincable.net' , 'F' , '4/15/1981' , '37 Lake St.' , NULL , 'Hamilton' , 'ON' , 'L9A 1G6' , '905-455-2916' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'robins' );
INSERT INTO Persons VALUES( 430 , 'Joe' , 'Smith' , 4 , 'joe.smith@home.com' , 'M' , '4/13/1975' , '50 Redcar Street' , NULL , 'Burlington' , 'ON' , 'L7T 4H3' , '905-336-4743' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'bantams' );
INSERT INTO Persons VALUES( 431 , 'Tim' , 'Jones' , 2 , 'tim_jones@rogers.com' , 'M' , '7/7/1987' , '21 Young St' , 'Apt. 4' , 'Hamilton' , 'ON' , 'L6H 4J1' , '905-297-8258' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'saddlers' );
INSERT INTO Persons VALUES( 432 , 'Karen' , 'Lynn' , 1 , 'klynn@yahoo.ca' , 'F' , '1/3/1984' , '21-4-East 21' , NULL , 'Hamilton' , 'ON' , 'L8P 1K4' , '905-604-2172' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gills' );
INSERT INTO Persons VALUES( 433 , 'Ken' , 'Kesey' , 2 , 'ken.kesey@home.com' , 'M' , '5/16/1987' , '154 Lakeside Dr.' , NULL , 'Hamilton' , 'ON' , 'L8L 1Z6' , '905-489-5733' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'potters' );
INSERT INTO Persons VALUES( 434 , 'Florence' , 'Henderson' , 1 , 'florence.henderson@home.com' , 'F' , '11/1/1994' , '56 Daisy Lane' , NULL , 'Hamilton' , 'ON' , 'LKJ 4P3' , '905-793-1076' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'glovers' );
INSERT INTO Persons VALUES( 435 , 'Santos' , 'Scott' , NULL , 'santoss@hotmail.com' , 'M' , '2/3/1973' , '127 Belle Court' , NULL , 'Hamilton' , 'ON' , 'L8H 5Y9' , '905-464-9568' , 'False' , NULL , 13 , NULL , 'True' , 'None' , 'False' , NULL , 'False' , 'irons' );
INSERT INTO Persons VALUES( 436 , 'Linda' , 'Wright' , 5 , 'linda.wright@home.com' , 'F' , '12/4/1976' , '93 Anna Capri' , NULL , 'Hamilton' , 'ON' , 'L9A 3T2' , '905-780-9744' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'vikings' );
INSERT INTO Persons VALUES( 437 , 'Craig' , 'Campbell' , 4 , 'craig.campbell@mountaincable.net' , 'M' , '7/16/1970' , '100 Lake Road' , NULL , 'Hamilton' , 'ON' , 'L8L 2T2' , '905-875-5248' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'terras' );
INSERT INTO Persons VALUES( 438 , 'Marcos' , 'Philip' , 2 , 'mphilip@yahoo.ca' , 'M' , '7/10/1980' , '47 Rose Drive' , NULL , 'Fruitland' , 'ON' , 'L4K 3Z7' , '905-804-7702' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'tractorboys' );
INSERT INTO Persons VALUES( 439 , 'Jonah' , 'Jameson' , NULL , 'j.jameson@canada.ca' , 'M' , '10/14/1963' , '145 St. Martins Ave. W.' , NULL , 'St. Catharines' , 'ON' , 'L4B 3T3' , '905-304-3593' , 'False' , NULL , NULL , NULL , 'False' , NULL , 'True' , 'Provincially certified' , 'False' , 'cherries' );
INSERT INTO Persons VALUES( 440 , 'Jean' , 'May' , 3 , 'jean.may@mountaincable.net' , 'F' , '1/19/1972' , '134 Main St.' , NULL , 'Hamilton' , 'ON' , 'LQ3 49P' , '905-601-5630' , 'True' , 'D' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'shaymen' );
INSERT INTO Persons VALUES( 441 , 'Jessica' , 'Jones' , 3 , 'jessicaj@hotmail.com' , 'F' , '3/11/1974' , '213 Proctor St.' , NULL , 'Hamilton' , 'ON' , 'L2N 6A8' , '905-677-5458' , 'True' , 'C' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'cardinals' );
INSERT INTO Persons VALUES( 442 , 'Adrienne' , 'Salsh' , 1 , 'adrienne_salsh@rogers.com' , 'F' , '10/18/1992' , '2225 Elmwood Ave.' , NULL , 'Burlington' , 'ON' , 'L4C 5W5' , '905-824-9436' , 'True' , 'A' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'pilgrims' );
INSERT INTO Persons VALUES( 443 , 'Mary' , 'Lester' , 3 , 'mary.lester@sympatico.ca' , 'F' , '5/17/1966' , '83 King St. W.' , 'Apt 2' , 'Hamilton' , 'ON' , 'L8K 9J4' , '905-335-1978' , 'True' , 'E' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'lions' );
INSERT INTO Persons VALUES( 444 , 'Joan' , 'Teal' , NULL , 'joant@mountaincable.net' , 'F' , '10/23/1971' , '36 Main Street North' , NULL , 'Cambridge' , 'ON' , 'N9C 2X9' , '519-256-9273' , 'False' , NULL , 2 , NULL , 'True' , 'Coached last year for first time' , 'False' , NULL , 'False' , 'terras' );
INSERT INTO Persons VALUES( 445 , 'Sam' , 'Smith' , 2 , 's.smith@cogeco.ca' , 'M' , '6/14/1993' , '33 Baillie Street' , NULL , 'Hamilton' , 'ON' , 'L8N 2K6' , '905-568-2881' , 'True' , 'B' , NULL , NULL , 'False' , NULL , 'False' , NULL , 'False' , 'gills' );
GO
