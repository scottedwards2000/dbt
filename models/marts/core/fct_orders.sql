select o.order_id, o.customer_id, p.amount
from {{ ref('stg_orders') }} o left join {{ ref('stg_payments') }} p on o.order_id = p.order_id
