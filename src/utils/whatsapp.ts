import siteConfig from '../config/site';
import type { Product } from '../types/product';

/**
 * Generate standard WhatsApp ordering link for an available product
 * Message: "Hi Thrift Tamilan, I'm interested in Product {code} – {name} priced at ₹{price}. Is this product available?"
 */
export function getOrderWhatsAppUrl(product: Product): string {
  const activePrice = product.offerPrice ?? product.price;
  const message = `Hi ${siteConfig.brandName}, I'm interested in Product ${product.code} – ${product.name} priced at ₹${activePrice}. Is this product available?`;
  return `https://wa.me/${siteConfig.whatsappNumber}?text=${encodeURIComponent(message)}`;
}

/**
 * Generate inquiry WhatsApp link for a sold out product
 * Message: "Hi Thrift Tamilan, I saw that Product {code} – {name} is sold out. Do you have any similar pieces in size {size}?"
 */
export function getSimilarPiecesWhatsAppUrl(product: Product): string {
  const message = `Hi ${siteConfig.brandName}, I saw that Product ${product.code} – ${product.name} is sold out. Do you have any similar pieces in size ${product.size}?`;
  return `https://wa.me/${siteConfig.whatsappNumber}?text=${encodeURIComponent(message)}`;
}

/**
 * Generate general WhatsApp inquiry link (used in Header, Floating badge, Footer, Contact)
 */
export function getGeneralWhatsAppUrl(customMessage?: string): string {
  const message = customMessage || `Hi ${siteConfig.brandName}, I'd like to ask a question about your thrift drops!`;
  return `https://wa.me/${siteConfig.whatsappNumber}?text=${encodeURIComponent(message)}`;
}
