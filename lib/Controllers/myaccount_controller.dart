import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MyAccountController extends GetxController{
    RxString currentUserID = "".obs;
  Rx<TextEditingController> searchPlace = TextEditingController().obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  RxBool onLongPress = false.obs;

  Rx<PharmacyModel> currentLoggedInPharmacy = PharmacyModel(lat: 0.0, long: 0.0).obs;

  AuthController accountController = Get.find<AuthController>();

  @override
  void onInit() {
    currentLoggedInPharmacy.value = accountController.currentLoggedInPharmacy.value;
    if (currentLoggedInPharmacy.value.address != null) {
      accountController.currentLoggedInPharmacy.listen((p0) {

        currentLoggedInPharmacy.value = p0;
        currentLoggedInPharmacy.refresh();
      });
    }
    super.onInit();
  }

  Future updateBirthDay(String birthDay) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"birthday": birthDay});
  }

  Future updateType(String gender) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"gender": gender});
  }

  Future updateUserName(String username) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"username": username});
  }

  Future updateEmail(String email) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"email": email});
  }

  Future updatedefaultAddress(double lat, double long,int index) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"lat": lat, "long": long,"defaultAddressIndex":index});
  }
}