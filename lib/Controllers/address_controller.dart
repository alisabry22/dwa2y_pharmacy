

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';


class AddressController extends GetxController{

  Rx<TextEditingController> street=TextEditingController().obs;
  Rx<TextEditingController>  nearby=TextEditingController().obs;
     Rx<TextEditingController> floor=TextEditingController().obs;
Rx<TextEditingController> apartmentNmber=TextEditingController().obs;
 Rx<TextEditingController> cityController=TextEditingController().obs;
  Rx<TextEditingController> blockNumber=TextEditingController().obs;
RxDouble lat=0.0.obs;
 final homeController=Get.find<HomeController>();
   RxDouble long=0.0.obs;

  final  addAddresKey=GlobalKey<FormState>();

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
        lat.value=homeController.currentpharmacy.value.lat;
    long.value=homeController.currentpharmacy.value.long;
    homeController.currentpharmacy.listen((p0) {
      lat.value=p0.lat;
       long.value=p0.long;
     
    });
  }
Future saveAddress()async{


  List<Placemark> placemarks=await placemarkFromCoordinates(lat.value, long.value);
  
  String fullAddress="${placemarks.first.administrativeArea!} ${placemarks.first.subAdministrativeArea!} ${placemarks.first.locality!} ${placemarks.first.name!} ${placemarks.first.street!}";
  var data={
    "googleAddress":fullAddress,
    "street":street.value.text.trim(),
    "nearby":nearby.value.text.isNotEmpty?nearby.value.text.trim():"",
    "floor":"",
    "city":cityController.value.text.trim(),
    "blocknumber":blockNumber.value.text.trim(),
    "apartment":"",
    "lat":lat.value,
    "long":long.value,
  
  };
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":data});
}

Future removeAddress( )async{
 
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":FieldValue.delete()});

}
Future updateAddress(AddressModel address)async{
  
  List<Placemark> placemarks=await placemarkFromCoordinates(lat.value, long.value);
  
  String fullAddress="${placemarks.first.administrativeArea!} ${placemarks.first.subAdministrativeArea!} ${placemarks.first.locality!} ${placemarks.first.name!} ${placemarks.first.street!}";

 var data={
  "street":address.street,
  "googleAddress":fullAddress,
  "nearby":address.nearby,
  "apartmentNumber":address.apartmentNumber,
  "floor":address.floor,
  "lat":address.lat,
  "long":address.long,
  "label":address.label,
 };

  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"address":data});
   street.value.text="";
  floor.value.text="";
  nearby.value.text="";
  apartmentNmber.value.text="";

}


}