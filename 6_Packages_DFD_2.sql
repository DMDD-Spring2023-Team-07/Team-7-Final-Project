set serveroutput on

CREATE OR REPLACE PACKAGE user_package AS
   
    -- Procedure to post a review by user on app
    PROCEDURE post_review (
        p_app_name   IN application.app_name%TYPE,
        p_user_email IN user_info.user_email%TYPE,
        p_rating     IN NUMBER,
        p_feedback   IN reviews.feedback%TYPE
    );
    
    -- UPDATE a Review
    PROCEDURE update_review(
        p_review_id IN reviews.review_id%TYPE,
        p_rating IN reviews.rating%TYPE,
        p_feedback IN reviews.feedback%TYPE
    );

    -- Procedure for adding billing info
    PROCEDURE add_billing_info (
        p_user_email   IN user_info.user_email%TYPE,
        p_name_on_card IN payments.name_on_card%TYPE,
        p_card_number  IN payments.card_number%TYPE,
        p_cvv          IN payments.cvv%TYPE
    );
    
    
    -- Procedure to get all billing info of a user
    PROCEDURE get_user_payments(
        p_user_id IN payments.user_id%TYPE
    );
    
    -- Procedure to create a new subscriptio
    PROCEDURE buy_subscription (
        p_app_name IN application.app_name%TYPE,
        p_user_email IN user_info.user_email%TYPE,
        p_subscription_name IN subscription.subscription_name%TYPE,
        p_type IN subscription.type%TYPE,
        p_subscription_end_dt IN subscription.subscription_end_dt%TYPE,
        p_subscription_amount IN subscription.subscription_amount%TYPE
    );
 
    -- Procedure to get all the user and app specific subscriptions
    PROCEDURE get_subscriptions (
        p_user_id IN subscription.user_id%TYPE,
        p_app_id  IN subscription.app_id%TYPE
    );

END user_package;
/


CREATE OR REPLACE PACKAGE BODY USER_PACKAGE AS
    -- Procedure for posting a user review
    PROCEDURE post_review(
      p_app_name IN application.app_name%TYPE,
      p_user_email IN user_info.user_email%TYPE,
      p_rating IN NUMBER,
      p_feedback IN reviews.feedback%TYPE
    ) IS
    BEGIN
        insert_review(p_app_name, p_user_email, p_rating, p_feedback);
    END post_review;
    
    -- Procedure to UPDATE A REVIEW
    PROCEDURE update_review(
        p_review_id IN reviews.review_id%TYPE,
        p_rating IN reviews.rating%TYPE,
        p_feedback IN reviews.feedback%TYPE
    )
    IS
    BEGIN
        UPDATE reviews
        SET rating = p_rating,
            feedback = p_feedback
        WHERE review_id = p_review_id;
    
        DBMS_OUTPUT.PUT_LINE('Review ' || p_review_id || ' updated successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No review found with ID ' || p_review_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred while updating the review.');
            DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
    END;

    
    
    -- Procedure for adding a billing Info
    PROCEDURE add_billing_info (
        p_user_email   IN user_info.user_email%TYPE,
        p_name_on_card IN payments.name_on_card%TYPE,
        p_card_number  IN payments.card_number%TYPE,
        p_cvv          IN payments.cvv%TYPE
    ) IS
    BEGIN
        insert_payment(p_user_email,p_name_on_card,p_card_number,p_cvv);
    END add_billing_info;
    
    
    -- Procedure to buy subscription
    PROCEDURE buy_subscription (
        p_app_name IN application.app_name%TYPE,
        p_user_email IN user_info.user_email%TYPE,
        p_subscription_name IN subscription.subscription_name%TYPE,
        p_type IN subscription.type%TYPE,
        p_subscription_end_dt IN subscription.subscription_end_dt%TYPE,
        p_subscription_amount IN subscription.subscription_amount%TYPE
    ) IS
    BEGIN
        insert_subscription(p_app_name,p_user_email,p_subscription_name,p_type, SYSDATE, p_subscription_end_dt,p_subscription_amount);
    END buy_subscription;
    
    -- Procedure for getting all billing info
    PROCEDURE get_user_payments(
        p_user_id IN payments.user_id%TYPE
    )
    IS
        -- Declare cursor
        CURSOR c_payments IS
            SELECT billing_id, user_id, name_on_card, card_number, cvv, created_at
            FROM payments
            WHERE user_id = p_user_id;
    
        -- Declare variables to hold cursor data
        v_billing_id payments.billing_id%TYPE;
        v_user_id payments.user_id%TYPE;
        v_name_on_card payments.name_on_card%TYPE;
        v_card_number payments.card_number%TYPE;
        v_cvv payments.cvv%TYPE;
        v_created_at payments.created_at%TYPE;
    BEGIN
        -- Open cursor
        OPEN c_payments;
    
        -- Loop through cursor data and print to console
        LOOP
            FETCH c_payments INTO v_billing_id, v_user_id, v_name_on_card, v_card_number, v_cvv, v_created_at;
            EXIT WHEN c_payments%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Billing ID: ' || v_billing_id || ', User ID: ' || v_user_id || ', Name on Card: ' || v_name_on_card || ', Card Number: ' || v_card_number || ', CVV: ' || v_cvv || ', Created At: ' || v_created_at);
        END LOOP;
    
        -- Close cursor
        CLOSE c_payments;
    END;

    
    -- Procedure for posting getting all subscriptions
    PROCEDURE get_subscriptions(
        p_user_id IN subscription.user_id%TYPE,
        p_app_id IN subscription.app_id%TYPE
    )IS
        CURSOR c_subscriptions IS
            SELECT *
            FROM subscription
            WHERE app_id = p_app_id AND user_id = p_user_id;
        
        v_subscription subscription%ROWTYPE;
    BEGIN
       
        OPEN c_subscriptions;
    
        DBMS_OUTPUT.PUT_LINE('Subscription ID  |  App ID  |  User ID  |  Subscription Name  |  Type  |  Start Date  |  End Date  |  Amount');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------');
        
        LOOP
            FETCH c_subscriptions INTO v_subscription;
            EXIT WHEN c_subscriptions%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(
                v_subscription.subscription_id || '  |  ' ||
                v_subscription.app_id || '  |  ' ||
                v_subscription.user_id || '  |  ' ||
                v_subscription.subscription_name || '  |  ' ||
                v_subscription.type || '  |  ' ||
                TO_CHAR(v_subscription.subcription_start_dt, 'DD-MON-YYYY') || '  |  ' ||
                TO_CHAR(v_subscription.subscription_end_dt, 'DD-MON-YYYY') || '  |  ' ||
                v_subscription.subscription_amount
            );
        END LOOP;
        
        CLOSE c_subscriptions;
    END get_subscriptions;
    
    
END USER_PACKAGE;
/


EXECUTE USER_PACKAGE.post_review('WhatsApp', 'rishab@gmail.com', 4.3, 'This is an awesome review');

EXECUTE USER_PACKAGE.get_subscriptions(1, 15);

execute USER_PACKAGE.add_billing_info('rishab@gmail.com', 'jaini', 'ABC12345', '255');

execute USER_PACKAGE.get_user_payments(1);

execute USER_PACKAGE.update_review(10000007, 3.1, 'App not working');

execute USER_PACKAGE.buy_subscription('WhatsApp', 'rishab@gmail.com', 'In-app Goodies', 'One Time', TO_DATE('2023-05-11', 'YYYY-MM-DD'), 10.5);

