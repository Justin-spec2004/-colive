// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseMsg {
//   final msgService = FirebaseMessaging.instance;

//   initFCM() async {
//     await msgService.requestPermission();

//     var token = await msgService.getToken();

//     print("Token: $token");

//     FirebaseMessaging.onBackgroundMessage(handleNotification);
//     FirebaseMessaging.onMessage.listen(handleNotification);
//   }
// }

// Future<void> handleNotification(RemoteMessage msg) async {}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initFCM() async {
    // Request permission for iOS and Android 13+
    await msgService.requestPermission();

    // Get token
    var token = await msgService.getToken();
    print("Token: $token");

    // Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      showNotification(msg);
    });

    // Init flutter local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'default_channel_id',
        'Default Channel',
        channelDescription: 'For showing default notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Needed for background messages
  print('🔙 Handling background message: ${message.messageId}');
}
