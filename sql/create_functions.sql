CREATE OR REPLACE FUNCTION AddComment()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.CREATION_DATE = CURRENT_TIMESTAMP;
    NEW.CHANGE_DATE = CURRENT_TIMESTAMP;
    return NEW;
END
$$;

CREATE TRIGGER tr1 BEFORE INSERT ON Comment EXECUTE FUNCTION AddComment();

CREATE OR REPLACE FUNCTION UpdateComment()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.CHANGE_DATE = CURRENT_TIMESTAMP;
    return NEW;
END
$$;

CREATE TRIGGER tr2 BEFORE UPDATE ON Comment EXECUTE FUNCTION UpdateComment();

CREATE OR REPLACE FUNCTION PublishNew(usr_id INT, passwd VARCHAR(20), nw_id INT)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
BEGIN
    if ((SELECT PASSWORD FROM Usr WHERE Usr.USER_ID = usr_id) != passwd)
    THEN
        ASSERT 'Wrong password';
    END IF;

    IF (NOT (SELECT Role.CAN_PUBLISH FROM Usr JOIN Role ON Role.ROLE_ID = Usr.ROLE_ID WHERE USER_ID = usr_id))
    THEN
        ASSERT 'Do not have rights to publish';
    END IF;

    UPDATE New SET IS_PUBLISHED = TRUE, PUBLISH_TIME = CURRENT_TIMESTAMP WHERE NEW_ID = nw_id;
END
$$;

CREATE OR REPLACE FUNCTION WriteNew(usr_id INT, passwd VARCHAR(20), nw_header VARCHAR(20), nw_text VARCHAR(3000), catg_id INT)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
BEGIN
    if ((SELECT PASSWORD FROM Usr WHERE Usr.USER_ID = usr_id) != passwd)
    THEN
        ASSERT 'Wrong password';
    END IF;

    IF (NOT (SELECT Role.CAN_WRITE_NEWS FROM Usr JOIN Role ON Role.ROLE_ID = Usr.ROLE_ID WHERE USER_ID = usr_id))
    THEN
        ASSERT 'Do not have rights to publish';
    END IF;

    INSERT INTO New (TITLE, TEXT, CATEGORY_ID, IS_PUBLISHED)
    VALUES (nw_header, nw_text, catg_id, FALSE);

    INSERT INTO New_Author (NEW_ID, USER_ID)
    VALUES ((SELECT NEW_ID FROM New WHERE TITLE = nw_header), usr_id);
END
$$;

CREATE OR REPLACE FUNCTION UpdateNew(usr_id INT, passwd VARCHAR(20), nw_header VARCHAR(20), nw_text VARCHAR(3000), catg_id INT, nw_id INT)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
BEGIN
    if ((SELECT PASSWORD FROM Usr WHERE Usr.USER_ID = usr_id) != passwd)
    THEN
        ASSERT 'Wrong password';
    END IF;

    IF (NOT (SELECT Role.CAN_WRITE_NEWS FROM Usr JOIN Role ON Role.ROLE_ID = Usr.ROLE_ID WHERE USER_ID = usr_id))
    THEN
        ASSERT 'Do not have rights to publish';
    END IF;

    IF (NOT (EXISTS(SELECT * FROM New_Author WHERE NEW_ID = nw_id AND USER_ID = usr_id)))
    THEN
        INSERT INTO New_Author (NEW_ID, USER_ID)
        VALUES (nw_id, usr_id);
    END IF;

    UPDATE New SET TITLE = nw_header, TEXT = nw_text, CATEGORY_ID = catg_id WHERE NEW_ID = nw_id;
END
$$;

CREATE OR REPLACE FUNCTION AddTag(usr_id INT, passwd VARCHAR(20), nw_id INT, nw_tag INT)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
BEGIN
    if ((SELECT PASSWORD FROM Usr WHERE Usr.USER_ID = usr_id) != passwd)
    THEN
        ASSERT 'Wrong password';
    END IF;

    IF (NOT (SELECT Role.CAN_WRITE_NEWS FROM Usr JOIN Role ON Role.ROLE_ID = Usr.ROLE_ID WHERE USER_ID = usr_id))
    THEN
        ASSERT 'Do not have rights to publish';
    END IF;

    IF (NOT (EXISTS(SELECT * FROM New_Author WHERE NEW_ID = nw_id AND USER_ID = usr_id)))
    THEN
        INSERT INTO New_Author (NEW_ID, USER_ID)
        VALUES (nw_id, usr_id);
    END IF;

    IF (EXISTS(SELECT * FROM New_Tag WHERE NEW_ID = nw_id AND TAG_ID = nw_tag))
    THEN
        ASSERT 'Tag already added';
    END IF;

    INSERT INTO New_Tag (NEW_ID, TAG_ID)
    VALUES (nw_id, nw_tag);
END
$$;

CREATE OR REPLACE FUNCTION RemoveTag(usr_id INT, passwd VARCHAR(20), nw_id INT, nw_tag INT)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
BEGIN
    if ((SELECT PASSWORD FROM Usr WHERE Usr.USER_ID = usr_id) != passwd)
    THEN
        ASSERT 'Wrong password';
    END IF;

    IF (NOT (SELECT Role.CAN_WRITE_NEWS FROM Usr JOIN Role ON Role.ROLE_ID = Usr.ROLE_ID WHERE USER_ID = usr_id))
    THEN
        ASSERT 'Do not have rights to publish';
    END IF;

    IF (NOT (EXISTS(SELECT * FROM New_Author WHERE NEW_ID = nw_id AND USER_ID = usr_id)))
    THEN
        INSERT INTO New_Author (NEW_ID, USER_ID)
        VALUES (nw_id, usr_id);
    END IF;

    IF (NOT(EXISTS(SELECT * FROM New_Tag WHERE NEW_ID = nw_id AND TAG_ID = nw_tag)))
    THEN
        ASSERT 'Tag not exists';
    END IF;

    DELETE FROM New_Tag WHERE TAG_ID = nw_tag AND NEW_ID = nw_id;
END
$$;