-------------- Creating all TRIGGERS ---------------
-- UPDATE THE OVERALL RATING
--drop trigger update_overall_rating;
-- CREATE OR REPLACE TRIGGER update_overall_rating
-- AFTER INSERT or update ON reviews
-- FOR EACH ROW
-- BEGIN
--     UPDATE application 
--     SET overall_rating = (SELECT ROUND(AVG(rating))
--                             FROM reviews 
--                             WHERE app_id = :new.app_id)
--     WHERE app_id = :new.app_id;
-- END;
-- /

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



-- TESTING
-- user trigger
SELECT * FROM USER_INFO;

DELETE FROM USER_INFO WHERE USER_ID = 1;

SELECT * FROM USER_INFO;
SELECT * FROM PROFILE;
SELECT * FROM PAYMENTS;
SELECT * FROM SUBSCRIPTION;

-- average review trigger
select * from reviews;

INSERT INTO REVIEWS (Review_ID, User_ID, App_ID, Rating, Feedback)
VALUES(306, 5, 505, 1, 'Bad App');

select * from reviews;
select * from application;

-- download count trigger
select * from application;

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (406, 502, 11, 2, 1, 'Auto-update', 1);

select * from USER_APP_CATALOGUE;
select * from application;

-- update available trigger --> SUCCESS
select * from application;
update application set app_version = 100 where app_id = 502;

select * from application;
SELECT * from user_app_catalogue;


-- num_of_apps trigger
select * from application;

INSERT INTO USER_APP_CATALOGUE (Catalogue_ID, App_ID, Profile_ID, Installed_Version, Is_Update_Available, Install_Policy_Desc, Is_Accepted)
VALUES (406, 502, 11, 2, 1, 'Auto-update', 1);

select * from USER_APP_CATALOGUE;
select * from application;
