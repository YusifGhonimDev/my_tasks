import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_tasks/data/model/notification.dart';

import '../../helper/notification_helper.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showNotification(DateTime deadline) {
    NotificationHelper.showNotification(Notification(
        id: 0,
        title: 'Hello',
        body: 'World',
        payload: 'payload',
        scheduleTime: deadline.subtract(const Duration(hours: 1))));
    emit(NotificationPushed(deadline));
    print('Notification pushed');
  }
}
