import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



class MyAccountController extends GetxController{
    RxString currentUserID = "".obs;
  Rx<TextEditingController> searchPlace = TextEditingController().obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
 RxString profilePickedPath="".obs;

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

 Future changeCurrentProfilePictureFromGallery()async{
    XFile? file=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(file!=null){
      profilePickedPath.value=file.path;
           if(Get.isBottomSheetOpen!){
      Get.back();
    }
    showLoadingDialog();
     String downlodurl= await uploadImageToDatabase();
   
           await FirebaseFirestore.instance.collection("pharmacies").doc(currentLoggedInPharmacy.value.userid).update({"profileImageLink":downlodurl});
  Get.back();
     
    }else{
      return null;
    }
  }
   Future changeCurrentProfilePictureFromCamera()async{
    XFile? file=await ImagePicker().pickImage(source: ImageSource.camera);
    if(file!=null){
            profilePickedPath.value=file.path;

        if(Get.isBottomSheetOpen!){
      Get.back();
    }
    showLoadingDialog();
     String downlodurl= await uploadImageToDatabase();
  
           await FirebaseFirestore.instance.collection("pharmacies").doc(currentLoggedInPharmacy.value.userid).update({"profileImageLink":downlodurl});

     Get.back();
    }else{
      return null;
    }
  }

  //upload profile image to Firebase Storage
  Future<String> uploadImageToDatabase() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final storage = FirebaseStorage.instance.ref("Pharmacyprofiles/$userId");
    if (profilePickedPath.value.isNotEmpty) {
      File profileImageToUpload = File(profilePickedPath.value);
      await storage.putFile(profileImageToUpload);
      String downloadUrl = await storage.getDownloadURL();
      return downloadUrl;
    }
    return "";
  }
    //loading dialog
  void showLoadingDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              Text("Loading...".tr)
            ],
          ),
        ),
      ),
    );
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