

import 'package:dwa2y_pharmacy/Models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controllers/address_controller.dart';
import '../Controllers/googlemaps_controller.dart';
import '../Utils/Constants/constants.dart';
import '../Widgets/custom_address_text_field.dart';
import '../Widgets/custom_elevated_button.dart';
import '../googlemap_page.dart';


class EditAddress extends GetView<AddressController> {

  EditAddress({super.key,required this.address});
  final AddressModel address;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "3lagy".tr,
          style: const TextStyle(
              color: Constants.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Constants.textColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GetX<GoogleMapServicers>(
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            controller.fullAddress.value,
                            style: const TextStyle(  fontSize: 14,),
                          )),
                      Stack(children: [
                        SizedBox(
                          width: 80,
                          height: 60,
                          child: GoogleMap(
                            initialCameraPosition:
                                controller.cameraPosition.value,
                            zoomControlsEnabled: false,
                            markers: Set<Marker>.of(controller.markers),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: 0.5,
                              child: Material(
                                child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    Get.to(() => const GoogleMapPage());
                                  },
                                  child: Ink(
                                    child: Container(
                                      color: Colors.grey,
                                      child: Center(
                                          child: Text(
                                        "Edit".tr,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Constants.textColor),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ])
                    ],
                  );
                },
              ),
              const Divider(color: Colors.grey),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Additional Address Details".tr,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAddressField(controller: controller.street.value, hintText: address.street!),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "PERSONAL INFORMATION".tr,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                 
                    CustomAddressField(controller: controller.nearby.value, hintText: address.nearby!),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
         
           
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  onPressed: ()async {
                  
                            AddressModel address=AddressModel(
                        street: controller.street.value.text.trim(),
                          apartmentNumber: "",
                          floor: "",
                        label: "Work",
                        nearby: controller.nearby.value.text.trim(),
                        lat: controller.homeController.currentpharmacy.value.lat,
                        long: controller.homeController.currentpharmacy.value.long,

                      );
                    await  controller.updateAddress(address);
                    Get.back();
                      
                  
                    
                    
                  },
                  text: "SAVE ADDRESS".tr),
            ]),
          ),
        ),
      ),
    );
  }
}
