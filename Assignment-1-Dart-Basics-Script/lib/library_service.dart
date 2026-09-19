import 'catalog_item.dart';
import 'library_member.dart';

/// Core service that manages the library's catalog, membership, and loan transactions.
class LibraryService {
  final String libraryName;
  final List<CatalogItem> catalog = [];
  final Map<String, LibraryMember> members = {};

  LibraryService(this.libraryName);

  /// Registers a new item (Book, Periodical, Comic) into the catalog inventory.
  void addItem(CatalogItem item) {
    catalog.add(item);
  }

  /// Enrolls a new patron into the library member database.
  void enrollMember(LibraryMember member) {
    members[member.id] = member;
  }

  /// Prints the full collection inventory of the library.
  void printCatalog() {
    print('\n======================================================');
    print('          $libraryName — CATALOG DIRECTORY            ');
    print('======================================================');
    if (catalog.isEmpty) {
      print('Notice: No items found in the repository.');
      return;
    }

    for (var index = 0; index < catalog.length; index++) {
      catalog[index].displayInfo();
    }
  }

  /// Issues a catalog item to an enrolled member if available.
  bool issueItem({required String itemId, required String memberId}) {
    final member = members[memberId];
    if (member == null) {
      print('[ERROR] Member record not found for ID "$memberId".');
      return false;
    }

    CatalogItem? targetItem;
    for (final item in catalog) {
      if (item.id.toLowerCase() == itemId.toLowerCase()) {
        targetItem = item;
        break;
      }
    }

    if (targetItem == null) {
      print('[ERROR] Catalog item with ID "$itemId" does not exist.');
      return false;
    }

    if (!targetItem.isAvailable) {
      print(
        '[NOTICE] "${targetItem.title}" is currently checked out by another patron.',
      );
      return false;
    }

    targetItem.isAvailable = false;
    member.activeLoans.add(targetItem);
    print('[SUCCESS] "${targetItem.title}" checked out to ${member.fullName}.');
    return true;
  }

  /// Processes the return of an item previously issued to a member.
  bool receiveReturn({required String itemId, required String memberId}) {
    final member = members[memberId];
    if (member == null) {
      print('[ERROR] Member record not found for ID "$memberId".');
      return false;
    }

    CatalogItem? targetLoan;
    for (final item in member.activeLoans) {
      if (item.id.toLowerCase() == itemId.toLowerCase()) {
        targetLoan = item;
        break;
      }
    }

    if (targetLoan == null) {
      print('[ERROR] ${member.fullName} has not borrowed item ID "$itemId".');
      return false;
    }

    targetLoan.isAvailable = true;
    member.activeLoans.remove(targetLoan);
    print(
      '[SUCCESS] "${targetLoan.title}" successfully checked back in from ${member.fullName}.',
    );
    return true;
  }

  /// Finds all catalog items whose title contains the given keyword.
  List<CatalogItem> findItemsByKeyword(String keyword) {
    final query = keyword.trim().toLowerCase();
    final results = <CatalogItem>[];

    for (final item in catalog) {
      if (item.title.toLowerCase().contains(query)) {
        results.add(item);
      }
    }

    return results;
  }
}
