import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/chat_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/localization_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/notification_controller.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/login_screen.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../myaddress.dart';
import 'location_controller.dart';

class AuthController extends GetxController {
  late Rx<User?> currentUser;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  StreamSubscription? listener;
  //sign up attributes

  //TextEditing Controllers for Signup screen
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;

  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  RxString profileImagePath = "".obs;
  RxString countrycode = "EG".obs;
  RxString dialCode = "+20".obs;
  RxBool obscurepassword = true.obs;
  Rx<PharmacyModel> currentLoggedInPharmacy =PharmacyModel(lat: 0.0, long: 0.0).obs;
  Rx<AddressModel> addressModel = AddressModel(
          street: "",
          googleAddress: "",
          lat: 0.0,
          long: 0.0,
          nearby: "",
          apartmentNumber: "")
      .obs;
  /////////////////////////////////////
  late SharedPreferences sharedprefs;

  //current user stream
  Rx<PharmacyModel> currentPharmacy=PharmacyModel(lat: 0.0, long: 0.0).obs;
  StreamSubscription<DocumentSnapshot>? listenStream;

  @override
  void onInit() async {
    super.onInit();
    currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(currentUser, _routeUser);
    sharedprefs = await SharedPreferences.getInstance();
  }

   Future showAddressDialog()async{
      await Get.defaultDialog(
        barrierDismissible: false,
        title: "Add First Address".tr,
        content:  Text("You Need To Add Your first Address".tr),
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
             backgroundColor: Constants.btnColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: (){
          Get.off(()=>const  MyAddresses());
         
        }, child: Text("Add Address".tr,style: TextStyle(fontSize:16,color: Colors.white),)),
      );
     }

  _routeUser(User? user) async{
    if (user != null) {
      Get.to(() => const Dashboard());
      await FirebaseFirestore.instance.collection("pharmacies").doc(user.uid).get().then((value) {
        currentLoggedInPharmacy.value=PharmacyModel.fromDocumentSnapshot(value);
      });
      getCurrentLoggedInUserData();
     await Get.find<NotificationController>().getToken();
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  //pick profile image
  Future pickprofileImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      profileImagePath.value = file.path;
    } else {
      return null;
    }
  }

  //sign up pharmacy
  Future signUpWithEmailandPassword() async {
     showLoadingDialog();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.value.text.trim(),
              password: passwordController.value.text.trim());

      sharedprefs.setString("UserID", credential.user!.uid);
     
      return [true, "login"];
    } on FirebaseAuthException catch (e) {
       Get.back();
      return [false, e.code];
    }
  }

  //log in
  Future signInMethod() async {
    showLoadingDialog();
    try {
      final usercredintial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.value.text.trim(),
              password: passwordController.value.text.trim());

      sharedprefs.setString("UserID", usercredintial.user!.uid.toString());

      Get.back();
      return [true, "login"];
    } on FirebaseAuthException catch (e) {
      Get.back();

      return [false, e.code.toString()];
    }
  }

  //save data in firebase
  Future saveDataInFirebase(photolink) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final usersCollection = FirebaseFirestore.instance.collection("pharmacies");
    final locationController = Get.find<LocationController>();
    currentLoggedInPharmacy.value = PharmacyModel(
      username: usernameController.value.text,
      phone: phoneController.value.text,
      countrycode: countrycode.value,
       locale: Get.find<LanguageController>().locale.value.languageCode,
      token:"",
      userid: FirebaseAuth.instance.currentUser!.uid,
      profileImageLink: photolink,
      email: emailController.value.text.trim(),
      lat: locationController.lat.value,
      long: locationController.long.value,
      
      status: "online",
      createdAt: DateTime.now().toLocal().toString(),
      updatedAt: DateTime.now().toLocal().toString(),
      
    );
   
    final jsonMap = currentLoggedInPharmacy.value.pharmacyModeltoJson();
    await usersCollection.doc(userId).set(jsonMap);
     await Get.find<NotificationController>().getToken();
  }

  //upload profile image to Firebase Storage
  Future<String> uploadImageToDatabase() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final storage = FirebaseStorage.instance.ref("Pharmacyprofiles/$userId");
    if (profileImagePath.value.isNotEmpty) {
      File profileImageToUpload = File(profileImagePath.value);
      await storage.putFile(profileImageToUpload);
      String downloadUrl = await storage.getDownloadURL();
      return downloadUrl;
    }
    return "";
  }

  //save in firebasefirestore
  Future saveWholeDataInDatabase() async {
   
    String photourl = await uploadImageToDatabase();
    await saveDataInFirebase(photourl);
    Get.back();
    //clear text fields
    usernameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
    phoneController.value.clear();
    profileImagePath.value = "";
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

  Future logout() async {
    if(listener!=null){
      await listener!.cancel();
    }
   await Get.delete<HomeController>();
   await Get.delete<ChatController>();
  
    await FirebaseAuth.instance.signOut();
  }

  getCurrentLoggedInUserData()async{

    if(currentUser.value!=null){
  listener=  FirebaseFirestore.instance.collection("pharmacies").doc(currentUser.value!.uid).snapshots().listen((event) {
        if(event.exists){
          currentLoggedInPharmacy.value=PharmacyModel.fromDocumentSnapshot(event);
          currentLoggedInPharmacy.refresh();

        }
      });
    }
  }
   Future <bool> checkLocationNotEmpty()async{
      //get Current Location

             final locationController = Get.find<LocationController>();
             await locationController.checkLocationServices();
             log(locationController.lat.value.toString());
    if(locationController.lat.value!=0.0&& locationController.long.value!=0.0){
      return true;
  
      }else {
            return false;
      }
      
  
  
   
  
}
}
