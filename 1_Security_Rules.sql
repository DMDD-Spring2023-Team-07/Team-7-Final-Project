SET SERVEROUTPUT ON;

-------------- CLEAN UP USER SESSIONS ---------------

BEGIN
    dbms_output.put_line('------ Starting user session cleanup ------');
    FOR s IN (SELECT sid, serial# FROM v$session WHERE username = 'DB_ADMIN' union all
            SELECT sid, serial# FROM v$session WHERE username = 'STORE_ADMIN' union all
            SELECT sid, serial# FROM v$session WHERE username = 'DEVELOPER_MANAGER' union all
            SELECT sid, serial# FROM v$session WHERE username = 'USER_MANAGER') LOOP
        DBMS_OUTPUT.PUT_LINE('Terminating session: ' || s.sid || ',' || s.serial#);
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''' IMMEDIATE';
    END LOOP;
    dbms_output.put_line('------ User session cleanup successfully completed ------');
END;
/


-------------- CLEAN UP SCRIPT FOR USER ---------------

DECLARE
    TYPE user_name_array IS VARRAY(10) OF VARCHAR2(20); -- define the array type
    user_names user_name_array := user_name_array('DB_ADMIN', 'STORE_ADMIN', 'DEVELOPER_MANAGER', 'USER_MANAGER'); -- initialize the array with values
BEGIN
    dbms_output.put_line('------ Starting user cleanup ------');
    FOR i IN 1..user_names.count LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('**** Deleting user: ' || user_names(i));
            EXECUTE IMMEDIATE 'DROP USER ' || user_names(i) || ' CASCADE ';
        EXCEPTION
                WHEN OTHERS THEN
                    IF SQLCODE != -1918 THEN
                        RAISE;
                    END IF;
            dbms_output.put_line('**** User already dropped');
        END;
    END LOOP;
    dbms_output.put_line('------ user cleanup successfully completed ------');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/


----- Users Creation -----

-- Creation of Database Admin

CREATE USER DB_ADMIN IDENTIFIED BY QueryNinjas#6210;


-- Creation of App Store Admin

CREATE USER STORE_ADMIN IDENTIFIED BY QueryNinjas#6210;


-- Creation of Developer Manager

CREATE USER DEVELOPER_MANAGER IDENTIFIED BY QueryNinjas#6210;


-- Creation of USER_MANAGER

CREATE USER USER_MANAGER IDENTIFIED BY QueryNinjas#6210;




----- Access Grants for the created users -----

GRANT CONNECT, CREATE SESSION, RESOURCE TO DB_ADMIN;
GRANT CONNECT, CREATE SESSION, RESOURCE TO STORE_ADMIN;
GRANT CONNECT, CREATE SESSION, RESOURCE TO DEVELOPER_MANAGER;
GRANT CONNECT, CREATE SESSION, RESOURCE TO USER_MANAGER;

----- Quota for the created users -----

ALTER USER DB_ADMIN QUOTA UNLIMITED ON DATA;
ALTER USER STORE_ADMIN QUOTA UNLIMITED ON DATA;
ALTER USER DEVELOPER_MANAGER QUOTA UNLIMITED ON DATA;
ALTER USER USER_MANAGER QUOTA UNLIMITED ON DATA;


----- Granting Access for the created users -----


-- Granting accesses for TABLES to DATABASE_ADMIN user
GRANT DROP ANY TABLE, DROP ANY VIEW TO DB_ADMIN;

-- Granting accesses for Views to DATABASE_ADMIN user
GRANT CREATE VIEW TO DB_ADMIN;

-- Granting accesses for Stores Procedures to DATABASE_ADMIN user
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE TO DB_ADMIN;

-- Granting accesses for Sequences to DATABASE_ADMIN user
GRANT CREATE SEQUENCE TO DB_ADMIN;

-- Grant Permissions to Encryption
GRANT EXECUTE ON DBMS_CRYPTO TO DB_ADMIN;


-- Save the changes
COMMIT;