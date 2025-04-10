

{{ config(
    materialized='table',
    partition_by={"field": "order_purchase_timestamp", "data_type": "timestamp"},
    cluster_by=["customer_id", "order_status"]
) }}

with

orders as (
  select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    days_taken,
    is_shipped
  from {{ ref('stg_fp_orders') }}
),

customers as (
  select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
  from {{ ref('stg_fp_customers') }}
),

products as (
  select
    product_id,
    product_category_name
  from {{ ref('stg_fp_products') }}
),

sellers as (
  select
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
  from {{ ref('stg_fp_sellers') }}
),

order_items as (
  select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value
  from {{source ('vanepska', 'fp_order_items')}}
),

payments as (
  select
    order_id,
    array_agg(struct(payment_type, payment_value, payment_installments)) as payment_info
  from {{ ref('stg_fp_order_payments') }}
  group by order_id
)

select
  o.order_id,
  o.customer_id,
  c.customer_unique_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  o.days_taken,
  o.is_shipped,
  array_agg(
    struct(
      oi.product_id,
      oi.order_item_id,
      p.product_category_name,
      oi.price,
      oi.freight_value
    )
  ) as products_info,
  s.seller_id,
  s.seller_zip_code_prefix,
  s.seller_city,
  s.seller_state,
  pay.payment_info
from orders o
left join customers c on o.customer_id = c.customer_id
left join order_items oi on o.order_id = oi.order_id
left join products p on oi.product_id = p.product_id
left join sellers s on oi.seller_id = s.seller_id
left join payments pay on o.order_id = pay.order_id
group by
  o.order_id,
  o.customer_id,
  c.customer_unique_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  o.days_taken,
  o.is_shipped,
  s.seller_id,
  s.seller_zip_code_prefix,
  s.seller_city,
  s.seller_state,
  pay.payment_info
