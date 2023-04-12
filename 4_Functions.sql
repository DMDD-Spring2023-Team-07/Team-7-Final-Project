set serveroutput on

--------------------------------------------------------------------------------
-------------- CREATE FUNCTIONS ---------------
-- PASSWORD ENCRYPTION
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

-- PAYMENT ENCRYPTION
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