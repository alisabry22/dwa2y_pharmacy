import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  RxBool hasLocationPermission = false.obs;

  RxDouble long = 0.0.obs;
  RxDouble lat = 0.0.obs;
  late StreamSubscription<Position> positionSetting;
  @override
  void onInit() {
    checkLocationServices();

    super.onInit();
  }

  @override
  void onClose() {

    super.onClose();
    positionSetting.cancel();
  }

  void checkLocationServices() async {
   PermissionStatus hasLocationPermission=await Permission.location.status;
    log("Before start ${hasLocationPermission.toString()}");
    if(hasLocationPermission.isDenied){
      Get.snackbar("Error","Please Enable GPS to Access Our App Easily",snackPosition: SnackPosition.TOP,duration: const Duration(milliseconds: 30));
    PermissionStatus requestAgain=  await Permission.location.request();
       if (requestAgain.isPermanentlyDenied){
      Get.defaultDialog(title: "GPS ERROR",content: const Text("Please enable GPS from APP Settings"));
    }else if (requestAgain.isGranted){
      getLocation();
    }
    }else if (hasLocationPermission.isPermanentlyDenied){
      Get.defaultDialog(title: "GPS ERROR",content: const Text("Please enable GPS from APP Settings"));
    }else if (hasLocationPermission.isGranted){
      getLocation();
    }
 
  }

  void getLocation() {
    positionSetting = Geolocator.getPositionStream().listen((event) {
      long.value = event.longitude;
      lat.value = event.latitude;
    });
  }
}
