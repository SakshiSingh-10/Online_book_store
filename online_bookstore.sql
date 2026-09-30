drop table if exists Books ;
create table Books (
    Book_id serial primary key,
	Title varchar (80),
	Author varchar (100),
	Genere varchar (100),
	published_year int ,
	Price numeric (10,2),
	Stock int 
);
drop table if exists Customers ;
create table Customers (
    customer_id serial primary key,
	Name varchar (100),
	Email varchar (100),
	Phone varchar (15),
	City varchar (30),
	Country varchar (150)
	
);
drop  table if exists Orders ;
create table Orders (
Order_id serial primary key ,
Customer_id int references Customers (Customer_id),
Book_id int references Books (Book_id),
Order_date date ,
Quantity int ,
Total_Amount numeric (10, 2) 
);

select * from Books ;
select * from Customers;
select * from Orders;

-- Import data into Books table
copy Books (Book_id , Title, Author ,Genere ,Published_year , Price , Stock)
from '‪‪C:\Users\hp\Desktop\Books.csv'
csv header;

--Import data into Coustomer table 
copy Coustomers(customer_id ,Name ,Email ,Phone ,City ,Country)
from '‪C:\Users\hp\Desktop\Customers.csv'
csv header ;

--Import data into order table 
copy Orders(Order_id ,Customer_id ,Book_id ,Order_date,Quantity , Total_Amount)
from 'C:\Users\hp\Desktop\Orders.csv'
csv header;

--Basic Query 
1-- Retrive all books in the "fiction" genere 
select * from Books 
where Genere = 'Fiction'; 
2-- Find books published year after 1950
select * from Books 
where Published_year >1950 ;

3-- List all the customers from canada 
select * from Customers 
where country = 'Canada';

4-- show order placed in nov 2023 
select * from Orders 
where order_date between '2023-11-01'and '2023-11-30';

5-- Retrive the total stock of books avilable 
select sum(stock) as Total_Stock
from Books ;

6-- Find the details of the most expensive books
select * from Books 
order by price 
desc limit 1;

7 -- display all the customers who oder more then 1 quantity of books 
select * from Orders
where quantity >1 ;

8-- Retrive all the oders where total cost exceded 	$20
select * from Orders 
where total_amount >20;

9--List all the generes avialble in books table 
select distinct  genere from Books ;

10 -- find the books with lowest price 
select * from Books 
order by stock asc
limit 1;

11-- calculate the total revenue genrated from all orders
select sum (total_amount) AS revenue 
from Orders ;

-- Advance Query 
1--Retrive the total number of book sold for each genere 
select * from Orders ;
select b.Genere,sum( o.Quantity) as Total_Books_sold
from Orders o
join Books  b on o.book_id = b.book_id
group by b.Genere;

2-- Find the avrg price of books in the "Fantasy" genere
select avg(price) as avg_price
from Books
where genere = 'Fantasy';

3-- List customres who have placed at least 2 orders 
select o.customer_id , c.name,count(o.Order_id) as Order_count
from Orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id ,c.name 
having count(Order_id)>= 2;
4--Find most frequently order book 
select Book_id ,count (order_id) as Order_Count
from Orders 
group by Book_id
order by Order_Count desc  limit 1;

5--show top 3 most expensive books of 'Fantasy' Genere 
select *  from books
where genere = 'Fantasy'
order by price desc  limit 3 ;

6-- Retrive the total quantity of books sold by each author 
select b.author,sum(o.quantity) as Total_Books_sold
from Orders o
join books b on o.book_id = b.book_id
group by b.Author;

7-- list the cities where customers who spent over $30 are located 
select distinct c .city,Total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount >30;
8-- Find the customer who spent the most on orders

select c.customer_id , c.name,sum (o.total_amount) as Total_spend
from Orders o
join customers c on o. customer_id=c.customer_id
group  by c.customer_id,c.name
order by Total_spend desc  limit 1;

9-- calculate the stock remaning after fulfling all orders

select b.book_id,b.title, b.stock,coalesce (sum (o.quantity),0) as Order_quantity,
     b.stock - coalesce (sum(o.quantity),0) as Remaining_Quantity
from Books b 
left join orders o on b.book_id = o.book_id
group by b.book_id order by b.book_id;

