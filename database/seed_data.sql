-- ==============================================================================
-- Thrift Tamilan - E-Commerce Database Seed Data
-- Compatible with MySQL, PostgreSQL, and SQLite
-- Populates all 12 products, measurements, images, plus sample customers & orders
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. Insert Categories
-- ------------------------------------------------------------------------------
INSERT INTO categories (id, name, slug, description) VALUES
(1, 'Jackets',  'jackets',  'Vintage denim, workwear, canvas & bomber jackets'),
(2, 'Hoodies',  'hoodies',  'Heavyweight fleece, thermal & athletic hoodies'),
(3, 'T-Shirts', 't-shirts', 'Single-stitch vintage band, graphic & skate tees'),
(4, 'Jeans',    'jeans',    'Selvedge, raw denim & relaxed vintage fit jeans'),
(5, 'Shirts',   'shirts',   'Oxford button-downs, flannels & patterned shirts'),
(6, 'Trousers', 'trousers', 'Work pants, double knees & skate chinos');

-- ------------------------------------------------------------------------------
-- 2. Insert Products
-- ------------------------------------------------------------------------------
INSERT INTO products (
  id, code, slug, name, category_id, price, offer_price, size, condition_grade,
  status, description, date_added, is_bestseller, is_featured
) VALUES
(
  1,
  'TT001',
  'carhartt-detroit-duck-canvas-jacket',
  '90s Carhartt Detroit Duck Canvas Jacket',
  1,
  3999.00,
  3499.00,
  'XL',
  'Like New',
  'available',
  'Heavyweight vintage Carhartt Detroit work jacket in weathered duck canvas. Blanket lined with corduroy collar and branded brass zipper. Perfectly aged patina with zero structural tears.',
  '2026-09-20',
  0,
  1
),
(
  2,
  'TT002',
  'vintage-nike-acg-trail-fleece-pullover',
  'Vintage Nike ACG Trail Thermal Fleece',
  2,
  2199.00,
  NULL,
  'L',
  'Good',
  'available',
  'Late 90s Nike All Conditions Gear (ACG) thermal fleece pullover. Deep navy and forest green two-tone block with embroidered triangular ACG chest patch and storm kangaroo zip pocket.',
  '2026-09-22',
  1,
  0
),
(
  3,
  'TT003',
  'pink-floyd-1994-division-bell-tour-tee',
  '1994 Pink Floyd Division Bell Tour Tee',
  3,
  1799.00,
  NULL,
  'L',
  'Good',
  'sold',
  'Authentic single-stitch 1994 Division Bell world tour graphic tee. Washed sun-faded vintage black cotton with classic double-face graphic and tour dates on the back.',
  '2026-09-15',
  1,
  0
),
(
  4,
  'TT004',
  'levis-501-original-fit-selvedge-denim',
  'Levi''s 501 Original Selvedge Raw Denim',
  4,
  2499.00,
  1999.00,
  '32',
  'Like New',
  'available',
  'Classic Levi''s 501 straight leg jeans with iconic button fly and red tab. Made from heavy 14oz rigid raw denim with natural honeycombing whiskering in excellent condition.',
  '2026-09-25',
  0,
  1
),
(
  5,
  'TT005',
  'ralph-lauren-oxford-classic-button-down',
  'Ralph Lauren Classic Oxford Shirt',
  5,
  1499.00,
  NULL,
  'M',
  'Like New',
  'available',
  'Crisp sky blue 100% heavyweight cotton oxford cloth button-down with multi-color polo player embroidery. Clean collar rolls, no collar fraying, relaxed 90s custom fit.',
  '2026-09-28',
  1,
  0
),
(
  6,
  'TT006',
  'dickies-874-work-trousers-charcoal',
  'Dickies 874 Original Skate Trousers',
  6,
  1699.00,
  NULL,
  '30',
  'Like New',
  'available',
  'Stiff twill Dickies 874 work pant in deep charcoal grey. High rise, wide belt loops, permanent front crease. Unbeatable street durability.',
  '2026-09-18',
  0,
  0
),
(
  7,
  'TT007',
  'stussy-90s-crown-boxy-graphic-tee',
  'Stüssy 90s Crown Boxy Graphic Tee',
  3,
  1599.00,
  1299.00,
  'XL',
  'Good',
  'available',
  'Early 2000s Stüssy heavyweight graphic tee with iconic royal crown crest print. Ribbed thick neckline, vintage boxy drop-shoulder cut, gently distressed hem.',
  '2026-10-01',
  0,
  1
),
(
  8,
  'TT008',
  'starter-chicago-bulls-vintage-bomber',
  'Starter Chicago Bulls Vintage Bomber',
  1,
  2899.00,
  NULL,
  'L',
  'Fair',
  'sold',
  'Grail 90s satin Starter Chicago Bulls varsity snap jacket. Quilted lining with red and black striped ribbing. Authentic minor patina on inner sleeve cuff.',
  '2026-09-10',
  0,
  0
),
(
  9,
  'TT009',
  'champion-reverse-weave-heavy-hoodie',
  'Champion Reverse Weave Heavyweight Hoodie',
  2,
  1899.00,
  NULL,
  'M',
  'Good',
  'available',
  'Heavy 12oz cross-grain cotton fleece hoodie in heather grey with ribbed side gussets. Thick double-ply hood and small signature C logo on left wrist.',
  '2026-10-02',
  0,
  1
),
(
  10,
  'TT010',
  'woolrich-shadow-plaid-heavy-flannel',
  'Woolrich Shadow Plaid Heavy Flannel',
  5,
  1699.00,
  1399.00,
  'XL',
  'Like New',
  'available',
  'Vintage thick brushed cotton lumberjack flannel shirt in terracotta, black and cream shadow plaid. Dual buttoned chest pockets and sturdy tortoise-shell buttons.',
  '2026-10-03',
  0,
  0
),
(
  11,
  'TT011',
  'harley-davidson-daytona-biker-tee',
  'Harley-Davidson 2003 Daytona Biker Tee',
  3,
  1650.00,
  NULL,
  'M',
  'Good',
  'available',
  '2003 Daytona Bike Week commemorative graphic t-shirt. Front eagle emblem with flame engine graphics and back Florida dealer print on thick vintage cotton.',
  '2026-10-04',
  1,
  0
),
(
  12,
  'TT012',
  'carhartt-double-knee-carpenter-pants',
  'Carhartt Double-Knee Carpenter Pants',
  6,
  2299.00,
  1899.00,
  '34',
  'Fair',
  'available',
  'Authentic workwear distressed double-front knee panel pants in tobacco tan duck canvas. Utility tool pocket, hammer loop, and real trade wear marks.',
  '2026-10-05',
  0,
  0
);

-- ------------------------------------------------------------------------------
-- 3. Insert Product Measurements
-- ------------------------------------------------------------------------------
INSERT INTO product_measurements (product_id, chest_or_waist, length, shoulder) VALUES
(1,  '26.5 inches', '28.0 inches',        '21.5 inches'),
(2,  '24.0 inches', '27.5 inches',        '20.0 inches'),
(3,  '22.5 inches', '29.0 inches',        '19.5 inches'),
(4,  '32.0 inches', '32.0 inches inseam', NULL),
(5,  '21.5 inches', '30.0 inches',        '18.5 inches'),
(6,  '30.0 inches', '30.0 inches inseam', NULL),
(7,  '25.0 inches', '29.5 inches',        '22.0 inches'),
(8,  '24.5 inches', '27.0 inches',        '20.5 inches'),
(9,  '22.0 inches', '27.0 inches',        '19.0 inches'),
(10, '25.5 inches', '31.0 inches',        '21.0 inches'),
(11, '21.0 inches', '28.0 inches',        '18.5 inches'),
(12, '34.0 inches', '31.5 inches inseam', NULL);

-- ------------------------------------------------------------------------------
-- 4. Insert Product Images
-- ------------------------------------------------------------------------------
INSERT INTO product_images (product_id, image_url, display_order, is_primary) VALUES
-- TT001
(1, '/products/tt001-front.svg',  1, 1),
(1, '/products/tt001-back.svg',   2, 0),
(1, '/products/tt001-detail.svg', 3, 0),

-- TT002
(2, '/products/tt002-front.svg',  1, 1),
(2, '/products/tt002-back.svg',   2, 0),

-- TT003
(3, '/products/tt003-front.svg',  1, 1),
(3, '/products/tt003-back.svg',   2, 0),

-- TT004
(4, '/products/tt004-front.svg',  1, 1),
(4, '/products/tt004-back.svg',   2, 0),
(4, '/products/tt004-detail.svg', 3, 0),

-- TT005
(5, '/products/tt005-front.svg',  1, 1),
(5, '/products/tt005-detail.svg', 2, 0),

-- TT006
(6, '/products/tt006-front.svg',  1, 1),
(6, '/products/tt006-back.svg',   2, 0),

-- TT007
(7, '/products/tt007-front.svg',  1, 1),
(7, '/products/tt007-back.svg',   2, 0),

-- TT008
(8, '/products/tt008-front.svg',  1, 1),
(8, '/products/tt008-back.svg',   2, 0),

-- TT009
(9, '/products/tt009-front.svg',  1, 1),
(9, '/products/tt009-back.svg',   2, 0),

-- TT010
(10, '/products/tt010-front.svg', 1, 1),
(10, '/products/tt010-detail.svg',2, 0),

-- TT011
(11, '/products/tt001-front.svg', 1, 1),
(11, '/products/tt001-back.svg',  2, 0),

-- TT012
(12, '/products/tt004-front.svg', 1, 1),
(12, '/products/tt004-back.svg',  2, 0);

-- ------------------------------------------------------------------------------
-- 5. Insert Sample Customers (Tamil Nadu Cities)
-- ------------------------------------------------------------------------------
INSERT INTO customers (id, full_name, phone, email, address_line1, city, state, postal_code, notes) VALUES
(1, 'Aravind Swaminathan', '+919876543210', 'aravind.s@gmail.com', '42, Besant Nagar 2nd Cross', 'Chennai', 'Tamil Nadu', '600090', 'Frequent buyer of vintage tees'),
(2, 'Karthik Raja',        '+919841234567', 'karthik.r@yahoo.com', '15, RS Puram West',        'Coimbatore', 'Tamil Nadu', '641002', 'Loves Carhartt workwear'),
(3, 'Dinesh Kumar',        '+919710987654', 'dinesh.k@outlook.com','88, KK Nagar Main Road',   'Madurai', 'Tamil Nadu', '625020', 'Prefers UPI payment');

-- ------------------------------------------------------------------------------
-- 6. Insert Sample Orders
-- ------------------------------------------------------------------------------
INSERT INTO orders (
  id, order_number, customer_id, subtotal, shipping_fee, discount_amount, total_amount,
  status, payment_status, payment_method, shipping_address, whatsapp_chat_ref
) VALUES
(
  1,
  'TT-ORD-2026-001',
  1,
  1799.00,
  0.00,
  0.00,
  1799.00,
  'delivered',
  'paid',
  'UPI',
  'Aravind Swaminathan, 42 Besant Nagar 2nd Cross, Chennai, Tamil Nadu - 600090',
  'WA-CHAT-+919876543210'
),
(
  2,
  'TT-ORD-2026-002',
  2,
  2899.00,
  100.00,
  0.00,
  2999.00,
  'delivered',
  'paid',
  'GPay',
  'Karthik Raja, 15 RS Puram West, Coimbatore, Tamil Nadu - 641002',
  'WA-CHAT-+919841234567'
),
(
  3,
  'TT-ORD-2026-003',
  3,
  3499.00,
  0.00,
  0.00,
  3499.00,
  'confirmed',
  'paid',
  'PhonePe',
  'Dinesh Kumar, 88 KK Nagar Main Road, Madurai, Tamil Nadu - 625020',
  'WA-CHAT-+919710987654'
);

-- ------------------------------------------------------------------------------
-- 7. Insert Order Items
-- ------------------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, unit_price, quantity) VALUES
(1, 3, 1799.00, 1), -- Sold Pink Floyd Tee
(2, 8, 2899.00, 1), -- Sold Starter Bulls Bomber
(3, 1, 3499.00, 1); -- Ordered Carhartt Detroit Jacket

-- ------------------------------------------------------------------------------
-- 8. Insert Sample WhatsApp Inquiries (Leads Pipeline)
-- ------------------------------------------------------------------------------
INSERT INTO whatsapp_inquiries (product_id, customer_name, customer_phone, message, status) VALUES
(4, 'Siddharth V',  '+919884011223', 'Hi bro, Levi''s 501 selvedge still available? Can you share waist measurement video?', 'replied'),
(7, 'Manoj K',      '+919790554433', 'Interested in the Stüssy crown tee. What is the chest width?', 'converted'),
(9, 'Vignesh R',    '+919600123987', 'Is Champion reverse weave hoodie fleece thick? Pan-India shipping how many days?', 'new');
