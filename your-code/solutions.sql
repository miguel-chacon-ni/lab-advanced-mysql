use publications;
select * from sales;
select * from titles;
select * from authors;
select * from stores;
select * from titleauthor;

-- Challenge 1:
select au_id, sum(revenue) as revenue
from
	(select title_id, au_id, sum(sales_royalty)+sum(advance) as revenue
	from
		(select titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100) as advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
		from titleauthor
		inner join titles
		on titles.title_id = titleauthor.title_id
		inner join sales on
		sales.title_id=titleauthor.title_id) as step1
	group by au_id, title_id
	order by revenue desc) as step2
group by au_id
order by revenue desc
limit 3;

-- Challenge 2: 
-- step1:
create temporary table step1 as
select titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100) as advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from titleauthor
inner join titles
on titles.title_id = titleauthor.title_id
inner join sales on
sales.title_id=titleauthor.title_id;

-- step2:
create temporary table step2 as
select title_id, au_id, sum(sales_royalty)+sum(advance) as revenue
from step1
group by au_id, title_id
order by revenue desc;


create temporary table step3 as
select au_id, sum(revenue) as revenue
from step2
group by au_id
order by revenue desc
limit 3;

select * from step3;

-- challenge 3:

create table most_profiting_authors as
select au_id, sum(revenue) as revenue
from step2
group by au_id
order by revenue desc
limit 3;

select * from most_profiting_authors

