drop view if exists dp_bi.vendor_delay;
create materialized view dp_bi.vendor_delay as 
with  d as (
		select 
		d.order_id as order_id,
		d.vendor_id,
		ROUND(d.vendor_delay/60,2)::numeric as vendor_delay
		from dp_bi.deliveries_did d
		       ),
	t  as (select o.order_id,
	     	        o.is_failed_order_vendor
	       from dp_bi.orders_oid o 
	            )
select d.*,t.is_failed_order_vendor
from d
LEFT JOIN t USING(order_id);
---this is testing 
SELECT a.*
FROM a
Left join b using(id)
