import puppeteer from 'puppeteer-core';
import fs from 'fs';
import path from 'path';

const EDGE_PATH = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const SCREENSHOT_DIR = 'C:\\Users\\keerthiv\\.gemini\\antigravity-ide\\brain\\0cacce78-644f-4eb2-8b9a-b4634a063211\\screenshots';

if (!fs.existsSync(SCREENSHOT_DIR)) {
  fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });
}

async function runTests() {
  console.log('Launching Edge for automated responsive testing...');
  const browser = await puppeteer.launch({
    executablePath: EDGE_PATH,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu'],
  });

  const page = await browser.newPage();
  const testResults = {
    mobileShop: {},
    mobileFilters: {},
    mobileProductAvailable: {},
    mobileProductSold: {},
    tablet: {},
    desktop: {},
    bugs: [],
  };

  try {
    // -------------------------------------------------------------
    // TEST 1: Mobile Shop (375x812)
    // -------------------------------------------------------------
    console.log('\n--- 1. Testing Mobile (375x812) Shop ---');
    await page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2 });
    await page.goto('http://localhost:4321/shop', { waitUntil: 'networkidle0' });

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '01_mobile_shop_375.png'), fullPage: false });
    console.log('Saved 01_mobile_shop_375.png');

    // Count initial items
    const initialCount = await page.$$eval('.product-card', (cards) => cards.filter(c => c.style.display !== 'none').length);
    console.log(`Initial visible cards on shop: ${initialCount}`);
    testResults.mobileShop.initialCount = initialCount;

    // Filter by category: Jackets
    console.log('Testing Category Filter: Jackets...');
    await page.select('#filter-category', 'Jackets');
    await new Promise(r => setTimeout(r, 200));

    const jacketCount = await page.$$eval('.product-card', (cards) => cards.filter(c => c.style.display !== 'none').length);
    const visibleCountText = await page.$eval('#visible-count', el => el.textContent);
    console.log(`After selecting Jackets: visible cards = ${jacketCount}, visible-count text = ${visibleCountText}`);
    testResults.mobileFilters.jacketCount = jacketCount;

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '02_mobile_shop_jackets_filter.png') });
    console.log('Saved 02_mobile_shop_jackets_filter.png');

    // Filter by availability: sold
    console.log('Testing Availability Filter: Sold Out Archives...');
    await page.select('#filter-category', 'all');
    await page.select('#filter-status', 'sold');
    await new Promise(r => setTimeout(r, 200));

    const soldCount = await page.$$eval('.product-card', (cards) => cards.filter(c => c.style.display !== 'none').length);
    console.log(`Sold out filtered cards: ${soldCount}`);
    testResults.mobileFilters.soldCount = soldCount;

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '03_mobile_shop_sold_filter.png') });
    console.log('Saved 03_mobile_shop_sold_filter.png');

    // Test Clear All Filters
    console.log('Testing Clear Filters Button...');
    await page.click('#clear-filters-btn');
    await new Promise(r => setTimeout(r, 200));
    const clearedCount = await page.$$eval('.product-card', (cards) => cards.filter(c => c.style.display !== 'none').length);
    console.log(`Cards after Clear Filters: ${clearedCount}`);
    testResults.mobileFilters.clearedCount = clearedCount;

    // Test Sorting: Price Low to High
    console.log('Testing Sort: Price Low to High...');
    await page.select('#sort-by', 'price-asc');
    await new Promise(r => setTimeout(r, 200));

    const firstCardPrice = await page.$$eval('.product-card', (cards) => {
      const first = cards.find(c => c.style.display !== 'none');
      return first ? Number(first.dataset.price) : null;
    });
    console.log(`First item price after sorting low-to-high: ₹${firstCardPrice}`);
    testResults.mobileFilters.firstSortedPrice = firstCardPrice;

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '04_mobile_shop_sorted_asc.png') });
    console.log('Saved 04_mobile_shop_sorted_asc.png');

    // -------------------------------------------------------------
    // TEST 2: Mobile Product Details - Available Item (375x812)
    // -------------------------------------------------------------
    console.log('\n--- 2. Testing Mobile (375x812) Product Details (Available Item) ---');
    await page.goto('http://localhost:4321/shop/carhartt-detroit-duck-canvas-jacket', { waitUntil: 'networkidle0' });

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '05_mobile_product_available_top.png') });
    console.log('Saved 05_mobile_product_available_top.png');

    // Check WhatsApp Order Button Link
    const orderBtnHref = await page.$eval('#whatsapp-order-btn', el => el.getAttribute('href'));
    console.log(`Primary WhatsApp Button Href:\n${orderBtnHref}`);
    testResults.mobileProductAvailable.orderBtnHref = orderBtnHref;

    // Test Gallery Interaction (Next Button)
    console.log('Testing Gallery Next Button...');
    const initialIndexText = await page.$eval('#gallery-current-idx', el => el.textContent);
    await page.click('#gallery-next');
    await new Promise(r => setTimeout(r, 300));
    const nextIndexText = await page.$eval('#gallery-current-idx', el => el.textContent);
    console.log(`Gallery index changed from ${initialIndexText} to ${nextIndexText}`);
    testResults.mobileProductAvailable.galleryNextWorked = (initialIndexText === '1' && nextIndexText === '2');

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '06_mobile_gallery_slide2.png') });
    console.log('Saved 06_mobile_gallery_slide2.png');

    // Scroll to verify Mobile Sticky Bottom Bar
    await page.evaluate(() => window.scrollBy(0, 500));
    await new Promise(r => setTimeout(r, 200));
    const isStickyVisible = await page.$eval('#mobile-sticky-order-bar', el => {
      const rect = el.getBoundingClientRect();
      return rect.height > 0 && rect.bottom <= window.innerHeight + 5;
    });
    console.log(`Is Mobile Sticky Order Bar pinned at bottom: ${isStickyVisible}`);
    testResults.mobileProductAvailable.isStickyVisible = isStickyVisible;

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '07_mobile_sticky_bar.png') });
    console.log('Saved 07_mobile_sticky_bar.png');

    // -------------------------------------------------------------
    // TEST 3: Mobile Product Details - Sold Out Item (375x812)
    // -------------------------------------------------------------
    console.log('\n--- 3. Testing Mobile (375x812) Product Details (Sold Out Item) ---');
    await page.goto('http://localhost:4321/shop/pink-floyd-1994-division-bell-tour-tee', { waitUntil: 'networkidle0' });

    const similarBtnHref = await page.$eval('#whatsapp-similar-btn', el => el.getAttribute('href'));
    console.log(`Sold Item Similar WhatsApp Button Href:\n${similarBtnHref}`);
    testResults.mobileProductSold.similarBtnHref = similarBtnHref;

    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '08_mobile_product_sold.png') });
    console.log('Saved 08_mobile_product_sold.png');

    // -------------------------------------------------------------
    // TEST 4: Tablet Testing (768x1024)
    // -------------------------------------------------------------
    console.log('\n--- 4. Testing Tablet (768x1024) ---');
    await page.setViewport({ width: 768, height: 1024, deviceScaleFactor: 1 });
    await page.goto('http://localhost:4321/shop', { waitUntil: 'networkidle0' });
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '09_tablet_shop.png') });
    console.log('Saved 09_tablet_shop.png');

    await page.goto('http://localhost:4321/shop/carhartt-detroit-duck-canvas-jacket', { waitUntil: 'networkidle0' });
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '10_tablet_product.png') });
    console.log('Saved 10_tablet_product.png');

    // -------------------------------------------------------------
    // TEST 5: Desktop Testing (1280x800)
    // -------------------------------------------------------------
    console.log('\n--- 5. Testing Desktop (1280x800) ---');
    await page.setViewport({ width: 1280, height: 800, deviceScaleFactor: 1 });
    await page.goto('http://localhost:4321/shop', { waitUntil: 'networkidle0' });
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '11_desktop_shop.png') });
    console.log('Saved 11_desktop_shop.png');

    await page.goto('http://localhost:4321/shop/carhartt-detroit-duck-canvas-jacket', { waitUntil: 'networkidle0' });
    await page.screenshot({ path: path.join(SCREENSHOT_DIR, '12_desktop_product.png') });
    console.log('Saved 12_desktop_product.png');

    // Write test report JSON
    fs.writeFileSync(
      path.join(SCREENSHOT_DIR, 'test_report.json'),
      JSON.stringify(testResults, null, 2)
    );
    console.log('\n✅ All automated browser tests and screenshots captured successfully!');
  } catch (err) {
    console.error('Error during testing:', err);
    testResults.bugs.push(String(err));
  } finally {
    await browser.close();
  }
}

runTests();
