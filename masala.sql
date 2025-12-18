-- -- 1) 1 chi kategorydagi productlar  96 yilning har bir oyida 1 kategorydagi maxsulotlarga nechta dan zakaz tushgan 10 $dan qimmat
-- -- 2) 3 kategorydagi eng arzon maxsulotga 97 yilining 7 oyida yetkazib bergan supplierlar
-- -- 3) 98 yilning mart oyidagi zakazlarni sotib olgan mijozlarrga hizmat ko'rsatgan hodimlar (kompany name, hodimni full name)
-- -- 4) har bir kategorydagi eng qimmat maxsulot 96 yilda qanchadan sotilgan
-- -- 5) 97 yilda amerikali customerlarga hizmat ko'rsatgan amerikalik supplierlar chiqarilsin
-- -- 6) 5 chi kategorydagi maxsulotlarga 97 yilda hizmat ko'rsatgan hodimlarni chiqarish
-- -- 7) amerikaning har bir shaxri 97 yilning har bir oyida qanchadan zakaz olgan

-- 1-masala
select  to_char(order_date,'YYYY-MM') ,p.category_id, count (distinct o.order_id) from orders o
inner join order_details od on (od.order_id=o.order_id)
inner join products p on (p.product_id=od.product_id)
where to_char(order_date,'YYYY')='1996' and od.unit_price>10 and p.category_id=1
group by to_char(o.order_date ,'YYYY-MM') ,p.category_id


-- 2-masala
select  to_char(o.order_date,'YYYY-MM'), s.supplier_id, p.category_id , p.unit_price  from products p
inner join suppliers s on(p.supplier_id=s.supplier_id)
inner join order_details od on (od.product_id=p.product_id)
inner join orders o on (o.order_id=od.order_id)
where  to_char(o.order_date,'YYYY-MM')='1997-07' and p.category_id=3 and p.unit_price=(select min(p2.unit_price)from products p2
inner join order_details od2 on (od2.product_id=p2.product_id)
inner join orders o2 on (o2.order_id=od2.order_id)
where to_char(o2.order_date,'YYYY-MM')='1997-07' and p2.category_id=3)
group by to_char(o.order_date,'YYYY-MM') , p.category_id ,s.supplier_id

-- 3-masala
select  to_char(o.order_date,'YYYY-MM') order_date,c.company_name, e.last_name ||' '|| e.first_name  as full_name from orders o
inner join customers c on (c.customer_id=o.customer_id)
inner join employees e on (e.employee_id=o.employee_id)
where  to_char(o.order_date,'YYYY-MM')='1998-03'
group by order_date ,c.company_name, full_name


-- 4-masala
select  to_char(o.order_date,'YYYY')  ,p.category_id ,p.product_name ,p.unit_price, sum(od.quantity) from products p
inner join order_details od on(od.product_id=p.product_id)
inner join orders o on (o.order_id=od.order_id)
where to_char(o.order_date,'YYYY')='1996' and p.unit_price=(
select max(p2.unit_price) from products p2
where p2.category_id=p.category_id)
group by to_char(o.order_date,'YYYY'), p.category_id ,p.product_name ,p.unit_price
order by p.category_id


-- 5masala
select to_char(o.order_date,'YYYY'), s.supplier_id , s.company_name from suppliers s
inner join products p on(p.supplier_id=s.supplier_id)
inner join order_details od on(od.product_id=p.product_id)
inner join orders o on(o.order_id=od.order_id)
inner join customers c on(c.customer_id=o.customer_id)
where to_char(o.order_date,'YYYY')='1997' and s. country='USA' and c.country='USA'


-- 6-masala
select to_char(o.order_date,'YYYY'), e.last_name ||' '|| e.first_name full_name, p.category_id from products p
inner join order_details od on(od.product_id=p.product_id)
inner join orders o on (o.order_id=od.order_id)
inner join employees e on (o.employee_id=e.employee_id)
where to_char(o.order_date,'YYYY')='1997' and p.category_id=5
group by to_char(o.order_date,'YYYY'),full_name,p.category_id


-- 7-masala
select to_char(o.order_date,'YYYY-MM') ,c.city,count(*) from orders o
inner join customers c on(c.customer_id=o.customer_id)
where to_char(o.order_date,'YYYY')='1997' and c.country='USA'
group by to_char(o.order_date,'YYYY-MM'),c.city