select
    order_id,
    payment_sequential,
    nullif(payment_type, '') as payment_type,
    payment_installments,
    payment_value
from {{source ('vanepska', 'fp_order_payments')}}