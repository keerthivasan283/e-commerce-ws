-- ==============================================================================
-- Thrift Tamilan - Handy E-Commerce SQL Queries & Store Operations
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. Catalogue Listing (Available Products with Category & Primary Image)
-- ------------------------------------------------------------------------------
SELECT 
  p.id,
  p.code,
  p.slug,
  p.name,
  c.name AS category_name,
  p.price,
  p.offer_price,
  COALESCE(p.offer_price, p.price) AS current_price,
  p.size,
  p.condition_grade,
  p.status,
  p.is_bestseller,
  p.is_featured,
  img.image_url AS primary_image
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN product_images img ON p.id = img.product_id AND img.is_primary = 1
WHERE p.status = 'available'
ORDER BY p.date_added DESC;

-- ------------------------------------------------------------------------------
-- 2. Single Product Details (Measurements + Images)
-- ------------------------------------------------------------------------------
-- Product Core Details & Measurements
SELECT 
  p.id,
  p.code,
  p.slug,
  p.name,
  c.name AS category,
  p.price,
  p.offer_price,
  p.size,
  p.condition_grade,
  p.status,
  p.description,
  p.date_added,
  m.chest_or_waist,
  m.length,
  m.shoulder
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN product_measurements m ON p.id = m.product_id
WHERE p.slug = 'carhartt-detroit-duck-canvas-jacket';

-- All Images for this product ordered
SELECT 
  image_url,
  display_order,
  is_primary
FROM product_images
WHERE product_id = 1
ORDER BY display_order ASC;

-- ------------------------------------------------------------------------------
-- 3. Filter by Category & Size
-- ------------------------------------------------------------------------------
SELECT 
  p.code,
  p.name,
  p.size,
  p.price,
  p.offer_price
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.slug = 'jackets'
  AND p.status = 'available'
  AND p.size IN ('L', 'XL');

-- ------------------------------------------------------------------------------
-- 4. Featured Drops for Homepage
-- ------------------------------------------------------------------------------
SELECT 
  p.code,
  p.name,
  p.price,
  p.offer_price,
  p.size,
  img.image_url
FROM products p
LEFT JOIN product_images img ON p.id = img.product_id AND img.is_primary = 1
WHERE p.is_featured = 1
  AND p.status = 'available'
ORDER BY p.date_added DESC;

-- ------------------------------------------------------------------------------
-- 5. Mark Product as Sold (1-of-1 Thrift Logic)
-- ------------------------------------------------------------------------------
UPDATE products
SET status = 'sold'
WHERE code = 'TT001';

-- ------------------------------------------------------------------------------
-- 6. Sales & Revenue Summary
-- ------------------------------------------------------------------------------
SELECT 
  COUNT(o.id) AS total_orders,
  SUM(CASE WHEN o.payment_status = 'paid' THEN o.total_amount ELSE 0 END) AS total_collected_revenue,
  AVG(o.total_amount) AS average_order_value,
  SUM(CASE WHEN o.status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
  SUM(CASE WHEN o.status = 'pending' THEN 1 ELSE 0 END) AS pending_orders
FROM orders o;

-- ------------------------------------------------------------------------------
-- 7. Inventory Status by Category
-- ------------------------------------------------------------------------------
SELECT 
  c.name AS category,
  COUNT(p.id) AS total_pieces,
  SUM(CASE WHEN p.status = 'available' THEN 1 ELSE 0 END) AS in_stock,
  SUM(CASE WHEN p.status = 'sold' THEN 1 ELSE 0 END) AS sold_out
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY in_stock DESC;

-- ------------------------------------------------------------------------------
-- 8. WhatsApp Inquiry Leads Conversion Rate
-- ------------------------------------------------------------------------------
SELECT 
  COUNT(*) AS total_inquiries,
  SUM(CASE WHEN status = 'converted' THEN 1 ELSE 0 END) AS converted_to_sales,
  ROUND(SUM(CASE WHEN status = 'converted' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS conversion_rate_percent
FROM whatsapp_inquiries;
