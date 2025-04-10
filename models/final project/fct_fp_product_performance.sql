select
  p.product_id,
  p.product_category_name,
  seller_state as region,
  sum(p.price + p.freight_value) as total_price,
  count(p.order_item_id) as items_sold
from
{{ ref('int_fp_sales_full') }},
  unnest(products_info) as p
group by
  p.product_id, p.product_category_name, region
order by
  total_price desc