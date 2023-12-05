import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_course/constant/app_constant.dart';
import 'package:notification_course/main.dart';
import 'package:notification_course/screens/home_screen.dart';
import 'package:notification_course/services/local_notification.dart';

/// Navigation
navigationAction(ReceivedAction receivedAction) {
  if (receivedAction.payload != null &&
      receivedAction.payload!['screen_name'] == 'HOME_SCREEN') {
    MyApp.navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }
}

class NotificationController with ChangeNotifier {
  /// Singleton Pattern
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /// Get Initialize all the Methods required
  static Future<void> getStartedWithNotification() async {
    NotificationController.initializeLocalNotification(debug: true);
    NotificationController.initializeNotificationForEventListeners();
    NotificationController.getInitialNotificationAction();
  }

  /// Initialization Method
  static Future<void> initializeLocalNotification({required bool debug}) async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: notificationChannelKey,
            channelName: notificationChannelName,
            channelDescription: notificationChannelDescription,
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
          ),

          /// Chat Channel
          NotificationChannel(
              channelGroupKey: chatChannelKey,
              channelKey: chatChannelKey,
              channelName: chatChannelName,
              channelDescription: chatChannelDescription,
              channelShowBadge: true,
              importance: NotificationImportance.Max)
        ],
        debug: debug);
  }

  /// Event Listeners
  static Future<void> initializeNotificationForEventListeners() async {
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  /// Action Received Method
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;

    // debugPrint('${isSilentAction ? 'Silent action' : 'Action'} Notification Received');
    debugPrint('receivedAction ${receivedAction.toString()}');
    navigationAction(receivedAction);
    //
    // if (receivedAction.buttonKeyPressed == 'SUBSCRIBE') {
    //   debugPrint('Subscribed to Harsh Shah');
    // } else if (receivedAction.buttonKeyPressed == 'DISMISS') {
    //   debugPrint('Dismiss Pressed');
    // }
    if (receivedAction.channelKey == chatChannelKey) {
      receiveChatNotificationAction(receivedAction);
    }
    Fluttertoast.showToast(
        msg:
            '${isSilentAction ? 'Silent action' : 'Action'} Notification Received',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 12,
        backgroundColor: Colors.amber);
  }

  /// Notification Created Method
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Created');

    Fluttertoast.showToast(
        msg: 'Notification Created',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 12,
        backgroundColor: Colors.amber);
  }

  /// Notification Displaed Method
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Displayed');

    Fluttertoast.showToast(
        msg: 'Notification Displayed',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 12,
        backgroundColor: Colors.amber);
  }

  /// Dismiss Action Received Method
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Action Received');

    Fluttertoast.showToast(
        msg: 'Action Received',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 12,
        backgroundColor: Colors.amber);
  }

  /// When app is in Killed State
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    if (receivedAction == null) {
      return;
    } else {
      navigationAction(receivedAction);
    }
  }

  /// Receive Chat Notification Action
  static Future<void> receiveChatNotificationAction(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'REPLY') {
      await LocalNotification.createMessagingNotification(
          channelKey: chatChannelKey,
          groupKey: receivedAction.groupKey!,
          chatName: receivedAction.summary!,
          userName: 'you',
          message: receivedAction.buttonKeyInput,
          profileIcon:
              'https://unsplash.com/photos/a-silhouette-of-a-man-standing-in-front-of-a-sunset-4tprl35EsVs');
    }
  }
}
