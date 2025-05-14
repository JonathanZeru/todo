class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }
}