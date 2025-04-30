-- models/staging/aircall/stg_users.sql

select
    id as user_id,
    wrap_up_time,
    name,
    team,
    language,
    time_zone
from {{ source("analytics_raw", "users") }}