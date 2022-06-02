class Notification {
  final int id;
  final String title, body, payload;
  final DateTime scheduleTime;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.scheduleTime,
  });
}
