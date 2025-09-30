**Other Analysis**

1- Considering measuring the relationship between restaurant preparation times and overall delivery times highlights which restaurants disproportionately inflate delivery duration.

By keeping track of which restaurants are slower than average, there could be a strategu to improve, adjust how couriers are assigned, or set more realistic delivery expectations for customers.


```python
SELECT 
  r.name AS restaurant_name,
  r.area AS restaurant_area,
  AVG(r.avg_preparation_time_min) AS avg_preparation_time,
  AVG(d.delivery_time_min) AS avg_delivery_time,
  COUNT(*) AS deliveries_count
FROM deliveries d
JOIN orders o ON d.delivery_id = o.delivery_id
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.name, r.area
ORDER BY avg_delivery_time DESC
LIMIT 10
```

2- Analyzing the average delivery time by day of the week is important to identify demand patterns and courier availability often change throughout the week. 

Certain weekdays may see higher order volumes, leading to longer delivery times. Understanding these trends can help plan ahead to ensure enough couriers are scheduled, anticipate potential delays, and adjust customer expectations more accurately.


```python
SELECT 
  TO_CHAR(d.order_placed_at, 'Day') AS day_of_week,
  AVG(d.delivery_time_min) AS avg_delivery_time,
  COUNT(*) AS deliveries_count
FROM deliveries d
GROUP BY TO_CHAR(d.order_placed_at, 'Day')
ORDER BY avg_delivery_time DESC
```

3- Knowing which conditions cause the biggest slowdowns allows better ETA adjustments and operational planning. 

Extreme weather conditions, such as heavy rain or dense fog, tend to have the most significant impact on delivery times, as they not only slow down couriers but can also increase safety risks and reduce the number of available drivers.


```python
SELECT 
  d.weather_condition,
  AVG(d.delivery_time_min) AS avg_delivery_time,
  COUNT(*) AS deliveries_count
FROM deliveries d
GROUP BY d.weather_condition
ORDER BY avg_delivery_time DESC
```
