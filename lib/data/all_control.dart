// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class AllControl with ChangeNotifier {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   notificationProvider() {
//     _initializeFirebaseMessaging();
//   }

//   void _initializeFirebaseMessaging() {
//     _firebaseMessaging.getToken().then((token) {
//       print("Firebase Messaging Token: $token");
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         _showNotification(notification);
//       }
//     });
//   }

//   void _showNotification(RemoteNotification notification) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//           'your_channel_id',
//           'your_channel_name',
//           //  'your_channel_description',
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: false,
//         );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   var fbm = FirebaseMessaging.instance;
// }
