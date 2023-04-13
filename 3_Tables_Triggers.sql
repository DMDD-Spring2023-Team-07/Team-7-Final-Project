set serveroutput on

--------------------------------------------------------------------------------
-------------- CLEAN UP SCRIPT FOR TABLES ---------------
DECLARE
    db_tables      sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll('ADVERTISEMENT', 'SUBSCRIPTION', 'APPLICATION', 'DEVELOPER', 'APP_CATEGORY', 'PAYMENTS', 'PINCODE', 'PROFILE', 'REVIEWS', 'USER_APP_CATALOGUE', 'USER_INFO');
    v_table_exists VARCHAR(1) := 'Y';
    v_sql          VARCHAR(2000);
BEGIN
    dbms_output.put_line('------ Starting schema cleanup ------');
    FOR i IN db_tables.first..db_tables.last LOOP
        dbms_output.put_line('**** Drop table ' || db_tables(i));
        BEGIN
            SELECT
                'Y'
            INTO v_table_exists
            FROM
                user_tables
            WHERE
                table_name = db_tables(i);

            v_sql := 'drop table ' || db_tables(i) || ' CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE v_sql;
            dbms_output.put_line('**** Table ' || db_tables(i) || ' dropped successfully');
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('**** Table already dropped');
        END;

    END LOOP;

    dbms_output.put_line('------ Schema cleanup successfully completed ------');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Failed to execute code:' || sqlerrm);
END;
/

--------------------------------------------------------------------------------
-------------- TABLES CREATION ---------------

-- PINCODE Table

CREATE TABLE pincode (
    zip_code INT PRIMARY KEY,
    country  VARCHAR(255),
    state    VARCHAR(255),
    city     VARCHAR(255)
);

ALTER TABLE pincode MODIFY
    country NOT NULL
MODIFY
    state NOT NULL
MODIFY
    city NOT NULL;
    
    
-- USER_INFO Table
CREATE TABLE user_info (
    user_id       INT PRIMARY KEY,
    user_zip_code INT,
    user_name     VARCHAR(255),
    user_email    VARCHAR(255),
    user_passcode VARCHAR(255),
    created_at    DATE,
    updated_at    DATE
);

ALTER TABLE user_info
    ADD CONSTRAINT user_zip_code_fk FOREIGN KEY ( user_zip_code )
        REFERENCES pincode ( zip_code );

ALTER TABLE user_info MODIFY
    user_name NOT NULL
MODIFY
    user_email NOT NULL
MODIFY
    user_passcode NOT NULL
MODIFY
    created_at NOT NULL;
    
   
    
-- PAYMENTS Table

CREATE TABLE payments (
    billing_id   INT PRIMARY KEY,
    user_id      INT,
    name_on_card VARCHAR(255),
    card_number  VARCHAR(255),
    cvv          VARCHAR(255),
    created_at   DATE
);

ALTER TABLE payments
    ADD CONSTRAINT user_id_fk FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    name_on_card NOT NULL
MODIFY
    card_number VARCHAR(16) NOT NULL
MODIFY
    cvv VARCHAR(4) NOT NULL
MODIFY
    created_at NOT NULL;


-- DEVELOPER Table
CREATE TABLE developer (
    developer_id        INTEGER NOT NULL,
    developer_name      VARCHAR(255) NOT NULL,
    developer_email     VARCHAR(255) NOT NULL,
    developer_password  VARCHAR(255) NOT NULL,
    organization_name   VARCHAR(255) NOT NULL,
    license_number      INTEGER NOT NULL,
    license_description VARCHAR(4000) NOT NULL,
    license_date        DATE NOT NULL,
    CONSTRAINT developer_id_pk PRIMARY KEY ( developer_id )
);



-- APP_CATEGORY Table
CREATE TABLE app_category (
    category_id          INTEGER NOT NULL,
    category_description VARCHAR(255) NOT NULL,
    category_type        VARCHAR(255) NOT NULL,
    number_of_apps       INTEGER NOT NULL,
    CONSTRAINT category_id_pk PRIMARY KEY ( category_id )
);



-- APPLICATION Table
CREATE TABLE application (
    app_id         INTEGER NOT NULL,
    developer_id   INTEGER NOT NULL,
    category_id    INTEGER NOT NULL,
    app_name       VARCHAR(255) NOT NULL,
    app_size       INTEGER NOT NULL,
    app_version    INTEGER NOT NULL,
    app_language   VARCHAR(255) NOT NULL,
    download_count INTEGER NOT NULL,
    target_age     INTEGER NOT NULL,
    supported_os   VARCHAR(255) NOT NULL,
    overall_rating INTEGER NOT NULL,
    app_create_dt  DATE NOT NULL,
    CONSTRAINT app_id_pk PRIMARY KEY ( app_id ),
    CONSTRAINT application_fk1 FOREIGN KEY ( developer_id )
        REFERENCES developer ( developer_id ),
    CONSTRAINT application_fk2 FOREIGN KEY ( category_id )
        REFERENCES app_category ( category_id )
);
 
    
-- PROFILE Table
CREATE TABLE profile (
    profile_id   INT PRIMARY KEY,
    user_id      INT,
    profile_name VARCHAR(255),
    device_info  VARCHAR(255),
    profile_type VARCHAR(255),
    created_at   DATE,
    updated_at   DATE
);

ALTER TABLE profile
    ADD CONSTRAINT user_id_fk_2 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    profile_name NOT NULL
MODIFY
    device_info NOT NULL
MODIFY
    profile_type NOT NULL
MODIFY
    created_at NOT NULL;



-- REVIEWS Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    user_id   INT,
    app_id    INT,
    rating    DECIMAL(10, 2),
    feedback  VARCHAR(255)
);

ALTER TABLE reviews
    ADD CONSTRAINT user_id_fk_3 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    rating NOT NULL
MODIFY
    feedback NOT NULL;

ALTER TABLE reviews
    ADD CONSTRAINT app_id_fk FOREIGN KEY ( app_id )
        REFERENCES application ( app_id );


-- USER_APP_CATALOGUE Table
CREATE TABLE user_app_catalogue (
    catalogue_id        INT PRIMARY KEY,
    app_id              INT,
    profile_id          INT,
    installed_version   INT,
    is_update_available NUMBER(1) DEFAULT 0 CHECK ( is_update_available IN ( 0, 1 ) ),
    install_policy_desc VARCHAR(255),
    is_accepted         NUMBER(1) DEFAULT 0 CHECK ( is_accepted IN ( 0, 1 ) )
);


ALTER TABLE user_app_catalogue
    ADD CONSTRAINT profile_id_fk FOREIGN KEY ( profile_id )
        REFERENCES profile ( profile_id )
MODIFY
    installed_version NOT NULL
MODIFY
    is_update_available NOT NULL
MODIFY
    install_policy_desc NOT NULL
MODIFY
    is_accepted NOT NULL;

ALTER TABLE user_app_catalogue
    ADD CONSTRAINT app_id_fk_2 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id );
        
    


-- ADVERTISEMENT Table
CREATE TABLE advertisement (
    ad_id        INTEGER NOT NULL,
    developer_id INTEGER NOT NULL,
    app_id       INTEGER NOT NULL,
    ad_details   VARCHAR(255) NOT NULL,
    ad_cost      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT ad_id_pk PRIMARY KEY ( ad_id ),
    CONSTRAINT advertisement_fk1 FOREIGN KEY ( developer_id )
        REFERENCES developer ( developer_id ),
    CONSTRAINT advertisement_fk2 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id )
);



-- SUBSCRIPTION Table

CREATE TABLE subscription (
    subscription_id      INTEGER NOT NULL,
    app_id               INTEGER NOT NULL,
    user_id              INTEGER NOT NULL,
    subscription_name    VARCHAR(255) NOT NULL,
    type                 VARCHAR(255) NOT NULL
        CONSTRAINT check_constraint_type CHECK ( type IN ( 'One Time', 'Recurring' ) ),
    subcription_start_dt DATE NOT NULL,
    subscription_end_dt  DATE NOT NULL,
    subscription_amount  DECIMAL(10, 2) NOT NULL,
    CONSTRAINT subscription_id_pk PRIMARY KEY ( subscription_id ),
    CONSTRAINT subscription_fk1 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id ),
    CONSTRAINT subscription_fk2 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
);


--------------------------------------------------------------------------------
-------------- Creating all TRIGGERS ---------------
-- UPDATE THE DOWNLOAD COUNT
-- drop trigger update_download_count;
CREATE OR REPLACE TRIGGER update_download_count
AFTER insert ON user_app_catalogue
FOR EACH ROW
BEGIN
    UPDATE application 
    SET download_count = download_count + 1
    WHERE app_id = :new.app_id;
END;
/


-- UPDATE IS_UPDATE_AVAILABLE IN USER_APP_CATALOGUE 
-- drop trigger update_available_update_flag;
CREATE OR REPLACE TRIGGER update_available_update_flag
AFTER UPDATE ON application
FOR EACH ROW
BEGIN
    UPDATE user_app_catalogue 
    SET is_update_available = 1
    WHERE app_id = :new.app_id;
END;
/


-- UPDATE NUMBER_OF_APPS IN APP_CATEGORY 
-- drop trigger update_number_of_apps;
CREATE OR REPLACE TRIGGER update_number_of_apps
AFTER insert ON application
FOR EACH ROW
BEGIN
    UPDATE number_of_apps 
    SET number_of_apps = number_of_apps + 1
    WHERE category_id = :new.category_id;
END;
/


--------------------------------------------------------------------------------
----- Granting Access for the created users -----

-- Granting accesses for TABLES to STORE_ADMIN user

GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.ADVERTISEMENT TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.APP_CATEGORY TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.APPLICATION TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.PINCODE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.PROFILE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.REVIEWS TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.SUBSCRIPTION TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.USER_APP_CATALOGUE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.USER_INFO TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.DEVELOPER TO STORE_ADMIN;



-- Granting access for TABLES to DEVELOPER_MANAGER user
    
GRANT SELECT ON DB_ADMIN.REVIEWS TO DEVELOPER_MANAGER;
GRANT SELECT ON DB_ADMIN.APP_CATEGORY TO DEVELOPER_MANAGER;

GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.APPLICATION TO DEVELOPER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.ADVERTISEMENT TO DEVELOPER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.SUBSCRIPTION TO DEVELOPER_MANAGER;


-- Granting access for TABLES to USER_MANAGER user

GRANT SELECT ON DB_ADMIN.USER_APP_CATALOGUE TO USER_MANAGER;
GRANT SELECT ON DB_ADMIN.SUBSCRIPTION TO USER_MANAGER;

GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.USER_INFO TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PAYMENTS TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PINCODE TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PROFILE TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.REVIEWS TO USER_MANAGER;



-- Save the changes
COMMIT;