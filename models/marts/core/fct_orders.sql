select o.order_id, o.customer_id, o.order_date, coalesce(sum(p.amount), 0) as amount
from {{ ref("stg_orders") }} o
left join {{ ref("stg_payments") }} p on o.order_id = p.order_id
where p.status = 'success'
group by 1, 2, 3
