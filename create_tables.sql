


DROP TABLE ADVERTISEMENT;
DROP TABLE SUBSCRIPTION;
DROP TABLE APPLICATION;
DROP TABLE DEVELOPER;
DROP TABLE APP_CATEGORY;

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



