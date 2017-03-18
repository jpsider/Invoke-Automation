CREATE DATABASE eventSignin;
use eventSignin;

SET default_storage_engine=INNODB;

CREATE TABLE stats (
  ID int(11) NOT NULL AUTO_INCREMENT,
  Name varchar(100),
  Phone varchar(100),
  Email varchar(100),
  Kindergarten int(11),
  Grade1 int(11),
  Grade2 int(11),
  Grade3 int(11),
  Grade4 int(11),
  Grade5 int(11),
  PRIMARY KEY (ID),
  date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

