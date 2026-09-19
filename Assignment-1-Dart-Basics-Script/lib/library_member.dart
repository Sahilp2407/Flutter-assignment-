import 'catalog_item.dart';

/// Class representing a registered patron / member in the library system.
class LibraryMember {
  final String id;
  final String fullName;
  final List<CatalogItem> activeLoans = [];

  LibraryMember({required this.id, required this.fullName});

  /// Displays the list of current active loans held by this member.
  void listActiveLoans() {
    print('Borrower Record: $fullName [ID: $id]');
    if (activeLoans.isEmpty) {
      print('  • No active books or periodicals currently borrowed.');
      return;
    }

    for (final item in activeLoans) {
      print('  • [${item.id}] "${item.title}"');
    }
  }
}
