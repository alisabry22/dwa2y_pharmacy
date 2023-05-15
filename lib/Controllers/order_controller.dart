import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/prescription_model.dart';


class OrderController extends GetxController{
  Rx<PrescriptionOrder>orderDetails=PrescriptionOrder().obs;
  Rx<TextEditingController>priceController=TextEditingController().obs;
  Rx<PharmacyModel> currentPharmacy=Get.find<AuthController>().currentLoggedInPharmacy.value.obs;
 


@override
  void onInit() {
    super.onInit();
    Get.find<AuthController>().currentLoggedInPharmacy.listen((p0) {
      currentPharmacy.value=p0;
    });
  }

  

 Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(){

  return  FirebaseFirestore.instance.collection("Orders").where("Pharmacies",arrayContains:FirebaseAuth.instance.currentUser!.uid ).snapshots();
  }

    Future getUserCreatedOrder(String userid) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .get().then((value) {
          if(value.exists){
            return UserModel.fromDocumentSnapshot(value);
          }
        });
}

Future getOrderDetails(String orderid)async{
  log("get order details calledd");
  await FirebaseFirestore.instance.collection("Orders").doc(orderid).get().then((value) {
    if(value.exists){
      orderDetails.value=PrescriptionOrder.fromDocumentSnapshot(value);
    }
  });
}

Future changeOrderStatusToDelivered(String orderid)async{
  await FirebaseFirestore.instance.collection("Orders").doc(orderid).update({
    "OrderStatus":"Delivered"
  });
}
}