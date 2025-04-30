
WITH converted_calls AS (
    SELECT
        id,
        number_id,
        user_id,
        raw_digits_anonymized,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', started_at) AS started_at,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', answered_at) AS answered_at,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', ended_at) AS ended_at,
        duration,
        missed_call_reason,
        direction
    FROM  {{ ref('stg_calls') }}
)

SELECT
    *,
    CASE
        WHEN answered_at IS NOT NULL THEN TIMESTAMPDIFF(SECOND, started_at, answered_at)
        ELSE NULL
    END AS response_time_seconds,

    EXTRACT(HOUR FROM started_at) AS call_hour,
    DAYOFWEEK(started_at) AS day_of_week,
    TO_CHAR(started_at, 'DY') AS day_name,
    CASE
        WHEN DAYOFWEEK(started_at) IN (1, 7) THEN 'weekend'
        ELSE 'weekday'
    END AS day_type

FROM converted_calls