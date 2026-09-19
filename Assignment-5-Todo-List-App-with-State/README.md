# TaskFlow - Flutter Todo List Application (Assignment 5)

[![Flutter](https://img.shields.io/badge/Flutter-3.44.8-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2.svg?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/State%20Management-StatefulWidget%20%26%20setState-gold.svg)](https://flutter.dev/docs/development/ui/interactive)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A clean, modern, and executive Todo List application developed for **Assignment 5**. The project emphasizes native state management principles in Flutter, strictly utilizing `StatefulWidget` and `setState()` without any external state packages.

---

## 📱 App Previews

<div align="center">

| **Animated Splash Screen** | **Executive Dark Todo UI** |
|:---:|:---:|
| <img src="assets/screenshots/splash_screen.png" width="320" alt="TaskFlow Splash Screen" /> | <img src="assets/screenshots/dark_todo_screen.png" width="320" alt="TaskFlow Dark Todo Screen" /> |

</div>

---

## ✨ Features

- **Animated Luxury Splash Screen**: Smooth entrance animations (`FadeTransition` & `ScaleTransition`) with glowing gold branding and tap-to-skip functionality.
- **Executive Dark Theme**: Obsidian canvas (`#0B0E14`), elevated card surfaces (`#151A22`), and radiant gold accents (`#D4AF37`).
- **Progress Overview Card**: Dynamic counter displaying `completed/total` tasks with a glowing linear progress bar and status pills.
- **Add New Tasks**: Input field with validation against empty/whitespace-only input and auto-clearing behavior.
- **Mark Complete / Incomplete**: Custom gold checkbox that updates task state and applies elegant strikethrough styling with muted typography.
- **Delete Tasks with Undo**: Intuitive trash button and swipe-to-delete with a SnackBar offering an immediate "UNDO" option.
- **Segmented Filter Tabs**: Filter by "All", "Active", or "Completed" tasks.
- **Empty State**: Custom luxury halo illustration when no tasks are present.
- **Responsive Layout**: Constrained center layout (`maxWidth: 680`) ensuring crisp appearance across mobile, tablet, and desktop/web screens.

---

## 🛠️ State Management Architecture

This project strictly avoids external state libraries (no Provider, Riverpod, Bloc, GetX, or Firebase) to demonstrate native Flutter state principles.

| Operation | Implementation | Description |
|---|---|---|
| **Add Task** | `_addTodo()` | Validates text, inserts `Todo` into `_todos` using `setState()`, and clears the controller. |
| **Toggle Complete** | `_toggleTodoCompletion()` | Toggles `todo.isCompleted` flag inside `setState()`, updating strikethrough & progress stats. |
| **Delete Task** | `_deleteTodo()` | Removes `Todo` by index inside `setState()` and triggers a SnackBar with `setState()` undo. |

---

## 📁 Project Structure

```
lib/
├── main.dart               # App entry point & Material 3 Dark theme setup
├── models/
│   └── todo.dart           # Todo data model (id, title, isCompleted, createdAt)
└── screens/
    ├── splash_screen.dart  # Animated entrance splash screen
    └── todo_screen.dart    # Main Todo screen with pure setState() logic
assets/
└── screenshots/            # App preview screenshots
test/
└── widget_test.dart        # 7 automated tests covering all assignment requirements
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.44+ recommended)
- Dart SDK 3.12+

### Run the App

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sahilp2407/Assignment-5-Todo-List-App-with-State.git
   cd Assignment-5-Todo-List-App-with-State
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Web):**
   ```bash
   flutter run -d chrome
   ```

4. **Run on macOS Desktop:**
   ```bash
   flutter run -d macos
   ```

5. **Run automated tests:**
   ```bash
   flutter test
   ```

---

## 👨‍💻 Author
- **Sahil Pandey** - [GitHub Profile](https://github.com/Sahilp2407)
