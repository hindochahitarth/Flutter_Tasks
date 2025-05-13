
class ToDosModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  ToDosModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ToDosModel.fromJson(Map<String, dynamic> json) {
    return ToDosModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  ToDosModel copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) {
    return ToDosModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
