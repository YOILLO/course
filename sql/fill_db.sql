INSERT INTO Race (NAME)
VALUES ('Dwarf'),
       ('Elf'),
       ('Hobbit'),
       ('Human'),
       ('Ent'),
       ('Orc'),
       ('Troll');

INSERT INTO Role (NAME, CAN_WRITE_NEWS, CAN_COMMENT, CAN_PUBLISH)
VALUES ('Admin', True, True, True),
       ('Writer', True, True, False),
       ('Publisher', False, True, True),
       ('User', False, True, False),
       ('Banned', False, False, False);

INSERT INTO Usr (USERNAME, PASSWORD, RACE_ID, ROLE_ID)
VALUES ('Me', '1234', 4, 1);

INSERT INTO Tag (NAME)
VALUES ('tag1'),
       ('tag2');