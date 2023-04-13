--------------------------------------------------------------------------------------------------------------------------
-- TESTS FOR DB_ADMIN
-- Has access to everything


--------------------------------------------------------------------------------------------------------------------------
-- TESTS FOR DEVELOPER_MANAGER
-- Tables:
select * from db_admin.user_info;

-- Insert:
INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL,100001, 'John Doe', 'johndoe@example.com', 'password123', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-01', 'YYYY-MM-DD'));

-- Views:
select * from db_admin.user_payment_dashboard;

-- Procedures:
execute insert_user_info (100001, 'test test', 'test@example.com', 'test');


--------------------------------------------------------------------------------------------------------------------------
-- TESTS FOR USER_MANAGER
-- Tables:
select * from db_admin.application;

-- Insert:
INSERT INTO APPLICATION (App_ID, Developer_ID, Category_ID, App_Name, App_Size, App_Version, App_Language, Download_Count, Target_Age, Supported_OS, Overall_Rating, APP_CREATE_DT)
VALUES (APPLICATION_SEQ.NEXTVAL, DEVELOPER_SEQ.CURRVAL,CATEGORY_SEQ.CURRVAL, 'Shazam', 50, 1, 'English', 100, 18, 'iOS', 4, TO_DATE('2023-03-03', 'YYYY-MM-DD'));

-- Views:
select * from db_admin.dev_app_status;

-- Procedures:
execute insert_application('test@example.com', 'test', 'test', 10, 'English', 10, 'iOS');

--------------------------------------------------------------------------------------------------------------------------
-- TESTS FOR STORE_ADMIN
-- Tables:
select * from db_admin.payments;

-- Insert:
INSERT INTO PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(BILLING_SEQ.NEXTVAL,USER_SEQ.CURRVAL, 'John Doe', 1345367829875712, 3445, TO_DATE('2022-03-02', 'YYYY-MM-DD'));

-- Views:
select * from db_admin.user_payment_dashboard;

-- Procedures:
execute insert_payment('test@example.com', 'test test', 12213232312, 1234);