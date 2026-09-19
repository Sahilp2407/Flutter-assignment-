// ============================================================
// ASSIGNMENT CORE: Sample Product Data (List<Product>)
// ============================================================
// All products are stored in a single List<Product>.
// The HomeScreen uses this list as the source of truth,
// then derives a 'filteredProducts' list via setState().
// ============================================================

import '../models/product.dart';

// 13 realistic sample products covering all categories with bundled high-res images
const List<Product> sampleProducts = [
  // ── Electronics ─────────────────────────────────────────
  Product(
    id: 1,
    name: 'iPhone 16 Pro Max',
    category: 'Electronics',
    price: 134900,
    rating: 4.9,
    image: 'assets/images/iphone.jpg',
    description:
        'The most powerful iPhone ever. Titanium design, A18 Pro chip, and a Pro camera system that shoots in 4K 120fps. All-day battery life with USB-C charging.',
    colors: ['Natural Titanium', 'Black Titanium', 'White Titanium'],
    reviewCount: 8420,
  ),
  Product(
    id: 2,
    name: 'Samsung Galaxy S25 Ultra',
    category: 'Electronics',
    price: 124999,
    rating: 4.8,
    image: 'assets/images/samsung.jpg',
    description:
        'Galaxy AI is here. The S25 Ultra features a built-in S Pen, 200MP camera, and the latest Snapdragon 8 Elite processor for a desktop-class experience.',
    colors: ['Titanium Black', 'Titanium Gray', 'Titanium Violet'],
    reviewCount: 6210,
  ),
  Product(
    id: 3,
    name: 'Sony WH-1000XM6',
    category: 'Electronics',
    price: 29990,
    rating: 4.7,
    image: 'assets/images/headphones.jpg',
    description:
        'Industry-leading noise cancelling headphones with 40-hour battery life, multipoint connection, and crystal-clear call quality with the V2 processor.',
    colors: ['Midnight Black', 'Platinum Silver'],
    reviewCount: 4810,
  ),
  Product(
    id: 4,
    name: 'MacBook Pro 14" M4',
    category: 'Electronics',
    price: 194900,
    rating: 4.9,
    image: 'assets/images/macbook.jpg',
    description:
        'Apple M4 Pro chip. Up to 24 GPU cores. Liquid Retina XDR display with ProMotion. Up to 22 hours of battery life. The world\'s best pro laptop.',
    colors: ['Space Black', 'Silver'],
    reviewCount: 3920,
  ),

  // ── Fashion ─────────────────────────────────────────────
  Product(
    id: 5,
    name: 'Oversized Linen Shirt',
    category: 'Fashion',
    price: 3499,
    rating: 4.5,
    image: 'assets/images/shirt.jpg',
    description:
        'Premium 100% linen oversized shirt. Breathable, stylish and perfect for any casual or smart-casual occasion. Available in S, M, L, XL.',
    colors: ['Beige', 'White', 'Sage Green', 'Dusty Blue'],
    reviewCount: 1230,
  ),
  Product(
    id: 6,
    name: 'Slim Fit Chino Pants',
    category: 'Fashion',
    price: 2799,
    rating: 4.4,
    image: 'assets/images/chinos.jpg',
    description:
        'Tailored slim-fit chinos made from stretch cotton blend. Wrinkle resistant and incredibly comfortable for all-day wear.',
    colors: ['Navy', 'Khaki', 'Olive', 'Black'],
    reviewCount: 890,
  ),

  // ── Shoes ───────────────────────────────────────────────
  Product(
    id: 7,
    name: 'Nike Air Max 270',
    category: 'Shoes',
    price: 12995,
    rating: 4.6,
    image: 'assets/images/nike.jpg',
    description:
        'The Nike Air Max 270 features Nike\'s biggest heel Air unit yet for an incredibly light, comfortable ride. Max Air cushioning and a snug fit.',
    colors: ['Black/White', 'Blue/Orange', 'Grey/Red'],
    reviewCount: 5670,
  ),
  Product(
    id: 8,
    name: 'Adidas Ultraboost 24',
    category: 'Shoes',
    price: 14999,
    rating: 4.7,
    image: 'assets/images/adidas.jpg',
    description:
        'Experience an energised run with Adidas Ultraboost 24. Lightstrike Pro midsole with BOOST technology returns energy with every stride.',
    colors: ['Core Black', 'Cloud White', 'Lucid Blue'],
    reviewCount: 3240,
  ),

  // ── Accessories ─────────────────────────────────────────
  Product(
    id: 9,
    name: 'Apple Watch Ultra 2',
    category: 'Accessories',
    price: 89900,
    rating: 4.8,
    image: 'assets/images/smartwatch.jpg',
    description:
        'Built for athletes and adventurers. Precision dual-frequency GPS, up to 60 hours of battery, and a rugged titanium case.',
    colors: ['Natural Titanium', 'Black Titanium'],
    reviewCount: 2890,
  ),
  Product(
    id: 10,
    name: 'Ray-Ban Aviator Classic',
    category: 'Accessories',
    price: 11499,
    rating: 4.6,
    image: 'assets/images/sunglasses.jpg',
    description:
        'The timeless Ray-Ban Aviator Classic. Crystal lenses offer superior clarity, comfort and 100% UV protection. An icon since 1937.',
    colors: ['Gold/G-15', 'Silver/Blue', 'Gold/Brown'],
    reviewCount: 4120,
  ),

  // ── Beauty ──────────────────────────────────────────────
  Product(
    id: 11,
    name: 'Charlotte Tilbury Pillow Talk',
    category: 'Beauty',
    price: 3200,
    rating: 4.9,
    image: 'assets/images/lipstick.jpg',
    description:
        'The world\'s most iconic nude-pink lipstick. Pillow Talk delivers a flattering, universally wearable hue in a creamy, moisturising formula.',
    colors: ['Original', 'Medium', 'Intense'],
    reviewCount: 9870,
  ),
  Product(
    id: 12,
    name: 'Dior Sauvage EDP',
    category: 'Beauty',
    price: 8500,
    rating: 4.8,
    image: 'assets/images/perfume.jpg',
    description:
        'An intense and fresh fragrance. Raw and noble materials: bergamot from Calabria, Sichuan pepper, lavender, vanilla from Madagascar.',
    colors: ['60ml', '100ml', '200ml'],
    reviewCount: 6450,
  ),
  Product(
    id: 13,
    name: 'Dyson Airwrap Complete',
    category: 'Beauty',
    price: 44900,
    rating: 4.7,
    image: 'assets/images/dyson.jpg',
    description:
        'Style, dry and curl with one tool. The Dyson Airwrap uses the Coanda effect to attract and wrap hair for multiple styles without extreme heat.',
    colors: ['Copper/Nickel', 'Prussian Blue/Copper', 'Nicopp'],
    reviewCount: 3780,
  ),
];
