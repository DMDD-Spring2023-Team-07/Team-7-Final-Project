set serveroutput on

-- Delete an Advertisement with ad id
EXECUTE DB_ADMIN.ADMIN_PACKAGE.delete_advertisement(250);


-- Publish an ad with incorrect app name
EXECUTE DB_ADMIN.ADMIN_PACKAGE.publish_ad('ad test', 'test', 500);


-- Publish an ad with correct app name
EXECUTE DB_ADMIN.ADMIN_PACKAGE.publish_ad('Shazam', 'test', 500);


-- Get all ads
EXECUTE DB_ADMIN.ADMIN_PACKAGE.get_advertisements_by_app_id(10);


-- Update advertisement
EXECUTE DB_ADMIN.ADMIN_PACKAGE.update_advertisement(10, 'test', 1000);


-- Add App Category
EXECUTE DB_ADMIN.ADMIN_PACKAGE.add_app_category('Health', 'Test category description');


-- Update App Category Description
EXECUTE DB_ADMIN.ADMIN_PACKAGE.update_category_description('test type', 'Test category description - NEW');


-- Add Pincode
EXECUTE DB_ADMIN.ADMIN_PACKAGE.add_new_pincode(200023, 'test country', 'test state', 'test city');


-- Sign Up developer
EXECUTE DB_ADMIN.ADMIN_PACKAGE.sign_up_developer('test dev name', 'test dev email', 'test password', 'test org', 'test license desc');


-- Update developer account
EXECUTE DB_ADMIN.ADMIN_PACKAGE.sign_up_developer(1, 'test dev name', 'test dev email', 'test password', 'test org');


-- Delete Review
EXECUTE DB_ADMIN.ADMIN_PACKAGE.delete_review(1);