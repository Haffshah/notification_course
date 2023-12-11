import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';

// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_course/constant/app_constant.dart';
import 'package:notification_course/main.dart';
import 'package:notification_course/screens/local_notification_screen.dart';
import 'package:notification_course/services/local_notification.dart';

/// Background Message Handler
Future<void> _bgMessageHandler(RemoteMessage remoteMessage) async {
  print('On Background Message Received ${remoteMessage.toMap()}');
}

/// Navigation
navigationAction(ReceivedAction receivedAction) {
  if (receivedAction.payload != null &&
      receivedAction.payload!['screen_name'] == 'HOME_SCREEN') {
    MyApp.navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) => const LocalNotificationScreen()));
  }
}

class NotificationController with ChangeNotifier {
  /// Singleton Pattern
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  NotificationController._internal();

  /// Get Initialize all the Methods required
  static Future<void> getStartedWithNotification() async {
    NotificationController.initializeLocalNotification(debug: true);
    NotificationController.initializeRemoteNotification(debug: true);
    NotificationController.initializeFirebaseRemoteNotification();
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

  ///Set Firebase Options
  static setFirebaseOption() {
    if (Platform.isAndroid) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyB9zHnV2KeRtdB8Gr1L4Gr6AwFy5TGQilI',
        appId: '1:616687156211:android:903430243b3f619b623086',
        messagingSenderId: '616687156211',
        projectId: 'push-notification-13736a',
      );
    }
  }

  /// Initialization Method
  static Future<void> initializeRemoteNotification(
      {required bool debug}) async {
    // await Firebase.initializeApp(
    //     options: NotificationController.setFirebaseOption());

    // await AwesomeNotificationsFcm().initialize(
    //     onFcmTokenHandle: NotificationController.myFcmTokenHandle,
    //     onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
    //     onNativeTokenHandle: NotificationController.myNativeTokenHandle,
    //     licenseKeys: [],
    //     debug: debug);
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

  /// Notification Displayed Method
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

  /// Remote Notification Event Listeners
  /// Use this method to execute on background when a silent data arrives
  /// (even While Terminated)
  // static Future<void> mySilentDataHandle(FcmSilentData fcmSilentData) async {
  //   Fluttertoast.showToast(
  //       msg: 'Silent Data Received',
  //       toastLength: Toast.LENGTH_SHORT,
  //       fontSize: 16,
  //       backgroundColor: Colors.amber);
  //
  //   if (fcmSilentData.data!['IsLiveScore'] == 'true') {
  //     LocalNotification.createLiveScoreNotification(
  //         id: 1,
  //         title: fcmSilentData.data!['title']!,
  //         body: fcmSilentData.data!['body']!,
  //         largeIcon: fcmSilentData.data!['largeIcon']!);
  //   }
  //
  //   debugPrint('"Silent Data" : ${fcmSilentData.data}');
  //   if (fcmSilentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
  //     debugPrint('Foreground');
  //   } else {
  //     debugPrint('Background');
  //   }
  // }

  /// FCM Token handle
  // static Future<void> myFcmTokenHandle(String token) async {
  //   Fluttertoast.showToast(
  //       msg: 'FCM token received',
  //       toastLength: Toast.LENGTH_SHORT,
  //       fontSize: 16,
  //       backgroundColor: Colors.amber);
  //
  //   debugPrint('"FCM Token" : $token');
  // }

  /// Native Token handle
  // static Future<void> myNativeTokenHandle(String token) async {
  //   Fluttertoast.showToast(
  //       msg: 'Native token received',
  //       toastLength: Toast.LENGTH_SHORT,
  //       fontSize: 16,
  //       backgroundColor: Colors.amber);
  //
  //   debugPrint('"Native Token" : $token');
  // }

  /// Request Firebase Token
  // static Future<String> requestFirebaseToken() async {
  //   if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
  //     try {
  //       return await AwesomeNotificationsFcm().requestFirebaseAppToken();
  //     } catch (e, s) {
  //       debugPrint('Exception $e\n Stacktrace $s');
  //     }
  //   } else {
  //     debugPrint('Firebase is not available ');
  //   }
  //
  //   return '';
  // }
  //
  /// Subscribe to Topic
  // static Future<void> subscribeToTopic(String topic) async {
  //   await AwesomeNotificationsFcm().subscribeToTopic(topic);
  //   debugPrint('Subscribe to Topic $topic');
  // }
  //
  /// Unsubscribe to Topic
  // static Future<void> unsubscribeToTopic(String topic) async {
  //   await AwesomeNotificationsFcm().unsubscribeToTopic(topic);
  //   debugPrint('Unsubscribe to Topic $topic');
  // }

  ///======================== Firebase Notification ===========================///

  static Future<void> initializeFirebaseRemoteNotification() async {
    await Firebase.initializeApp(
       options: NotificationController.setFirebaseOption());

    /// For On Background and Terminated State
    FirebaseMessaging.onBackgroundMessage(_bgMessageHandler);

    /// Foreground State
    FirebaseMessaging.onMessage.listen(onForegroundMessageReceived);

    /// Calls when user taps on It.
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

  static Future<void> onForegroundMessageReceived(
      RemoteMessage remoteMessage) async {
    print('On Foreground Message Received ${remoteMessage.toMap()}');
  }

  static Future<void> onMessageOpenedApp(RemoteMessage remoteMessage) async {
    print('On Tap of Received Message  ${remoteMessage.toMap()}');
  }

   getFcmToken() async {
    final fcmToken = await firebaseMessaging.getToken();
    print('FirebaseMessaging FCM $fcmToken');
  }
}
