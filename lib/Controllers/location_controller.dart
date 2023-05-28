import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../Widgets/custom_elevated_button.dart';
import '../Widgets/location_permission_dialog.dart';

class LocationController extends GetxController {
  RxBool hasLocationPermission = false.obs;

  RxDouble long = 0.0.obs;
  RxDouble lat = 0.0.obs;
 

  

  Future checkLocationServices() async {
      bool serviceEnabled;
      LocationPermission locationPermission;

    serviceEnabled= await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
    await  Get.defaultDialog(
      barrierDismissible: false,
        title: "GPS permission Request".tr,
        content:  Text("Location permission is Required for better using of app".tr),
        actions: [
          CustomElevatedButton(width: 200, height: 100, onPressed: ()async{
            Location location=Location();
         await location.requestService();
  
          Get.back();
          }, text: "Turn On Gps".tr),
        ],
      
      );
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        Get.dialog(const LocationDialg(),barrierDismissible: false);
      }
    }
    
    if (locationPermission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
    await  Get.dialog(const LocationDialg(),barrierDismissible: false);
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
   await  getLocation();
    }

   Future getLocation()async {

    try {
       await Geolocator.getCurrentPosition().then((event) {
      long.value = event.longitude;
      lat.value = event.latitude;
    });
    } catch  (e) {
      if(Get.isDialogOpen!){
        Get.back();
      }
    await Get.defaultDialog(
      title: "GPS Error".tr,
      content: Text("Please Enable Gps And try Again...".tr),
      actions: [
        CustomElevatedButton(width: 120, height: 60, onPressed: (){
          Get.back();
        }, text: "Ok".tr),
      ]
    );
    } 

  }
}
