with fp_sales_full as (
  select
    p.seller_id,
    count(distinct order_id) as total_orders,
    round(sum(p.price + p.freight_value), 2) as total_price
  from {{ ref('int_fp_sales_full') }},
    unnest(products_info) as p
  group by p.seller_id
),

fct_fp_seller_analytics as (
  select
    seller_id,
    total_orders,
    round(total_price, 2) as total_price
  from {{ ref('fct_fp_seller_analytics') }}
)

select
  fp_sales_full.seller_id,
  fp_sales_full.total_orders as sales_full_total_orders,
  fct_fp_seller_analytics.total_orders as analytics_total_orders,
  fp_sales_full.total_price as sales_full_total_price,
  fct_fp_seller_analytics.total_price as analytics_total_price
from fp_sales_full
left join fct_fp_seller_analytics
  on fp_sales_full.seller_id = fct_fp_seller_analytics.seller_id
where fp_sales_full.total_orders != fct_fp_seller_analytics.total_orders
  or fp_sales_full.total_price != fct_fp_seller_analytics.total_price
