export interface SiteConfig {
  brandName: string;
  tagline: string;
  description: string;
  whatsappNumber: string; // digits only with country code (e.g. 916382803200)
  displayPhone: string;
  instagramUrl: string;
  email: string;
  location: string;
  siteUrl: string;
  currency: string;
  currencySymbol: string;
  announcementText: string;
}

export const siteConfig: SiteConfig = {
  brandName: "Thrift Tamilan",
  tagline: "Curated Vintage & Streetwear Drops in Tamil Nadu",
  description: "One-of-a-kind vintage, streetwear, and pre-loved apparel hand-picked and curated in Tamil Nadu, India. 1-of-1 pieces ordered directly via WhatsApp.",
  whatsappNumber: "916382803200", // E.164 formatted digits for wa.me links
  displayPhone: "+91 63828 03200",
  instagramUrl: "https://instagram.com/thrifttamilan",
  email: "orders@thrifttamilan.com",
  location: "Tamil Nadu, India",
  siteUrl: "https://thrifttamilan.com",
  currency: "INR",
  currencySymbol: "₹",
  announcementText: "⚡ DROP 04 IS LIVE • PAN-INDIA SHIPPING • 1-OF-1 PIECES ONLY ⚡",
};

export default siteConfig;
