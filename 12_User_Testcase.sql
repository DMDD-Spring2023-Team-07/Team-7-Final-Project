set serveroutput on

-- Check if zipcode does not exists
execute db_admin.user_manager_pkg.insert_user_info_pkg(02119, 'Rishabh Jain', 'rishabh@example.com', 'password');

-- Success if User added successfully
execute db_admin.user_manager_pkg.insert_user_info_pkg(100001, 'Rishabh Jain', 'rishabh@example.com', 'password');


execute db_admin.user_manager_pkg.select_user_info;


execute db_admin.user_manager_pkg.update_user_info(2, 100001, 'Orijit', 'ori@email.com', 'password');


execute db_admin.user_manager_pkg.create_profile_pkg('ori@email.com','ori_profile','iOS device','public');


-- If app does not exists
execute db_admin.user_manager_pkg.insert_user_app_catalog_pkg('Facebook', 'ori@email.com', 'ori_profile', 'This is sample install policy');

-- If app does exists
execute db_admin.user_manager_pkg.insert_user_app_catalog_pkg('Shazam', 'ori@email.com', 'ios device', 'This is sample install policy');


execute db_admin.user_manager_pkg.get_apps_for_profile(1000000);
