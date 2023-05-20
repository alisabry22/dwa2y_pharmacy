

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'location_controller.dart';

class AddressController extends GetxController{

  Rx<TextEditingController> street=TextEditingController().obs;
  Rx<TextEditingController>  nearby=TextEditingController().obs;


  final  addAddresKey=GlobalKey<FormState>();


Future saveAddress()async{

  List<Placemark> placemarks=await placemarkFromCoordinates(Get.find<LocationController>().lat.value, Get.find<LocationController>().long.value);
  
  String fullAddress="${placemarks.first.administrativeArea!} ${placemarks.first.subAdministrativeArea!} ${placemarks.first.locality!} ${placemarks.first.name!} ${placemarks.first.street!}";
  var data={
    "googleAddress":fullAddress,
    "street":street.value.text.trim(),
    "nearby":nearby.value.text.isNotEmpty?nearby.value.text.trim():"",
    "floor":"",
    "apartment":"",
    "lat":Get.find<LocationController>().lat.value,
    "long":Get.find<LocationController>().long.value,
  
  };
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":data});
}

Future removeAddress( )async{
 
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":FieldValue.delete()});

}


}