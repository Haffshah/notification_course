import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:notification_course/constant/app_constant.dart';
import 'package:notification_course/services/local_notification.dart';
import 'package:notification_course/services/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.getStartedWithNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Global NavigatorKey
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
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
        ],
      ),
    );
  }
}
