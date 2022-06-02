import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_tasks/data/model/notification.dart' as n;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> init({bool initScheduled = false}) async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iOS = const IOSInitializationSettings();
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) => onNotifications.add(payload),
    );
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> showNotification(n.Notification notification) async {
    tz.initializeTimeZones();
    return _notifications.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        tz.TZDateTime.from(notification.scheduleTime, tz.local),
        await _notificationDetails(),
        payload: notification.payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
