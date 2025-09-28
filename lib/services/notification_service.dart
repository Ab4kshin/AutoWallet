// Заглушка для notification_service.dart

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:auto_wallet2/models/event_model.dart';

class NotificationService {
  static Future<void> init() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();
    
    // Notifications temporarily disabled
    print('Notifications temporarily disabled due to compatibility issues');
  }

  static Future<void> scheduleEventNotification(Event event) async {
    if (!event.notificationEnabled) return;
    
    // Notifications temporarily disabled
    print('Event notification scheduled (mock): ${event.title} at ${event.dateTime}');
  }

  static Future<void> cancelNotification(int id) async {
    // Notifications temporarily disabled
    print('Notification canceled (mock): $id');
  }

  static Future<void> cancelAllNotifications() async {
    // Notifications temporarily disabled
    print('All notifications canceled (mock)');
  }
}

