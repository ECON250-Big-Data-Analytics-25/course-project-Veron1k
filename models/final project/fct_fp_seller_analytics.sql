select
  seller_id,
  count(distinct order_id) as total_orders,
  avg(date_diff(order_delivered_customer_date, order_purchase_timestamp, day)) as avg_days_taken,
  sum(price + freight_value) as total_price
from
  {{ ref( 'int_fp_sales_full') }},
  unnest(products_info) as p
group by
  seller_id
order by
  total_orders desc