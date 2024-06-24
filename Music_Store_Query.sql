1) Who is the senior most employee based on job title?
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1

2) Which contry have the most invoices?
SELECT billing_country, COUNT(*) AS c
FROM invoice
GROUP BY billing_country
ORDER BY c DESC
LIMIT 1

3) What are the top 3 vales of total invoice?
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3

4) Which city has the best customers? We would like to throw a promotional Music festival in the city we made the mostmoney. write a query that returns one city that has the highest sum of invoice tottals.Return both the city name & sum of all invoice totals
SELECT SUM(total) as Total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY Total DESC
LIMIT 5

5) Who is the best customer? The customer who spent the most money will be declared as the best customer. Write a queary that returns the person who has spent the most money.
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS Total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY Total DESC
LIMIT 1

6) Write the queary to return the email, first name, last name & Genre of all the Rock Music listners. Return Your list ordered alphabetically by email starting with A
SELECT DISTINCT customer.email, customer.first_name, customer.last_name, genre.name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre on track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY customer.email
LIMIT 5

7) Lets's invite the artist who have written the most Rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 Rock Bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
From artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
Join genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
Order by number_of_songs DESC
LIMIT 10;

8) Return all the track names that have a song length longer than the average song length, Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT name, milliseconds
FROM track
WHERE milliseconds >(SELECT AVG(milliseconds) AS length
FROM track)
ORDER BY milliseconds DESC
LIMIT 5;

9) Find how much amount spent by each customer on best artist? Write a query to return customer name, artist name and total spent
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price * invoice_line.quantity)AS total_sales
	FROM artist
	JOIN album ON artist.artist_id = album.artist_id
	JOIN track ON album.album_id = track.album_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
	GROUP BY artist.artist_id
	ORDER BY total_sales DESC	
	LIMIT 1
	)
	
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price * il.quantity) as amount_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album alb ON t.album_id = alb.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

10) We want to find out the most popular music Genre for each country. We dertermine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with top Genre. For countries where the maximum number of purchases is shared return all genres.
WITH popular_genre AS (
	SELECT customer.country, genre.genre_id, genre.name, COUNT(invoice_line.quantity),
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC) AS RowNo
	FROM customer
	JOIN invoice ON customer.customer_id = invoice.customer_id
	JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
	JOIN track ON invoice_line.track_id = track.track_id
	JOIN genre ON track.genre_id = genre.genre_id
	GROUP BY 1,2,3
	ORDER BY 1 ASC, 4 DESC
)
	
SELECT *
FROM popular_genre
WHERE RowNo <=1

11) Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
 WITH customer_with_country AS (
	SELECT customer.customer_id, first_name, last_name, billing_country, sum(total) AS total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
	FROM customer
	JOIN invoice ON customer.customer_id = invoice.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 4 ASC, 5 DESC
	)
SELECT *
FROM customer_with_country
WHERE RowNo <= 1


