import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  Future<void> schedulePeriodReminder(DateTime expectedDate, bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_period_reminder', isEnabled);
    
    await _flutterLocalNotificationsPlugin.cancel(id: 1); // cancel old period reminder
    
    if (!isEnabled) return;

    // Request permission just-in-time (Memenuhi Poin 5 Audit ISO)
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    final reminderDate = expectedDate.subtract(const Duration(days: 2));
    if (reminderDate.isBefore(DateTime.now())) return; // past date

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Pengingat Siklus Haid',
      body: 'Haid Anda diprediksi akan tiba dalam 2 hari. Yuk bersiap!',
      scheduledDate: tz.TZDateTime.from(reminderDate.add(const Duration(hours: 8)), tz.local), // 8 AM
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'period_reminder_channel',
          'Pengingat Haid',
          channelDescription: 'Notifikasi untuk mengingatkan masa haid',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleFertilityReminder(DateTime expectedDate, bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_fertility_reminder', isEnabled);

    await _flutterLocalNotificationsPlugin.cancel(id: 2); // cancel old
    
    if (!isEnabled) return;

    // Request permission just-in-time (Memenuhi Poin 5 Audit ISO)
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    final fertilityDate = expectedDate.subtract(const Duration(days: 14)); // simple ovulaton estimate
    if (fertilityDate.isBefore(DateTime.now())) return; 

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 2,
      title: 'Jendela Kesuburan',
      body: 'Anda diprediksi memasuki masa subur hari ini.',
      scheduledDate: tz.TZDateTime.from(fertilityDate.add(const Duration(hours: 9)), tz.local), // 9 AM
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fertility_reminder_channel',
          'Masa Subur',
          channelDescription: 'Notifikasi untuk masa subur',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<bool> getPeriodReminderPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pref_period_reminder') ?? true;
  }

  Future<bool> getFertilityReminderPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pref_fertility_reminder') ?? false;
  }
}
