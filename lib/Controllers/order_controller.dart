
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
  Rx<TextEditingController>notesText=TextEditingController().obs;
  Rx<PharmacyModel> currentPharmacy=Get.find<AuthController>().currentLoggedInPharmacy.value.obs;
  RxList<int> selectedOrders=<int>[].obs;
RxList<PrescriptionOrder> deletedOrders=<PrescriptionOrder>[].obs;
RxList<PrescriptionOrder> orders=<PrescriptionOrder>[].obs;

  RxBool delivered=false.obs;
RxBool pendingPicked=true.obs;
RxBool longpressed=false.obs;
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

Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderDetails(String orderid){
  return  FirebaseFirestore.instance.collection("Orders").doc(orderid).snapshots();
}

Future changeOrderStatusToDelivered(String orderid)async{
  await FirebaseFirestore.instance.collection("Orders").doc(orderid).update({
    "OrderStatus":"Delivered"
  });
}
Future deleteOrders()async{
  print(selectedOrders.value.length);
 
    await FirebaseFirestore.instance.collection("Orders")
    .where("userMadeOrder",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if(value.docs.isNotEmpty){
        for (var element in value.docs) {
            orders.add(PrescriptionOrder.fromDocumentSnapshot(element));
            orders.refresh();

        }
      }
    });
    if(selectedOrders.isNotEmpty){
      for (var element in selectedOrders) {
        deletedOrders.add(orders[element]);
      }
      deletedOrders.forEach((element) {
        print(element.toJson());
      });
      for (var element in deletedOrders) {
            await FirebaseFirestore.instance.collection("Orders").doc(element.orderid).delete();
      }
      selectedOrders.clear();
      deletedOrders.clear();
      selectedOrders.refresh();
      deletedOrders.refresh();
    
    }


  
  
}
}