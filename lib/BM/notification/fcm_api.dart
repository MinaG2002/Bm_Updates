import 'package:firebase_messaging/firebase_messaging.dart';

class FcmApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  iniNotification() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print(fcmToken);
    FirebaseMessaging.onBackgroundMessage(handelbackgroundfcm);
  }
}

Future<void> handelbackgroundfcm(RemoteMessage message) async {
  print("title:${message.notification?.title}");
  print("body:${message.notification?.body}");
}
