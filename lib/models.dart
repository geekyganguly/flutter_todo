class TodoModel {
  final int id;
  final String task;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoModel({
    required this.id,
    required this.task,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> data) {
    return TodoModel(
      id: data['id'] as int,
      task: data['task'] as String,
      isCompleted: data['is_completed'] as bool,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }
}
