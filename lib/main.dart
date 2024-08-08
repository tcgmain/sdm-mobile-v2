import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sdm/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Workmanager
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // // Register the periodic task
  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "simplePeriodicTask",
  //   frequency: const Duration(minutes: 15), // Use a minimum of 15 minutes for periodic tasks
  // );

  // Set preferred orientations and run the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    runApp(const MyApp());
  });
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await MyApp.checkForPendingApprovals();
//     return Future.value(true);
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    // // Initialize the local notifications plugin
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon'); // Ensure 'app_icon' exists in res/drawable
    // const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    // const InitializationSettings initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sdm',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(81, 95, 131, 1)),
      ),
      home: const SplashView(),
    );
  }

  static Future<void> checkForPendingApprovals() async {
    
    int pendingApprovalsCount  = 5; // Placeholder for actual check

    if (pendingApprovalsCount > 0) {
      //await _showNotification(pendingApprovalsCount);
    }
  }

  // static Future<void> _showNotification(int pendingApprovalsCount) async {
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //     'SDM',
  //     'SDM',
  //     channelDescription: 'Sales Data Management System',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //     icon: 'app_icon', // Ensure 'app_icon' exists in res/drawable
  //   );
  //   var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Pending Approvals',
  //     'You have $pendingApprovalsCount pending organization approvals',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }
}
