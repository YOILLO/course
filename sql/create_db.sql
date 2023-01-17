CREATE TABLE Role (
                      ROLE_ID SERIAL PRIMARY KEY,
                      NAME VARCHAR(20) NOT NULL,
                      CAN_WRITE_NEWS BOOLEAN NOT NULL,
                      CAN_COMMENT BOOLEAN NOT NULL,
                      CAN_PUBLISH BOOLEAN NOT NULL
);
CREATE INDEX ON Role USING hash(ROLE_ID);

CREATE TABLE Race (
                      RACE_ID SERIAL PRIMARY KEY,
                      NAME VARCHAR(20) NOT NULL
);

CREATE INDEX ON Race USING hash(RACE_ID);

CREATE TABLE Tag (
                     TAG_ID SERIAL PRIMARY KEY,
                     NAME VARCHAR(20) NOT NULL
);

CREATE INDEX ON Tag USING hash(TAG_ID);
CREATE INDEX ON Tag USING hash(NAME);

CREATE TABLE Category (
                          CATEGORY_ID SERIAL PRIMARY KEY,
                          NAME VARCHAR(20) NOT NULL
);

CREATE INDEX ON Category USING hash(CATEGORY_ID);
CREATE INDEX ON Category USING hash(NAME);

CREATE TABLE Usr (
                     USER_ID SERIAL PRIMARY KEY,
                     USERNAME VARCHAR(20),
                     PASSWORD VARCHAR(20),
                     RACE_ID INT REFERENCES Race(RACE_ID),
                     ROLE_ID INT REFERENCES Role(ROLE_ID),
                     CREATION_TIME TIMESTAMP
);

CREATE INDEX ON Usr USING hash(USER_ID);
CREATE INDEX ON Usr USING hash(USERNAME);
CREATE INDEX ON Usr USING hash(PASSWORD);

CREATE TABLE New (
                     NEW_ID SERIAL PRIMARY KEY,
                     TITLE VARCHAR(20) UNIQUE,
                     TEXT VARCHAR(3000) NOT NULL,
                     CATEGORY_ID INT REFERENCES Category(CATEGORY_ID) NOT NULL,
                     IS_PUBLISHED BOOLEAN NOT NULL,
                     PUBLISH_TIME TIMESTAMP
);

CREATE INDEX ON New USING hash(NEW_ID);
CREATE INDEX ON New USING hash(TITLE);

CREATE TABLE New_Author(
                           NEW_ID INT REFERENCES New(NEW_ID),
                           USER_ID INT REFERENCES Usr(USER_ID)
);

CREATE INDEX ON New_Author USING hash(NEW_ID);
CREATE INDEX ON New_Author USING hash(USER_ID);

CREATE TABLE New_Tag(
                        NEW_ID INT REFERENCES New(NEW_ID),
                        TAG_ID INT REFERENCES Tag(TAG_ID)
);

CREATE INDEX ON New_Tag USING hash(NEW_ID);
CREATE INDEX ON New_Tag USING hash(TAG_ID);

CREATE TABLE Comment(
                        COMMENT_ID SERIAL PRIMARY KEY,
                        TEXT VARCHAR(1000),
                        CREATION_DATE TIMESTAMP,
                        CHANGE_DATE TIMESTAMP,
                        NEW_ID INT REFERENCES New(NEW_ID),
                        USER_ID INT REFERENCES Usr(USER_ID)
);

CREATE INDEX ON Comment USING hash(COMMENT_ID);
CREATE INDEX ON Comment USING hash(NEW_ID);