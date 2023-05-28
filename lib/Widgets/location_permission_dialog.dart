import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationDialg extends StatelessWidget {
  const LocationDialg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration:const BoxDecoration(
        color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      
      child: Column(
        children: [
           Text(
            "GPS permission Request".tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        const  SizedBox(height: 20,),
           Text("Location permission is Required for better using of app".tr,style: const TextStyle(fontSize: 14),),
            const  SizedBox(height: 20,),
          Center(
              child: CustomElevatedButton(
            height: 60,
            width: MediaQuery.of(context).size.width*0.6,
            onPressed: () async {
              
                await Geolocator.openAppSettings();

              Get.back();
            },
            text: "Turn On Gps".tr,
          )),
        ],
      ),
    );
  }
}
