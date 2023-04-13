--------------------------------------------------------------------------------
set serveroutput on
-------------- CLEAN UP SCRIPT FOR SEQUENCES ---------------
DECLARE
    db_sequences      sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll(
'USER_SEQ',
'APPLICATION_SEQ',
'DEVELOPER_SEQ',
'SUBSCRIPTION_SEQ',
'CATEGORY_SEQ',
'BILLING_SEQ',
'PROFILE_SEQ',
'REVIEW_SEQ',
'CATALOGUE_SEQ',
'LICENSE_SEQ',
'ADVERTISEMENT_SEQ');
    v_sequence_exists VARCHAR(1) := 'Y';
    v_sql          VARCHAR(2000);
BEGIN
    dbms_output.put_line('------ Starting schema cleanup ------');
    FOR i IN db_sequences.first..db_sequences.last LOOP
        dbms_output.put_line('**** Drop sequence ' || db_sequences(i));
        BEGIN
            SELECT
                'Y'
            INTO v_sequence_exists
            FROM
                user_sequences
            WHERE
                sequence_name = db_sequences(i);

            v_sql := 'drop sequence ' || db_sequences(i) || ' ';
            EXECUTE IMMEDIATE v_sql;
            dbms_output.put_line('**** sequence ' || db_sequences(i) || ' dropped successfully');
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('**** sequence already dropped');
        END;

    END LOOP;

    dbms_output.put_line('------ Schema cleanup successfully completed ------');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Failed to execute code:' || sqlerrm);
END;
/




--CREATE SEQUENCES
-- USER_INFO
CREATE SEQUENCE USER_SEQ
 MINVALUE 0
 START WITH     1
 INCREMENT BY   1;
 
-- APPLICATION
CREATE SEQUENCE APPLICATION_SEQ
 MINVALUE 0
 START WITH     10
 INCREMENT BY   1;
 
-- DEVELOPER
CREATE SEQUENCE DEVELOPER_SEQ
 MINVALUE 0
 START WITH     100
 INCREMENT BY   1;
 
-- SUBSCRIPTION
CREATE SEQUENCE SUBSCRIPTION_SEQ
 MINVALUE 0
 START WITH     1000
 INCREMENT BY   1;

-- APP_CATEGORY
CREATE SEQUENCE CATEGORY_SEQ
 MINVALUE 0
 START WITH     10000
 INCREMENT BY   1;
 
-- PAYMENTS
CREATE SEQUENCE BILLING_SEQ
 MINVALUE 0
 START WITH     100000
 INCREMENT BY   1;
 
-- PROFILE
CREATE SEQUENCE PROFILE_SEQ
 MINVALUE 0
 START WITH     1000000
 INCREMENT BY   1;
 
-- REVIEWS
CREATE SEQUENCE REVIEW_SEQ
 MINVALUE 0
 START WITH     10000000
 INCREMENT BY   1;
 
-- USER_APP_CATALOGUE
CREATE SEQUENCE CATALOGUE_SEQ
 MINVALUE 0
 START WITH     100000000
 INCREMENT BY   1;

-- LICENSE
CREATE SEQUENCE LICENSE_SEQ
 MINVALUE 0
 START WITH     500
 INCREMENT BY   5;

 -- LICENSE
CREATE SEQUENCE ADVERTISEMENT_SEQ
 MINVALUE 0
 START WITH     200
 INCREMENT BY   10;