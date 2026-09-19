/// Base abstract class representing any item in the library catalog.
abstract class CatalogItem {
  final String id;
  final String title;
  bool isAvailable;

  CatalogItem({required this.id, required this.title, this.isAvailable = true});

  /// Displays detailed information about the catalog item.
  void displayInfo();
}
