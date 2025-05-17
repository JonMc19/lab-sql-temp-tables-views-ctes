#--Paso 1 Create a View:
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create or replace view Customer_Summary as 
select 
	c.customer_id,
    concat (c.first_name, c.last_name) as "Full_Name",
    c.email,
    count(rental_id) as rental_count
from sakila.customer as c
left join sakila.rental as r
	using (customer_id)

group by 
	c.customer_id,
    c.first_name, 
    c.email;
    
#--Paso 2 Create a temporary table:
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
#and calculate the total amount paid by each customer.

create temporary table payment_summary as

select
	cs.customer_id,
    cs.Full_Name,
    cs.email,
    cs.rental_count,
	sum(p.amount) as total_payment
from sakila.Customer_Summary as cs
left join sakila.payment as p
	using(customer_id)
group by 
	cs.customer_id,
    cs.Full_Name,
    cs.email,
    cs.rental_count
order by 
	total_payment desc;


#Paso 3 Create CTE:
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.

#Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, 
#rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with intermediate_table as (
	select 
		cs.*,
		ps.total_payment
	from Customer_Summary as cs
	inner join payment_summary as ps
		on cs.customer_id=ps.customer_id
)

select 
	*,
    round(total_payment/rental_count,2) as average_rent
from intermediate_table












