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