set serveroutput on

-------------- CLEAN UP SCRIPT ---------------
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
    rating    INT,
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
    ad_cost      DECIMAL NOT NULL,
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
    subscription_amount  DECIMAL NOT NULL,
    CONSTRAINT subscription_id_pk PRIMARY KEY ( subscription_id ),
    CONSTRAINT subscription_fk1 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id ),
    CONSTRAINT subscription_fk2 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
);


-------------- INSERTING INTO TABLES ---------------

-- Inserting into PINCODE Table

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100001, 'India', 'Delhi', 'New Delhi');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100034, 'India', 'Maharashtra', 'Mumbai');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100023, 'USA', 'Massachusetts', 'Boston');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100043, 'USA', 'Massachusetts', 'Salem');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100056, 'USA', 'Massachusetts', 'Lowell');




-- Inserting into USER_INFO Table

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (1, 100001, 'John Doe', 'johndoe@example.com', 'password123', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-01', 'YYYY-MM-DD'));

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (2, 100034, 'Jane Smith', 'janesmith@example.com', 'password456', TO_DATE('2022-01-02', 'YYYY-MM-DD'), TO_DATE('2022-01-02', 'YYYY-MM-DD'));

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (3, 100023, 'Bob Johnson', 'bobjohnson@example.com', 'password789',  TO_DATE('2022-01-03', 'YYYY-MM-DD'), TO_DATE('2022-01-03', 'YYYY-MM-DD'));

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (4, 100043, 'Alice Brown', 'alicebrown@example.com', 'passwordabc',  TO_DATE('2022-01-04', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'));

INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (5, 100056, 'Mike Davis', 'mikedavis@example.com','passworddef',  TO_DATE('2022-01-04', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'));




-- Inserting into DEVELOPER Table

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(1, 'John Smith', 'john.smith@example.com', 'password123', 'Acme Inc.', 12345, 'Full license', TO_DATE('2022-01-01', 'YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(2, 'Jeniffer Lawrence', 'JLaw@example.com', 'letmein', 'Globex Corp.', 67890, 'Limited license', TO_DATE('2023-06-30','YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(3, 'Mark Rhonson', 'Mark.Rhonson@example.com', 'securepassword', 'Stark Industries', 24680, 'Full license', TO_DATE('2024-09-15','YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(4, 'David Guetta', 'Guetta.Dave@example.com', 'securepassword', 'Wayne Enterprises', 13579, 'Full license', TO_DATE('2025-02-28','YYYY-MM-DD'));

INSERT INTO DEVELOPER (Developer_ID, Developer_Name, Developer_Email, Developer_Password, Organization_Name, License_Number, License_Description, License_Date)
VALUES(5, 'Helena Carter', 'carter.hell@example.com', 'securepassword', 'Umbrella Corporation', 86420, 'Full license', TO_DATE('2026-11-01','YYYY-MM-DD'));




-- Inserting into APP_CATEGORY

INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES (101, 'Social Networking', 'Entertainment', 1);

INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES(102, 'Productivity', 'Business', 1);

INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES(103, 'Gaming', 'Entertainment', 1);

INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES(104, 'Finance', 'Business', 1);

INSERT INTO APP_CATEGORY (Category_ID, Category_Description, Category_Type, Number_Of_Apps)
VALUES(105, 'Travel', 'Lifestyle', 1);




-- Inserting in to PAYMENTS Table

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(203, 1, 'John Doe', 1345367829875712, 3445, TO_DATE('2022-03-02', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(204, 2, 'Jane Smith', 2347598678904004, 5772, TO_DATE('2022-06-28', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(207, 3, 'Bob Heather Johnson', 5697234589076009, 2349, TO_DATE('2022-08-13', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(289, 4, 'Alice Marie Brown', 9009582614056879, 9807, TO_DATE('2022-07-13', 'YYYY-MM-DD'));

INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(290, 5, 'Mike Thunder Davis', 1440698740321011, 3478, TO_DATE('2022-12-02', 'YYYY-MM-DD'));





-- Insert into Profile

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(11, 1, 'John Doe', 'iPhone 13', 'Private',TO_DATE('2021-06-28', 'YYYY-MM-DD'), TO_DATE('2022-05-9', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(12, 2, 'Jane Smith', 'Macbook air', 'Public',TO_DATE('2020-04-09', 'YYYY-MM-DD'), TO_DATE('2022-06-07', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(13, 3, 'Bob Johnson', 'Samsung Galaxy A7', 'Public',TO_DATE('2018-02-19', 'YYYY-MM-DD'), TO_DATE('2021-06-03', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(14, 4, 'Alice Brown', 'iPhone 11', 'Private',TO_DATE('2020-08-11', 'YYYY-MM-DD'), TO_DATE('2023-01-31', 'YYYY-MM-DD'));

INSERT INTO PROFILE(Profile_ID, User_ID, Profile_Name, Device_Info,Profile_Type, Created_At, Updated_At )
VALUES(15, 5, 'Mike Davis', 'Acer Nitro 5', 'Private',TO_DATE('2017-08-13', 'YYYY-MM-DD'), TO_DATE('2021-03-31', 'YYYY-MM-DD'));





-- Insert into Application

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (501, 1, 101, 'Shazam', 50, 1, 'English', 100, 18, 'iOS', 4, TO_DATE('2023-03-03', 'YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (502, 2, 102, 'Instagram', 100, 21, 'English', 10000, 21, 'iOS', 6, TO_DATE('2022-03-06', 'YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (503, 3, 103, 'LinkedIN', 30, 24, 'English', 300, 35, 'iOS', 3, TO_DATE('2022-05-28', 'YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (504, 4, 104, 'Snapchat', 200, 3, 'English', 3000, 16, 'iOS', 7, TO_DATE('2022-07-18', 'YYYY-MM-DD'));

INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (505, 5, 105, 'Toppings', 70, 5, 'English', 90000, 24, 'iOS', 8, TO_DATE('2022-03-05', 'YYYY-MM-DD'));






-- Insert into Reviews

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(301, 1, 501, 4, 'Great app, very user-friendly');

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(302, 2, 502, 3, 'Needs improvement in search feature');

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(303, 3, 503, 5, 'Love the design and functionality');

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(304, 4, 504, 2, 'Too many bugs, needs fixing');

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(305, 5, 505, 4, 'Good app, but could use more features');





-- Insert into USER_APP_CATALOGUE

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (401, 501, 11, 2, 1, 'Auto-update', 1);

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (402, 502, 12, 5, 0, 'Manual update', 1);

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (403, 503, 13, 3, 1, 'Auto-update', 1);

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (404, 504, 14, 2, 1, 'Auto-update', 1);

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (405, 505, 15, 1, 1, 'Auto-update', 1);




-- Insert into ADVERTISEMENT

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (601, 1, 501, 'Udemy ad', 50.00);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (602, 2, 502, 'Shampoo ad', 30.00);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (603, 3, 503, 'Liberty ad', 60.00);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (604, 4, 504, 'Tesla ad', 90.00);

INSERT INTO ADVERTISEMENT (Ad_ID, Developer_ID, App_ID, Ad_Details, Ad_Cost)
VALUES (605, 5, 505, 'Travel ad', 20.00);





-- Insert into SUBSCRIPTION

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (701, 501, 1, 'Basic Plan', 'Recurring', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 20.00);
	   
INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (702, 502, 2, 'Preminum Plan', 'Recurring', TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 60.00);

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (703, 503, 3, 'Basic Plan', 'Recurring', TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 20.00);

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (704, 504, 4, 'Family Plan', 'Recurring', TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 40.00);

INSERT INTO SUBSCRIPTION (Subscription_ID, App_ID, User_ID, Subscription_Name, Type, Subcription_Start_Dt, Subscription_End_Dt, Subscription_Amount)
VALUES (705, 505, 5, 'Basic Plan', 'Recurring', TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 20.00);
