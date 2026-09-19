import 'catalog_item.dart';

/// Class representing periodicals, comics issues, or magazines.
class PeriodicalItem extends CatalogItem {
  final int issueNo;
  final String publicationDate;

  PeriodicalItem({
    required super.id,
    required super.title,
    required this.issueNo,
    required this.publicationDate,
    super.isAvailable = true,
  });

  @override
  void displayInfo() {
    final availabilityStatus = isAvailable ? 'Available' : 'Issued';
    print(
      '[Periodical/Comic] #$id | "$title" (Vol./Issue #$issueNo, $publicationDate) -> Status: $availabilityStatus',
    );
  }
}
