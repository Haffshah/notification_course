import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:notification_course/services/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotification(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                triggerNotification();
              },
              child: const Text('Trigger Notification')),
          ElevatedButton(
              onPressed: () {
                scheduleNotification();
              },
              child: const Text('Schedule Notification')),
          ElevatedButton(
              onPressed: () {
                cancelScheduledNotification(110);
              },
              child: const Text('Cancel Schedule Notification')),
        ],
      ),
    );
  }

  /// Trigger Notification
  triggerNotification() {
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
  scheduleNotification() {
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
  cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}
