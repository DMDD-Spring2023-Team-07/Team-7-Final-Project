set serveroutput on

--------------------------------------------------------------------------------
-------------- CREATE PROCEDURES ---------------
-- RISHABH

-- Procedure for Inserting a Pincode
CREATE OR REPLACE PROCEDURE insert_pincode(
    p_zip_code IN pincode.zip_code%TYPE,
    p_country IN pincode.country%TYPE,
    p_state IN pincode.state%TYPE,
    p_city IN pincode.city%TYPE
)
IS
v_count NUMBER;
v_country VARCHAR(225);
v_state VARCHAR(225);
v_city VARCHAR(225);
BEGIN

    -- Check for
    IF p_zip_code IS NULL OR p_zip_code = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid zipcode');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM pincode
    WHERE zip_code = p_zip_code;

    IF v_count = 0 THEN
        
        v_state := INITCAP(p_state);
        v_city := INITCAP(p_city);
        v_country := INITCAP(p_country);
            
        INSERT INTO pincode(zip_code, country, state, city)
        VALUES(p_zip_code, v_country, v_state, v_city);
        
        DBMS_OUTPUT.PUT_LINE('Pincode inserted');

        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pincode already exists');

        RAISE_APPLICATION_ERROR(-20002, 'Pincode already exists');
    END IF;


    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/


-- Procedure for User table

CREATE OR REPLACE PROCEDURE insert_user_info (
    p_user_zip_code IN user_info.user_zip_code%TYPE,
    p_user_name     IN user_info.user_name%TYPE,
    p_user_email    IN user_info.user_email%TYPE,
    p_user_passcode IN user_info.user_passcode%TYPE
) IS
    v_number_of_code NUMBER;
    v_number_of_user NUMBER;
    v_user_name      VARCHAR(225);
    v_user_email     VARCHAR(225);
BEGIN

    -- Check for invalid email
    IF p_user_email IS NULL OR length(p_user_email) = 0 OR NOT regexp_like(p_user_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        raise_application_error(-20001, 'Invalid user email');
    END IF;

    -- Check for invalid user name
    IF p_user_name IS NULL OR length(p_user_name) = 0 OR regexp_like(p_user_name, '^\d+$') THEN
        raise_application_error(-20002, 'Invalid user name');
    END IF;
    
    -- Check for pincode
    SELECT
        COUNT(*)
    INTO v_number_of_code
    FROM
        pincode
    WHERE
        zip_code = p_user_zip_code;

    IF v_number_of_code = 0 THEN
        dbms_output.put_line('Zip code does not exists');
        raise_application_error(-20003, 'Invalid zipcode or not available');
    END IF;

    v_user_name := initcap(p_user_name);
    v_user_email := lower(p_user_email);
    
    SELECT
        COUNT(*)
    INTO v_number_of_user
    FROM
        user_info
    WHERE
        user_email = v_user_email;
        
        
    IF v_number_of_user > 0 THEN
        dbms_output.put_line('User already exists' || v_user_email);
        raise_application_error(-20004, 'User already exists with email');
    END IF;
    
    INSERT INTO user_info (
        user_id,
        user_zip_code,
        user_name,
        user_email,
        user_passcode,
        created_at,
        updated_at
    ) VALUES (
        user_seq.NEXTVAL,
        p_user_zip_code,
        v_user_name,
        v_user_email,
        encrypt_password(p_user_passcode),
        sysdate,
        sysdate
    );

    dbms_output.put_line('User info inserted successfully');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || sqlcode || ' - ' || sqlerrm);
END;
/


-- EXECUTE insert_user_info(2117, 'Rishabh Jain', 'rishab@gmail.com', '123456789');

-- Procedure for profile
CREATE OR REPLACE PROCEDURE create_profile(
    p_user_email IN user_info.user_email%TYPE,
    p_profilename IN profile.profile_name%TYPE,
    p_device_info IN profile.device_info%TYPE,
    p_profile_type IN profile.profile_type%TYPE
)
IS
    l_user_id user_info.user_id%TYPE;
    l_profile_id profile.profile_id%TYPE;
BEGIN
    -- Check if the provided user_email exists in the user_info table
    SELECT user_id INTO l_user_id
    FROM user_info
    WHERE user_email = p_user_email;
    
    -- If no rows are returned, raise an error
    IF l_user_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'User with email ' || p_user_email || ' does not exist');
    END IF;
    
    -- Check if any of the parameters are null or empty
    IF p_profilename IS NULL OR TRIM(p_profilename) = '' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Profile name cannot be null or empty');
    END IF;
    
    IF p_device_info IS NULL OR TRIM(p_device_info) = '' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Device info cannot be null or empty');
    END IF;
    
    IF p_profile_type IS NULL OR TRIM(p_profile_type) = '' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Profile type cannot be null or empty');
    END IF;
    
    
    -- Insert the new row into the profile table
    INSERT INTO profile(profile_id, user_id, profile_name, device_info, profile_type, created_at, updated_at)
    VALUES(PROFILE_SEQ.NEXTVAL, l_user_id, p_profilename, p_device_info, p_profile_type, SYSDATE, SYSDATE);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || sqlcode || ' - ' || sqlerrm);
END;
/

-- EXECUTE create_profile('rishab@gmail.com','rishabh_profile','android device','private');

-- select * from profile;

-- INSERT into developer table
CREATE OR REPLACE PROCEDURE insert_developer(
    p_developer_name IN developer.developer_name%TYPE,
    p_developer_email IN developer.developer_email%TYPE,
    p_developer_password IN developer.developer_password%TYPE,
    p_organization_name IN developer.organization_name%TYPE,
    p_license_description IN developer.license_description%TYPE
)
IS
    v_developer_id developer.developer_id%TYPE;
    v_email_count NUMBER;
    v_org_count NUMBER;

BEGIN
    -- Check for null or empty values
    IF p_developer_name IS NULL OR TRIM(p_developer_name) = '' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Developer name is required');
    END IF;
    
    IF p_developer_email IS NULL OR TRIM(p_developer_email) = '' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Developer email is required');
    END IF;
    
    IF p_developer_password IS NULL OR TRIM(p_developer_password) = '' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Developer password is required');
    END IF;
    
    IF p_organization_name IS NULL OR TRIM(p_organization_name) = '' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Organization name is required');
    END IF;
    
    IF p_license_description IS NULL OR TRIM(p_license_description) = '' THEN
        RAISE_APPLICATION_ERROR(-20005, 'License description is required');
    END IF;
    
    -- Check if developer_email already exists
    SELECT COUNT(*) INTO v_email_count FROM developer WHERE developer_email = p_developer_email;
    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Developer email already exists');
    END IF;
    
    -- Check if organization_name already exists
    SELECT COUNT(*) INTO v_org_count FROM developer WHERE organization_name = p_organization_name;
    IF v_org_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Organization name already exists');
    END IF;

    -- Generate a new developer ID using a sequence
    SELECT developer_seq.NEXTVAL INTO v_developer_id FROM dual;

    -- Insert the new record into the developer table
    INSERT INTO developer(developer_id, developer_name, developer_email, developer_password, organization_name, license_number, license_description, license_date)
    VALUES(v_developer_id, p_developer_name, p_developer_email, encrypt_password(p_developer_password), p_organization_name, LICENSE_SEQ.NEXTVAL, p_license_description, SYSDATE);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || sqlcode || ' - ' || sqlerrm);
END;


-- EXECUTE insert_developer('Jhon Doe','jhon1@northeastern.edu', '123456789', 'Northeastern University2', 'Basic license description');



-- App category

CREATE OR REPLACE PROCEDURE insert_app_category(
    p_category_description IN app_category.category_description%TYPE,
    p_category_type IN app_category.category_type%TYPE
)
IS
    v_number_of_apps INTEGER := 0;
    v_category_type VARCHAR(255);
    v_category_id app_category.category_id%TYPE;
BEGIN
    IF p_category_description IS NULL OR LENGTH(p_category_description) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Category description cannot be null or empty');
    END IF;
    
    IF p_category_type IS NULL OR REGEXP_LIKE(p_category_type, '^\d+$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid category type');
    END IF;
    
    v_category_type := INITCAP(p_category_type);

    -- Check if category_type already exists in app_category table
    SELECT category_id INTO v_category_id FROM app_category WHERE category_type = v_category_type;
    
    IF v_category_id IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Category type already exists');
    END IF;
    
    INSERT INTO app_category(category_id, category_description, category_type, number_of_apps)
    VALUES (category_seq.nextval, p_category_description, v_category_type, v_number_of_apps);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || sqlcode || ' - ' || sqlerrm);
END;

-- EXECUTE insert_app_category('Health','test1');
-- EXECUTE insert_app_category('Gaming','test2');



-- Procedure for Application table

CREATE OR REPLACE PROCEDURE insert_application (
    p_developer_email IN developer.developer_email%TYPE,
    p_category_type IN app_category.category_type%TYPE,
    p_app_name IN application.app_name%TYPE,
    p_app_size IN application.app_size%TYPE,
    p_app_language IN application.app_language%TYPE,
    p_target_age IN application.target_age%TYPE,
    p_supported_os IN application.supported_os%TYPE
) IS
    v_developer_id NUMBER;
    v_developer_count NUMBER;
    v_category_count NUMBER;
    v_app_count NUMBER;
    v_app_name application.app_name%TYPE;
    v_category_id app_category.category_id%TYPE;
    v_app_id application.app_id%TYPE;
    v_app_version application.app_version%TYPE := 1;
BEGIN
    -- Check for null or empty values
    IF p_developer_email IS NULL OR TRIM(p_developer_email) = '' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Developer email is required');
    END IF;
    
    IF p_category_type IS NULL OR TRIM(p_category_type) = '' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Category type is required');
    END IF;

    IF p_app_name IS NULL OR TRIM(p_app_name) = '' THEN
        RAISE_APPLICATION_ERROR(-20003, 'App name is required');
    END IF;
    

    IF p_app_language IS NULL OR TRIM(p_app_language) = '' THEN
        RAISE_APPLICATION_ERROR(-20005, 'App language is required');
    END IF;
    
    SELECT COUNT(*) INTO v_developer_count
    FROM developer
    WHERE developer_email = LOWER(p_developer_email);
    
    IF v_developer_count = 0 THEN
        dbms_output.put_line('Developer email not found' || p_developer_email);
        raise_application_error(-20004, 'Developer email does not exist');
    END IF;
    
    -- Find the developer ID from the developer table
    SELECT developer_id INTO v_developer_id FROM developer WHERE developer_email = LOWER(p_developer_email);

    
    SELECT COUNT(*) INTO v_category_count
    FROM app_category
    WHERE category_type = INITCAP(p_category_type);
    
    IF v_category_count = 0 THEN
        dbms_output.put_line('Category does not found' || p_developer_email);
        RAISE_APPLICATION_ERROR(-20007, 'Category type does not exist');
    END IF;
    
    -- Find the category ID from the app_category table
    SELECT category_id INTO v_category_id FROM app_category WHERE category_type = INITCAP(p_category_type);

    v_app_name := INITCAP(p_app_name);

    SELECT COUNT(*) INTO v_app_count
    FROM application
    WHERE app_name = v_app_name AND DEVELOPER_ID != v_developer_id;
        
    IF v_app_count > 0 THEN
        dbms_output.put_line('App name already exists - ' || v_app_name);
        RAISE_APPLICATION_ERROR(-20007, 'App with this name already exists published by other developer');
    END IF;
    
    
    -- Get the app version from the application table and increment it if the app name already exists
    SELECT COUNT(*) INTO v_app_count
    FROM application
    WHERE app_name = v_app_name AND DEVELOPER_ID = v_developer_id;
    
    dbms_output.put_line('App name with count same dev - ' || v_app_count);

    
    IF v_app_count > 0 THEN
        
        SELECT app_version INTO v_app_version
        FROM application
        WHERE app_name = v_app_name;
        
        IF v_app_version IS NOT NULL THEN
            v_app_version := v_app_version + 1;
        END IF;
        
        UPDATE application
        SET app_version=v_app_version, app_size=p_app_size, category_id=v_category_id, app_language=p_app_language, target_age=p_target_age, supported_os=p_supported_os
        WHERE app_name=v_app_name;
        
        dbms_output.put_line('Application updated succesfully with name - ' || v_app_name);
        
    ELSE
        
        -- Generate a new app ID using a sequence
        SELECT application_seq.NEXTVAL INTO v_app_id FROM dual;
    
        -- Insert the new record into the application table
        INSERT INTO application(app_id, developer_id, category_id, app_name, app_size, app_version, app_language, download_count, target_age, supported_os, overall_rating, app_create_dt)
        VALUES(v_app_id, v_developer_id, v_category_id, v_app_name, p_app_size, v_app_version, p_app_language, 0, p_target_age, p_supported_os, 0.0, SYSDATE);
        dbms_output.put_line('Application is created succesfully with name - ' || v_app_name);
    
    END IF;
    
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || sqlcode || ' - ' || sqlerrm);
END;

-- EXECUTE insert_application('','Health', 'WhatsApp', 85, 'English', 10, 'Android');
-- EXECUTE insert_application('rishab@gmail.com','', 'WhatsApp', 85, 'English', 10, 'Android');
-- EXECUTE insert_application('jhon@northeastern.edu','Health', 'WhatsApp', 85, 'English', 10, 'Android');

-- EXECUTE insert_application('jhon1@northeastern.edu','Health', 'Facebook', 85, 'English', 10, 'iOS');





-- FEL
create or replace procedure PROCEDURE_REVIEWS

(
    p_review_id IN reviews.review_id%TYPE,
    p_rating    IN reviews.rating%TYPE,
    p_feedback  IN reviews.feedback%TYPE
    )
    
    IS 
    
    BEGIN
    
    -- review_id NOT NULL
    IF p_review_id IS NULL OR LENGTH(p_review_id) = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'There should be existing reviews');
  END IF;
    -- rating NOT NULL
    IF p_rating IS NULL OR LENGTH(p_rating) = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'App ratings should exist');
  END IF;
    -- feedback NOT NULL
    IF p_feedback IS NULL OR LENGTH(p_feedback) = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Feedback should exist');
  END IF;
  
    -- Inserting values into the reviews table
    INSERT INTO reviews (review_id, user_id, app_id, rating, feedback)
    VALUES (REVIEW_SEQ.NEXTVAL, USER_SEQ.NEXTVAL, APPLICATION_SEQ.NEXTVAL,4, 'Great app, very user-friendly');
    
    -- Update overall_rating in the application table 
    
    UPDATE application 
    SET overall_rating = (SELECT ROUND(AVG(rating))
                         FROM reviews 
                         WHERE app_id = APPLICATION_SEQ.NEXTVAL)
    WHERE app_id = APPLICATION_SEQ.NEXTVAL;
    
    
    
    
    
    END;
    
 -- Procedure for the table USER_INFO   
    CREATE OR REPLACE PROCEDURE PROCEDURE_USER_INFO (
    p_user_id IN user_info.user_id%TYPE,
    p_user_zip_code IN user_info.user_zip_code%TYPE,
    p_user_name     IN user_info.user_name%TYPE,
    p_user_email    IN user_info.user_email%TYPE,
    p_user_passcode IN user_info.user_passcode%TYPE,
    p_created_at    IN user_info.created_at%TYPE
) 
IS
BEGIN

    IF p_user_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'User ID cannot be NULL');
    END IF;
    
    
    
    IF p_user_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'User name cannot be NULL');
    END IF;
    
    IF p_user_email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'User email cannot be NULL');
    END IF;
    
    IF p_user_passcode IS NULL THEN
        RAISE_APPLICATION_ERROR(-20005, 'User passcode cannot be NULL');
    END IF;
    
    IF p_created_at IS NULL THEN
        RAISE_APPLICATION_ERROR(-20006, 'Created at cannot be NULL');
    END IF;
    
    INSERT INTO USER_INFO (User_ID, User_Zip_Code, User_Name, User_Email, User_Passcode, Created_At, Updated_at) 
VALUES (USER_SEQ.NEXTVAL, 02930, 'John Doe', 'johndoe@example.com', 'password123', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-01', 'YYYY-MM-DD'));
      
END;


-- procedure for table PAYMENTS
    CREATE OR REPLACE PROCEDURE insert_payment (
    p_billing_id IN payments.billing_id%TYPE,
    p_user_id    IN  payments.user_id%TYPE,
    p_name_on_card IN payments.name_on_card%TYPE,
    p_card_number IN payments.card_number%TYPE,
    p_cvv        IN payments.cvv%TYPE,
    p_created_at IN payments.created_at%TYPE
) AS
    v_encrypted_card_number VARCHAR2(255);
BEGIN
    IF p_billing_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Billing ID cannot be NULL');
    END IF;
    
    
    IF p_name_on_card IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Name on card cannot be NULL');
    END IF;
    
    IF p_card_number IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Card number cannot be NULL');
    END IF;
    
    IF p_cvv IS NULL THEN
        RAISE_APPLICATION_ERROR(-20005, 'CVV cannot be NULL');
    END IF;
    
    IF p_created_at IS NULL THEN
        RAISE_APPLICATION_ERROR(-20006, 'Created at cannot be NULL');
    END IF;
    
    -- v_encrypted_card_number := encrypt_card(p_card_number);
    
    INSERT INTO payments (billing_id, user_id, name_on_card, card_number, cvv, created_at) 
    VALUES (BILLING_SEQ.NEXTVAl, USER_SEQ.NEXTVAL, 'John Doe', encrypt_card(1345367829875712), 3445, TO_DATE('2022-03-02', 'YYYY-MM-DD'));
    
END;
    




-- CHARAN
--- Procedure to Insert new Subscription -----------
Create or Replace Procedure procedure_add_subscription(
    p_subscription_id IN  subscription.subscription_id%type,
    p_app_id IN subscription.app_id%type,
    P_user_id IN subscription.user_Id%type,
    p_subscription_name IN subscription.subscription_name%type,
    p_type IN subscription.type%type,
    p_SUBCRIPTION_START_DT IN subscription.SUBCRIPTION_START_DT%type,
    p_SUBSCRIPTION_END_DT IN subscription.SUBSCRIPTION_END_DT%type,
    p_subscription_amount IN subscription.SUBSCRIPTION_AMOUNT%type
)
AS 
BEGIN
  INSERT INTO Subscription( SUBSCRIPTION_ID,APP_ID,USER_ID,SUBSCRIPTION_NAME,TYPE,SUBCRIPTION_START_DT,SUBSCRIPTION_END_DT,SUBSCRIPTION_AMOUNT )
  VALUES ( Subscription_seq.Nextval ,application_seq.nextval ,user_seq.nextval, p_subscription_name ,p_type,p_SUBCRIPTION_START_DT,p_SUBSCRIPTION_END_DT,p_subscription_amount);
--  VALUES ( Subscription_seq.Nextval ,application_seq.nextval ,user_seq.nextval ,'Basic Plan', 'Recurring', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 20.00);
END;

-- Procedure to insert new User-App-Catalogue:

Create  or replace Procedure procedure_add_new_app_catalogue(
    p_CATALOGUE_ID IN User_app_catalogue.CATALOGUE_ID%type,
    p_APP_ID IN User_app_catalogue.APP_ID%type,
    p_PROFILE_ID IN User_app_catalogue.PROFILE_ID%type,
    p_INSTALLED_VERSION IN User_app_catalogue.INSTALLED_VERSIOn%type,
    p_IS_UPDATE_AVAILABLE IN User_app_catalogue.IS_UPDATE_AVAILABLE%type,
    p_INSTALL_POLICY_DESC IN User_app_catalogue.INSTALL_POLICY_DESC%type,
    p_IS_ACCEPTED IN User_app_catalogue.IS_ACCEPTED%type)
    AS
    BEGIN
    INSERT INTO User_app_catalogue(CATALOGUE_ID ,APP_ID,PROFILE_ID ,INSTALLED_VERSION,IS_UPDATE_AVAILABLE,INSTALL_POLICY_DESC,IS_ACCEPTED)
    VALUES ( catalogue_seq.nextval, application_seq.nextval , profile_seq.nextval ,p_install_version , p_is_update_avalilable  ,  p_INSTALL_POLICY_DESC , p_IS_ACCEPTED);
END;

-- Procedure to insert new User in User_INFO Table:
Create or replace Procedure procedure_add_user_info(
    p_user_id IN user_info.CATALOGUE_ID%type,
    p_USER_ZIP_CODE IN user_info.USER_ZIP_CODE %type,
    p_USER_NAME IN user_info.USER_NAME%type,
    p_USER_EMAIL IN user_info.USER_EMAIL%type,
    p_USER_PASSCODE IN user_info.USER_PASSCODE%type,
    p_CREATED_AT IN user_info.CREATED_AT%type,
    p_UPDATED_AT IN user_info.UPDATED_AT%type)
    AS
    BEGIN
    INSERT INTO User_info(USER_ID,USER_ZIP_CODE,USER_NAME,USER_EMAIL,USER_PASSCODE,CREATED_AT,UPDATED_AT)
    VALUES (user_seq.nextval,p_USER_ZIP_CODE,p_USER_NAME,p_USER_EMAIL,p_USER_PASSCODE,p_CREATED_AT,p_UPDATED_AT);
END;
--- Procedure to insert new DEVELOPER table:
Create or replace Procedure procedure_add_new_developer(
    p_DEVELOPER_ID IN Developer.DEVELOPER_ID%type,
    p_DEVELOPER_NAME IN Developer.DEVELOPER_NAME%type,
    p_DEVELOPER_EMAIL IN DEVELOPER_EMAIL%type,
    p_DEVELOPER_PASSWORD IN DEVELOPER_PASSWORD%type,
    p_ORGANIZATION_NAME IN ORGANIZATION_NAME%type,
    p_LICENSE_NUMBER IN LICENSE_NUMBER%type,
    p_LICENSE_DESCRIPTION IN LICENSE_DESCRIPTION%type,
    p_LICENSE_DATE IN LICENSE_DATE%type)
    AS
    BEGIN
    INSERT INTO Developer(DEVELOPER_ID ,DEVELOPER_NAME,DEVELOPER_EMAIL,DEVELOPER_PASSWORD,ORGANIZATION_NAME,LICENSE_NUMBER,LICENSE_DESCRIPTION,LICENSE_DATE)
    VALUES (developer_id_seq.nextval,p_DEVELOPER_NAME,p_DEVELOPER_EMAIL,p_DEVELOPER_PASSWORD,p_ORGANIZATION_NAME,p_LICENSE_NUMBER,p_LICENSE_DESCRIPTION,p_LICENSE_DATE);
END;



