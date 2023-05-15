import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/login_screen.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location_controller.dart';

class AuthController extends GetxController {
  late Rx<User?> currentUser;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

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
          addressTitle: "",
          googleAddress: "",
          lat: 0.0,
          long: 0.0,
          phone: "",
          label: "")
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
    getCurrentLoggedInUserData();
    sharedprefs = await SharedPreferences.getInstance();
  }

 

  _routeUser(User? user) async{
    if (user != null) {
      Get.to(() => const Dashboard());
      await FirebaseFirestore.instance.collection("pharmacies").doc(user.uid).get().then((value) {
        currentLoggedInPharmacy.value=PharmacyModel.fromDocumentSnapshot(value);
      });
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
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.value.text.trim(),
              password: passwordController.value.text.trim());

      sharedprefs.setString("UserID", credential.user!.uid);
      return [true, "login"];
    } on FirebaseAuthException catch (e) {
      return [false, e.code];
    }
  }

  //log in
  Future signInMethod() async {
    showDialog();
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
      token: "",

      profileImageLink: photolink,
      email: emailController.value.text.trim(),
      lat: locationController.lat.value,
      long: locationController.long.value,
      createdAt: DateTime.now().toLocal().toString(),
      updatedAt: DateTime.now().toLocal().toString(),
      addresses: [],
    );
    Get.back();
    final jsonMap = currentLoggedInPharmacy.value.pharmacyModeltoJson();
    await usersCollection.doc(userId).set(jsonMap);
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
    showDialog();
    String photourl = await uploadImageToDatabase();
    await saveDataInFirebase(photourl);
    //clear text fields
    usernameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
    phoneController.value.clear();
    profileImagePath.value = "";
  }

  //loading dialog
  void showDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Loading...")
            ],
          ),
        ),
      ),
    );
  }

  Future logout() async {
    Get.delete<HomeController>();
    await FirebaseAuth.instance.signOut();
  }

  getCurrentLoggedInUserData()async{

    if(currentUser.value!=null){
    FirebaseFirestore.instance.collection("pharmacies").doc(currentUser.value!.uid).snapshots().listen((event) {
        if(event.exists){

          currentLoggedInPharmacy.value=PharmacyModel.fromDocumentSnapshot(event);
          currentLoggedInPharmacy.refresh();

        }
      });
    }
  }
}
