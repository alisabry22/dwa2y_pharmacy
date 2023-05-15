

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'location_controller.dart';

class AddressController extends GetxController{

  Rx<TextEditingController> addressTitle=TextEditingController().obs;
  Rx<TextEditingController> phone=TextEditingController().obs;
  Rx<TextEditingController> firstname=TextEditingController().obs;
  Rx<TextEditingController>  lastname=TextEditingController().obs;
  RxString label="Home".obs;
  RxInt selectedButton=0.obs;

  final  addAddresKey=GlobalKey<FormState>();


Future saveAddress()async{

  List<Placemark> placemarks=await placemarkFromCoordinates(Get.find<LocationController>().lat.value, Get.find<LocationController>().long.value);
  
  String fullAddress="${placemarks.first.administrativeArea!} ${placemarks.first.subAdministrativeArea!} ${placemarks.first.locality!} ${placemarks.first.name!} ${placemarks.first.street!}";
  var data={
    "googleAddress":fullAddress,
    "AddressTitle":addressTitle.value.text.trim(),
    "Phone":phone.value.text.trim(),
    "lat":Get.find<LocationController>().lat.value,
    "long":Get.find<LocationController>().long.value,
    "label":label.value,
  };
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":FieldValue.arrayUnion([data])});
}

Future removeAddress( AddressModel data)async{
 
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":FieldValue.arrayRemove([data.toJson()])});

}


}