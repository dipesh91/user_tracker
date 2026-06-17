import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static final _checkInReminderId = 1;
  static final _checkInConfirmId = 2;
  static final _breakEndReminderId = 3;
  static final _breakStartConfirmId = 4;
  static final _checkOutConfirmId = 5;

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    final android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(InitializationSettings(android: android));

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await scheduleCheckInReminder();
  }

  static NotificationDetails _details({String channelId = 'attendance'}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'Attendance Notifications',
        channelDescription: 'Check-in, check-out and break reminders',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  static Future<void> scheduleCheckInReminder() async {
    await _plugin.cancel(_checkInReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9, 0);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _checkInReminderId,
      'Check-in Reminder',
      "You haven't checked in yet!",
      scheduled,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> onCheckIn(String time) async {
    await _plugin.cancel(_checkInReminderId);

    await _plugin.show(
      _checkInConfirmId,
      '✅ Check-in Successful',
      'you checked in at $time 💪',
      _details(),
    );
  }

  static Future<void> onCheckInAgain(String time) async {
    await _plugin.cancel(_checkInReminderId);
    await _plugin.show(
      _checkInConfirmId,
      'You Checked-in Again',
      'you checked in again at $time 💪',
      _details(),
    );
  }

  static Future<void> onBreakStart({
    required String breakType,
    required String startTime,
  }) async {
    final int durationMinutes;
    final String breakLabel;

    switch (breakType.toLowerCase()) {
      case 'tea':
        durationMinutes = 15;
        breakLabel = 'Tea Break';
        break;
      case 'lunch':
        durationMinutes = 45;
        breakLabel = 'Lunch Break';
        break;
      default:
        durationMinutes = 15;
        breakLabel = 'Break';
    }

    await _plugin.show(
      _breakStartConfirmId,
      ' $breakLabel Started',
      "Break started at $startTime You'll be reminded in ${_formatDuration(durationMinutes)}.",
      _details(),
    );

    final endTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(minutes: durationMinutes));

    await _plugin.cancel(_breakEndReminderId);
    await _plugin.zonedSchedule(
      _breakEndReminderId,
      '$breakLabel Time Over!',
      '${_formatDuration(durationMinutes)} are up! Time to get back to work. 💼',
      endTime,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> onBreakEnd(String breakType) async {
    await _plugin.cancel(_breakEndReminderId);
  }

  static Future<void> onCheckOut(String time) async {
    await _plugin.show(
      _checkOutConfirmId,
      '👋 Check-out Successful',
      'You checked out at $time. See you tomorrow!',
      _details(),
    );
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  static String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}
