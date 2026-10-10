-- ==============================================================================
-- Thrift Tamilan - E-Commerce Database Schema (MySQL / MariaDB)
-- Database: thrift_tamilan_db
-- Charset: utf8mb4 (Full Unicode Support)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `thrift_tamilan_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `thrift_tamilan_db`;

-- Drop existing tables if re-running (in reverse dependency order)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `whatsapp_inquiries`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `product_measurements`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------------------------
-- 1. Categories Table
-- ------------------------------------------------------------------------------
CREATE TABLE `categories` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `slug` VARCHAR(60) NOT NULL UNIQUE,
  `description` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. Products Table (1-of-1 Thrift Items)
-- ------------------------------------------------------------------------------
CREATE TABLE `products` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Unique product code e.g. TT001',
  `slug` VARCHAR(120) NOT NULL UNIQUE COMMENT 'URL slug for SEO',
  `name` VARCHAR(200) NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `price` DECIMAL(10, 2) NOT NULL COMMENT 'Original price in INR',
  `offer_price` DECIMAL(10, 2) NULL COMMENT 'Discounted offer price in INR if on sale',
  `size` ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', '28', '30', '32', '34', '36') NOT NULL,
  `condition_grade` ENUM('Like New', 'Good', 'Fair') NOT NULL DEFAULT 'Good',
  `status` ENUM('available', 'sold', 'reserved') NOT NULL DEFAULT 'available',
  `description` TEXT NOT NULL,
  `date_added` DATE NOT NULL,
  `is_bestseller` BOOLEAN NOT NULL DEFAULT FALSE,
  `is_featured` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  INDEX `idx_products_status` (`status`),
  INDEX `idx_products_category` (`category_id`),
  INDEX `idx_products_featured` (`is_featured`),
  INDEX `idx_products_bestseller` (`is_bestseller`),
  INDEX `idx_products_price` (`price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. Product Measurements Table
-- ------------------------------------------------------------------------------
CREATE TABLE `product_measurements` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL UNIQUE,
  `chest_or_waist` VARCHAR(50) NULL COMMENT 'e.g. 26.5 inches or 32.0 inches',
  `length` VARCHAR(50) NULL COMMENT 'e.g. 28.0 inches',
  `shoulder` VARCHAR(50) NULL COMMENT 'e.g. 21.5 inches',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT `fk_measurements_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 4. Product Images Table (Supports multiple photos per item)
-- ------------------------------------------------------------------------------
CREATE TABLE `product_images` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `display_order` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT `fk_images_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,

  INDEX `idx_images_product_order` (`product_id`, `display_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 5. Customers Table
-- ------------------------------------------------------------------------------
CREATE TABLE `customers` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `full_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL UNIQUE COMMENT 'WhatsApp / primary contact phone',
  `email` VARCHAR(150) NULL,
  `address_line1` VARCHAR(255) NULL,
  `city` VARCHAR(100) NULL,
  `state` VARCHAR(100) NOT NULL DEFAULT 'Tamil Nadu',
  `postal_code` VARCHAR(20) NULL,
  `notes` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_customers_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 6. Orders Table
-- ------------------------------------------------------------------------------
CREATE TABLE `orders` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_number` VARCHAR(30) NOT NULL UNIQUE COMMENT 'Human-readable ID e.g. TT-ORD-2026-001',
  `customer_id` INT UNSIGNED NULL,
  `subtotal` DECIMAL(10, 2) NOT NULL,
  `shipping_fee` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `discount_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `total_amount` DECIMAL(10, 2) NOT NULL,
  `status` ENUM('pending', 'confirmed', 'packed', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  `payment_status` ENUM('unpaid', 'paid', 'cod', 'refunded') NOT NULL DEFAULT 'unpaid',
  `payment_method` ENUM('UPI', 'GPay', 'PhonePe', 'COD', 'Bank Transfer') NOT NULL DEFAULT 'UPI',
  `shipping_address` TEXT NOT NULL,
  `whatsapp_chat_ref` VARCHAR(100) NULL COMMENT 'Ref code or phone number from WhatsApp thread',
  `tracking_number` VARCHAR(100) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT `fk_orders_customer`
    FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,

  INDEX `idx_orders_status` (`status`),
  INDEX `idx_orders_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 7. Order Items Table
-- ------------------------------------------------------------------------------
CREATE TABLE `order_items` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `unit_price` DECIMAL(10, 2) NOT NULL COMMENT 'Snapshotted price at time of order',
  `quantity` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT `fk_order_items_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_items_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 8. WhatsApp Inquiries & Leads Table
-- ------------------------------------------------------------------------------
CREATE TABLE `whatsapp_inquiries` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NULL,
  `customer_name` VARCHAR(100) NULL,
  `customer_phone` VARCHAR(20) NOT NULL,
  `message` TEXT NULL,
  `status` ENUM('new', 'replied', 'converted', 'dropped') NOT NULL DEFAULT 'new',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT `fk_inquiries_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,

  INDEX `idx_inquiries_phone` (`customer_phone`),
  INDEX `idx_inquiries_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
