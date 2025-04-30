-- models/staging/aircall/stg_calls.sql

select
    id,
    number_id,
    user_id,
    raw_digits_anonymized,
    answered_at,
    duration,
    missed_call_reason,
    started_at,
    ended_at,
    direction
from {{ source("analytics_raw", "calls") }}