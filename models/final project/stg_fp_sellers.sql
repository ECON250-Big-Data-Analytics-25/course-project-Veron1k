select
    seller_id,
    cast(seller_zip_code_prefix as string) as seller_zip_code_prefix,
    nullif(seller_city, '') as seller_city,
    nullif(seller_state, '') as seller_state
from {{source ('vanepska', 'fp_sellers')}}