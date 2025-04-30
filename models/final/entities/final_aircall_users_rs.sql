select * 
from {{ ref('stg_users') }}
where team = 'RS'