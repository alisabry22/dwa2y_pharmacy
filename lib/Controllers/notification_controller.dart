import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Models/prescription_model.dart';
import '../Models/user_model.dart';
import '../Widgets/custom_bottom_sheet.dart';
import '../Widgets/custom_order_dialog.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late NotificationSettings settings;
  final accountController = Get.find<AuthController>();
  Rx<PrescriptionOrder> order = PrescriptionOrder().obs;
  Rx<UserModel> userCreatedOrder = UserModel(lat: 0.0, long: 0.0).obs;
  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<TextEditingController> notestextController=TextEditingController().obs;
  Rx<PharmacyModel> currentLoggedInPharmacy =PharmacyModel(lat: 0.0, long: 0.0).obs;
  
        

  RxString orderId = "".obs;
  
  @override
  void onInit() async {
    super.onInit();
    settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: true,
      sound: true,
    );
   await getToken();

    //listen to current user changes
    accountController.currentLoggedInPharmacy.listen((p0) {
      currentLoggedInPharmacy.value = p0;
    });
   
    FirebaseMessaging.onMessage.listen((event) async {
         orderId.value = event.data['order_id'];
      //customer requests order
         log(event.data.toString());

      if(event.data["status"]=="done"){
              Get.find<HomeController>().badgeCounter.value++;
        await getOrderData(event.data['order_id']);
         FlutterRingtonePlayer.playNotification();
       await Get.dialog(
          
          CustomOrderDialog(
            prescriptionOrder: order.value,
            userCreatedOrder: userCreatedOrder.value),barrierDismissible: false);
      }
       //means that the user accepted order and waiting for you to contact him
      else if (event.data["status"]=="Waiting For Delivery"){
      
     
       
                   Get.find<HomeController>().badgeCounter.value++;

        contactCustomer(event.data);
         FlutterRingtonePlayer.playNotification();
      
      }
      //customer rejects order
      else {
        Get.snackbar("Rejected your Order".tr, "${event.data["CustomerName"]} Rejected Your Offer".tr,snackPosition: SnackPosition.TOP,duration: const Duration(seconds: 2),backgroundColor: Colors.grey);
      } 
    });
  }

  Future getToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection("pharmacies")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"token": fcmToken});
    }
  }

  Future getOrderData(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderId)
          .get()
          .then((value) {
        if (value.exists) {
          order.value = PrescriptionOrder.fromDocumentSnapshot(value);
        }
      });
      await getUserCreatedOrder(order.value.userMadeOrder!);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future getUserCreatedOrder(String userid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .get()
        .then((value) {
      if (value.exists) {
        userCreatedOrder.value = UserModel.fromDocumentSnapshot(value);
      }
    });
  }

  Future onRejectOrder(String orderid) async {
    List<String> pharmaciesbefore = [];
    List<String> pharmaciesafter = [];

    if (FirebaseAuth.instance.currentUser != null) {
      //read all array and then delete me
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderid)
          .get()
          .then((value) {
        if (value.exists) {
          pharmaciesbefore = (value.get("Pharmacies") as List).map((e) => e as String).toList() ;
        }
      });
      //if iam last pharmacy and i reject order update status to rejected to inform user
    if(pharmaciesbefore.length==1){
      await FirebaseFirestore.instance.collection("Orders").doc(orderid).update({"OrderStatus":"Rejected"});

    }else{
       for (var element in pharmaciesbefore) {
        if (element!=FirebaseAuth.instance.currentUser!.uid) {
          pharmaciesafter.add(element);
        }
      }

      //write it back to firebase firestore
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderid)
          .update({"Pharmacies": pharmaciesafter});
    }
     
    }
  }

  Future sendNotificationback(String orderid, String token, String? price,String pharmacyId, String pharmacyName,String title,String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":
              'key=AAAAGEPFvzA:APA91bHJ-aoqR1ln8I_YOaSrfKKnDHacd_Em6Hd70hDc_yL75ON6ITboslu7C-0_uhuDyPV9GlMoE_BWupL4vClcISlaksTi5qGtw78FkcRA8WkXFMh0HMLBsmx7kwg4mU8OcouaRBG-',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'order_id': orderid,
            'price': price,
            'pharmacyId': pharmacyId,
            'pharmacyname': pharmacyName,
          },
          // 'notification': {
          //   'order_id': orderid,
          //   'price': price,
          //   'title':title,
          //   'body':body,
          // },
          'to': token,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }
    Future sendRejectNotification(String orderid, String token,String pharmacyId, String pharmacyName,String title,String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":
              'key=AAAAGEPFvzA:APA91bHJ-aoqR1ln8I_YOaSrfKKnDHacd_Em6Hd70hDc_yL75ON6ITboslu7C-0_uhuDyPV9GlMoE_BWupL4vClcISlaksTi5qGtw78FkcRA8WkXFMh0HMLBsmx7kwg4mU8OcouaRBG-',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'reject',
            'order_id': orderid,
            'pharmacyId': pharmacyId,
            'pharmacyname': pharmacyName,
          },
          // 'notification': {
          //   'order_id': orderid,
          //   'title':title,
          //   'body':body,
          // },
          'to': token,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future addtoNotification(String orderid,String patientToken,String usermadeorder, String price,  String pharmacyId, String pharmacyName) async {
    var data = {
      "orderid": orderid,
      "usermadeorder": usermadeorder,
      "price": price,
      "pharmacyId": pharmacyId,
      "pharmacyName": pharmacyName,
      "pharmacytoken": currentLoggedInPharmacy.value.token,
      "patient_token": patientToken,
      "notes":notestextController.value.text.isNotEmpty?notestextController.value.text.trim():"",
    };
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc()
        .set(data);

        //delete me from order because when i get here then i already offered customer 
        List<String> pharmaciesbefore = [];
    List<String> pharmaciesafter = [];

    if (FirebaseAuth.instance.currentUser != null) {
      //read all array and then delete me
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderid)
          .get()
          .then((value) {
        if (value.exists) {
          pharmaciesbefore = (value.get("Pharmacies") as List).map((e) => e as String).toList() ;
        }
      });
      //if iam last pharmacy and i reject order update status to rejected to inform user
    
       for (var element in pharmaciesbefore) {
        if (element!=FirebaseAuth.instance.currentUser!.uid) {
          pharmaciesafter.add(element);
        }
      
  }
       //write it back to firebase firestore
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderid)
          .update({"Pharmacies": pharmaciesafter});
    }
    priceController.value.text="";
  }

  //listen to orders that iam included in 
   Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(){
  return  FirebaseFirestore.instance.collection("Orders").where("Pharmacies",arrayContains:FirebaseAuth.instance.currentUser!.uid ).where("OrderStatus",isEqualTo: "Pending").snapshots();
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToOrder(String orderid) {
    return FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderid)
        .snapshots();
  }

  void contactCustomer(Map<String, dynamic> data) async {
    
    final userid = data['customer_id'];
    final orderid = data['order_id'];

    await getUserCreatedOrder(userid);
    Get.bottomSheet(
        CustomBottomSheet(
            usercreatedOrder: userCreatedOrder.value, orderid: orderid),
        isDismissible: false);
  }
}
