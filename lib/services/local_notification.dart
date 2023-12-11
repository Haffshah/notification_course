import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notification_course/constant/app_constant.dart';

/// Create Unique id
int createUniqueId(int maxValue) {
  Random random = Random();
  return random.nextInt(maxValue);
}

class LocalNotification {
  /// Trigger Notification
  static triggerNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: notificationChannelKey,
            title: 'New Notification',
            body: 'New charging slot found on speaker.',
            bigPicture:
                'https://plus.unsplash.com/premium_photo-1701127871438-af582cdd8c55?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            notificationLayout: NotificationLayout.BigPicture));
  }

  /// Schedule Notification
  static scheduleNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: notificationChannelKey,
            title: 'Scheduled Notification',
            body: 'New charging slot found on speaker.',
            bigPicture:
                'https://plus.unsplash.com/premium_photo-1701127871438-af582cdd8c55?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            notificationLayout: NotificationLayout.BigPicture),

        ///First Way
        schedule: NotificationCalendar(second: 0, repeats: true)

        /// Second Way
        // schedule: NotificationCalendar.fromDate(
        //     date: DateTime.now().add(const Duration(seconds: 10)),
        //     allowWhileIdle: true,
        //     preciseAlarm: true),
        );
  }

  /// Cancel Scheduled Notification
  static cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  /// Action Button Notification
  static showNotificationWithActionButton(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: notificationChannelKey,
          title: 'Anonymous says:',
          body: 'Hi there!',
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'SUBSCRIBE',
              label: 'Subscribe',
              autoDismissible: true,
              isDangerousOption: true),
          NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.Default,
          ),
        ]);
  }

  /// Create Basic Notification With Payload
  static Future<void> createBasicNotificationWithPayload() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: notificationChannelKey,
            title: 'This is Notification With Payload',
            body: 'Press on notification to check...',
            payload: {'screen_name': 'HOME_SCREEN'}));
  }

  /// Create Messaging Notification
  static Future<void> createMessagingNotification({
    required String channelKey,
    required String groupKey,
    required String chatName,
    required String userName,
    required String message,
    String? profileIcon,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(AwesomeNotifications.maxID),
            groupKey: groupKey,
            channelKey: channelKey,
            summary: chatName,
            title: userName,
            body: message,
            largeIcon: profileIcon,
            notificationLayout: NotificationLayout.MessagingGroup,
            category: NotificationCategory.Message),
        actionButtons: [
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply',
              requireInputText: true,
              autoDismissible: false),
          NotificationActionButton(
              key: 'READ', label: 'Mark as Read', autoDismissible: true),
        ]);
  }

  /// Progress Bar Notification
  static Future<void> createIndeterminateProgressNotification(int id) async {
    /// Fake Download
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: notificationChannelKey,
            title: 'Downloading file',
            body: 'FileName.txt',
            category: NotificationCategory.Progress,
            payload: {'file': 'FileName.txt'},
            progress: null,
            locked: true,
            notificationLayout: NotificationLayout.ProgressBar));

    /// Fake Download Complete
    Future.delayed(const Duration(seconds: 5), () async {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: id,
        channelKey: notificationChannelKey,
        title: 'Downloading finished',
        body: 'FileName.txt',
        category: NotificationCategory.Progress,
        locked: false,
      ));
    });
  }

  /// Download Progress Notification Start
  static int currentStep = 0;

  static Future<void> showDownloadProgressNotification(int id) async {
    int maxStep = 10;

    for (int simulatedStep = 1; simulatedStep <= maxStep + 1; simulatedStep++) {
      currentStep = simulatedStep;
      await Future.delayed(const Duration(seconds: 1));
      _updateCurrentProgressBar(
          id: id, simulatedStep: currentStep, maxStep: maxStep);
    }
  }

  static void _updateCurrentProgressBar(
      {required int id,
      required int simulatedStep,
      required int maxStep}) async {
    /// To show Complete Notification
    if (simulatedStep > maxStep) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: id,
        channelKey: notificationChannelKey,
        title: 'Downloading finished',
        body: 'FileName.txt',
        category: NotificationCategory.Progress,
        locked: false,
      ));
    }

    /// Show Progress
    else {
      int progress = min((simulatedStep / maxStep * 100).round(), 100);
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: notificationChannelKey,
              title: 'Downloading file ($progress%)',
              body: 'FileName.txt',
              category: NotificationCategory.Progress,
              payload: {'file': 'FileName.txt'},
              progress: progress,
              locked: true,
              notificationLayout: NotificationLayout.ProgressBar));
    }
  }

  /// Download Progress Notification End

  /// Emoji Notification
  static Future<void> showEmojiNotification(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: notificationChannelKey,
      title:
          'Emojis Are Awesome! 🤪🥳😇 ${Emojis.activites_admission_tickets} ${Emojis.science_dna}',
      body: 'Emojis are emotions on face ${Emojis.activites_carp_streamer}',
      category: NotificationCategory.Social,
    ));
  }

  /// Wakeup Notification will Wake up Lock Screen
  static Future<void> showWakeUpNotification(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: notificationChannelKey,
            title: 'Wakeup Notification',
            body: 'Wakeup you lazy boy!',
            wakeUpScreen: true));
  }

  /// Create LiveScore Notification
  static Future<void> createLiveScoreNotification(
      {required int id,
      required String title,
      required String body,
      String? largeIcon}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: notificationChannelKey,
            body: body,
            title: title,
            largeIcon: largeIcon));
  }
}
