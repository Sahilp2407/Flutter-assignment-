// ============================================================
// ASSIGNMENT CORE: Product Data Model
// ============================================================
// A Product class is used instead of raw Maps to get:
//   - Type safety (compiler catches typos)
//   - Auto-complete in the IDE
//   - Easy filtering/searching on strongly-typed fields
// ============================================================

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String image;
  final String description;
  final List<String> colors;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    required this.description,
    required this.colors,
    required this.reviewCount,
  });
}
