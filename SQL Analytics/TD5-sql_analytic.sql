/*QUESTION 1*/
CREATE DATABASE IF NOT EXISTS `CielBleu`;
USE `CielBleu`;

DROP TABLE IF EXISTS `Reservation`;
DROP TABLE IF EXISTS `Adherent`;
DROP TABLE IF EXISTS `Voyage`;
DROP TABLE IF EXISTS `Temps`;


Create table Adherent (
numA integer not null,  
nom   varchar(45) NOT NULL,
prenom   varchar(45) NOT NULL,
villeA  varchar(45) DEFAULT NULL,
cotA   varchar(45) DEFAULT NULL,
CONSTRAINT pk_numA PRIMARY KEY(numA));

INSERT INTO Adherent values (1, 'Dubois', 'Jean', 'PARIS', 2);
INSERT INTO Adherent values (2, 'LEGRAND', 'EMILIE', 'LYON', 3);
INSERT INTO Adherent values (3, 'Tuche', 'Jean', 'MARSEILLE', 4);
INSERT INTO Adherent values (4, 'Caret', 'Sangoku', 'NAMET', 5);
INSERT INTO Adherent values (5, 'Navy', 'Zelda', 'NAMET', 2);
INSERT INTO Adherent values (6, 'LELOUCH', 'Jule', 'LYON', 3);
INSERT INTO Adherent values (7, 'Malika', 'Tristan', 'MARSEILLE', 4);
INSERT INTO Adherent values (8, 'Loue', 'Krys', 'NAMET', 5);

DROP TABLE IF EXISTS `Voyage`;
CREATE TABLE Voyage (
refV integer NOT NULL, 
destV   varchar(45) NOT NULL,
dureeV   integer NOT NULL,
typeV   varchar(45) NOT NULL,
CONSTRAINT pk_refV PRIMARY KEY (refV) );

INSERT INTO Voyage values (1, 'Moscou', 1, 'Noce');
INSERT INTO Voyage values (2, 'Londres', 2, 'Affaire');
INSERT INTO Voyage values (3, 'Moscou', 3, 'Noce');
INSERT INTO Voyage values (4, 'Londres', 4, 'Affaire');

CREATE TABLE Temps (
numT integer NOT NULL,
dated integer NOT NULL,
mois integer NOT NULL,
annee integer NOT NULL,
CONSTRAINT PK_NumT  PRIMARY KEY (NumT));

INSERT INTO Temps values (1, '12', '11', '2010');
INSERT INTO Temps values (2, '13', '02', '2010');
INSERT INTO Temps values (3, '22', '11', '1995');
INSERT INTO Temps values (4, '28', '28', '1995');

CREATE TABLE   Reservation (
nDossier   integer NOT NULL,
numA  integer NOT NULL,
refV    integer NOT NULL,
numT    integer NOT NULL,
accompte    integer NOT NULL,
CONSTRAINT PK_Dos  PRIMARY KEY (nDossier),
Constraint FK_Adh Foreign key (numA) references Adherent(numA),
Constraint FK_Voy Foreign key (refV) references Voyage(refV),
Constraint FK_Tps Foreign key (numT) references Temps(numT));

INSERT INTO Reservation values (1, 1, 1, 1, 5000);
INSERT INTO Reservation values (2, 2, 2, 2, 1000);
INSERT INTO Reservation values (3, 3, 3, 3, 8000);
INSERT INTO Reservation values (4, 4, 4, 4, 2000);
INSERT INTO Reservation values (5, 1, 1, 1, 1200);
INSERT INTO Reservation values (6, 2, 2, 2, 3000);
INSERT INTO Reservation values (7, 3, 3, 3, 6000);
INSERT INTO Reservation values (8, 4, 4, 4, 7000);


/*QUESTION 2*/
	/*a)Quel est le nombre de réservations par adhérent.*/
		SELECT numA, Count(*)
        FROM Reservation 
        GROUP BY numA;
    /*b)Quel est le nombre de réservations pour chaque mois de l'année 2010*/
		SELECT t.mois, t.annee, count(nDossier) 
        FROM Reservation r 
        JOIN Temps t ON t.numT=r.numT WHERE t.annee=2010 
        GROUP BY t.mois;
    /*c)Quel est le nombre de réservations par durée de voyage.*/
		SELECT v.dureeV, count(nDossier) 
        FROM Reservation r 
        JOIN Voyage v ON v.refV=r.refV 
        GROUP BY v.dureeV;
    /*d)Quel est la somme des acomptes versés pour chaque mois de l'année 2010.*/
		SELECT t.mois, t.annee, SUM(accompte) 
        FROM Reservation r 
        JOIN Temps t ON t.numT=r.numT WHERE t.annee=2010 
        GROUP BY t.mois;
    /*e)Quel est le nombre de réservations par destination, par année et par mois.*/
		SELECT mois, annee, destV, Count(*) 
        FROM Reservation r 
        JOIN Voyage v ON r.refV=v.refV
        JOIN Temps t ON t.numT=r.numT
        GROUP BY v.destV, t.mois, t.annee;
        

/*QUESTION 3*/
	/*a)Quel est le nombre de réservations par adhérent.*/
		SELECT numA, Count(*),Grouping_id(numA)
        FROM Reservation
        GROUP BY CUBE(numA); 
    /*b)Quel est le nombre de réservations pour chaque mois de l'année 2010*/
		SELECT t.mois, t.annee, count(nDossier), grouping(annee) as grp_annee, grouping(mois) as grp_mois,Grouping_id(mois,annee) as grp_id 
        FROM Reservation r 
        JOIN Temps t ON t.numT=r.numT WHERE t.annee=2010 
        GROUP BY CUBE(mois, annee);
    /*c)Quel est le nombre de réservations par durée de voyage.*/
		SELECT v.dureeV, count(nDossier), grouping_id(dureeV) 
        FROM Reservation r 
        JOIN Voyage v ON v.refV=r.refV 
        GROUP BY CUBE(v.dureeV);
    /*d)Quel est la somme des acomptes versés pour chaque mois de l'année 2010.*/
		SELECT t.mois, t.annee, SUM(accompte), grouping(annee) as grp_annee, grouping(mois) as grp_mois,Grouping_id(mois,annee) as grp_id 
        FROM Reservation r 
        JOIN Temps t ON t.numT=r.numT WHERE t.annee=2010 
        GROUP BY CUBE(t.mois, t.annee);
    /*e)Quel est le nombre de réservations par destination, par année et par mois.*/
		SELECT mois, annee, destV, Count(*), grouping(annee) as grp_annee, grouping(mois) as grp_mois, grouping(destV) as grp_destV, 
        grouping_id(annee,mois,destV)
        FROM Reservation r 
        JOIN Voyage v ON r.refV=v.refV
        JOIN Temps t ON t.numT=r.numT
        GROUP BY CUBE(v.destV, t.mois, t.annee);