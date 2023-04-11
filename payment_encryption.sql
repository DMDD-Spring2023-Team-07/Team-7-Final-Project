set serveroutput on
---------------------------------------------------------------------------------
-- Payment Details Encryption
-- Grant Permissions
GRANT EXECUTE ON DBMS_CRYPTO TO DB_ADMIN;

-- Encryption Function
CREATE OR REPLACE FUNCTION encrypt_card(card_number VARCHAR2) RETURN VARCHAR2
AS
    p_key VARCHAR2(9) := '123456789';
BEGIN
  RETURN DBMS_CRYPTO.encrypt( UTL_RAW.CAST_TO_RAW (card_number), dbms_crypto.DES_CBC_PKCS5, UTL_RAW.CAST_TO_RAW (p_key) );
END;
/

-- Decryption Function
CREATE OR REPLACE FUNCTION decrypt_card(card_number_encrypt VARCHAR2) RETURN VARCHAR2
AS
    p_key VARCHAR2(9) := '123456789';
BEGIN
   RETURN UTL_RAW.CAST_TO_VARCHAR2 ( DBMS_CRYPTO.decrypt( card_number_encrypt, dbms_crypto.DES_CBC_PKCS5, UTL_RAW.CAST_TO_RAW (p_key) ) );
END;
/


-- TESTING
SELECT encrypt_card('hello') FROM dual;
SELECT decrypt_card('BA16C6A0257125AF') FROM dual;

SELECT decrypt_card(encrypt_card('JAREDV')) FROM dual;



CREATE TABLE X_payments (
    billing_id   INT PRIMARY KEY,
    user_id      INT,
    name_on_card VARCHAR(255),
    card_number  VARCHAR(255),
    cvv          VARCHAR(255),
    created_at   DATE
);

INSERT INTO X_PAYMENTS(Billing_ID, User_ID, Name_On_Card, Card_Number, CVV, Created_At )
VALUES(203, 1, 'John Doe', encrypt_card(1345367829875712), 3445, TO_DATE('2022-03-02', 'YYYY-MM-DD'));

select * from x_payments;
