part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationPushed extends NotificationState {
  final DateTime deadline;

  NotificationPushed(this.deadline);
}
