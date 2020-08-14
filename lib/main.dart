import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appcenter/flutter_appcenter.dart';
import 'package:polka_wallet/app.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:polka_wallet/service/notification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polka_wallet/service/subscan.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  var initialised = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
  print('notification_plugin initialised: $initialised');

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    WalletApp(),
  );

  FlutterAppCenter.init(
      androidAppId: 'f37bf978-7d80-4798-ae45-ea13ad0ff077',
      iOSAppId: '590a0334-84e0-4e44-9e8b-4f8611ba2e3b');
}
