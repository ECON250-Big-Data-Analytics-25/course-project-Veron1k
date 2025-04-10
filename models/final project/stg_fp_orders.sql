select
    order_id,
    customer_id,
    nullif(order_status, '') as order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    date_diff(order_delivered_customer_date, order_purchase_timestamp, day) as days_taken,
    order_status in ('shipped', 'delivered') as is_shipped
  from {{source ('vanepska', 'fp_orders')}}