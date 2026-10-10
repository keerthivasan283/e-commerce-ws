-- ==============================================================================
-- Thrift Tamilan - E-Commerce Database Schema (PostgreSQL / Supabase / Neon)
-- Database: thrift_tamilan_db
-- ==============================================================================

-- Create extension for UUIDs if needed in the future
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if re-running (in reverse dependency order)
DROP TABLE IF EXISTS whatsapp_inquiries CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS product_images CASCADE;
DROP TABLE IF EXISTS product_measurements CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- Drop custom types if exist
DROP TYPE IF EXISTS product_size_enum CASCADE;
DROP TYPE IF EXISTS product_condition_enum CASCADE;
DROP TYPE IF EXISTS product_status_enum CASCADE;
DROP TYPE IF EXISTS order_status_enum CASCADE;
DROP TYPE IF EXISTS payment_status_enum CASCADE;
DROP TYPE IF EXISTS inquiry_status_enum CASCADE;

-- ------------------------------------------------------------------------------
-- Custom ENUM Types
-- ------------------------------------------------------------------------------
CREATE TYPE product_size_enum AS ENUM ('XS', 'S', 'M', 'L', 'XL', 'XXL', '28', '30', '32', '34', '36');
CREATE TYPE product_condition_enum AS ENUM ('Like New', 'Good', 'Fair');
CREATE TYPE product_status_enum AS ENUM ('available', 'sold', 'reserved');
CREATE TYPE order_status_enum AS ENUM ('pending', 'confirmed', 'packed', 'shipped', 'delivered', 'cancelled');
CREATE TYPE payment_status_enum AS ENUM ('unpaid', 'paid', 'cod', 'refunded');
CREATE TYPE inquiry_status_enum AS ENUM ('new', 'replied', 'converted', 'dropped');

-- ------------------------------------------------------------------------------
-- 1. Categories Table
-- ------------------------------------------------------------------------------
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  slug VARCHAR(60) NOT NULL UNIQUE,
  description VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 2. Products Table (1-of-1 Thrift Items)
-- ------------------------------------------------------------------------------
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  slug VARCHAR(120) NOT NULL UNIQUE,
  name VARCHAR(200) NOT NULL,
  category_id INT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
  offer_price NUMERIC(10, 2) CHECK (offer_price IS NULL OR offer_price >= 0),
  size product_size_enum NOT NULL,
  condition_grade product_condition_enum NOT NULL DEFAULT 'Good',
  status product_status_enum NOT NULL DEFAULT 'available',
  description TEXT NOT NULL,
  date_added DATE NOT NULL DEFAULT CURRENT_DATE,
  is_bestseller BOOLEAN NOT NULL DEFAULT FALSE,
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_bestseller ON products(is_bestseller);
CREATE INDEX idx_products_price ON products(price);

-- ------------------------------------------------------------------------------
-- 3. Product Measurements Table
-- ------------------------------------------------------------------------------
CREATE TABLE product_measurements (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL UNIQUE REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
  chest_or_waist VARCHAR(50),
  length VARCHAR(50),
  shoulder VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 4. Product Images Table
-- ------------------------------------------------------------------------------
CREATE TABLE product_images (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
  image_url VARCHAR(255) NOT NULL,
  display_order SMALLINT NOT NULL DEFAULT 1,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_images_product_order ON product_images(product_id, display_order);

-- ------------------------------------------------------------------------------
-- 5. Customers Table
-- ------------------------------------------------------------------------------
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(150),
  address_line1 VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100) NOT NULL DEFAULT 'Tamil Nadu',
  postal_code VARCHAR(20),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_customers_phone ON customers(phone);

-- ------------------------------------------------------------------------------
-- 6. Orders Table
-- ------------------------------------------------------------------------------
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_number VARCHAR(30) NOT NULL UNIQUE,
  customer_id INT REFERENCES customers(id) ON DELETE SET NULL ON UPDATE CASCADE,
  subtotal NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),
  shipping_fee NUMERIC(10, 2) NOT NULL DEFAULT 0.00 CHECK (shipping_fee >= 0),
  discount_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00 CHECK (discount_amount >= 0),
  total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0),
  status order_status_enum NOT NULL DEFAULT 'pending',
  payment_status payment_status_enum NOT NULL DEFAULT 'unpaid',
  payment_method VARCHAR(50) NOT NULL DEFAULT 'UPI',
  shipping_address TEXT NOT NULL,
  whatsapp_chat_ref VARCHAR(100),
  tracking_number VARCHAR(100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- ------------------------------------------------------------------------------
-- 7. Order Items Table
-- ------------------------------------------------------------------------------
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
  product_id INT NOT NULL REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
  quantity SMALLINT NOT NULL DEFAULT 1 CHECK (quantity > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 8. WhatsApp Inquiries & Leads Table
-- ------------------------------------------------------------------------------
CREATE TABLE whatsapp_inquiries (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id) ON DELETE SET NULL ON UPDATE CASCADE,
  customer_name VARCHAR(100),
  customer_phone VARCHAR(20) NOT NULL,
  message TEXT,
  status inquiry_status_enum NOT NULL DEFAULT 'new',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_inquiries_phone ON whatsapp_inquiries(customer_phone);
CREATE INDEX idx_inquiries_status ON whatsapp_inquiries(status);

-- ------------------------------------------------------------------------------
-- Automatic updated_at trigger function
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_timestamp_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_timestamp_column();

CREATE TRIGGER trg_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW EXECUTE FUNCTION update_timestamp_column();

CREATE TRIGGER trg_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_timestamp_column();
