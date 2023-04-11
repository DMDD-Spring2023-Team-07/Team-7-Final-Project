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
    
    