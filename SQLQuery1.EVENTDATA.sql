CREATE DATABASE EventsDATA

USE EventsDATA

CREATE TABLE Cities
(
Id INT CONSTRAINT PK_CT_ID PRIMARY KEY IDENTITY,
NAME NVARCHAR(20) NOT NULL
)

INSERT INTO Cities
VALUES
('Baki'),
('Istanbul'),
('Ankara'),
('Minsk'),
('Tbilisi'),
('Kiev')


CREATE TABLE [Events]
(
Id INT CONSTRAINT PK_EVENT_ID PRIMARY KEY IDENTITY,
NAME NVARCHAR(20) NOT NULL,
CityId INT NOT NULL CONSTRAINT FK_Event_CTID FOREIGN KEY REFERENCES Cities(Id),
StartDate DATETIME2 NOT NULL,
EndDate DATETIME2 NOT NULL
)

INSERT INTO [Events]
VALUES
('Novruz Tedbiri', 1, '2020-03-20', '2020-03-24'),
(N'Müstəqillik Günü',2, '2022-11-06', '2022-11-07'),
('Yeni il',3, '2021-01-01', '2021-01-02'),
('İstanbul Maratonu',4, '2019-11-09', '2019-11-13'),
(N'Zəfər Günü',5, '2022-11-08', '2022-11-10'),
(N'Hərbi Donanma Günü',6, '2022-11-15', '2022-11-16')


CREATE TABLE Speakers
(
Id INT CONSTRAINT PK_SPK_ID PRIMARY KEY IDENTITY,
FullName NVARCHAR(35) NOT NULL,
)

INSERT INTO Speakers
VALUES
('Hesen Eliyev'),
('Ramiz Ramizov'),
('Elcin Sirinov'),
('Eldar Musayev'),
('Guler Solmazova'),
('Gulnar Agayeva'),
('Fidan Muradova'),
('Semed Zeynalov')

CREATE TABLE EventSpeakers
(
Id INT CONSTRAINT PK_EventSpk_ID PRIMARY KEY IDENTITY,
SpeakerId INT NOT NULL CONSTRAINT FK_EventSpk_SpeakerID FOREIGN KEY REFERENCES Speakers(Id),
EventId INT NOT NULL CONSTRAINT FK_EventSpk_EventID FOREIGN KEY REFERENCES [Events](Id),
)

INSERT INTO EventSpeakers
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(4,1),
(5,2),
(1,3),
(4,5),
(2,4),
(3,6),
(1,6),
(3,5),
(7,4),
(8,2)


SELECT * FROM Cities
SELECT * FROM [Events]
SELECT * FROM Speakers
SELECT * FROM EventSpeakers

SELECT E.NAME, E.StartDate, E.EndDate, Cities.NAME, (SELECT DATEDIFF(MINUTE, StartDate, EndDate)) AS 'Bas Tutma Muddeti', 
(SELECT COUNT(Id) FROM EventSpeakers WHERE EventId=E.Id) AS 'SpeakersCount' FROM [Events] AS E 
JOIN Cities ON E.CityId=Cities.Id

SELECT *, (SELECT DATEDIFF(MINUTE, StartDate, EndDate)) AS 'Bas Tutma Muddeti', 
(SELECT COUNT(Id) FROM EventSpeakers WHERE EventId=E.Id) AS 'SpeakersCount' FROM [Events] AS E 
JOIN Cities ON E.CityId=Cities.Id

CREATE PROCEDURE SelectEvent @StartDt DATETIME2, @EndDt DATETIME2
AS
SELECT * FROM [Events] WHERE StartDate = @StartDt AND EndDate = @EndDt

EXEC SelectEvent '2022-11-08', '2022-11-10'

CREATE VIEW EventsData
AS
(SELECT E.NAME AS 'Event Name', E.StartDate, E.EndDate, Cities.NAME AS 'City Name', 
(SELECT COUNT(Id) FROM EventSpeakers WHERE EventId=E.Id) AS 'SpeakersCount' FROM [Events] AS E 
JOIN Cities ON E.CityId=Cities.Id
WHERE YEAR(StartDate) = YEAR(DATEADD(YEAR,0,GETDATE())))


SELECT * FROM EventsData

DROP VIEW EventsData

CREATE PROCEDURE CreateNewCity @CityName NVARCHAR(20)
AS
INSERT INTO Cities
VALUES (@CityName)

EXEC CreateNewCity 'Barcelona'

DELETE FROM Cities WHERE NAME='semnsd'

UPDATE Cities
SET NAME='Kiev'
WHERE CITIES.Id=7



SELECT CityId, COUNT(Id) AS 'CountEvent' FROM [Events]
GROUP BY CityId
HAVING COUNT(Id)>0



SELECT *, (SELECT COUNT(Id) FROM EventSpeakers WHERE SpeakerId=E.Id) AS 'EventCount' FROM Speakers AS E 