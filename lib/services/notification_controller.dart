import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController with ChangeNotifier {
  /// Singleton Pattern
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /// Initialization Method
  static Future<void> initializeLocalNotification({required bool debug}) async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notification',
            channelDescription: 'Notification channel for basic test',
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Secret,
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            channelShowBadge: true,
            enableVibration: true,
            enableLights: true,
            defaultColor: Colors.deepPurpleAccent,
            icon: 'resource://drawable/res_naruto',
            playSound: true,
            soundSource: 'resource://raw/naruto_jutsu',
          )
        ],
        debug: debug);
  }
}
