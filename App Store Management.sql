-- Pincode
CREATE TABLE PINCODE(
Zip_Code INT  PRIMARY KEY,
Country varchar(255),
State varchar(255),
City varchar(255)
);
ALTER TABLE PINCODE
MODIFY Country NOT NULL
MODIFY State NOT NULL
MODIFY City NOT NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Payments
CREATE TABLE PAYMENTS(
Billing_ID int primary key,
User_ID int,
Name_On_Card varchar(255),
Card_Number varchar(255),
CVV varchar(255),
Created_At date
);
ALTER TABLE PAYMENTS
Add CONSTRAINT User_ID_FK foreign key (User_ID) references USER_INFO(User_ID)

Alter table PAYMENTS
MODIFY Name_On_Card NOT NULL
MODIFY Card_Number varchar (16) NOT NULL
MODIFY CVV varchar (4) NOT NULL
MODIFY Created_At NOT NULL

----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- User
-- invalid table name
CREATE TABLE USER_INFO(
User_ID int primary key,
User_Zip_Code int,
User_Name varchar(255),
User_Email varchar(255),
User_Passcode varchar(255),
Created_At date,
Updated_at date
);
ALTER TABLE USER_INFO
ADD CONSTRAINT User_Zip_Code_FK foreign key (User_Zip_Code) references PINCODE(Zip_Code);

ALTER TABLE USER_INFO
MODIFY User_Name NOT NULL
MODIFY User_Email NOT NULL
MODIFY User_Passcode NOT NULL
MODIFY Created_At NOT NULL

----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Profile
CREATE TABLE PROFILE(
Profile_ID int primary key,
User_ID int,
Profile_Name varchar(255),
Device_Info varchar(255),
Profile_Type varchar(255),
Created_At date,
Updated_At date
);
ALTER TABLE PROFILE 
ADD CONSTRAINT User_ID_FK_2 foreign key (User_ID) references USER_INFO(User_ID)
MODIFY Profile_Name NOT NULL
MODIFY Device_Info NOT NULL
MODIFY Profile_Type NOT NULL
MODIFY Created_At NOT NULL
;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Reviews 
CREATE TABLE REVIEWS(
Review_ID int primary key,
User_ID int,
App_ID int,
Rating int,
Feedback varchar(255)
);


ALTER TABLE REVIEWS
ADD CONSTRAINT User_ID_FK_3 foreign key (User_ID) references USER_INFO(User_ID)
MODIFY Rating NOT NULL
MODIFY Feedback NOT NULL;

ALTER TABLE REVIEWS
ADD CONSTRAINT App_ID_FK foreign key (App_ID) references APPLICATION(App_ID);

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User_App_Catalogue
CREATE TABLE USER_APP_CATALOGUE(
Catalogue_ID int primary key,
App_ID int,
Profile_ID int,
Installed_Version int,
Is_Update_Available NUMBER(1) DEFAULT 0 CHECK (Is_Update_Available IN (0, 1)),
Install_Policy_Desc varchar(255),
Is_Accepted NUMBER(1) DEFAULT 0 CHECK (Is_Accepted IN (0, 1))
);


ALTER TABLE USER_APP_CATALOGUE
ADD CONSTRAINT Profile_ID_FK foreign key (Profile_ID) references PROFILE(Profile_ID)
MODIFY Installed_Version Not Null
MODIFY Is_Update_Available Not Null
MODIFY Install_Policy_Desc Not Null
MODIFY Is_Accepted Not Null;

ALTER TABLE USER_APP_CATALOGUE
ADD CONSTRAINT App_ID_FK_2 foreign key (App_ID) references APPLICATION(App_ID);


----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DROP TABLE ADVERTISEMENT;
-- DROP TABLE SUBSCRIPTION;
-- DROP TABLE APPLICATION;
-- DROP TABLE DEVELOPER;
-- DROP TABLE APP_CATEGORY;

--------------------------------------------------------------------------------
-- RUN THIS AFTER USER_INFO CREATED
---------------------------------------------
CREATE TABLE DEVELOPER (
	Developer_ID INTEGER NOT NULL,
	Developer_Name VARCHAR(255) NOT NULL,
	Developer_Email VARCHAR(255) NOT NULL,
	Developer_Password VARCHAR(255) NOT NULL,
	Organization_Name VARCHAR(255) NOT NULL,
	License_Number INTEGER NOT NULL,
	License_Description VARCHAR(4000) NOT NULL,
	License_Date DATE NOT NULL,
	CONSTRAINT Developer_ID_PK Primary Key (Developer_ID)
);
---------------------------------------------
CREATE TABLE APP_CATEGORY (
	Category_ID INTEGER NOT NULL,
	Category_Description VARCHAR(255) NOT NULL,
	Category_Type VARCHAR(255) NOT NULL,
	Number_Of_Apps INTEGER NOT NULL,
	CONSTRAINT Category_ID_PK Primary Key (Category_ID)
);
---------------------------------------------
CREATE TABLE APPLICATION (
	App_ID INTEGER NOT NULL,
	Developer_ID INTEGER NOT NULL,
	Category_ID INTEGER NOT NULL,
	App_Name VARCHAR(255) NOT NULL,
	App_Size INTEGER NOT NULL,
	App_Version INTEGER NOT NULL,
	App_Language VARCHAR(255) NOT NULL,
	Download_Count INTEGER NOT NULL,
	Target_Age INTEGER NOT NULL,
	Supported_OS VARCHAR(255) NOT NULL,
	Overall_Rating INTEGER NOT NULL,
    APP_CREATE_DT DATE NOT NULL,
	CONSTRAINT App_ID_PK Primary Key (App_ID),
	CONSTRAINT APPLICATION_FK1 Foreign Key (Developer_ID) references DEVELOPER(Developer_ID),
	CONSTRAINT APPLICATION_FK2 Foreign Key (Category_ID) references APP_CATEGORY(CATEGORY_ID)
);
---------------------------------------------
CREATE TABLE ADVERTISEMENT (
	Ad_ID INTEGER NOT NULL,
	Developer_ID INTEGER NOT NULL,
	App_ID INTEGER NOT NULL,
	Ad_Details VARCHAR(255) NOT NULL,
	Ad_Cost DECIMAL NOT NULL,
	CONSTRAINT Ad_ID_PK Primary Key (Ad_ID),
	CONSTRAINT ADVERTISEMENT_FK1 Foreign Key (Developer_ID) references DEVELOPER(Developer_ID),
	CONSTRAINT ADVERTISEMENT_FK2 Foreign Key (APP_ID) references APPLICATION(APP_ID)
);
---------------------------------------------
CREATE TABLE SUBSCRIPTION (
	Subscription_ID INTEGER NOT NULL,
	App_ID INTEGER NOT NULL,
	User_ID INTEGER NOT NULL,
	Subscription_Name VARCHAR(255) NOT NULL,
	Type VARCHAR(255) NOT NULL CONSTRAINT CHECK_CONSTRAINT_TYPE CHECK(TYPE IN ('One Time', 'Recurring')),
	Subcription_Start_Dt DATE NOT NULL,
	Subscription_End_Dt DATE NOT NULL,
	Subscription_Amount DECIMAL NOT NULL,
	CONSTRAINT Subscription_ID_PK Primary Key (Subscription_ID),
	CONSTRAINT SUBSCRIPTION_FK1 Foreign Key (APP_ID) references APPLICATION(APP_ID),
	CONSTRAINT SUBSCRIPTION_FK2 Foreign Key (User_ID) references USER_INFO(User_ID)
);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for "Pincode"
INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100001, 'India', 'Delhi', 'New Delhi');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100034, 'India', 'Maharashtra', 'Mumbai');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100023, 'USA', 'Massachusetts', 'Boston');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100043, 'USA', 'Massachusetts', 'Salem');

INSERT INTO PINCODE (Zip_Code, Country, State, City)
VALUES (100056, 'Italy', 'Massachusetts', 'Lowell');

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for USER_INFO

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for DEVELOPER
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for APP_CATEGORY
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for PAYMENTS
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------


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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert into REVIEWS
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
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

SELECT * FROM USER_APP_CATALOGUE;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------
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
























































