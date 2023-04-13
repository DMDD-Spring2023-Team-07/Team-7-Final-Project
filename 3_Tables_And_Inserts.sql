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


--------------------------------------------------------------------------------
----- INSERTING INTO TABLES -----
--- INSERTING IN FIRST ROW ------------------
INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (CATEGORY_SEQ.NEXTVAL, 'Social Networking', 'Entertainment', 1);

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100001, 'India', 'Delhi', 'New Delhi');

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL,100001, 'John Doe', 'johndoe@example.com', 'password123', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-01', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'John Doe', 1345367829875712, 3445, TO_DATE('2022-03-02', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(DEVELOPER_SEQ.NEXTVAL, 'John Smith', 'john.smith@example.com', 'password123', 'Acme Inc.', 12345, 'Full license', TO_DATE('2022-01-01', 'YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'Shazam', 50, 1, 'English', 100, 18, 'iOS', 4, TO_DATE('2023-03-03', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(PROFILE_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'John Doe', 'iPhone 13', 'Private',TO_DATE('2021-06-28', 'YYYY-MM-DD'), TO_DATE('2022-05-9', 'YYYY-MM-DD'));

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (SUBSCRIPTION_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,USER_SEQ.CURRVAL, 'Basic Plan', 'Recurring', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 20.00);

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(REVIEW_SEQ.NEXTVAL,USER_SEQ.CURRVAL,APPLICATION_SEQ.CURRVAL, 4, 'Great app, very user-friendly');

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (CATALOGUE_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,PROFILE_SEQ.CURRVAL, 2, 1, 'Auto-update', 1);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (ADVERTISEMENT_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL, APPLICATION_SEQ.CURRVAL, 'Udemy ad', 50.00);

--- INSERTING IN SECOND ROW ------------------
INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (CATEGORY_SEQ.NEXTVAL, 'Productivity', 'Business', 1);

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100034, 'India', 'Maharashtra', 'Mumbai');

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL, 100034, 'Jane Smith', 'janesmith@example.com', 'password456', TO_DATE('2022-01-02', 'YYYY-MM-DD'), TO_DATE('2022-01-02', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Jane Smith', 2347598678904004, 5772, TO_DATE('2022-06-28', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(DEVELOPER_SEQ.NEXTVAL, 'Jeniffer Lawrence', 'JLaw@example.com', 'letmein', 'Globex Corp.', 67890, 'Limited license', TO_DATE('2023-06-30','YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'Instagram', 100, 21, 'English', 10000, 21, 'iOS', 6, TO_DATE('2022-03-06', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(PROFILE_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Jane Smith', 'Macbook air', 'Public',TO_DATE('2020-04-09', 'YYYY-MM-DD'), TO_DATE('2022-06-07', 'YYYY-MM-DD'));

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (SUBSCRIPTION_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,USER_SEQ.CURRVAL, 'Preminum Plan', 'Recurring', TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 60.00);

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(REVIEW_SEQ.NEXTVAL,USER_SEQ.CURRVAL,APPLICATION_SEQ.CURRVAL, 3, 'Needs improvement in search feature');

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (CATALOGUE_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,PROFILE_SEQ.CURRVAL, 5, 0, 'Manual update', 1);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (ADVERTISEMENT_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL, APPLICATION_SEQ.CURRVAL, 'Shampoo ad', 30.00);



--- INSERTING IN THIRD ROW ------------------
INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (CATEGORY_SEQ.NEXTVAL, 'Gaming', 'Entertainment', 1);

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100023, 'USA', 'Massachusetts', 'Boston');

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL, 100023, 'Bob Johnson', 'bobjohnson@example.com', 'password789',  TO_DATE('2022-01-03', 'YYYY-MM-DD'), TO_DATE('2022-01-03', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Bob Heather Johnson', 5697234589076009, 2349, TO_DATE('2022-08-13', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(DEVELOPER_SEQ.NEXTVAL, 'Mark Rhonson', 'Mark.Rhonson@example.com', 'securepassword', 'Stark Industries', 24680, 'Full license', TO_DATE('2024-09-15','YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'LinkedIN', 30, 24, 'English', 300, 35, 'iOS', 3, TO_DATE('2022-05-28', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(PROFILE_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Bob Johnson', 'Samsung Galaxy A7', 'Public',TO_DATE('2018-02-19', 'YYYY-MM-DD'), TO_DATE('2021-06-03', 'YYYY-MM-DD'));

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (SUBSCRIPTION_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,USER_SEQ.CURRVAL, 'Basic Plan', 'Recurring', TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 20.00);

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(REVIEW_SEQ.NEXTVAL,USER_SEQ.CURRVAL,APPLICATION_SEQ.CURRVAL, 5, 'Love the design and functionality');

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (CATALOGUE_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,PROFILE_SEQ.CURRVAL, 3, 1, 'Auto-update', 1);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (ADVERTISEMENT_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL, APPLICATION_SEQ.CURRVAL, 'Liberty ad', 60.00);



--- INSERTING IN FOURTH ROW ------------------
INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (CATEGORY_SEQ.NEXTVAL, 'Finance', 'Business', 1);

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100043, 'USA', 'Massachusetts', 'Salem');

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL, 100043, 'Alice Brown', 'alicebrown@example.com', 'passwordabc',  TO_DATE('2022-01-04', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Alice Marie Brown', 9009582614056879, 9807, TO_DATE('2022-07-13', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(DEVELOPER_SEQ.NEXTVAL, 'David Guetta', 'Guetta.Dave@example.com', 'securepassword', 'Wayne Enterprises', 13579, 'Full license', TO_DATE('2025-02-28','YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'Snapchat', 200, 3, 'English', 3000, 16, 'iOS', 7, TO_DATE('2022-07-18', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(PROFILE_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Alice Brown', 'iPhone 11', 'Private',TO_DATE('2020-08-11', 'YYYY-MM-DD'), TO_DATE('2023-01-31', 'YYYY-MM-DD'));

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (SUBSCRIPTION_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,USER_SEQ.CURRVAL, 'Family Plan', 'Recurring', TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 40.00);

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(REVIEW_SEQ.NEXTVAL,USER_SEQ.CURRVAL,APPLICATION_SEQ.CURRVAL, 2, 'Too many bugs, needs fixing');

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (CATALOGUE_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,PROFILE_SEQ.CURRVAL, 2, 1, 'Auto-update', 1);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (ADVERTISEMENT_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL, APPLICATION_SEQ.CURRVAL, 'Tesla ad', 90.00);

--- INSERTING IN FIFTH ROW ------------------
INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (CATEGORY_SEQ.NEXTVAL, 'Travel', 'Lifestyle', 1);

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100056, 'USA', 'Massachusetts', 'Lowell');

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL, 100056, 'Mike Davis', 'mikedavis@example.com','passworddef',  TO_DATE('2022-01-04', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Mike Thunder Davis', 1440698740321011, 3478, TO_DATE('2022-12-02', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(DEVELOPER_SEQ.NEXTVAL, 'Helena Carter', 'carter.hell@example.com', 'securepassword', 'Umbrella Corporation', 86420, 'Full license', TO_DATE('2026-11-01','YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'Toppings', 70, 5, 'English', 90000, 24, 'iOS', 8, TO_DATE('2022-03-05', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(PROFILE_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'Mike Davis', 'Acer Nitro 5', 'Private',TO_DATE('2017-08-13', 'YYYY-MM-DD'), TO_DATE('2021-03-31', 'YYYY-MM-DD'));

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (SUBSCRIPTION_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,USER_SEQ.CURRVAL, 'Basic Plan', 'Recurring', TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 20.00);

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(REVIEW_SEQ.NEXTVAL,USER_SEQ.CURRVAL,APPLICATION_SEQ.CURRVAL,  4, 'Good app, but could use more features');

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (CATALOGUE_SEQ.NEXTVAL,APPLICATION_SEQ.CURRVAL,PROFILE_SEQ.CURRVAL, 1, 1, 'Auto-update', 1);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (ADVERTISEMENT_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL, APPLICATION_SEQ.CURRVAL, 'Travel ad', 20.00);



-- Save the changes
COMMIT;