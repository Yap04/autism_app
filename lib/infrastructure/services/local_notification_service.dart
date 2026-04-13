import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(settings: initSettings);
  }

  Future<void> scheduleAppointmentReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'appointment_reminders_channel',
      'Appointment Reminders',
      channelDescription: 'Reminders for upcoming sports sessions',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tzTime,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(int notificationId) async {
    await _notificationsPlugin.cancel(id: notificationId);
  }

  Future<void> requestPermissions() async {
    final androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> showImmediateAppointmentReminder({
    required int notificationId,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'urgent_appointment_channel',
      'Urgent Reminders',
      channelDescription: 'Immediate reminders for urgent bookings',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }
}
