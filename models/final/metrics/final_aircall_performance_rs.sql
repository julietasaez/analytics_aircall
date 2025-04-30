WITH date_series AS (
    SELECT DISTINCT DATE_TRUNC('day', started_at) AS day
    FROM {{ ref('final_aircall_calls_rs_extended') }}
),
all_agents AS (
    SELECT DISTINCT user_id, user_name
    FROM {{ ref('final_aircall_calls_rs_extended') }}
),
cross_join_dates_agents AS (
    SELECT a.user_id, a.user_name, d.day
    FROM all_agents a
    CROSS JOIN date_series d
),
calls_per_agent AS (
    SELECT
        user_id,
        user_name,
        DATE_TRUNC('day', started_at) AS day,
        COUNT(DISTINCT ID) AS total_calls,
        SUM(duration) AS total_duration_seconds,
        AVG(duration) AS average_call_duration,
        COUNT(CASE WHEN duration >= 180 THEN 1 END) AS successful_calls,
        COUNT(CASE WHEN direction = 'inbound' THEN 1 END) AS inbound_calls,
        COUNT(CASE WHEN direction = 'outbound' THEN 1 END) AS outbound_calls
    FROM {{ ref('final_aircall_calls_rs_extended') }}
    GROUP BY user_id, user_name, DATE_TRUNC('day', started_at)
)

SELECT
    c.user_id,
    c.user_name,
    c.day,
    COALESCE(p.total_calls, 0) AS total_calls,
    COALESCE(p.total_duration_seconds, 0) AS total_duration_seconds,
    COALESCE(p.average_call_duration, 0) AS average_call_duration,
    COALESCE(p.successful_calls, 0) AS successful_calls,
    COALESCE(p.inbound_calls, 0) AS inbound_calls,
    COALESCE(p.outbound_calls, 0) AS outbound_calls,
    17 AS target_calls,
    ROUND(COALESCE(p.outbound_calls, 0) / 17.0, 2) AS target_achievement_ratio,
    CASE
        WHEN COALESCE(p.outbound_calls, 0) >= 17 THEN TRUE
        ELSE FALSE
    END AS in_target,
    ROUND(
        CASE
            WHEN COALESCE(p.total_calls, 0) > 0 THEN COALESCE(p.successful_calls, 0) * 1.0 / COALESCE(p.total_calls, 1)
            ELSE 0
        END,
    2) AS success_rate
FROM cross_join_dates_agents c
LEFT JOIN calls_per_agent p ON c.user_id = p.user_id AND c.day = p.day
