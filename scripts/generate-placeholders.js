import fs from 'fs';
import path from 'path';

const outDir = path.resolve('public/products');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

const items = [
  // TT001 Carhartt Jacket
  { file: 'tt001-front.svg', code: 'TT001', title: 'Carhartt Duck Jacket', view: 'FRONT VIEW', color: '#8C5835', type: 'JACKET' },
  { file: 'tt001-back.svg', code: 'TT001', title: 'Carhartt Duck Jacket', view: 'BACK VIEW', color: '#8C5835', type: 'JACKET' },
  { file: 'tt001-detail.svg', code: 'TT001', title: 'Carhartt Duck Jacket', view: 'COLLAR & LINING DETAIL', color: '#8C5835', type: 'DETAIL' },

  // TT002 Nike ACG Fleece
  { file: 'tt002-front.svg', code: 'TT002', title: 'Nike ACG Trail Fleece', view: 'FRONT VIEW', color: '#1E3A5F', type: 'HOODIE' },
  { file: 'tt002-back.svg', code: 'TT002', title: 'Nike ACG Trail Fleece', view: 'BACK VIEW', color: '#1E3A5F', type: 'HOODIE' },

  // TT003 Pink Floyd Tee
  { file: 'tt003-front.svg', code: 'TT003', title: 'Pink Floyd Division Bell Tee', view: 'FRONT GRAPHIC', color: '#2C2B29', type: 'TEE' },
  { file: 'tt003-back.svg', code: 'TT003', title: 'Pink Floyd Division Bell Tee', view: 'TOUR DATES BACK', color: '#2C2B29', type: 'TEE' },

  // TT004 Levi's 501
  { file: 'tt004-front.svg', code: 'TT004', title: "Levi's 501 Raw Denim", view: 'FULL FRONT', color: '#1B263B', type: 'JEANS' },
  { file: 'tt004-back.svg', code: 'TT004', title: "Levi's 501 Raw Denim", view: 'POCKETS & RED TAB', color: '#1B263B', type: 'JEANS' },
  { file: 'tt004-detail.svg', code: 'TT004', title: "Levi's 501 Raw Denim", view: 'SELVEDGE ID CUFF', color: '#1B263B', type: 'DETAIL' },

  // TT005 Ralph Lauren Oxford
  { file: 'tt005-front.svg', code: 'TT005', title: 'Ralph Lauren Oxford Shirt', view: 'FRONT VIEW', color: '#4A7C9A', type: 'SHIRT' },
  { file: 'tt005-detail.svg', code: 'TT005', title: 'Ralph Lauren Oxford Shirt', view: 'PONY EMBROIDERY DETAIL', color: '#4A7C9A', type: 'DETAIL' },

  // TT006 Dickies 874
  { file: 'tt006-front.svg', code: 'TT006', title: 'Dickies 874 Skate Pants', view: 'FRONT VIEW', color: '#33373B', type: 'PANTS' },
  { file: 'tt006-back.svg', code: 'TT006', title: 'Dickies 874 Skate Pants', view: 'BACK VIEW', color: '#33373B', type: 'PANTS' },

  // TT007 Stussy Tee
  { file: 'tt007-front.svg', code: 'TT007', title: 'Stüssy Crown Graphic Tee', view: 'FRONT CHEST PRINT', color: '#1E1E1E', type: 'TEE' },
  { file: 'tt007-back.svg', code: 'TT007', title: 'Stüssy Crown Graphic Tee', view: 'BACK CROWN LOGO', color: '#1E1E1E', type: 'TEE' },

  // TT008 Starter Bomber
  { file: 'tt008-front.svg', code: 'TT008', title: 'Starter Bulls Bomber', view: 'FRONT SATIN SNAP', color: '#8B1E1E', type: 'JACKET' },
  { file: 'tt008-back.svg', code: 'TT008', title: 'Starter Bulls Bomber', view: 'EMBROIDERED BACK', color: '#8B1E1E', type: 'JACKET' },

  // TT009 Champion Hoodie
  { file: 'tt009-front.svg', code: 'TT009', title: 'Champion Reverse Weave', view: 'FRONT VIEW', color: '#5C636A', type: 'HOODIE' },
  { file: 'tt009-back.svg', code: 'TT009', title: 'Champion Reverse Weave', view: 'HOOD PROFILE', color: '#5C636A', type: 'HOODIE' },

  // TT010 Woolrich Flannel
  { file: 'tt010-front.svg', code: 'TT010', title: 'Woolrich Shadow Flannel', view: 'FRONT VIEW', color: '#7E3F27', type: 'SHIRT' },
  { file: 'tt010-detail.svg', code: 'TT010', title: 'Woolrich Shadow Flannel', view: 'BRUSHED PLAID TEXTURE', color: '#7E3F27', type: 'DETAIL' },
];

for (const item of items) {
  const safeView = item.view.replace(/&/g, '&amp;');
  const safeTitle = item.title.toUpperCase().replace(/&/g, '&amp;');

  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 1000" width="800" height="1000">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#141414" />
      <stop offset="100%" stop-color="#0A0A0A" />
    </linearGradient>
    <linearGradient id="garmentGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="${item.color}" />
      <stop offset="100%" stop-color="${item.color}CC" />
    </linearGradient>
  </defs>

  <!-- Editorial Dark Studio Background -->
  <rect width="800" height="1000" fill="url(#bgGrad)" />

  <!-- Frame Grid Accent Lines -->
  <rect x="24" y="24" width="752" height="952" fill="none" stroke="#262626" stroke-width="1.5" />
  <circle cx="24" cy="24" r="4" fill="#B5532F" />
  <circle cx="776" cy="24" r="4" fill="#B5532F" />
  <circle cx="24" cy="976" r="4" fill="#B5532F" />
  <circle cx="776" cy="976" r="4" fill="#B5532F" />

  <!-- Top Metadata Bar -->
  <text x="48" y="60" font-family="'Courier New', monospace" font-size="14" fill="#8E8B85" letter-spacing="2">ARCHIVE ITEM // ${item.code}</text>
  <text x="752" y="60" font-family="'Courier New', monospace" font-size="14" fill="#B5532F" letter-spacing="2" text-anchor="end">1-OF-1 CURATED</text>

  <!-- Garment Graphic Representation -->
  <g transform="translate(100, 140)">
    <!-- Silhouette Silhouette Base -->
    <rect x="50" y="50" width="500" height="580" rx="16" fill="url(#garmentGrad)" stroke="#3A3A3A" stroke-width="2" />
    
    <!-- Stylized streetwear garment motif -->
    <path d="M 120 50 Q 300 120 480 50 L 530 200 L 450 220 L 450 610 L 150 610 L 150 220 L 70 200 Z" fill="${item.color}" opacity="0.9" stroke="#1F1F1F" stroke-width="3" />
    
    <!-- Inner graphic / badge -->
    <circle cx="300" cy="280" r="70" fill="#0A0A0A" opacity="0.4" />
    <text x="300" y="286" font-family="'Arial Black', sans-serif" font-weight="900" font-size="28" fill="#F5F3EE" text-anchor="middle" letter-spacing="1">THRIFT</text>
    <text x="300" y="310" font-family="'Courier New', monospace" font-size="12" fill="#B5532F" text-anchor="middle" letter-spacing="3">AUTHENTIC</text>
  </g>

  <!-- Bottom Editorial Typography -->
  <rect x="48" y="800" width="704" height="1" fill="#262626" />
  <text x="48" y="845" font-family="'Arial Black', 'Impact', sans-serif" font-size="34" font-weight="900" fill="#F5F3EE" letter-spacing="1">${safeTitle}</text>
  <text x="48" y="880" font-family="'Courier New', monospace" font-size="16" fill="#B5532F" letter-spacing="2">${safeView}</text>
  <text x="752" y="880" font-family="'Courier New', monospace" font-size="14" fill="#8E8B85" letter-spacing="1" text-anchor="end">THRIFT TAMILAN ARCHIVE</text>

  <!-- Barcode element -->
  <g transform="translate(48, 915)">
    <rect x="0" y="0" width="4" height="24" fill="#8E8B85" />
    <rect x="8" y="0" width="2" height="24" fill="#8E8B85" />
    <rect x="14" y="0" width="6" height="24" fill="#8E8B85" />
    <rect x="24" y="0" width="3" height="24" fill="#8E8B85" />
    <rect x="32" y="0" width="5" height="24" fill="#8E8B85" />
    <rect x="42" y="0" width="2" height="24" fill="#8E8B85" />
    <rect x="48" y="0" width="7" height="24" fill="#8E8B85" />
    <rect x="60" y="0" width="3" height="24" fill="#8E8B85" />
    <text x="75" y="18" font-family="'Courier New', monospace" font-size="12" fill="#8E8B85">${item.code}-VERIFIED</text>
  </g>
</svg>`;

  fs.writeFileSync(path.join(outDir, item.file), svg, 'utf-8');
}

console.log(`Generated ${items.length} placeholder SVGs in public/products/`);
