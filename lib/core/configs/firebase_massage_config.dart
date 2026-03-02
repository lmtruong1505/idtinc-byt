import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasa/core/injection/injection.dart';
import 'package:tasa/core/navigation/navigator.dart';

class FirebaseMessageConfig {
  final notificationSettings = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    try {
      notificationSettings.requestPermission();
      final deviceToken = await notificationSettings.getToken();
      if (deviceToken != null) {
        if (kDebugMode) {
          print("=====deviceToke=====$deviceToken");
        }
        iniPushNotification(context);
        // initLocalNotifications();
        // FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // _showNotification(message);
    // final navigator = getIt.get<AppNavigator>();
    // final appCubit = getIt.get<AppCubit>();
    // if (appCubit.state.isLoggedIn) {
    //   navigator.push(OrderDetailPage(code: message.data["custom_id"]));
    // } else {
    //   navigator.push(LoginPage());
    // }
    final navigator = getIt.get<AppNavigator>();
    final routeName = navigator.getCurrentRouteName();
    if (kDebugMode) {
      print("======= $routeName");
      print("======= ${message.data}");
    }
  }

  Future iniPushNotification(BuildContext context) async {
    final navigator = getIt.get<AppNavigator>();
    try {
      await notificationSettings.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (notificationSettings.isAutoInitEnabled) {
        print('User granted permission');
      } else {
        print('User declined or has not accepted permission');
      }
      initLocalNotifications();

      // notificationSettings.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((message) {
        if (kDebugMode) {
          print("=======FirebaseMessaging onMessage");
        }
        // context.router.current == OrderRoute
        final routeName = navigator.getCurrentRouteName();
        if (kDebugMode) {
          print("======= $routeName");
          print("======= ${message.data}");
        }

        final RemoteNotification? notification = message.notification;
        if (notification == null) {
          return;
        }
        _showNotification(message);
      });
    } catch (e) {
      print("=======FirebaseMessaging error");
    }
  }

  Future initLocalNotifications() async {
    try {
      const iOS = DarwinInitializationSettings();
      const android = AndroidInitializationSettings('@drawable/ic_launcher');
      const settings = InitializationSettings(iOS: iOS, android: android);
      await flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload != null) {
            jsonDecode(details.payload!);
            final navigator = getIt.get<AppNavigator>();
            navigator.getCurrentRouteName();
          } else {
            debugPrint('notification payload');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("==========initLocalNotifications Error");
      }
    }
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // handleMessage(message);
    // _showNotification(message);
    final navigator = getIt.get<AppNavigator>();
    final routeName = navigator.getCurrentRouteName();
    if (kDebugMode) {
      print("======= $routeName");
      print("======= ${message.data}");
    }
  }

  void _showNotification(RemoteMessage message) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
      );

      const platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      print("===============ShowError Noti Error");
    }
  }
}
