
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/notification_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/prescription_model.dart';
import '../Widgets/custom_elevated_button.dart';


class OrderController extends GetxController with GetSingleTickerProviderStateMixin{
  Rx<PrescriptionOrder>orderDetails=PrescriptionOrder().obs;
  Rx<TextEditingController>priceController=TextEditingController().obs;
  Rx<TextEditingController>notesText=TextEditingController().obs;
  Rx<PharmacyModel> currentPharmacy=Get.find<AuthController>().currentLoggedInPharmacy.value.obs;
  RxList<PrescriptionOrder> selectedOrders=<PrescriptionOrder>[].obs;
RxList<PrescriptionOrder> deletedOrders=<PrescriptionOrder>[].obs;
RxList<PrescriptionOrder> orders=<PrescriptionOrder>[].obs;

RxList<PrescriptionOrder> pendingOrders = <PrescriptionOrder>[].obs;
  RxList<PrescriptionOrder> completedOrders = <PrescriptionOrder>[].obs;
  late TabController tabController;

  RxBool delivered=false.obs;
RxBool pendingPicked=true.obs;
RxBool longpressed=false.obs;
@override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
      pendingOrders.bindStream(getPendingOrders());
    completedOrders.bindStream(getCompletedOrders());
    Get.find<AuthController>().currentLoggedInPharmacy.listen((p0) {
      currentPharmacy.value=p0;
    });
       tabController.addListener(() {
      selectedOrders.clear();
      longpressed.value = false;
    });
  }
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  
 Stream<List<PrescriptionOrder>> getPendingOrders() {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Pharmacies",arrayContains:FirebaseAuth.instance.currentUser!.uid )
        .where("OrderStatus", isNotEqualTo: "Delivered")
        .orderBy("OrderStatus")
        .orderBy("OrderDate", descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => PrescriptionOrder.fromDocumentSnapshot(e))
          .toList();
    });
  }
    Stream<List<PrescriptionOrder>> getCompletedOrders() {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Pharmacies",arrayContains:FirebaseAuth.instance.currentUser!.uid )
        .where("OrderStatus", isEqualTo: "Delivered")
        .where("hideForPharmacy",isNotEqualTo: true)
        .orderBy("hideForPharmacy")
        .orderBy("OrderDate", descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => PrescriptionOrder.fromDocumentSnapshot(e))
          .toList();
    });
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

Future changeOrderStatusToDelivered(String orderid,UserModel usercreatedOrder,String orderStatus)async{
  await FirebaseFirestore.instance.collection("Orders").doc(orderid).update({
    "OrderStatus":"Delivered"
  });
  await sendNotificationBack(orderid, usercreatedOrder,orderStatus);
  
  
}

Future sendNotificationBack(String orderid,UserModel usercreatedOrder,String orderStatus)async{
 final notificationCont= Get.find<NotificationController>();
   var data={
                                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                    'status': orderStatus,
                                    'order_id':orderid,
                                   'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
                                    'pharmacyname':notificationCont.currentLoggedInPharmacy.value.username
                                  };
                                 if(usercreatedOrder.locale=="ar"){
                                  //send arabic notification
                                      await notificationCont.sendRejectNotification(usercreatedOrder.token!,data,"تم توصيل طلبك",
                                      "${notificationCont.currentLoggedInPharmacy.value.username},  تم توصيل طلبك بنجاح");
                             
                                 }else{
                                  //send english notification
                                      await notificationCont.sendRejectNotification( usercreatedOrder.token!,data,
                                          "Order Delivered","${notificationCont.currentLoggedInPharmacy.value.username!}, sucessfully delivered your order");
                          
}
}

Future deleteOrders()async{

    await FirebaseFirestore.instance
        .collection("Orders")
        .where("Pharmacies",arrayContains:FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          orders.add(PrescriptionOrder.fromDocumentSnapshot(element));
          orders.refresh();
        }
      }
    });
    if (selectedOrders.isNotEmpty) {
      for (var element in selectedOrders) {
        deletedOrders.add(element);
      }
   
//pharmacy can't delete pending order only reject or accept
//pharmacy can only delete delivered

      for(var element in deletedOrders){
        if(element.orderStatus=="Delivered"){
  await FirebaseFirestore.instance.collection("Orders").doc(element.orderid).update({"hideForPharmacy":true});

        }
        }
      }
   
      selectedOrders.clear();
      deletedOrders.clear();
      longpressed.value=false;
  
    }


  
  


showDeleteDialog() {
    Get.defaultDialog(
      title: "Delete Orders".tr,
      content: Text("${"Are you sure to delete".tr} ${selectedOrders.length}  ${"?".tr}"),
      confirm: CustomElevatedButton(
          width: 120,
          height: 50,
          onPressed: () async {
            //call delete order function
            Get.back();
           await deleteOrders();

          },
          text: "Confirm".tr),
      cancel: CustomElevatedButton(
          width: 120,
          height: 50,
          onPressed: () {
            Get.back();
            selectedOrders.clear();
            longpressed.value = false;
          },
          text: "Cancel".tr),
    );
  }
}