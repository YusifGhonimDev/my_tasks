class Task {
  final int? id;
  String name;
  bool isDone;

  Task({
    this.id,
    required this.name,
    this.isDone = false,
  });

  factory Task.fromMap(Map mao) {
    return Task(
      id: mao['id'],
      name: mao['name'],
      isDone: mao['isDone'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone == true ? 1 : 0,
    };
  }
}
