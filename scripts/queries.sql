
#SHOW COLUMNS FROM ene;

SELECT * FROM ene LIMIT 100;

CREATE USER 'klaus'@'%' IDENTIFIED BY 'roscalata';
GRANT ALL PRIVILEGES ON ine.* TO 'klaus'@'%';

CREATE USER 'reader'@'%' IDENTIFIED BY 'roscalata';
GRANT SELECT ON ine.* TO 'reader'@'%' IDENTIFIED BY 'roscalata';


DROP USER 'reader'@'%';

SELECT User FROM mysql.user;

