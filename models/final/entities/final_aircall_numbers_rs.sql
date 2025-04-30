select *
from {{ ref('stg_numbers') }}
WHERE name ILIKE '%RS%'
