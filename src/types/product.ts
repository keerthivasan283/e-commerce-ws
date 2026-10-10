export type ProductCategory = 
  | 'T-Shirts' 
  | 'Shirts' 
  | 'Jackets' 
  | 'Jeans' 
  | 'Hoodies' 
  | 'Trousers';

export type ProductCondition = 'Like New' | 'Good' | 'Fair';

export type ProductStatus = 'available' | 'sold';

export type ProductSize = 'XS' | 'S' | 'M' | 'L' | 'XL' | 'XXL' | '28' | '30' | '32' | '34' | '36';

export interface Product {
  code: string;
  slug: string;
  name: string;
  price: number;
  size: ProductSize;
  condition: ProductCondition;
  category: ProductCategory;
  status: ProductStatus;
  images: string[];
  description: string;
  dateAdded: string; // YYYY-MM-DD
  bestSeller: boolean;
  featured: boolean;
  offerPrice?: number;
  measurements?: {
    chestOrWaist?: string;
    length?: string;
    shoulder?: string;
  };
}
