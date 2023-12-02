import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotification {
  /// Trigger Notification
  static triggerNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: 'basic_channel',
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
            channelKey: 'basic_channel',
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
          channelKey: 'basic_channel',
          title: 'Anonymous says:',
          body: 'Hi there!',
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'READ',
              label: 'Mark as read',
              autoDismissible: true,
              requireInputText: true),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.Default,
              color: Colors.redAccent),
        ]);
  }
}
