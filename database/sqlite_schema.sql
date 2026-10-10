-- ==============================================================================
-- Thrift Tamilan - E-Commerce Database Schema (SQLite / Turso / Cloudflare D1)
-- Database: thrift_tamilan.sqlite
-- ==============================================================================

PRAGMA foreign_keys = ON;

-- Drop existing tables
DROP TABLE IF EXISTS whatsapp_inquiries;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS product_measurements;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- ------------------------------------------------------------------------------
-- 1. Categories Table
-- ------------------------------------------------------------------------------
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 2. Products Table (1-of-1 Thrift Items)
-- ------------------------------------------------------------------------------
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  price REAL NOT NULL,
  offer_price REAL,
  size TEXT NOT NULL CHECK(size IN ('XS', 'S', 'M', 'L', 'XL', 'XXL', '28', '30', '32', '34', '36')),
  condition_grade TEXT NOT NULL DEFAULT 'Good' CHECK(condition_grade IN ('Like New', 'Good', 'Fair')),
  status TEXT NOT NULL DEFAULT 'available' CHECK(status IN ('available', 'sold', 'reserved')),
  description TEXT NOT NULL,
  date_added TEXT NOT NULL,
  is_bestseller INTEGER NOT NULL DEFAULT 0,
  is_featured INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_bestseller ON products(is_bestseller);

-- ------------------------------------------------------------------------------
-- 3. Product Measurements Table
-- ------------------------------------------------------------------------------
CREATE TABLE product_measurements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL UNIQUE REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
  chest_or_waist TEXT,
  length TEXT,
  shoulder TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 4. Product Images Table
-- ------------------------------------------------------------------------------
CREATE TABLE product_images (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
  image_url TEXT NOT NULL,
  display_order INTEGER NOT NULL DEFAULT 1,
  is_primary INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_images_product_order ON product_images(product_id, display_order);

-- ------------------------------------------------------------------------------
-- 5. Customers Table
-- ------------------------------------------------------------------------------
CREATE TABLE customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL UNIQUE,
  email TEXT,
  address_line1 TEXT,
  city TEXT,
  state TEXT NOT NULL DEFAULT 'Tamil Nadu',
  postal_code TEXT,
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_customers_phone ON customers(phone);

-- ------------------------------------------------------------------------------
-- 6. Orders Table
-- ------------------------------------------------------------------------------
CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_number TEXT NOT NULL UNIQUE,
  customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL ON UPDATE CASCADE,
  subtotal REAL NOT NULL,
  shipping_fee REAL NOT NULL DEFAULT 0.00,
  discount_amount REAL NOT NULL DEFAULT 0.00,
  total_amount REAL NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'confirmed', 'packed', 'shipped', 'delivered', 'cancelled')),
  payment_status TEXT NOT NULL DEFAULT 'unpaid' CHECK(payment_status IN ('unpaid', 'paid', 'cod', 'refunded')),
  payment_method TEXT NOT NULL DEFAULT 'UPI',
  shipping_address TEXT NOT NULL,
  whatsapp_chat_ref TEXT,
  tracking_number TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_orders_status ON orders(status);

-- ------------------------------------------------------------------------------
-- 7. Order Items Table
-- ------------------------------------------------------------------------------
CREATE TABLE order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  unit_price REAL NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 8. WhatsApp Inquiries & Leads Table
-- ------------------------------------------------------------------------------
CREATE TABLE whatsapp_inquiries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER REFERENCES products(id) ON DELETE SET NULL ON UPDATE CASCADE,
  customer_name TEXT,
  customer_phone TEXT NOT NULL,
  message TEXT,
  status TEXT NOT NULL DEFAULT 'new' CHECK(status IN ('new', 'replied', 'converted', 'dropped')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_inquiries_phone ON whatsapp_inquiries(customer_phone);
