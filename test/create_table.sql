
CREATE SCHEMA IF NOT EXISTS test DEFAULT CHARACTER SET utf8 ;

USE test;

CREATE TABLE `table1` ( `id` INT NOT NULL AUTO_INCREMENT, `name` VARCHAR(255) NOT NULL, `marks` INT NOT NULL, PRIMARY KEY (`id`) ) ENGINE=InnoDB;

INSERT INTO table1 (id, name, marks) VALUES (1, "abc", 5);

INSERT INTO table1 (id, name, marks) VALUES (2, "xyz", 1);

