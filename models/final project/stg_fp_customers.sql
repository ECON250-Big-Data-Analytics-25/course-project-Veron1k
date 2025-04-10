select
    customer_id,
    customer_unique_id,
    cast(customer_zip_code_prefix as string) as customer_zip_code_prefix,
    nullif(customer_city, '') as customer_city,
    nullif(customer_state, '') as customer_state
from {{source ("vanepska", "fp_customers")}}
