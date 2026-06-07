class Task {
  final String id;
  String name;
  String category;
  bool isCompleted;
  String? date; // 'yyyy-MM-dd' format — set for calendar tasks

  Task({
    required this.id,
    required this.name,
    required this.category,
    this.isCompleted = false,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'isCompleted': isCompleted,
        if (date != null) 'date': date,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        date: json['date'] as String?,
      );
}
