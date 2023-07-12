#Change data type of ds_checkin to DATE
 
alter table fct_reservations
MODIFY column ds_checkin DATE;

# All qulified audience for the survey.
SELECT DISTINCT
        du.id_user,
        du.dim_user_region AS region,
        du.dim_user_country AS country
FROM
        dim_users du
INNER JOIN dim_listings dl ON du.id_user = dl.id_user
LEFT JOIN fct_reservations fr ON fr.id_listing = dl.id_listing
LEFT JOIN dim_contact_preferences dc ON dc.id_user = du.id_user
WHERE
	dc.policy_email = 1
	AND 
	du.dim_user_country IN ('US', 'FR', 'MX', 'ES', 'AU', 'KR', 'GB', 'CA', 'BR', 'PT', 'CO')
	AND 
	dl.dim_country IN ('US', 'FR', 'MX', 'ES', 'AU', 'KR', 'GB', 'CA', 'BR', 'PT', 'CO')
	AND (
		(dl.dim_is_active = 1 AND du.dim_user_country = dl.dim_country)
		OR
		(fr.ds_checkin >= '2022-01-01' AND du.dim_user_country = dl.dim_country)
        );


#Create new table called policy_survey_pilot_audience have Region, Country for distinct user_id
# Write sub_quries and CET to limit the number of audience(200) and the number of user per region(50)
 
create table policy_survey_pilot_audience
as(
WITH cte_recipients AS (
    SELECT DISTINCT
        du.id_user,
        du.dim_user_region AS region,
        du.dim_user_country AS country,
        DENSE_RANK() OVER (ORDER BY du.id_user) AS recipient_rank,
        DENSE_RANK() OVER (PARTITION BY du.dim_user_region ORDER BY du.id_user) AS region_rank
    FROM
        dim_users du
    INNER JOIN dim_listings dl ON du.id_user = dl.id_user
    LEFT JOIN fct_reservations fr ON fr.id_listing = dl.id_listing
    LEFT JOIN dim_contact_preferences dc ON dc.id_user = du.id_user
    WHERE
        dc.policy_email = 1
        AND 
        du.dim_user_country IN ('US', 'FR', 'MX', 'ES', 'AU', 'KR', 'GB', 'CA', 'BR', 'PT', 'CO')
        AND 
        dl.dim_country IN ('US', 'FR', 'MX', 'ES', 'AU', 'KR', 'GB', 'CA', 'BR', 'PT', 'CO')
        AND (
            (dl.dim_is_active = 1 AND du.dim_user_country = dl.dim_country)
            OR
            (fr.ds_checkin >= '2022-01-01' AND du.dim_user_country = dl.dim_country)
        )
)
SELECT id_user, region, country
FROM cte_recipients
WHERE 
	recipient_rank <= 200
    AND 
    region_rank <= 50
ORDER BY id_user
);

#Check if new table "policy_survey_pilot_audience" is created with results.
# returns 175 rows and no duplicates
select * from policy_survey_pilot_audience;

/*To get each number of users per region
EMEA:50
NAMER:37
LATAM:50
APAC:38
*/
select region, count(region) from policy_survey_pilot_audience
group by region
having count(region);


/*To get each number of users per country
'ES':13
'CA':13
'US':24
'BR':27
'FR':19
'CO':12
'GB':8
'MX':11
'PT':10
'KR':32
'AU':6
*/
select country, count(country) from policy_survey_pilot_audience
group by country
having count(country);





