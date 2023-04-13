## DMDD-Team-7-Project-3

# Instructions:
1. Post Login excute 'security_rules.sql' : This file creates users , sessions and grants access
2. Then excute 'App_Store_Management.sql' : with credentials ( Username : DB_ADMIN , Password :  QueryNinjas#6210) Which contains both DDL and DML scripts for the project as admin

# Files:
### 1_Security_Rules.sql
- Cleans up old user sessions and users.
- Creates new users.
  - Example: DB_ADMIN
- Grants these new users their respective permissions.
  - Grant create view to DB_ADMIN
### 2_Sequences.sql
- Cleans up existing sequences.
- Creates new sequences for certain primary keys from the tables.
  - Example: USER_SEQ
### 3_Tables_And_Inserts.sql
- Cleans up existing tables.
- Creates new tables.
  - Example: USER_INFO
- Grants access for created users.
  - Example: GRANT SELECT, INSERT, UPDATE, DELETE ON DB_ADMIN.ADVERTISEMENT TO STORE_ADMIN;
- Inserts dummy test data into these tables
### 4_Functions.sql
- Creates function for encrypting passwords and credit cards using DBMS_CRYPTO.
### 5_Views.sql
- Cleans up existing views.
- Creates new views (see below).
  - Example: APP_STORE_USER_USAGE
- Grants access for views to existing users.
### 6_Triggers.sql
- 
### 7_Common_Procedures.sql
- 
### 8_DB_ADMIN_Package.sql
- 
### 9_Developer_Manager_Package.sql
- 
### 10_User_Manager_Package.sql
- 
### 12_Reports.sql
- 
### 13_Test_Cases.sql
- 

# Description and security rules for the users:
DB_ADMIN : ( Username : DBADMIN , Password :  QueryNinjas#6210 )
Complete Access -> All Tables

STORE_ADMIN : ( Username : STORE_ADMIN , Password : QueryNinjas#6210)
Complete Access -> All Tables (Except for the Payments table)

ORGANIZATION/DEVELOPER : ( Username : DEVELOPER_MANAGER , Password : QueryNinjas#6210)
SELECT -> REVIEWS,APP_CATEGORY
SELECT, INSERT, UPDATE -> APPLICATION,ADVERTISEMENT,SUBSCRIPTION
                                                                                                   
USER : (Username : USER_MANAGER , Password : QueryNinjas#6210)
SELECT -> USER_APP_CATALOGUE,SUBSCRIPTION 
SELECT, INSERT, UPDATE -> USER,PAYMENTS,PINCODE,PROFILE,REVIEWS 

***The updated view descriptions for the views that we have included in the code are below

# View Descriptions:
Our project contains the 6 views below, each of which will help address specific problems and provide a clear overview of the app store. These views will also be relevant for the end-user and for business reporting. 

-	APP_STORE_APP_OVERVIEW: 
    - This view will show numerous aggregate app counts for the app store over time. Examples of these counts will include total_apps. These counts will be grouped by time, app_category, and overall_rating for more granular breakdowns of the data. 
- APP_STORE_USER_USAGE: 
    -	This view will show numerous aggregate user and profile counts for the app store over time. Examples of these counts will include total_users and total_profiles. These counts will be grouped by time and user_country for more granular breakdowns of the data. 
-	USER_APP_DASHBOARD: 
    -	This view will show a user’s overall experience in the app platform. Overall user metrics will be included, such as total_profiles, total_apps, total_apps_with_available_update, total_size, total_subscriptions, total_reviews etc.  
-	USER_PAYMENT_DASHBOARD: 
    -	This view will show an overview of a user’s existing subscriptions and payments. Metrics here will include total_subscription_amount, next_subscription_end_date, and most_recent_subscription. These metrics will be broken down by subscription type. 
-	DEV_APP_STATUS: 
    -	This view will be a tool for the developer to see the overall usage and status of users for their apps. The metrics for this view will be aggregate user counts. These metrics will be broken down by app_version and subscription_type.
-	REVENUE_DASHBOARD: 
    -	This view will show an overview of the financial side of the app store for a developer. The metrics here will be broken down by app. Metrics here will include total_users, total_ad_cost, total_subscription_amount, and total_subscriptions. 

