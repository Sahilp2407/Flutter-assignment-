# Assignment Report: Null-Safe Asynchronous Data Fetcher in Dart

**Student Name:** Sahil Pandey  
**Course / Batch:** EM Batch - Dart & Flutter Development  
**Assignment:** Null Safety & Asynchronous Programming  
**Technology:** Dart SDK  

---

## 1. 📌 Objective & Overview

The objective of this assignment is to demonstrate a clear understanding of **Dart's Asynchronous Programming model** and **Sound Null Safety**. 

The project simulates an asynchronous backend/database call to search and retrieve student records by ID. It showcases how to:
- Simulate network latency without blocking the execution thread using `Future` and `async/await`.
- Handle non-existent records safely using Dart's nullable types (`String?`).
- Validate inputs and handle runtime exceptions using `try-catch` and `throw`.

---

## 2. 🔑 Key Concepts Implemented

### 2.1 Asynchronous Execution (`Future`, `async`, `await`)
- **`Future.delayed(const Duration(seconds: 1))`**: Simulates the delay of fetching data over a network or database.
- **`async` / `await`**: Allows writing non-blocking asynchronous code that reads sequentially and cleanly.

### 2.2 Sound Null Safety (`String?`)
- **Nullable Return Type (`Future<String?>`)**: Explicitly indicates that the function may return a valid `String` (student name) or `null` if no record exists.
- **Safe Null Checking**: The caller verifies `if (studentName != null)` before accessing the value, preventing runtime `NullPointer` exceptions.

### 2.3 Exception Handling (`throw` & `try-catch`)
- **Input Validation**: Throws `Exception('Invalid user ID')` if `userId <= 0`.
- **Graceful Error Recovery**: The `try-catch` block inside `showStudent()` intercepts errors so the application continues executing without crashing.

---

## 3. 💻 Source Code (`main.dart`)

```dart
// Function to simulate fetching student data asynchronously
Future<String?> getStudent(int userId) async {
  // Simulating 1 second network latency
  await Future.delayed(const Duration(seconds: 1));

  // Validation: IDs must be positive integers
  if (userId <= 0) {
    throw Exception('Invalid user ID');
  }

  // Matching student records
  switch (userId) {
    case 1:
      return 'Sahil Pandey';
    case 2:
      return 'Naman Sethi';
    case 3:
      return 'Ayush Aryan';
    default:
      return null; // Return null if student record is not found
  }
}

// Consumer function that handles output, null check, and exceptions
Future<void> showStudent(int userId) async {
  print('Searching for student with ID: $userId');

  try {
    final String? studentName = await getStudent(userId);

    if (studentName != null) {
      print('Student found: $studentName');
    } else {
      print('No student found with ID $userId');
    }
  } catch (e) {
    print('Something went wrong: $e');
  }

  print('-------------------------');
}

// Program Entry Point
Future<void> main() async {
  print('Student Data Fetcher');
  print('====================');

  await showStudent(1);   // Existing user (Sahil Pandey)
  await showStudent(3);   // Existing user (Ayush Aryan)
  await showStudent(5);   // Non-existent user (returns null)
  await showStudent(-1);  // Invalid user ID (throws exception)
}
```

---

## 4. 🧪 Test Cases & Results Matrix

| Test Case | Input (`userId`) | Expected Behavior | Actual Result | Status |
| :--- | :---: | :--- | :--- | :---: |
| **Case 1: Valid ID (1)** | `1` | Fetch student record after 1s delay | `Student found: Sahil Pandey` | ✅ PASS |
| **Case 2: Valid ID (3)** | `3` | Fetch student record after 1s delay | `Student found: Ayush Aryan` | ✅ PASS |
| **Case 3: Non-existent ID (5)** | `5` | Returns `null`, safely handled | `No student found with ID 5` | ✅ PASS |
| **Case 4: Invalid ID (-1)** | `-1` | Throws exception, caught by `try-catch` | `Something went wrong: Exception: Invalid user ID` | ✅ PASS |

---

## 5. 🖥️ Terminal Execution Output

Command used to run the program:
```bash
dart run main.dart
```

**Console Output:**
```text
Student Data Fetcher
====================
Searching for student with ID: 1
Student found: Sahil Pandey
-------------------------
Searching for student with ID: 3
Student found: Ayush Aryan
-------------------------
Searching for student with ID: 5
No student found with ID 5
-------------------------
Searching for student with ID: -1
Something went wrong: Exception: Invalid user ID
-------------------------
```

---

## 6. 📝 Conclusion & Key Learnings

1. **Futures in Dart:** Learned how `Future<T>` represents computation that will complete at a later time.
2. **Null Safety in Practice:** Understood how Dart's type system distinguishes between nullable (`Type?`) and non-nullable (`Type`) variables at compile time.
3. **Resilience:** Implemented defensive programming using input validation and `try-catch` to ensure high application stability.
