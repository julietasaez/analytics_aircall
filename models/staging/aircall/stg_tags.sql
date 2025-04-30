-- models/staging/aircall/stg_tags.sql


select id as tag_id, color, name, description 
from {{ source("analytics_raw", "tags") }}
