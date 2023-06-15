import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void initialize(BuildContext context) {
    const settings = InitializationSettings(
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    // initialize notifications plugin
    notificationsPlugin.initialize(
      settings,
      onSelectNotification: (String? route) async {
        Navigator.pushNamed(context, route!);
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = int.parse(const Uuid().v4());

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Dhabi", // this has to be the same as the string passed in the meta-data in AndroidManifest.xml
          "Dhabi Channel",
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(),
      );
      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["routeFor"],
      );
    } catch (_) {
      rethrow;
    }
  }
}
