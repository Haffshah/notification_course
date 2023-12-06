import 'package:flutter/material.dart';
import 'package:notification_course/services/local_notification.dart';
import 'package:notification_course/services/notification_controller.dart';

class RemoteNotificationScreen extends StatelessWidget {
  const RemoteNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Remote Notification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                NotificationController.subscribeToTopic('FlutterNewsletter');
              },
              child: const Text('Subscribe to Topic')),

          ElevatedButton(
              onPressed: () {
                NotificationController.unsubscribeToTopic('FlutterNewsletter');
              },
              child: const Text('Unsubscribe to Topic')),

        ],
      ),
    );
  }
}
