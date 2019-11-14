with c AS(
			with j as(
						   with d as        
								(select regexp_replace(ad.postcode_district,'^[0-9]{3}','') as district,avg(lat) as standard_lat,avg(lon) as standard_lon  
									FROM dp_bi.vendors_accountid ad
									where backend_active = 1 and ad.postcode_district is not NULL
									group by 1
									),
								t as
								(select regexp_replace(postcode_district,'^[0-9]{3}','') as district,vendor_code,lat,lon
									from dp_bi.vendors_accountid
									where backend_active = 1 and postcode_district is not NULL
									)
						select d.district,
							t.vendor_code,
							(case when d.standard_lat - t.lat <0 then -(d.standard_lat - t.lat) else d.standard_lat - t.lat end)+
							(case when d.standard_lon - t.lon <0 then -(d.standard_lon - t.lon) else d.standard_lon - t.lon end) as final__
							from d
							full join t on d.district = t.district
					)
				select j.*,RANK () OVER (partition by district ORDER BY final__ ) as rank_no 
					from j
		)
select c.district,c.vendor_code
	from c
	where rank_no <4