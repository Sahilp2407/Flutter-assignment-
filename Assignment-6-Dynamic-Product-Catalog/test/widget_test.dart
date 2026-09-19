import 'package:flutter_test/flutter_test.dart';
import 'package:luxe_mart/main.dart';
import 'package:luxe_mart/models/product.dart';
import 'package:luxe_mart/data/products.dart';

void main() {
  test('Product model fields and validation', () {
    const testProduct = Product(
      id: 999,
      name: 'Luxury Chrono Watch',
      category: 'Accessories',
      price: 49999.0,
      rating: 4.9,
      image: 'https://images.unsplash.com/photo-watch',
      description: 'Handcrafted luxury timepiece.',
      colors: ['Gold', 'Silver'],
      reviewCount: 340,
    );

    expect(testProduct.id, 999);
    expect(testProduct.name, 'Luxury Chrono Watch');
    expect(testProduct.category, 'Accessories');
    expect(testProduct.price, 49999.0);
    expect(testProduct.rating, 4.9);
    expect(testProduct.colors.length, 2);
  });

  test('Sample products data contains 12+ realistic items across categories', () {
    expect(sampleProducts.length, greaterThanOrEqualTo(12));

    final categories = sampleProducts.map((p) => p.category).toSet();
    expect(categories.contains('Electronics'), true);
    expect(categories.contains('Fashion'), true);
    expect(categories.contains('Shoes'), true);
    expect(categories.contains('Accessories'), true);
    expect(categories.contains('Beauty'), true);
  });

  test('Filtering logic: search and category filtering behavior', () {
    // 1. Filter by category
    final electronicProducts =
        sampleProducts.where((p) => p.category == 'Electronics').toList();
    expect(electronicProducts.isNotEmpty, true);
    for (final p in electronicProducts) {
      expect(p.category, 'Electronics');
    }

    // 2. Search by name (case-insensitive)
    const query = 'iphone';
    final searchResults = sampleProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    expect(searchResults.length, 1);
    expect(searchResults.first.name, contains('iPhone'));

    // 3. Combined category + search
    final combined = sampleProducts.where((p) {
      final matchesCategory = p.category == 'Electronics';
      final matchesQuery = p.name.toLowerCase().contains('pro');
      return matchesCategory && matchesQuery;
    }).toList();
    expect(combined.isNotEmpty, true);
    for (final p in combined) {
      expect(p.category, 'Electronics');
      expect(p.name.toLowerCase(), contains('pro'));
    }
  });

  testWidgets('App smoke test - verifies initial launch renders splash screen',
      (WidgetTester tester) async {
    // Build the LuxeMartApp
    await tester.pumpWidget(const LuxeMartApp());

    // Verify splash screen renders title and tagline
    expect(find.text('LUXE MART'), findsOneWidget);
    expect(find.text('Discover. Shop. Repeat.'), findsOneWidget);

    // Fast-forward animation & timer to complete splash cleanly
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
