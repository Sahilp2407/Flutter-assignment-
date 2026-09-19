import 'package:flutter/material.dart';
import '../models/todo.dart';

/// Filter options for viewing todos
enum TodoFilter { all, active, completed }

/// [TodoScreen] is a [StatefulWidget] that manages the state of the Todo list.
///
/// In Flutter, a StatefulWidget maintains mutable state over its lifecycle.
/// When user interactions occur (adding, toggling, or deleting a task),
/// we call [setState] to schedule a rebuild of the widget tree with the new state.
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------

  /// The list storing all Todo items in memory.
  /// Managed purely using setState() without any external state libraries.
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Review Flutter StatefulWidget concepts',
      isCompleted: true,
    ),
    Todo(
      id: '2',
      title: 'Complete Assignment 5 requirements',
      isCompleted: false,
    ),
    Todo(
      id: '3',
      title: 'Test add, complete, and delete operations',
      isCompleted: false,
    ),
  ];

  /// Controller to manage and read input from the text field.
  final TextEditingController _textController = TextEditingController();

  /// Focus node to handle keyboard focus smoothly.
  final FocusNode _focusNode = FocusNode();

  /// Current active filter (All, Active, Completed).
  TodoFilter _currentFilter = TodoFilter.all;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // COMPUTED PROPERTIES (Derived from State)
  // ---------------------------------------------------------------------------

  int get _totalCount => _todos.length;
  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get _activeCount => _totalCount - _completedCount;

  double get _completionPercentage =>
      _totalCount == 0 ? 0.0 : _completedCount / _totalCount;

  List<Todo> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.active:
        return _todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((t) => t.isCompleted).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  // ---------------------------------------------------------------------------
  // STATE MANAGEMENT OPERATIONS (setState Demonstrations)
  // ---------------------------------------------------------------------------

  /// OPERATION 1: ADD A NEW TODO
  ///
  /// Demonstrates:
  /// 1. Validation (prevents adding empty or whitespace-only todos).
  /// 2. Calling [setState] to add the new [Todo] to [_todos].
  /// 3. Clearing the [TextEditingController] after success.
  void _addTodo() {
    final String enteredTitle = _textController.text.trim();

    // Prevent adding empty todos (Requirement 6)
    if (enteredTitle.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFE2C974), size: 20),
              SizedBox(width: 10),
              Text(
                'Please enter a task title before adding!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E2530),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // STATE CHANGE: Adding a new item to the list
    // setState() notifies Flutter to rebuild the UI with the updated list and counter
    setState(() {
      _todos.insert(
        0,
        Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: enteredTitle,
          isCompleted: false,
        ),
      );
    });

    // Clear the input field after successful addition (Requirement 7)
    _textController.clear();
    _focusNode.unfocus();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF4EBA88), size: 20),
            SizedBox(width: 10),
            Text(
              'Task added to list!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF161E28),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFF4EBA88).withValues(alpha: 0.4)),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// OPERATION 2: TOGGLE TODO COMPLETION STATUS
  ///
  /// Demonstrates:
  /// 1. Locating the target todo item.
  /// 2. Calling [setState] to invert [todo.isCompleted].
  /// 3. Flutter rebuilds the widget tree, updating the checkbox,
  ///    applying strikethrough styling, and updating the counter.
  void _toggleTodoCompletion(Todo todo) {
    setState(() {
      // Invert the completion flag
      todo.isCompleted = !todo.isCompleted;
    });
  }

  /// OPERATION 3: DELETE A TODO
  ///
  /// Demonstrates:
  /// 1. Finding the index of the item.
  /// 2. Calling [setState] to remove the item from [_todos].
  /// 3. Displaying an undo action via SnackBar which also uses [setState]
  ///    if the user chooses to restore the deleted task.
  void _deleteTodo(Todo todo) {
    final int itemIndex = _todos.indexOf(todo);
    if (itemIndex == -1) return;

    // Cache the removed todo in case of Undo
    final Todo removedTodo = todo;

    // STATE CHANGE: Removing the item from the list
    setState(() {
      _todos.removeAt(itemIndex);
    });

    // Provide immediate feedback with an Undo option
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted "${removedTodo.title}"',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A222E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A3649)),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFE2C974),
          onPressed: () {
            // STATE CHANGE: Restoring the deleted item
            setState(() {
              _todos.insert(itemIndex, removedTodo);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Clear all completed tasks at once (bonus convenience feature)
  void _clearCompleted() {
    if (_completedCount == 0) return;

    final List<Todo> removed = _todos.where((t) => t.isCompleted).toList();

    setState(() {
      _todos.removeWhere((t) => t.isCompleted);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cleared ${removed.length} completed task(s)',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A222E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFE2C974),
          onPressed: () {
            setState(() {
              _todos.addAll(removed);
            });
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD & UI COMPONENTS
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14), // Premium Obsidian Dark
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                // Header overview card with counter & glowing progress bar
                _buildOverviewCard(),

                // Input card with modern dark TextField and gold Add button
                _buildInputSection(),

                // Filter tabs (All / Active / Completed)
                _buildFilterChips(),

                // Scrollable list of todos or empty-state
                Expanded(
                  child: _filteredTodos.isEmpty
                      ? _buildEmptyState()
                      : _buildTodoList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Modern, executive Dark AppBar with obsidian canvas and radiant gold emblem
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFF0B0E14),
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF3E5AB), Color(0xFFD4AF37), Color(0xFF997528)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.checklist_rounded,
              color: Color(0xFF10141D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Todo List',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Assignment 5 • StatefulWidget & setState',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Counter badge showing completed / total tasks
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF171D26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.task_alt_rounded,
                size: 15,
                color: Color(0xFFE2C974),
              ),
              const SizedBox(width: 6),
              Text(
                '$_completedCount/$_totalCount Done',
                style: const TextStyle(
                  color: Color(0xFFE2C974),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Executive dark overview card showing stats and glowing gold progress bar
  Widget _buildOverviewCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151A22), // Sleek elevated surface
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF263040),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Summary',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_completedCount of $_totalCount tasks completed',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              // Percentage pill with gold gradient
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE2C974), Color(0xFFC5A059)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '${(_completionPercentage * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF0F131A),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Glowing Gold progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _completionPercentage,
              minHeight: 8,
              backgroundColor: const Color(0xFF202735),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
          ),
          const SizedBox(height: 14),
          // Mini statistic badges
          Row(
            children: [
              _buildMiniStat('Total', '$_totalCount', const Color(0xFF8B949E)),
              const SizedBox(width: 8),
              _buildMiniStat('Active', '$_activeCount', const Color(0xFFE2C974)),
              const SizedBox(width: 8),
              _buildMiniStat('Done', '$_completedCount', const Color(0xFF4EBA88)),
              const Spacer(),
              if (_completedCount > 0)
                TextButton.icon(
                  onPressed: _clearCompleted,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: const Color(0xFFE2C974),
                  ),
                  icon: const Icon(Icons.clear_all_rounded, size: 16),
                  label: const Text(
                    'Clear Done',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.9),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Input section containing the modern dark TextField and glowing gold Add button
  Widget _buildInputSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF263040)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // TextField for new todo title
          Expanded(
            child: TextField(
              key: const Key('todo_input_field'),
              controller: _textController,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addTodo(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
              ),
              decoration: InputDecoration(
                hintText: 'What needs to be accomplished?',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFFD4AF37),
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Glowing Gold Add Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFF3E5AB), Color(0xFFD4AF37), Color(0xFF997528)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FilledButton.icon(
              key: const Key('add_todo_button'),
              onPressed: _addTodo,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: const Color(0xFF0F131A),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 20, color: Color(0xFF0F131A)),
              label: const Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF0F131A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Filter chips row (All, Active, Completed)
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('All ($_totalCount)', TodoFilter.all),
          const SizedBox(width: 8),
          _buildFilterChip('Active ($_activeCount)', TodoFilter.active),
          const SizedBox(width: 8),
          _buildFilterChip('Completed ($_completedCount)', TodoFilter.completed),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, TodoFilter filter) {
    final bool isSelected = _currentFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F2836) : const Color(0xFF131820),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF263040),
            width: isSelected ? 1.4 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFFE2C974)
                : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  /// Scrollable list displaying all Todo cards
  Widget _buildTodoList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _filteredTodos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final todo = _filteredTodos[index];
        return _buildTodoCard(todo, index);
      },
    );
  }

  /// Individual Todo Card with Checkbox, Strikethrough, and Delete Icon
  Widget _buildTodoCard(Todo todo, int index) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteTodo(todo),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF3B181C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFEF4444),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? const Color(0xFF12161E)
              : const Color(0xFF161C26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: todo.isCompleted
                ? const Color(0xFF212936)
                : const Color(0xFF2C384A),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          // Checkbox to mark completed / uncompleted (Requirement 3)
          leading: Transform.scale(
            scale: 1.15,
            child: Checkbox(
              key: Key('checkbox_${todo.id}'),
              value: todo.isCompleted,
              activeColor: const Color(0xFFD4AF37),
              checkColor: const Color(0xFF0F131A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(
                color: todo.isCompleted
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF4B5563),
                width: 1.5,
              ),
              // Calls setState() inside _toggleTodoCompletion (Requirement 3 & 4)
              onChanged: (_) => _toggleTodoCompletion(todo),
            ),
          ),
          // Title with strikethrough styling when completed (Requirement 4)
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: todo.isCompleted ? FontWeight.normal : FontWeight.w600,
              color: todo.isCompleted
                  ? const Color(0xFF6B7280)
                  : const Color(0xFFF3F4F6),
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: const Color(0xFFD4AF37),
              decorationThickness: 2.0,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isCompleted
                        ? const Color(0xFF4EBA88)
                        : const Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  todo.isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: todo.isCompleted
                        ? const Color(0xFF4EBA88)
                        : const Color(0xFFE2C974),
                  ),
                ),
              ],
            ),
          ),
          // Delete icon button (Requirement 5)
          trailing: IconButton(
            key: Key('delete_${todo.id}'),
            tooltip: 'Delete task',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF6B7280),
              size: 20,
            ),
            hoverColor: const Color(0xFF3B181C),
            splashRadius: 20,
            // Calls setState() inside _deleteTodo (Requirement 5)
            onPressed: () => _deleteTodo(todo),
          ),
        ),
      ),
    );
  }

  /// Empty state display when there are no todos (Requirement 8)
  Widget _buildEmptyState() {
    final bool isFiltered = _todos.isNotEmpty && _filteredTodos.isEmpty;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative luxury halo icon badge
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFF151A22),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isFiltered ? Icons.filter_alt_off_rounded : Icons.task_alt_rounded,
                size: 52,
                color: const Color(0xFFE2C974),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              isFiltered ? 'No tasks in this filter' : 'All Caught Up!',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Switch to "All" to view all your tasks.'
                  : 'Add a new task above to stay organized,\nfocused, and productive today!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
