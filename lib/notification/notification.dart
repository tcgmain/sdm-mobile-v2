// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   //Initialize the FlutterLocalNotificationsPlugin instance
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {

//   }

//   //Initialize the notification plugin
//   static Future<void> init() async {
//     //Define the Android initialization settings
//     const  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

//     //Define the Ios initialization settings
//     const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

//     //Combine Android and Ios initialization settings
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iOSInitializationSettings
//     );

//     //Initialize the plugin the specified settings
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse
//     );

//     //Request notification permission for android
//     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//     ?.requestNotificationsPermission();
//   }

//   //Show an instant Notification
//   static Future<void> showInstantNotification(String title, String body) async {
//     //Define Notification Details
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "channelId", 
//         "channelName", 
//         importance: Importance.high,
//         priority: Priority.high
//       ),
//       iOS: DarwinNotificationDetails()
//     );
//     await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
//   }

//   //Show a schedule Notification 
//     static Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
//     //Define Notification Details
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: AndroidNotificationDetails(
//         "channelId", 
//         "channelName", 
//         importance: Importance.high,
//         priority: Priority.high
//       ),
//       iOS: DarwinNotificationDetails()
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0, 
//       title, 
//       body, 
//       tz.TZDateTime.from(scheduledDate, tz.local), 
//       platformChannelSpecifics, 
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime
//     );
//   }

// }