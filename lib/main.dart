import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:notification_course/get_it.dart';
import 'package:notification_course/screens/local_notification_screen.dart';
import 'package:notification_course/screens/media_notifications/media_notification_screen.dart';
import 'package:notification_course/screens/media_notifications/services/page_manager.dart';
import 'package:notification_course/services/notification_controller.dart';
import 'package:notification_course/screens/remote_notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.getStartedWithNotification();
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Global NavigatorKey
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Awesome Notifications'),
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
    getIt<PageManager>().init();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();


        }
      });
      /// Request Form Awesome Notification FCM
      // NotificationController.requestFirebaseToken();
      /// Request Token From FirebaseMessaging
      // NotificationController().getFcmToken();

    });
  }


  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Local Notification
          ElevatedButton(
              onPressed: () {
                MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (_) => const LocalNotificationScreen()));
              },
              child: const Text('Local Notification')),

          /// Remote Notification
          ElevatedButton(
              onPressed: () {
                MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (_) => const RemoteNotificationScreen()));
              },
              child: const Text('Remote Notification')),

          /// Media Notification
          ElevatedButton(
              onPressed: () {
                MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (_) => const MediaNotificationScreen()));
              },
              child: const Text('Media Notification')),
        ],
      ),
    );
  }
}
