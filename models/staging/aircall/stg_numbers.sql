-- models/staging/aircall/stg_numbers.sql

select
    id as number_id,
    country,
    availability_status,
    live_recording_activated,
    name,
    digits,
    is_ivr
from {{ source("analytics_raw", "numbers") }}
