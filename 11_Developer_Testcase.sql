set serveroutput on

-- Developer email does is NULL or ''
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('', 'Health', 'TikTok', 90, 'English', 10, 'iOS');

-- Developer email does not exists
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('jain.rishabh2@northeastern.edu', 'Health', 'TikTok', 90, 'English', 10, 'iOS');


-- App category type is NULL or ''
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('carter.hell@example.com', '', 'TikTok', 90, 'English', 10, 'iOS');


-- App category type does not exists
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('carter.hell@example.com', 'Health', 'TikTok', 90, 'English', 10, 'iOS');


-- App language is empty
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('carter.hell@example.com', 'Gaming', 'TikTok', 90,'', 10, 'iOS');


-- Publishing a new app
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_application('carter.hell@example.com', 'Gaming', 'TikTok', 90, 'English', 10, 'iOS');


-- Get all available app categories
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.get_app_categories;


-- Publish an Ad with Wrong App name
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_ad('', 'BINGO20', 10.5);


-- Publish an Ad
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.publish_ad('TikTok', 'BINGO20', 10.5);


-- Get app ads
EXECUTE DB_ADMIN.DEVELOPER_PACKAGE.get_advertisements_by_app_id(15);