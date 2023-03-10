--test comment
with
    customer_orders as (

        select
            o.customer_id,
            min(o.order_date) as first_order_date,
            max(o.order_date) as most_recent_order_date,
            count(o.order_id) as number_of_orders,
            sum(o.amount) as lifetime_value
        from {{ ref("fct_orders") }} o
        group by 1

    )
select
    c.customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    coalesce(co.number_of_orders, 0) as number_of_orders,
    co.lifetime_value
from {{ ref("stg_customers") }} c
left join customer_orders co on c.customer_id = co.customer_id
