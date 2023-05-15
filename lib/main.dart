import 'dart:developer';

import 'package:dwa2y_pharmacy/Bindings/bindings.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/auth_router.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:dwa2y_pharmacy/notification_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    if(message.notification!=null){
      Get.to(()=>const Dashboard());
      Get.to(()=>const Notifications());
    }
  });
await  setUpFlutterNotificationChannel();
  runApp(const MyApp());
}

Future<void> setUpFlutterNotificationChannel() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high);
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        isFlutterLocalNotificationsInitialized=true;
}

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (message.notification!=null && android != null) {
    

//     // flutterLocalNotificationsPlugin.show(notification.hashCode, "Order Request", "${message.data["CustomerName"]} is requesting medicine from you", NotificationDetails(android:AndroidNotificationDetails(
//     //   channel.id,
//     //   channel.name,
//     //   channelDescription: channel.description,
//     //   icon: '@mipmap/ic_launcher',
//     // ) ));
//   }
// }

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setUpFlutterNotificationChannel();
 //showFlutterNotification(message);
 log("handling background notification ${message.data}");
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      home: const AuthRouter(),
    );
  }
}
