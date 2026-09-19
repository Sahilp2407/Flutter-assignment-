import 'catalog_item.dart';

/// Class representing a Book or Graphic Novel in the library.
class BookItem extends CatalogItem {
  final String author;
  final int pageCount;
  final String category;

  BookItem({
    required super.id,
    required super.title,
    required this.author,
    required this.pageCount,
    required this.category,
    super.isAvailable = true,
  });

  @override
  void displayInfo() {
    final availabilityStatus = isAvailable ? 'Available' : 'Issued';
    print(
      '[Book/Novel] #$id | "$title" by $author • $pageCount pages [$category] -> Status: $availabilityStatus',
    );
  }
}
