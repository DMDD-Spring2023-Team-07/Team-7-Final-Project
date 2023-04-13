set serveroutput on


CREATE OR REPLACE PACKAGE DEVELOPER_PACKAGE AS



    -- Procedure to release a New App
    PROCEDURE publish_application (
        p_developer_email IN developer.developer_email%TYPE,
        p_category_type IN app_category.category_type%TYPE,
        p_app_name IN application.app_name%TYPE,
        p_app_size IN application.app_size%TYPE,
        p_app_language IN application.app_language%TYPE,
        p_target_age IN application.target_age%TYPE,
        p_supported_os IN application.supported_os%TYPE
    );
    
    
    -- GET all available Categories for the app
    PROCEDURE get_app_categories;
 
    -- Procedure to publish an Ad for specific App.
    PROCEDURE publish_ad(
        p_app_name IN application.app_name%TYPE,
        p_ad_details IN advertisement.ad_details%TYPE,
        p_ad_cost IN advertisement.ad_cost%TYPE
    );
       
       
    PROCEDURE get_advertisements_by_app_id(
        p_app_id IN advertisement.app_id%TYPE
    );

END DEVELOPER_PACKAGE;
/


CREATE OR REPLACE PACKAGE BODY DEVELOPER_PACKAGE AS

    
    -- Procedure body to release a New App
    PROCEDURE publish_application (
        p_developer_email IN developer.developer_email%TYPE,
        p_category_type IN app_category.category_type%TYPE,
        p_app_name IN application.app_name%TYPE,
        p_app_size IN application.app_size%TYPE,
        p_app_language IN application.app_language%TYPE,
        p_target_age IN application.target_age%TYPE,
        p_supported_os IN application.supported_os%TYPE
    )IS
    BEGIN
        insert_application(p_developer_email, p_category_type, p_app_name, p_app_size, p_app_language, p_target_age, p_supported_os);
    END publish_application;
    
    -- Procedure body to get all categories
    PROCEDURE get_app_categories
    IS
        CURSOR app_category_cur IS
        SELECT category_id, category_description, category_type, number_of_apps
        FROM app_category;
    BEGIN
          DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('CATEGORY ID | CATEGORY DESCRIPTION | CATEGORY TYPE | NUMBER OF APPS');
          DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
          FOR app_category_rec IN app_category_cur LOOP
            DBMS_OUTPUT.PUT_LINE(
              app_category_rec.category_id || ' | ' ||
              app_category_rec.category_description || ' | ' ||
              app_category_rec.category_type || ' | ' ||
              app_category_rec.number_of_apps
            );
          END LOOP;
          DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
    END get_app_categories;
    
    
    PROCEDURE publish_ad(
        p_app_name IN application.app_name%TYPE,
        p_ad_details IN advertisement.ad_details%TYPE,
        p_ad_cost IN advertisement.ad_cost%TYPE
    ) IS
    BEGIN
        insert_advertisement(p_app_name, p_ad_details, p_ad_cost);
    END publish_ad;
    
    
    
    -- PROCEDURE body to get all advertisement based on APP_ID
    PROCEDURE get_advertisements_by_app_id(
        p_app_id IN advertisement.app_id%TYPE
    )
    IS
      CURSOR c_advertisements IS
        SELECT ad_id, developer_id, app_id, ad_details, ad_cost
        FROM advertisement
        WHERE app_id = p_app_id;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('Advertisements for App ID ' || p_app_id || ':');
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
      
      FOR advertisement_rec IN c_advertisements LOOP
        DBMS_OUTPUT.PUT_LINE('Ad ID: ' || advertisement_rec.ad_id);
        DBMS_OUTPUT.PUT_LINE('Developer ID: ' || advertisement_rec.developer_id);
        DBMS_OUTPUT.PUT_LINE('App ID: ' || advertisement_rec.app_id);
        DBMS_OUTPUT.PUT_LINE('Ad Details: ' || advertisement_rec.ad_details);
        DBMS_OUTPUT.PUT_LINE('Ad Cost: ' || advertisement_rec.ad_cost);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
      END LOOP;
      
    END;

END DEVELOPER_PACKAGE;
/


GRANT EXECUTE ON DEVELOPER_PACKAGE TO DEVELOPER_MANAGER;
GRANT EXECUTE ON insert_application TO DEVELOPER_MANAGER;




-- EXECUTE DEVELOPER_PACKAGE.publish_application('jhon@northeastern.edu', 'Health', 'TikTok', 90, 'English', 10, 'iOS');

-- EXECUTE DEVELOPER_PACKAGE.get_app_categories;

-- EXECUTE DEVELOPER_PACKAGE.get_advertisements_by_app_id(15);

-- EXECUTE DEVELOPER_PACKAGE.publish_ad('Whatsapp', 'BINGO50', 10.5);


