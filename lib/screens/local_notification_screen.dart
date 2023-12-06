import 'package:flutter/material.dart';
import 'package:notification_course/constant/app_constant.dart';
import 'package:notification_course/services/local_notification.dart';

class LocalNotificationScreen extends StatelessWidget {
  const LocalNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Local Notification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                LocalNotification.triggerNotification();
              },
              child: const Text('Trigger Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.scheduleNotification();
              },
              child: const Text('Schedule Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.cancelScheduledNotification(0);
              },
              child: const Text('Cancel Schedule Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.showNotificationWithActionButton(1);
              },
              child: const Text('Action Button Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.createBasicNotificationWithPayload();
              },
              child: const Text('Basic Notification With Payload')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.createMessagingNotification(
                  channelKey: chatChannelKey,
                  groupKey: 'Harsh_shah',
                  chatName: 'Hera Pheri Group',
                  userName: 'Harsh',
                  message: 'Manthan has send a message',
                  profileIcon:
                      'https://unsplash.com/photos/a-man-running-up-a-mountain-with-a-sky-background-gj7WgSOIIu4',
                );
              },
              child: const Text('Chat Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.createIndeterminateProgressNotification(1000);
              },
              child: const Text('Simple Progress Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.showDownloadProgressNotification(100);
              },
              child: const Text('Download Progress Notification')),
          ElevatedButton(
              onPressed: () {
                LocalNotification.showEmojiNotification(99);
              },
              child: const Text('Emojis Notification')),
          ElevatedButton(
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 10), () {
                  LocalNotification.showWakeUpNotification(98);
                });
              },
              child: const Text('Wakeup Notification')),
        ],
      ),
    );
  }
}
