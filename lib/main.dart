
import 'package:dwa2y_pharmacy/Bindings/bindings.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/auth_router.dart';
import 'package:dwa2y_pharmacy/Utils/languages.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:dwa2y_pharmacy/notification_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controllers/localization_controller.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    if(message.data.isNotEmpty){
     
  Get.offAll(()=>const Dashboard());
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

void showFlutterNotification(RemoteMessage message) {
  // RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  if (message.data.isNotEmpty ) {
    print(message.data);
      if(message.data["status"]=="done"){
        print("Order Request".tr);
        flutterLocalNotificationsPlugin.show(message.hashCode, "Order Request".tr, "${message.data["CustomerName"]} ${"Please Offer Him price for Prescription".tr}", NotificationDetails(android:AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: '@mipmap/ic_launcher',
    ) ));
      }else if (message.data["status"]=="Waiting For Delivery"){
flutterLocalNotificationsPlugin.show(message.hashCode, "Offer Accepted".tr, "${message.data["CustomerName"]} ${"Accepted Your Offer Deliver it now!!".tr}", NotificationDetails(android:AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: '@mipmap/ic_launcher',
    ) ));
      }else if(message.data["status"]=="reject"){
flutterLocalNotificationsPlugin.show(message.hashCode, "Offer Rejected".tr, "${message.data["CustomerName"]} ${"Rejected Your Offer".tr}", NotificationDetails(android:AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: '@mipmap/ic_launcher',
    ) ));
      }else{
          flutterLocalNotificationsPlugin.show(message.hashCode, message.notification!.title, message.notification!.body, NotificationDetails(android:AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: '@mipmap/ic_launcher',
    ) ));
      }
 
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
await setUpFlutterNotificationChannel();
showFlutterNotification(message);
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LanguageController localeController=Get.put(LanguageController());
    print(localeController.locale.value);
        return GetMaterialApp(
      locale: localeController.locale.value,
      translations: Languages(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
         fontFamily: localeController.locale.value==const Locale('ar')?'Alexandria':'Poppins',
      ),
      initialBinding: Binding(),
      home: const AuthRouter(),
    );
  }
}
