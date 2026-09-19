# Assignment: Null-Safe Async Fetcher in Dart

**Author:** Sahil Pandey  
**Course:** EM Batch - Dart & Flutter Development  
**Topic:** Asynchronous Programming, Sound Null Safety, and Exception Handling  

---

## 📌 Executive Summary

This project implements a lightweight and null-safe asynchronous data fetcher in Dart (`main.dart`). It simulates real-world asynchronous communication using `Future`, `async`, and `await`, while properly handling non-blocking delays, missing records (`null`), and runtime exceptions (`try-catch`).

---

## 🚀 Key Features

1. **Asynchronous Operations (`Future`, `async`, `await`)**:
   - Simulates network latency using `Future.delayed(const Duration(seconds: 1))`.
   - Executes non-blocking calls on the main thread.

2. **Sound Null Safety (`String?`, Null Checks)**:
   - Uses nullable return type `Future<String?>` to represent data that may or may not exist.
   - Handles missing records safely using `if (studentName != null)`.

3. **Exception Handling (`throw` & `try-catch`)**:
   - Validates input values (e.g., `userId <= 0`) and raises an `Exception`.
   - Intercepts errors gracefully in the consumer function without crashing the program.

---

## 📁 Project Structure

```text
null_async_assigment/
├── main.dart                      # Main Dart source code
├── README.md                      # Project documentation and summary
└── ASSIGNMENT_DOCUMENTATION.md    # Detailed submission report with test cases
```

---

## 💻 Source Code (`main.dart`)

```dart
Future<String?> getStudent(int userId) async {
  await Future.delayed(const Duration(seconds: 1));

  if (userId <= 0) {
    throw Exception('Invalid user ID');
  }

  switch (userId) {
    case 1:
      return 'Sahil Pandey';
    case 2:
      return 'Naman Sethi';
    case 3:
      return 'Ayush Aryan';
    default:
      return null;
  }
}

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

Future<void> main() async {
  print('Student Data Fetcher');
  print('====================');

  await showStudent(1);
  await showStudent(3);
  await showStudent(5);
  await showStudent(-1);
}
```

---

## 🧪 Test Cases & Verification Matrix

| Test Case | Input (`userId`) | Expected Output | Status |
| :--- | :---: | :--- | :---: |
| **Case 1: Valid Student (1)** | `1` | `Student found: Sahil Pandey` | ✅ PASS |
| **Case 2: Valid Student (3)** | `3` | `Student found: Ayush Aryan` | ✅ PASS |
| **Case 3: Non-Existent Student (5)** | `5` | `No student found with ID 5` | ✅ PASS |
| **Case 4: Invalid ID (-1)** | `-1` | `Something went wrong: Exception: Invalid user ID` | ✅ PASS |

---

## 🖥️ Terminal Execution Output

```bash
dart run main.dart
```

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
