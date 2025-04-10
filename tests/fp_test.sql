with fp_sales_full as (
  select
    sum(p.price + p.freight_value) as total_price
  from {{ ref('int_fp_sales_full') }},
    unnest(products_info) as p
),

mart_revenue as (
  select
    sum(total_price) as mart_revenue
  from {{ ref('fct_fp_product_performance') }}
)

select
  fp.total_price as full_total,
  mr.mart_revenue as mart_total
from fp_sales_full fp, mart_revenue mr
where fp.total_price != mr.mart_revenue
