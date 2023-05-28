import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

 final accountController =Get.find<AuthController>();
 Rx<PharmacyModel> currentpharmacy=PharmacyModel(lat: 0.0, long: 0.0).obs;
 RxInt badgeCounter=0.obs;

  @override
  void onInit() async{
    super.onInit();
    await getCurrentLoggedPharmacy();
    accountController.currentLoggedInPharmacy.listen((p0) {
      log("changed current user from current pharmacy");
      currentpharmacy.value=p0;
    });
    log(currentpharmacy.value.userid!);

    //for notification bage 
   await countIncludedOrders();
  }

 

  
  

getCurrentLoggedPharmacy()async{
  if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseFirestore.instance.collection('pharmacies').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
    if(value.exists){
      currentpharmacy.value=PharmacyModel.fromDocumentSnapshot(value);
    }
  });
  }

}
  Future  countIncludedOrders()async{
  
log(currentpharmacy.value.userid!);
 await    FirebaseFirestore.instance.collection("Orders").where("Pharmacies",arrayContains:currentpharmacy.value.userid ).where("OrderStatus",isEqualTo: "Pending").get().then((value) {
      if(value.docs.isNotEmpty){
        badgeCounter.value=value.docs.length;
      print(badgeCounter.value);
      }
      
    });

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTopProducts(){
     return FirebaseFirestore.instance.collection("Products").where("pharmacyId",isEqualTo: currentpharmacy.value.userid).orderBy("discountPercent",descending: true).snapshots();
  }

 


}