set serveroutput on

-- Advertisement with ad id not found
EXECUTE DB_ADMIN.ADMIN_PACKAGE.delete_advertisement(1000000000);


-- Error deleting advertisement
EXECUTE DB_ADMIN.ADMIN_PACKAGE.delete_advertisement('test');


-- Publish an ad
EXECUTE DB_ADMIN.ADMIN_PACKAGE.publish_ad('ad test', 'test', 500);


-- Get all ads
EXECUTE DB_ADMIN.ADMIN_PACKAGE.get_advertisements_by_app_id(1);


-- Update advertisement
EXECUTE DB_ADMIN.ADMIN_PACKAGE.update_advertisement('ad test', 'test', 1000);


-- Add App Category
EXECUTE DB_ADMIN.ADMIN_PACKAGE.add_app_category('test type', 'Test category description');


-- Update App Category Description
EXECUTE DB_ADMIN.ADMIN_PACKAGE.update_category_description('test type', 'Test category description - NEW');


-- Add Pincode
EXECUTE DB_ADMIN.ADMIN_PACKAGE.add_new_pincode(1000, 'test country', 'test state', 'test city');


-- Sign Up developer
EXECUTE DB_ADMIN.ADMIN_PACKAGE.sign_up_developer('test dev name', 'test dev email', 'test password', 'test org', 'test license desc');


-- Update developer account
EXECUTE DB_ADMIN.ADMIN_PACKAGE.sign_up_developer(1, 'test dev name', 'test dev email', 'test password', 'test org');


-- Delete Review
EXECUTE DB_ADMIN.ADMIN_PACKAGE.delete_review(1);