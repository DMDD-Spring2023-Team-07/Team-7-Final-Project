## DMDD-Team-7-Project-3

# Instructions:
Roles:
Cloud_Wallet_Admin : The user credentials used to login into the wallet

DB_ADMIN : ( Username : DBADMIN , Password :  QueryNinjas#6210 )
Complete Access -> All Tables

DEVELOPER_MANAGER: : ( Username : DEVELOPER_MANAGER , Password : QueryNinjas#6210)
SELECT -> REVIEWS,APP_CATEGORY
SELECT, INSERT, UPDATE -> APPLICATION,ADVERTISEMENT,SUBSCRIPTION
                                                                                                   
USER_MANAGER: : (Username : USER_MANAGER , Password : QueryNinjas#6210)
SELECT -> USER_APP_CATALOGUE,SUBSCRIPTION 
SELECT, INSERT, UPDATE -> USER,PAYMENTS,PINCODE,PROFILE,REVIEWS 


Execution Steps:
Note: All the steps needs to be run as 'Clound_Wallet_Admin' unless until mentioned otherwise.

1. Execute '1_Security_Rules' as 'Cloud_Wallet_Admin'
2. Switch user credentials to for DB_ADMIN to connect
3. Execute '2_Sequences" as 'DB_ADMIN'
4. Execute '3_Table_and_Inserts' as 'DB_ADMIN'
5. Execute '4_Functions' as 'DB_ADMIN'
6. Execute '5_Views' as 'DB_ADMIN'
7. Execute '6_Triggers' as 'DB_ADMIN'
8. Execute '7_Common_Procedures' as 'DB_ADMIN'
9. Execute '8_DB_ADMIN_Package' as 'DB_ADMIN'
10. Execute '9_Developer_Manager_Package' as 'DB_ADMIN'
11. Execute '10_User_Manager_Package' as 'DB_ADMIN'
12. Switch user credentials to for DEVELOPER_MANAGER to connect
13. Execute '11_Developer_Testcase' as 'DEVELOPER_MANAGER'
14. Switch user credentials to for USER_MANAGER to connect
15. Execute '12_User_Testcase' as 'USER_MANAGER'
16. Switch user credentials to for DB_ADMIN to connect
17. Execute '13_Admin_Testcase' as 'DB_ADMIN'
18. Execute '14_Reports' as 'DB_ADMIN'

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
- Creating triggers.
  - Example: Update download count after a user downloads an app.
### 7_Common_Procedures.sql
- Creating all the common procedures. These procedures are restricted by user access.
  - Example: Inserting User Info
### 8_DB_ADMIN_Package.sql
- Create admin package with required procedures based on the admin role.
- Grant execute privileges on this package to the admin.
### 9_Developer_Manager_Package.sql
- Create admin package with required procedures based on the developer_manager role.
- Grant execute privileges on this package to the developer_manager.
### 10_User_Manager_Package.sql
- Create admin package with required procedures based on the user_manager role.
- Grant execute privileges on this package to the user_manager.
### 11_Developer_Testcase.sql
- Testing examples and expected outputs for the developer_package.
  - Example: Publish Application
### 12_User_Testcase.sql
- Testing examples and expected outputs for the user_manager_package.
  - Example: Insert user info
### 13_Admin_Testcase.sql
- Testing examples and expected outputs for the admin_package.
  - Example: Add App Category
### 13_Additional_Test_Cases.sql
- General test cases relating to tableinsert, view, etc. access.
### 14_Reports.sql
- Same queries as the views, since we designed the views in a way that slect * from a view would give you a report.


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

# ERD Diagram:
![image](https://user-images.githubusercontent.com/47637485/231647532-80e6c821-17db-46f6-89e1-2acd61478514.png)

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

