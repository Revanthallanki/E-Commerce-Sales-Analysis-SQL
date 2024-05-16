select * from sales_sql_project.dbo.salesreport;
select * from sales_sql_project.dbo.yearreport;

-- select caterogy and status from the salesreport table
-- in which category orders are not cancelled and ordery by category

select category, status  
	from sales_sql_project.dbo.salesreport
	where status <> 'Cancelled'
	order by category;

-- join two tabels on equal in category

select * from sales_sql_project.dbo.salesreport sa
	join sales_sql_project.dbo.yearreport ya
	on sa.category= ya.category;

-- to know the sales in karnataka

select [ship-state],COUNT(*) as sales_in_karnakata 
	from sales_sql_project.dbo.salesreport
		group by [ship-state]
		having  [ship-state] = 'KARNATAKA';

-- to know the sales in each state
-- and order ship state

select [ship-state],COUNT(*) as sales_in_each_sates 
	from sales_sql_project.dbo.salesreport
		group by [ship-state]
		order by[ship-state];

-- to know the sales in each city
-- and order ship city

select [ship-city],COUNT(*) as city_sales 
	from sales_sql_project.dbo.salesreport
		group by [ship-city]
		order by[ship-city];

-- select weight and count and group by weight 
-- to know how many sales in each weight of product

select [Weight] , count(*) as count_by_weight from sales_sql_project.dbo.yearreport
group by [Weight];

-- return category and size which has more than 500 Rs
-- and order by category

select Category, Size ,Amount from sales_sql_project.dbo.salesreport
where  Amount >=500
order by category;

-- return category weight and max price in Ajio MRP
-- from the yearreport tabele

select category,[weight], [Ajio MRP]  
	from sales_sql_project.dbo.yearreport
		where [Ajio MRP] = 
			(select max([Ajio MRP]) from sales_sql_project.dbo.yearreport);

-- select date and count of sales on that date 
-- which amount is greater than 500

select [date], count([date]) as sales_on_particular_date from sales_sql_project.dbo.salesreport
where [Amount] > 500
group by [date]
having count([date]) >= 1000;

-- join two tables on based on category
-- return which product has equal prices in both ajio and amazon
-- and whose weight is greater than 0.2 and amount is greater than 500

select * from sales_sql_project.dbo.salesreport s
join sales_sql_project.dbo.yearreport y
on s.category = y.category
	where ((y.[weight] >=0.2) and y.[ajio MRP]> 500) 
		and 
		[Amazon MRP] IN (select [ajio MRP] from sales_sql_project.dbo.yearreport);


-- It returns which product has equal price in all ecommerace plateforms

select category,[ajio MRP],[Amazon MRP],[flipkart MRP],[myntra MRP] from sales_sql_project.dbo.yearreport
where [ajio MRP] IN 
	(select [amazon MRP] from sales_sql_project.dbo.yearreport
	where [amazon MRP] IN
		(select [Flipkart MRP] from sales_sql_project.dbo.yearreport
		where [Flipkart MRP] IN
			(select  [Myntra MRP] from sales_sql_project.dbo.yearreport))); 


-- It return category and platform in which has least price for that product
-- It compares price in all platforms and return platform which has least price

SELECT category,LEAST([Amazon MRP], [Flipkart MRP], [Ajio MRP], [Myntra MRP]) AS LeastMRP,
    CASE 
        WHEN [Amazon MRP] = LEAST([Amazon MRP], [Flipkart MRP], [Ajio MRP], [Myntra MRP]) THEN 'Amazon'
        WHEN [Flipkart MRP] = LEAST([Amazon MRP], [Flipkart MRP], [Ajio MRP], [Myntra MRP]) THEN 'Flipkart'
        WHEN [Ajio MRP]= LEAST([Amazon MRP], [Flipkart MRP], [Ajio MRP], [Myntra MRP]) THEN 'Ajio'
        WHEN [Myntra MRP] = LEAST([Amazon MRP], [Flipkart MRP], [Ajio MRP], [Myntra MRP]) THEN 'Myntra'
    END AS LeastMRPPlatform
FROM 
    sales_sql_project.dbo.yearreport;


-- It return how many products are available in particular size

select category,size, count(size) as available   from sales_sql_project.dbo.salesreport
group by category,size
order by category;

-- It return the count of ship-service-level in diffrent levels

select [ship-service-level], 
	count([ship-service-level]) as available   
	from sales_sql_project.dbo.salesreport
		group by [ship-service-level];
--
-- Most popular product 

select sku, count(*) as total_shipped from sales_sql_project.dbo.salesreport
where status like 'shipped%'
group by sku
order by total_shipped desc

-- return total number of shipped ad cancelled orders
-- and ratio between them

select 
    (select count(*) from sales_sql_project.dbo.salesreport where status like 'shipped%') as shipped_orders,
    (select count(*) from sales_sql_project.dbo.salesreport where status = 'cancelled') as cancelled_orders,
    (cast((select count(*) from sales_sql_project.dbo.salesreport where status like 'shipped%') as float) /
     (case when (select count(*) from sales_sql_project.dbo.salesreport where status = 'cancelled') = 0 then 1
           else (select count(*) from sales_sql_project.dbo.salesreport where status = 'cancelled') end)) as shipped_to_cancelled_ratio;

-- It selects the total revenue through the each channel

select o.[sales channel], sum(o.amount) as total_revenue
from sales_sql_project.dbo.salesreport o
where o.status like 'shipped%'
group by o.[sales channel];

-- It  return the category based on demand 
-- It gives from higher demand product to lower demnad product

select category , count(*) as total_count
from  sales_sql_project.dbo.salesreport 
group by category
order by total_count desc;












