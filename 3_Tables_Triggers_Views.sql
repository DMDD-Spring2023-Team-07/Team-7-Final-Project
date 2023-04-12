set serveroutput on

--------------------------------------------------------------------------------
-------------- CLEAN UP SCRIPT FOR TABLES ---------------
DECLARE
    db_tables      sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll('ADVERTISEMENT', 'SUBSCRIPTION', 'APPLICATION', 'DEVELOPER', 'APP_CATEGORY', 'PAYMENTS', 'PINCODE', 'PROFILE', 'REVIEWS', 'USER_APP_CATALOGUE', 'USER_INFO');
    v_table_exists VARCHAR(1) := 'Y';
    v_sql          VARCHAR(2000);
BEGIN
    dbms_output.put_line('------ Starting schema cleanup ------');
    FOR i IN db_tables.first..db_tables.last LOOP
        dbms_output.put_line('**** Drop table ' || db_tables(i));
        BEGIN
            SELECT
                'Y'
            INTO v_table_exists
            FROM
                user_tables
            WHERE
                table_name = db_tables(i);

            v_sql := 'drop table ' || db_tables(i) || ' CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE v_sql;
            dbms_output.put_line('**** Table ' || db_tables(i) || ' dropped successfully');
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('**** Table already dropped');
        END;

    END LOOP;

    dbms_output.put_line('------ Schema cleanup successfully completed ------');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Failed to execute code:' || sqlerrm);
END;
/

--------------------------------------------------------------------------------
-------------- TABLES CREATION ---------------

-- PINCODE Table

CREATE TABLE pincode (
    zip_code INT PRIMARY KEY,
    country  VARCHAR(255),
    state    VARCHAR(255),
    city     VARCHAR(255)
);

ALTER TABLE pincode MODIFY
    country NOT NULL
MODIFY
    state NOT NULL
MODIFY
    city NOT NULL;
    
    
-- USER_INFO Table
CREATE TABLE user_info (
    user_id       INT PRIMARY KEY,
    user_zip_code INT,
    user_name     VARCHAR(255),
    user_email    VARCHAR(255),
    user_passcode VARCHAR(255),
    created_at    DATE,
    updated_at    DATE
);

ALTER TABLE user_info
    ADD CONSTRAINT user_zip_code_fk FOREIGN KEY ( user_zip_code )
        REFERENCES pincode ( zip_code );

ALTER TABLE user_info MODIFY
    user_name NOT NULL
MODIFY
    user_email NOT NULL
MODIFY
    user_passcode NOT NULL
MODIFY
    created_at NOT NULL;
    
   
    
-- PAYMENTS Table

CREATE TABLE payments (
    billing_id   INT PRIMARY KEY,
    user_id      INT,
    name_on_card VARCHAR(255),
    card_number  VARCHAR(255),
    cvv          VARCHAR(255),
    created_at   DATE
);

ALTER TABLE payments
    ADD CONSTRAINT user_id_fk FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    name_on_card NOT NULL
MODIFY
    card_number VARCHAR(16) NOT NULL
MODIFY
    cvv VARCHAR(4) NOT NULL
MODIFY
    created_at NOT NULL;


-- DEVELOPER Table
CREATE TABLE developer (
    developer_id        INTEGER NOT NULL,
    developer_name      VARCHAR(255) NOT NULL,
    developer_email     VARCHAR(255) NOT NULL,
    developer_password  VARCHAR(255) NOT NULL,
    organization_name   VARCHAR(255) NOT NULL,
    license_number      INTEGER NOT NULL,
    license_description VARCHAR(4000) NOT NULL,
    license_date        DATE NOT NULL,
    CONSTRAINT developer_id_pk PRIMARY KEY ( developer_id )
);



-- APP_CATEGORY Table
CREATE TABLE app_category (
    category_id          INTEGER NOT NULL,
    category_description VARCHAR(255) NOT NULL,
    category_type        VARCHAR(255) NOT NULL,
    number_of_apps       INTEGER NOT NULL,
    CONSTRAINT category_id_pk PRIMARY KEY ( category_id )
);



-- APPLICATION Table
CREATE TABLE application (
    app_id         INTEGER NOT NULL,
    developer_id   INTEGER NOT NULL,
    category_id    INTEGER NOT NULL,
    app_name       VARCHAR(255) NOT NULL,
    app_size       INTEGER NOT NULL,
    app_version    INTEGER NOT NULL,
    app_language   VARCHAR(255) NOT NULL,
    download_count INTEGER NOT NULL,
    target_age     INTEGER NOT NULL,
    supported_os   VARCHAR(255) NOT NULL,
    overall_rating INTEGER NOT NULL,
    app_create_dt  DATE NOT NULL,
    CONSTRAINT app_id_pk PRIMARY KEY ( app_id ),
    CONSTRAINT application_fk1 FOREIGN KEY ( developer_id )
        REFERENCES developer ( developer_id ),
    CONSTRAINT application_fk2 FOREIGN KEY ( category_id )
        REFERENCES app_category ( category_id )
);
 
    
-- PROFILE Table
CREATE TABLE profile (
    profile_id   INT PRIMARY KEY,
    user_id      INT,
    profile_name VARCHAR(255),
    device_info  VARCHAR(255),
    profile_type VARCHAR(255),
    created_at   DATE,
    updated_at   DATE
);

ALTER TABLE profile
    ADD CONSTRAINT user_id_fk_2 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    profile_name NOT NULL
MODIFY
    device_info NOT NULL
MODIFY
    profile_type NOT NULL
MODIFY
    created_at NOT NULL;



-- REVIEWS Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    user_id   INT,
    app_id    INT,
    rating    DECIMAL(10, 2),
    feedback  VARCHAR(255)
);

ALTER TABLE reviews
    ADD CONSTRAINT user_id_fk_3 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
MODIFY
    rating NOT NULL
MODIFY
    feedback NOT NULL;

ALTER TABLE reviews
    ADD CONSTRAINT app_id_fk FOREIGN KEY ( app_id )
        REFERENCES application ( app_id );


-- USER_APP_CATALOGUE Table
CREATE TABLE user_app_catalogue (
    catalogue_id        INT PRIMARY KEY,
    app_id              INT,
    profile_id          INT,
    installed_version   INT,
    is_update_available NUMBER(1) DEFAULT 0 CHECK ( is_update_available IN ( 0, 1 ) ),
    install_policy_desc VARCHAR(255),
    is_accepted         NUMBER(1) DEFAULT 0 CHECK ( is_accepted IN ( 0, 1 ) )
);


ALTER TABLE user_app_catalogue
    ADD CONSTRAINT profile_id_fk FOREIGN KEY ( profile_id )
        REFERENCES profile ( profile_id )
MODIFY
    installed_version NOT NULL
MODIFY
    is_update_available NOT NULL
MODIFY
    install_policy_desc NOT NULL
MODIFY
    is_accepted NOT NULL;

ALTER TABLE user_app_catalogue
    ADD CONSTRAINT app_id_fk_2 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id );
        
    


-- ADVERTISEMENT Table
CREATE TABLE advertisement (
    ad_id        INTEGER NOT NULL,
    developer_id INTEGER NOT NULL,
    app_id       INTEGER NOT NULL,
    ad_details   VARCHAR(255) NOT NULL,
    ad_cost      DECIMAL(10, 2) NOT NULL,
    CONSTRAINT ad_id_pk PRIMARY KEY ( ad_id ),
    CONSTRAINT advertisement_fk1 FOREIGN KEY ( developer_id )
        REFERENCES developer ( developer_id ),
    CONSTRAINT advertisement_fk2 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id )
);



-- SUBSCRIPTION Table

CREATE TABLE subscription (
    subscription_id      INTEGER NOT NULL,
    app_id               INTEGER NOT NULL,
    user_id              INTEGER NOT NULL,
    subscription_name    VARCHAR(255) NOT NULL,
    type                 VARCHAR(255) NOT NULL
        CONSTRAINT check_constraint_type CHECK ( type IN ( 'One Time', 'Recurring' ) ),
    subcription_start_dt DATE NOT NULL,
    subscription_end_dt  DATE NOT NULL,
    subscription_amount  DECIMAL(10, 2) NOT NULL,
    CONSTRAINT subscription_id_pk PRIMARY KEY ( subscription_id ),
    CONSTRAINT subscription_fk1 FOREIGN KEY ( app_id )
        REFERENCES application ( app_id ),
    CONSTRAINT subscription_fk2 FOREIGN KEY ( user_id )
        REFERENCES user_info ( user_id )
);


--------------------------------------------------------------------------------
-------------- Creating all TRIGGERS ---------------
-- UPDATE THE DOWNLOAD COUNT
-- drop trigger update_download_count;
CREATE OR REPLACE TRIGGER update_download_count
AFTER insert ON user_app_catalogue
FOR EACH ROW
BEGIN
    UPDATE application 
    SET download_count = download_count + 1
    WHERE app_id = :new.app_id;
END;
/


-- UPDATE IS_UPDATE_AVAILABLE IN USER_APP_CATALOGUE 
-- drop trigger update_available_update_flag;
CREATE OR REPLACE TRIGGER update_available_update_flag
AFTER UPDATE ON application
FOR EACH ROW
BEGIN
    UPDATE user_app_catalogue 
    SET is_update_available = 1
    WHERE app_id = :new.app_id;
END;
/


-- UPDATE NUMBER_OF_APPS IN APP_CATEGORY 
-- drop trigger update_number_of_apps;
CREATE OR REPLACE TRIGGER update_number_of_apps
AFTER insert ON application
FOR EACH ROW
BEGIN
    UPDATE number_of_apps 
    SET number_of_apps = number_of_apps + 1
    WHERE category_id = :new.category_id;
END;
/


--------------------------------------------------------------------------------
-------------- CLEAN UP SCRIPT FOR VIEWS ---------------
DECLARE
    db_views      sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll('APP_STORE_APP_OVERVIEW',
'APP_STORE_USER_USAGE',
'USER_APP_DASHBOARD',
'USER_PAYMENT_DASHBOARD',
'DEV_APP_STATUS',
'REVENUE_DASHBOARD');
    v_view_exists VARCHAR(1) := 'Y';
    v_sql          VARCHAR(2000);
BEGIN
    dbms_output.put_line('------ Starting schema cleanup ------');
    FOR i IN db_views.first..db_views.last LOOP
        dbms_output.put_line('**** Drop view ' || db_views(i));
        BEGIN
            SELECT
                'Y'
            INTO v_view_exists
            FROM
                user_views
            WHERE
                view_name = db_views(i);

            v_sql := 'drop view ' || db_views(i) || ' CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE v_sql;
            dbms_output.put_line('**** view ' || db_views(i) || ' dropped successfully');
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('**** view already dropped');
        END;

    END LOOP;

    dbms_output.put_line('------ Schema cleanup successfully completed ------');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Failed to execute code:' || sqlerrm);
END;
/


-------------- Creating all views ---------------

-- APP STORE APP OVERVIEW VIEW
CREATE VIEW app_store_app_overview (
    category_type,
    overall_rating,
    create_date,
    total_apps
) AS
    SELECT
        category_type,
        overall_rating,
        trunc(app_create_dt)   create_date,
        COUNT(DISTINCT app_id) total_apps
    FROM
             application a
        JOIN app_category b ON a.category_id = b.category_id
    GROUP BY
        category_type,
        overall_rating,
        trunc(app_create_dt);
        
        
-- APP STORE USER USAGE VIEW
CREATE VIEW app_store_user_usage (
    create_date,
    country,
    total,
    count_type
) AS
    SELECT
        trunc(a.created_at)       create_date,
        b.country,
        COUNT(DISTINCT a.user_id) total,
        'USERS'                   count_type
    FROM
             user_info a
        JOIN pincode b ON a.user_zip_code = b.zip_code
    GROUP BY
        trunc(a.created_at),
        b.country,
        'USERS'
    UNION ALL
    SELECT
        trunc(c.created_at)          create_date,
        b.country,
        COUNT(DISTINCT c.profile_id) total,
        'PROFILES'                   count_type
    FROM
             user_info a
        JOIN pincode b ON a.user_zip_code = b.zip_code
        JOIN profile c ON a.user_id = c.user_id
    GROUP BY
        trunc(c.created_at),
        b.country,
        'PROFILES';


-- USER APP DASHBOARD VIEW
CREATE VIEW user_app_dashboard (
    user_id,
    total_profiles,
    total_apps,
    total_size,
    total_reviews,
    total_subscriptions
) AS
    SELECT
        a.user_id,
        COUNT(DISTINCT b.profile_id)      total_profiles,
        COUNT(DISTINCT d.app_id)          total_apps,
        SUM(d.app_size)                   total_size,
        COUNT(DISTINCT e.review_id)       total_reviews,
        COUNT(DISTINCT f.subscription_id) total_subscriptions
    FROM
             user_info a
        JOIN profile            b ON a.user_id = b.user_id
        JOIN user_app_catalogue c ON b.profile_id = c.profile_id
        JOIN application        d ON c.app_id = d.app_id
        LEFT JOIN reviews            e ON a.user_id = e.user_id
        LEFT JOIN subscription       f ON a.user_id = f.user_id
    GROUP BY
        a.user_id;


-- USER PAYMENT DASHBOARD VIEW
CREATE VIEW user_payment_dashboard (
    user_id,
    subscription_type,
    total_subscriptions,
    subscription_amout,
    next_subscription_end_date,
    most_recent_subscription
) AS
    SELECT
        a.user_id,
        b.type                            subscription_type,
        COUNT(DISTINCT b.subscription_id) total_subscriptions,
        SUM(b.subscription_amount)        subscription_amout,
        MIN(
            CASE
                WHEN b.subscription_end_dt >= sysdate THEN
                    b.subscription_end_dt
                ELSE
                    NULL
            END
        )                                 next_subscription_end_date,
        MAX(
            CASE
                WHEN b.subcription_start_dt <= sysdate THEN
                    b.subcription_start_dt
                ELSE
                    NULL
            END
        )                                 most_recent_subscription
    FROM
        user_info    a
        LEFT JOIN subscription b ON a.user_id = b.user_id
    GROUP BY
        a.user_id,
        b.type;



-- DEV APP STATUS VIEWS

CREATE VIEW dev_app_status (
    developer_name,
    app_version,
    subscription_type,
    total_users
) AS
    SELECT
        a.developer_name,
        b.app_version,
        f.type                    subscription_type,
        COUNT(DISTINCT d.user_id) total_users
    FROM
             developer a
        JOIN application        b ON a.developer_id = b.developer_id
        JOIN user_app_catalogue c ON b.app_id = c.app_id
        JOIN profile            d ON c.profile_id = d.profile_id
        JOIN user_info          e ON d.user_id = e.user_id
        LEFT JOIN subscription       f ON e.user_id = f.user_id
    GROUP BY
        a.developer_name,
        b.app_version,
        f.type;



-- REVENUE DASHBOARD VIEW
CREATE OR REPLACE VIEW revenue_dashboard (
    app_id,
    total_users,
    total_subscription_amt,
    total_ad_revenue,
    total_subscriptions
) AS
    SELECT
        application.app_id                    AS app_id,
        application.download_count            AS total_users,
        SUM(subscription.subscription_amount) AS total_subscription_amt,
        SUM(advertisement.ad_cost)            AS total_ad_revenue,
        COUNT(subscription.subscription_id)   AS total_subscriptions
    FROM
        application
        LEFT JOIN subscription ON subscription.app_id = application.app_id
        LEFT JOIN advertisement ON advertisement.app_id = application.app_id
    GROUP BY
        application.app_id,
        application.download_count;
        
        

--------------------------------------------------------------------------------
----- Granting Access for the created users -----

-- Granting accesses for TABLES to STORE_ADMIN user

GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.ADVERTISEMENT TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.APP_CATEGORY TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.APPLICATION TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.PINCODE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.PROFILE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.REVIEWS TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.SUBSCRIPTION TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.USER_APP_CATALOGUE TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.USER_INFO TO STORE_ADMIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.DEVELOPER TO STORE_ADMIN;



-- Granting access for TABLES to DEVELOPER_MANAGER user
    
GRANT SELECT ON DB_ADMIN.REVIEWS TO DEVELOPER_MANAGER;
GRANT SELECT ON DB_ADMIN.APP_CATEGORY TO DEVELOPER_MANAGER;

GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.APPLICATION TO DEVELOPER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.ADVERTISEMENT TO DEVELOPER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.SUBSCRIPTION TO DEVELOPER_MANAGER;


-- Granting access for TABLES to USER_MANAGER user

GRANT SELECT ON DB_ADMIN.USER_APP_CATALOGUE TO USER_MANAGER;
GRANT SELECT ON DB_ADMIN.SUBSCRIPTION TO USER_MANAGER;

GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.USER_INFO TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PAYMENTS TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PINCODE TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.PROFILE TO USER_MANAGER;
GRANT SELECT, INSERT, UPDATE ON DB_ADMIN.REVIEWS TO USER_MANAGER;



-- Save the changes
COMMIT;