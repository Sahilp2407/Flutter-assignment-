/// Model representing a single Todo item.
class Todo {
  final String id;
  String title;
  bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
