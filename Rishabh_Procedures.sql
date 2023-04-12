set serveroutput on


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

    SELECT COUNT(*) INTO v_count
    FROM pincode
    WHERE zip_code = p_zip_code;

    IF v_count = 0 THEN
        
        -- Check for
        IF p_zip_code IS NULL OR p_zip_code = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid zipcode');
        END IF;
        
        v_state := INITCAP(p_state);
        v_city := INITCAP(p_city);
        v_country := INITCAP(p_country);
            
        INSERT INTO pincode(zip_code, country, state, city)
        VALUES(p_zip_code, v_country, v_state, v_city);
        
        DBMS_OUTPUT.PUT_LINE('Pincode inserted');

        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pincode already exists');

        RAISE_APPLICATION_ERROR(-20001, 'Pincode already exists');
    END IF;


    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;





-- EXECUTE insert_pincode(02119, 'United States', 'Massachusets', 'Boston');


-- Procedure for User table

CREATE OR REPLACE PROCEDURE insert_user_info (
    p_user_zip_code IN user_info.user_zip_code%TYPE,
    p_user_name     IN user_info.user_name%TYPE,
    p_user_email    IN user_info.user_email%TYPE,
    p_user_passcode IN user_info.user_passcode%TYPE
) IS
    v_number_of_code NUMBER;
    v_user_name      VARCHAR(225);
    v_user_email     VARCHAR(225);
BEGIN

    -- Check for invalid department name
    IF p_user_email IS NULL OR length(p_user_email) = 0 OR NOT regexp_like(p_user_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    ) THEN
        raise_application_error(-20001, 'Invalid user email');
    END IF;

    -- Check for invalid department name
    IF p_user_name IS NULL OR length(pro_dept_name) = 0 OR regexp_like(pro_dept_name, '^\d+$') THEN
        raise_application_error(-20002, 'Invalid user name');
    END IF;
    
    -- Check for pincode
    SELECT
        COUNT(*)
    INTO v_number_of_code
    FROM
        pincode
    WHERE
        zipcode = p_user_zip_code;

    IF number_of_dept = 0 THEN
        dbms_output.put_line('Zip code does not exists');
        raise_application_error(-20003, 'Invalid zipcode or not available');
    END IF;

    v_user_name := initcap(p_user_name);
    v_user_email := lower(p_user_email);
    
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
        p_user_passcode,
        sysdate,
        sysdate
    );

    dbms_output.put_line('User info inserted successfully');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: '
                             || sqlcode
                             || ' - '
                             || sqlerrm);
END;

