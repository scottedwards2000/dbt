
with
    customers as (select * from {{ ref("stg_customers") }}),

    orders as (select * from {{ ref("stg_orders") }}),

    customer_orders as (

        select
            o.customer_id,

            min(o.order_date) as first_order_date,
            max(o.order_date) as most_recent_order_date,
            count(o.order_id) as number_of_orders,
            sum(p.amount) as lifetime_value

        from orders o join {{ ref('stg_payments') }} p on o.order_id = p.order_id

        group by 1

    ),
    final as (

        select
            c.customer_id,
            c.first_name,
            c.last_name,
            co.first_order_date,
            co.most_recent_order_date,
            coalesce(co.number_of_orders, 0) as number_of_orders,
            co.lifetime_value

        from customers c

        left join customer_orders co on c.customer_id = co.customer_id

    )
select *
from final
