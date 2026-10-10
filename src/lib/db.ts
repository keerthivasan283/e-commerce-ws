import path from 'node:path';
import fs from 'node:fs';
import { createRequire } from 'node:module';
import type { Product, ProductCategory, ProductSize, ProductCondition, ProductStatus } from '../types/product';

const require = createRequire(import.meta.url);

// Fallback loader
function getFallbackProducts(): Product[] {
  try {
    const jsonPath = path.resolve(process.cwd(), 'src', 'data', 'products.json');
    if (fs.existsSync(jsonPath)) {
      return JSON.parse(fs.readFileSync(jsonPath, 'utf8')) as Product[];
    }
  } catch (err) {
    console.error('[DB] Error loading fallback JSON:', err);
  }
  return [];
}

// Path to the SQLite database
const DB_PATH = path.resolve(process.cwd(), 'database', 'thrift_tamilan.sqlite');

/**
 * Loads products from the SQLite database.
 * Falls back safely to products.json if the SQL database is unavailable.
 */
export function getProductsFromSQL(): Product[] {
  try {
    if (!fs.existsSync(DB_PATH)) {
      console.warn(`[DB] Database file not found at ${DB_PATH}. Falling back to static JSON.`);
      return getFallbackProducts();
    }

    // Use Node.js built-in SQLite engine (available in Node 22+)
    const { DatabaseSync } = require('node:sqlite');
    const db = new DatabaseSync(DB_PATH, { open: true });

    // 1. Fetch images mapped by product ID
    const imageRows = db.prepare(
      'SELECT product_id, image_url FROM product_images ORDER BY display_order ASC'
    ).all() as Array<{ product_id: number; image_url: string }>;

    const imagesByProductId = new Map<number, string[]>();
    for (const row of imageRows) {
      const existing = imagesByProductId.get(row.product_id) || [];
      existing.push(row.image_url);
      imagesByProductId.set(row.product_id, existing);
    }

    // 2. Query products with joined categories and measurements
    const query = `
      SELECT 
        p.id,
        p.code,
        p.slug,
        p.name,
        c.name AS category,
        p.price,
        p.offer_price AS offerPrice,
        p.size,
        p.condition_grade AS condition,
        p.status,
        p.description,
        p.date_added AS dateAdded,
        p.is_bestseller AS bestSeller,
        p.is_featured AS featured,
        m.chest_or_waist AS chestOrWaist,
        m.length AS length,
        m.shoulder AS shoulder
      FROM products p
      JOIN categories c ON p.category_id = c.id
      LEFT JOIN product_measurements m ON p.id = m.product_id
      ORDER BY p.date_added DESC, p.id ASC
    `;

    const productRows = db.prepare(query).all() as Array<{
      id: number;
      code: string;
      slug: string;
      name: string;
      category: string;
      price: number;
      offerPrice: number | null;
      size: string;
      condition: string;
      status: string;
      description: string;
      dateAdded: string;
      bestSeller: number;
      featured: number;
      chestOrWaist: string | null;
      length: string | null;
      shoulder: string | null;
    }>;

    // 3. Map into strongly-typed Product objects
    const products: Product[] = productRows.map((row) => {
      const productImages = imagesByProductId.get(row.id) || [];

      const measurements: { chestOrWaist?: string; length?: string; shoulder?: string } = {};
      if (row.chestOrWaist) measurements.chestOrWaist = row.chestOrWaist;
      if (row.length) measurements.length = row.length;
      if (row.shoulder) measurements.shoulder = row.shoulder;

      return {
        code: row.code,
        slug: row.slug,
        name: row.name,
        price: Number(row.price),
        offerPrice: row.offerPrice !== null ? Number(row.offerPrice) : undefined,
        size: row.size as ProductSize,
        condition: row.condition as ProductCondition,
        category: row.category as ProductCategory,
        status: row.status as ProductStatus,
        images: productImages.length > 0 ? productImages : ['/products/placeholder.svg'],
        description: row.description,
        dateAdded: row.dateAdded,
        bestSeller: Boolean(row.bestSeller),
        featured: Boolean(row.featured),
        measurements: Object.keys(measurements).length > 0 ? measurements : undefined,
      };
    });

    db.close();
    return products;
  } catch (error) {
    console.error('[DB] Failed to query SQL database, using fallback JSON:', error);
    return getFallbackProducts();
  }
}

/**
 * Returns all products.
 */
export function getAllProducts(): Product[] {
  return getProductsFromSQL();
}

/**
 * Returns a product by slug.
 */
export function getProductBySlug(slug: string): Product | undefined {
  const products = getAllProducts();
  return products.find((p) => p.slug === slug);
}

/**
 * Returns a product by code (e.g. 'TT001').
 */
export function getProductByCode(code: string): Product | undefined {
  const products = getAllProducts();
  return products.find((p) => p.code === code);
}
