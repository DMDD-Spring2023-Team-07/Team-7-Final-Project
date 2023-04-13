set serveroutput on


CREATE OR REPLACE PACKAGE ADMIN_PACKAGE AS

    -- Procedure to Delete an Ad.
    PROCEDURE delete_advertisement(p_ad_id IN advertisement.ad_id%TYPE);
    
    -- Procedure to publish Ad
    PROCEDURE publish_ad(
        p_app_name IN application.app_name%TYPE,
        p_ad_details IN advertisement.ad_details%TYPE,
        p_ad_cost IN advertisement.ad_cost%TYPE
    );

    -- GET all advertisement based on APP_ID
    PROCEDURE get_advertisements_by_app_id(
        p_app_id IN advertisement.app_id%TYPE
    );
    
    -- UPDATE an Ad details and budget
    PROCEDURE update_advertisement (
        p_ad_id IN advertisement.ad_id%TYPE,
        p_ad_details IN advertisement.ad_details%TYPE,
        p_ad_cost IN advertisement.ad_cost%TYPE
    );
    
    
    -- Add a new app category
    PROCEDURE add_app_category(
        p_category_type IN app_category.category_type%TYPE,
        p_category_description IN app_category.category_description%TYPE
    );
    
    
    -- Update a category by id
    PROCEDURE update_category_description (
        p_category_id          IN app_category.category_id%TYPE,
        p_category_description IN app_category.category_description%TYPE
    );
    
    
    -- Adding a new pincode
    PROCEDURE add_new_pincode(
        p_zip_code IN pincode.zip_code%TYPE,
        p_country IN pincode.country%TYPE,
        p_state IN pincode.state%TYPE,
        p_city IN pincode.city%TYPE
    );
    
    
    -- Sign up a new developer account
    PROCEDURE sign_up_developer(
        p_developer_name IN developer.developer_name%TYPE,
        p_developer_email IN developer.developer_email%TYPE,
        p_developer_password IN developer.developer_password%TYPE,
        p_organization_name IN developer.organization_name%TYPE,
        p_license_description IN developer.license_description%TYPE
    );
    
    
    PROCEDURE update_developer(
        p_developer_id IN developer.developer_id%TYPE,
        p_developer_name IN developer.developer_name%TYPE,
        p_developer_email IN developer.developer_email%TYPE,
        p_developer_password IN developer.developer_password%TYPE,
        p_organization_name IN developer.organization_name%TYPE,
        p_license_number IN developer.license_number%TYPE,
        p_license_description IN developer.license_description%TYPE,
        p_license_date IN developer.license_date%TYPE
    );
    
    
    -- Deleting a review by review_id
    PROCEDURE delete_review(review_id IN INT);
        
END ADMIN_PACKAGE;
/


CREATE OR REPLACE PACKAGE BODY ADMIN_PACKAGE AS

    ---------------------- PROCEDURES FOR ADVERTISEMENTS TABLE -------------------------------

    PROCEDURE delete_advertisement(p_ad_id IN advertisement.ad_id%TYPE) IS
    BEGIN
      DELETE FROM advertisement
      WHERE ad_id = p_ad_id;
      DBMS_OUTPUT.PUT_LINE('Advertisement with ad_id ' || p_ad_id || ' deleted successfully.');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Advertisement with ad_id ' || p_ad_id || ' not found.');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error deleting advertisement: ' || SQLERRM);
    END delete_advertisement;
    
    
    
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
      
    END get_advertisements_by_app_id;
    
    
    -- Procedure to update an Ad
    PROCEDURE update_advertisement (
        p_ad_id IN advertisement.ad_id%TYPE,
        p_ad_details IN advertisement.ad_details%TYPE,
        p_ad_cost IN advertisement.ad_cost%TYPE
    )
    IS
    BEGIN
        UPDATE advertisement
        SET ad_details = p_ad_details,
            ad_cost = p_ad_cost
        WHERE ad_id = p_ad_id;
        
        DBMS_OUTPUT.PUT_LINE('Advertisement updated successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Advertisement with ad_id ' || p_ad_id || ' does not exist.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred while updating advertisement with ad_id ' || p_ad_id || ': ' || SQLERRM);
    END update_advertisement;
    
    
    ---------------------- PROCEDURES FOR CATEGORY TABLE -------------------------------
    
    -- Category addition
    PROCEDURE add_app_category(
        p_category_type IN app_category.category_type%TYPE,
        p_category_description IN app_category.category_description%TYPE
    )
    AS
    BEGIN
        insert_app_category(p_category_description, p_category_type);
        
        DBMS_OUTPUT.PUT_LINE('New category added successfully.');
    END add_app_category;


    -- Category updation
    PROCEDURE update_category_description (
        p_category_id          IN app_category.category_id%TYPE,
        p_category_description IN app_category.category_description%TYPE
    ) AS
    BEGIN
        UPDATE app_category
        SET category_description = p_category_description
        WHERE category_id = p_category_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Category description updated successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Category ID not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLCODE || ' - ' || SQLERRM);
    END update_category_description;
    
    ---------------------- PROCEDURES FOR PINCODE TABLE -------------------------------


    -- Pincode Addition
    PROCEDURE add_new_pincode(
        p_zip_code IN pincode.zip_code%TYPE,
        p_country IN pincode.country%TYPE,
        p_state IN pincode.state%TYPE,
        p_city IN pincode.city%TYPE
    )AS
    BEGIN
        insert_pincode(p_zip_code, p_country, p_state, p_city);
    END add_new_pincode;
    
    
    ----------------------  PROCEDURES FOR DEVELOPER TABLE -------------------------------

    -- Sign up Developer account
    PROCEDURE sign_up_developer(
        p_developer_name IN developer.developer_name%TYPE,
        p_developer_email IN developer.developer_email%TYPE,
        p_developer_password IN developer.developer_password%TYPE,
        p_organization_name IN developer.organization_name%TYPE,
        p_license_description IN developer.license_description%TYPE
    ) AS
    BEGIN
        insert_developer(p_developer_name, p_developer_email, p_developer_password, p_organization_name, p_license_description);
    END sign_up_developer;
    
    
    -- Update a Developer account
    PROCEDURE update_developer(
        p_developer_id IN developer.developer_id%TYPE,
        p_developer_name IN developer.developer_name%TYPE,
        p_developer_email IN developer.developer_email%TYPE,
        p_developer_password IN developer.developer_password%TYPE,
        p_organization_name IN developer.organization_name%TYPE
    ) AS
    BEGIN
        UPDATE developer
        SET developer_name = p_developer_name,
            developer_email = p_developer_email,
            developer_password = p_developer_password,
            organization_name = p_organization_name
        WHERE developer_id = p_developer_id;
        
        COMMIT;
        dbms_output.put_line('Developer details updated successfully');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLCODE || ' - ' || SQLERRM);
            ROLLBACK;
    END update_developer;
    
    
    ----------------------  PROCEDURES FOR REVIEW TABLE -------------------------------

    PROCEDURE delete_review(review_id IN INT) AS
    BEGIN
        DELETE FROM reviews WHERE review_id = delete_review.review_id;
        DBMS_OUTPUT.PUT_LINE('Review deleted successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Review with review_id ' || delete_review.review_id || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END delete_review;
    
    
    

END ADMIN_PACKAGE;
/