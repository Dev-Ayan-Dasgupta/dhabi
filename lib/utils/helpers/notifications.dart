import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      onSelectNotification: (_) async {
        // Navigator.pushNamed(context, Routes.depositStatement);
        navigatorKey.currentState!.pushNamed(Routes.depositStatement);
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      // final id = int.parse(const Uuid().v4());

      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              "Dhabi",
              "Dhabi name",
              importance: Importance.high,
              enableVibration: true,
              playSound: true,
            ),
          );

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
        0,
        // id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: Routes.depositStatement,
      );
    } catch (_) {
      rethrow;
    }
  }
}
