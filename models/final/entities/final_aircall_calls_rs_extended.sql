WITH calls AS (
    SELECT *
    FROM {{ ref('final_aircall_calls') }}
),
users_rs AS (
    SELECT *
    FROM {{ ref('final_aircall_users_rs') }}
),
numbers_rs AS (
    SELECT *
    FROM {{ ref('final_aircall_numbers_rs') }}
),
final AS (
    SELECT
        calls.*,
        users_rs.name AS user_name,
        numbers_rs.availability_status as number_availability_status,
        numbers_rs.live_recording_activated,
        numbers_rs.name AS number_name, 
        numbers_rs.digits AS number_digits,
        numbers_rs.is_ivr AS number_is_ivr
    FROM calls
    JOIN users_rs ON calls.user_id = users_rs.user_id
    LEFT JOIN numbers_rs ON calls.number_id = numbers_rs.number_id
)
SELECT * FROM final