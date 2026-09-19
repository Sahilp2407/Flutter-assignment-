import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_5/main.dart';
import 'package:assignment_5/screens/todo_screen.dart';

void main() {
  setUp(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize =
        const Size(1080, 1920);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });

  testWidgets('SplashScreen renders branding and navigates to TodoScreen on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pump();

    // Verify splash branding
    expect(find.text('TASKFLOW'), findsOneWidget);
    expect(find.text('ASSIGNMENT 5 • STATEFULWIDGET & SETSTATE'), findsOneWidget);

    // Tap anywhere on splash screen to navigate immediately
    await tester.tap(find.text('TASKFLOW'));
    await tester.pumpAndSettle();

    // Verify TodoScreen has loaded
    expect(find.text('Todo List'), findsOneWidget);
  });

  testWidgets('TodoApp loads initial UI elements and default items in dark theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    // Verify AppBar Title
    expect(find.text('Todo List'), findsOneWidget);

    // Verify Initial tasks
    expect(find.text('Review Flutter StatefulWidget concepts'), findsOneWidget);
    expect(find.text('Complete Assignment 5 requirements'), findsOneWidget);

    // Verify counter shows 1/3 Done
    expect(find.text('1/3 Done'), findsOneWidget);
  });

  testWidgets('Prevents adding empty todo and shows warning',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    final addButton = find.byKey(const Key('add_todo_button'));
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify warning snackbar message
    expect(find.text('Please enter a task title before adding!'), findsOneWidget);
    // Task count should still be 3
    expect(find.text('1/3 Done'), findsOneWidget);
  });

  testWidgets('Successfully adds a new todo, updates count, and clears input',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    final inputField = find.byKey(const Key('todo_input_field'));
    const String newTaskTitle = 'Practice setState rebuild lifecycle';

    await tester.enterText(inputField, newTaskTitle);
    expect(find.text(newTaskTitle), findsOneWidget);

    final addButton = find.byKey(const Key('add_todo_button'));
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify new task appears in the list
    expect(find.text(newTaskTitle), findsOneWidget);

    // Verify counter updated from 1/3 to 1/4 Done
    expect(find.text('1/4 Done'), findsOneWidget);

    // Verify TextField is cleared
    final TextField textFieldWidget = tester.widget(inputField);
    expect(textFieldWidget.controller?.text, isEmpty);
  });

  testWidgets('Toggles completion status using Checkbox and applies strikethrough',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    // Find the checkbox for item '2' (initially incomplete)
    final checkbox = find.byKey(const Key('checkbox_2'));
    expect(checkbox, findsOneWidget);

    // Initial counter: 1/3 Done
    expect(find.text('1/3 Done'), findsOneWidget);

    // Tap checkbox to toggle complete
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Counter should now be 2/3 Done
    expect(find.text('2/3 Done'), findsOneWidget);

    // Verify Text widget has lineThrough decoration
    final textFinder = find.text('Complete Assignment 5 requirements');
    final Text textWidget = tester.widget(textFinder);
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);

    // Tap again to uncomplete
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Counter returns to 1/3 Done
    expect(find.text('1/3 Done'), findsOneWidget);
    final Text textWidgetUncompleted = tester.widget(textFinder);
    expect(textWidgetUncompleted.style?.decoration, TextDecoration.none);
  });

  testWidgets('Deletes a todo using delete icon and shows Undo option',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    // Task 3 should exist
    expect(find.text('Test add, complete, and delete operations'), findsOneWidget);
    expect(find.text('1/3 Done'), findsOneWidget);

    final deleteButton = find.byKey(const Key('delete_3'));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Task 3 is removed
    expect(find.text('Test add, complete, and delete operations'), findsNothing);
    expect(find.text('1/2 Done'), findsOneWidget);

    // Verify SnackBar Undo button is present
    expect(find.text('UNDO'), findsOneWidget);

    // Tap UNDO to restore
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // Task 3 should be back
    expect(find.text('Test add, complete, and delete operations'), findsOneWidget);
    expect(find.text('1/3 Done'), findsOneWidget);
  });

  testWidgets('Displays empty state message when no todos exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp(home: TodoScreen()));
    await tester.pumpAndSettle();

    // Delete all 3 tasks
    await tester.tap(find.byKey(const Key('delete_1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('delete_2')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('delete_3')));
    await tester.pumpAndSettle();

    // Counter is 0/0 Done
    expect(find.text('0/0 Done'), findsOneWidget);

    // Empty state is displayed
    expect(find.text('All Caught Up!'), findsOneWidget);
  });
}
