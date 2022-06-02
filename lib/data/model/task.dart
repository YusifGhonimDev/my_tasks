class Task {
  final int? id;
  String name;
  String deadline;
  bool isDone;

  Task({
    this.id,
    required this.name,
    required this.deadline,
    this.isDone = false,
  });

  factory Task.fromMap(Map map) {
    return Task(
      id: map['id'],
      name: map['name'],
      deadline: map['deadline'],
      isDone: map['isDone'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'deadline': deadline,
      'isDone': isDone == true ? 1 : 0,
    };
  }
}
