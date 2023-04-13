set serveroutput on

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
-- CREATE OR REPLACE TRIGGER update_available_update_flag
-- AFTER UPDATE ON application
-- FOR EACH ROW
-- BEGIN
--     UPDATE user_app_catalogue 
--     SET is_update_available = 1
--     WHERE app_id = :new.app_id;
-- END;
-- /


-- UPDATE NUMBER_OF_APPS IN APP_CATEGORY 
-- drop trigger update_number_of_apps;
CREATE OR REPLACE TRIGGER update_number_of_apps
AFTER insert ON application
FOR EACH ROW
BEGIN
    UPDATE app_category 
    SET number_of_apps = number_of_apps + 1
    WHERE category_id = :new.category_id;
END;
/