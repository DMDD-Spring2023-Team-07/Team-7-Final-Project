set serveroutput on

CREATE SEQUENCE LICENSE_SEQ
 MINVALUE 0
 START WITH     500
 INCREMENT BY   5;


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



-- EXECUTE insert_pincode(2119, 'United States', 'Massachusets', 'Boston');
GRANT EXECUTE ON DBMS_CRYPTO TO DB_ADMIN;



CREATE OR REPLACE FUNCTION encrypt_password(user_password VARCHAR2) RETURN VARCHAR2
AS
    p_key VARCHAR2(9) := '123456789';
BEGIN
  RETURN DBMS_CRYPTO.encrypt( UTL_RAW.CAST_TO_RAW (user_password), dbms_crypto.DES_CBC_PKCS5, UTL_RAW.CAST_TO_RAW (p_key) );
END;
/


CREATE OR REPLACE FUNCTION decryp_password(password_encrypt VARCHAR2) RETURN VARCHAR2
AS
    p_key VARCHAR2(9) := '123456789';
BEGIN
   RETURN UTL_RAW.CAST_TO_VARCHAR2 ( DBMS_CRYPTO.decrypt( password_encrypt, dbms_crypto.DES_CBC_PKCS5, UTL_RAW.CAST_TO_RAW (p_key) ) );
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


EXECUTE insert_developer('Jhon Doe','jhon1@northeastern.edu', '123456789', 'Northeastern University2', 'Basic license description');



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

EXECUTE insert_application('','Health', 'WhatsApp', 85, 'English', 10, 'Android');
EXECUTE insert_application('rishab@gmail.com','', 'WhatsApp', 85, 'English', 10, 'Android');
EXECUTE insert_application('jhon@northeastern.edu','Health', 'WhatsApp', 85, 'English', 10, 'Android');

EXECUTE insert_application('jhon1@northeastern.edu','Health', 'Facebook', 85, 'English', 10, 'iOS');





