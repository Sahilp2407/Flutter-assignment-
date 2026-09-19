# Marvel Universe Archives & Library Management System

A modular, console-based Library Catalog Management System implemented in **Dart (v3.x)** demonstrating Object-Oriented Programming (OOP) principles, sound null safety, and clean code architecture.

## 🚀 Features

- **Object-Oriented Design**: Abstract base class (`CatalogItem`) extended by concrete models (`BookItem`, `PeriodicalItem`).
- **Catalog Management**: Dynamic item registration, keyword search, and availability tracking.
- **Member Management**: Patron registration and real-time active loan portfolio management.
- **Transaction Engine**: Safe checkout validation (preventing double-loans) and authentic return processing.
- **Fine Calculation Utility**: Overdue penalty calculation with configurable daily rates.

## 📁 Project Structure

```
.
├── lib/
│   ├── app_runner.dart       # End-to-end simulation runner
│   ├── book_item.dart        # Book/Graphic novel model
│   ├── catalog_item.dart     # Abstract base item model
│   ├── fine_calculator.dart  # Overdue fine calculation utility
│   ├── library_member.dart   # Member profile & loan tracking
│   ├── library_service.dart  # Core business logic service
│   ├── main.dart             # Application entry point
│   └── periodical_item.dart  # Periodical / Comic model
├── DOCUMENTATION.docx        # Technical documentation report
└── README.md
```

## 🛠️ How to Run

Ensure you have Dart SDK installed, then run:

```bash
dart run lib/main.dart
```

## 📊 Sample Output

```text
======================================================
          Marvel Universe Archives & Library — CATALOG DIRECTORY            
======================================================
[Book/Novel] #MV-BK101 | "The Infinity Gauntlet" by Jim Starlin • 256 pages [Marvel Cosmic] -> Status: Available
[Book/Novel] #MV-BK102 | "Civil War" by Mark Millar • 208 pages [Marvel Events] -> Status: Available
[Book/Novel] #MV-BK103 | "Spider-Man: Kraven's Last Hunt" by J.M. DeMatteis • 168 pages [Marvel Classics] -> Status: Available
[Periodical/Comic] #MV-MG201 | "Marvel Comics Magazine #1" (Vol./Issue #1, Collector Special 2026) -> Status: Available

>>> INITIATING ITEM CHECKOUTS <<<
[SUCCESS] "The Infinity Gauntlet" checked out to Peter Parker.
[SUCCESS] "Marvel Comics Magazine #1" checked out to Tony Stark.
[NOTICE] "The Infinity Gauntlet" is currently checked out by another patron.

>>> ACTIVE MEMBER LOANS DIRECTORY <<<
Borrower Record: Peter Parker [ID: HERO-001]
  • [MV-BK101] "The Infinity Gauntlet"
Borrower Record: Tony Stark [ID: HERO-002]
  • [MV-MG201] "Marvel Comics Magazine #1"

>>> SEARCHING CATALOG FOR "Spider-Man" <<<
[Book/Novel] #MV-BK103 | "Spider-Man: Kraven's Last Hunt" by J.M. DeMatteis • 168 pages [Marvel Classics] -> Status: Available

>>> RETURN TRANSACTION & OVERDUE FINE EVALUATION <<<
[SUCCESS] "The Infinity Gauntlet" successfully checked back in from Peter Parker.
Overdue penalty for 4 day(s) late return: $14.00
```

---
**Author:** Sahil Pandey
