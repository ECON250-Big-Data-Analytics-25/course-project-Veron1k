 select
  payment_type,
  count(distinct order_id) as total_orders,
  sum(p.price + p.freight_value) as total_price,
  p.seller_state as region
from
  {{ ref('int_fp_sales_full') }},
  unnest(payment_info) as pay,
  unnest(products_info) as p
group by
  payment_type, region
order by
  total_price desc
