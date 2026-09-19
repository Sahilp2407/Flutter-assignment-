import 'catalog_item.dart';
import 'book_item.dart';
import 'periodical_item.dart';
import 'library_member.dart';
import 'library_service.dart';
import 'fine_calculator.dart';

void runLibraryApp() {
  // Initialize the Marvel-themed library system
  final marvelArchive = LibraryService('Marvel Universe Archives & Library');

  // Populate Marvel graphic novels and comic books
  marvelArchive.addItem(
    BookItem(
      id: 'MV-BK101',
      title: 'The Infinity Gauntlet',
      author: 'Jim Starlin',
      pageCount: 256,
      category: 'Marvel Cosmic',
    ),
  );

  marvelArchive.addItem(
    BookItem(
      id: 'MV-BK102',
      title: 'Civil War',
      author: 'Mark Millar',
      pageCount: 208,
      category: 'Marvel Events',
    ),
  );

  marvelArchive.addItem(
    BookItem(
      id: 'MV-BK103',
      title: 'Spider-Man: Kraven\'s Last Hunt',
      author: 'J.M. DeMatteis',
      pageCount: 168,
      category: 'Marvel Classics',
    ),
  );

  marvelArchive.addItem(
    PeriodicalItem(
      id: 'MV-MG201',
      title: 'Marvel Comics Magazine #1',
      issueNo: 1,
      publicationDate: 'Collector Special 2026',
    ),
  );

  // Register library patrons / members
  final memberPeter = LibraryMember(id: 'HERO-001', fullName: 'Peter Parker');
  final memberTony = LibraryMember(id: 'HERO-002', fullName: 'Tony Stark');

  marvelArchive.enrollMember(memberPeter);
  marvelArchive.enrollMember(memberTony);

  // Display initial inventory
  marvelArchive.printCatalog();

  // Process checkout transactions
  print('\n>>> INITIATING ITEM CHECKOUTS <<<');
  marvelArchive.issueItem(itemId: 'MV-BK101', memberId: 'HERO-001');
  marvelArchive.issueItem(itemId: 'MV-MG201', memberId: 'HERO-002');
  // Attempt to checkout an already issued item
  marvelArchive.issueItem(itemId: 'MV-BK101', memberId: 'HERO-002');

  // Display member loan summaries
  print('\n>>> ACTIVE MEMBER LOANS DIRECTORY <<<');
  memberPeter.listActiveLoans();
  memberTony.listActiveLoans();

  // Search catalog for specific Marvel titles
  print('\n>>> SEARCHING CATALOG FOR "Spider-Man" <<<');
  List<CatalogItem> searchResults = marvelArchive.findItemsByKeyword(
    'Spider-Man',
  );
  for (final result in searchResults) {
    result.displayInfo();
  }

  // Process return and compute overdue fine
  print('\n>>> RETURN TRANSACTION & OVERDUE FINE EVALUATION <<<');
  marvelArchive.receiveReturn(itemId: 'MV-BK101', memberId: 'HERO-001');

  const daysDelayed = 4;
  final totalPenalty = computeFine(overdueDays: daysDelayed, dailyRate: 3.50);
  print(
    'Overdue penalty for $daysDelayed day(s) late return: \$${totalPenalty.toStringAsFixed(2)}',
  );

  // Display updated catalog inventory
  marvelArchive.printCatalog();
}
