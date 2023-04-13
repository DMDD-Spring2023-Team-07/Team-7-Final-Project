--- Application categorized report under given category and Overall rating

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

--- User usage Report by Country ------------

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

----- Complete All User application report containing total size , total reviews , total subscription ------------------------
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
    
--- Complete Subscription report done over all users --------------------------------

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
    
------------ Developer report like Total users to view their respective contribution and number users they cater to ---------

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

------- Reveune Report showing total revence generated from each application ------- 

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