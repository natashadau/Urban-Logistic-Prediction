-- 1- Top 5 customer areas with highest average delivery time in the last 30 days.

SELECT
  d.customer_area AS "Customer Area",
  AVG(d.delivery_time_min) AS "Average Delivery Time Min"
FROM deliveries d
WHERE d.order_placed_at >= NOW() - INTERVAL '30 days'
GROUP BY d.customer_area
ORDER BY "Average Delivery Time Min" DESC
LIMIT 5


-- 2. Average delivery time per traffic condition, by restaurant area and cuisine type.

SELECT
  r.area AS "Restaurant Area",
  r.cuisine_type AS "Cuisine Type",
  d.traffic_condition AS "Traffic Condition",
  AVG(d.delivery_time_min) AS "Average Delivery Time Min"
FROM deliveries d
JOIN orders o      ON o.delivery_id   = d.delivery_id
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.area, r.cuisine_type, d.traffic_condition
ORDER BY "Average Delivery Time Min" DESC


-- 3. Top 10 delivery people with the fastest average delivery time, considering only those with at least 50 deliveries and who are still active.

SELECT
  dp.delivery_person_id,
  dp.name,
  COUNT(*) AS total_deliveries,
  AVG(d.delivery_time_min) AS average_delivery_time
FROM deliveries d
JOIN delivery_persons dp
  ON dp.delivery_person_id = d.delivery_person_id::INT  -- cast aquí
WHERE dp.is_active = TRUE
GROUP BY dp.delivery_person_id, dp.name
HAVING COUNT(*) >= 50
ORDER BY average_delivery_time ASC
LIMIT 10


-- 4. The most profitable restaurant area in the last 3 months, defined as the area with the highest total order value.

SELECT
  r.area AS "Restaurant Area",
  SUM(o.order_value) AS "Revenue Total"
FROM orders o
JOIN deliveries d  ON d.delivery_id   = o.delivery_id
JOIN restaurants r ON r.restaurant_id = o.restaurant_id
WHERE d.order_placed_at >= NOW() - INTERVAL '3 months'
GROUP BY r.area
ORDER BY "Revenue Total" DESC
LIMIT 1


-- 5. Identify whether any delivery people show an increasing trend in average delivery time.

WITH delivery_times AS (
  SELECT
    d.delivery_person_id::INT AS delivery_person_id,
    CASE
      WHEN d.order_placed_at >= NOW() - INTERVAL '30 days' THEN 'current'
      ELSE 'previous'
    END AS period,
    AVG(d.delivery_time_min) AS avg_delivery_time
  FROM deliveries d
  WHERE d.order_placed_at >= NOW() - INTERVAL '60 days'
  GROUP BY d.delivery_person_id::INT,
           CASE WHEN d.order_placed_at >= NOW() - INTERVAL '30 days' THEN 'current'
                ELSE 'previous'
           END
),
trends AS (
  SELECT
    delivery_person_id,
    MAX(CASE WHEN period = 'current'  THEN avg_delivery_time END) AS current_avg,
    MAX(CASE WHEN period = 'previous' THEN avg_delivery_time END) AS previous_avg
  FROM delivery_times
  GROUP BY delivery_person_id
)
SELECT
  t.delivery_person_id,
  dp.name,
  t.previous_avg,
  t.current_avg,
  (t.current_avg - t.previous_avg) AS delta_min
FROM trends t
JOIN delivery_persons dp
  ON dp.delivery_person_id = t.delivery_person_id
WHERE t.current_avg  IS NOT NULL
  AND t.previous_avg IS NOT NULL
  AND t.current_avg > t.previous_avg
ORDER BY delta_min DESC

