

import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:dwa2y_pharmacy/add_address.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Controllers/googlemaps_controller.dart';
import 'Utils/Constants/constants.dart';
import 'Widgets/custom_elevated_button.dart';

class GoogleMapPage extends GetView<GoogleMapServicers> {
  const GoogleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Text("3lagy".tr.tr,style: const TextStyle(fontWeight: FontWeight.w500,color: Constants.textColor),),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme:const IconThemeData(color: Constants.textColor),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.primaryColor.withOpacity(0.6),
                  Constants.primaryColor.withOpacity(0.3),
                ]),
          ),
          child: Stack(
            children: [
              GetX<GoogleMapServicers>(
                builder: (controller) {
                  return GoogleMap(
                    initialCameraPosition: controller.cameraPosition.value,
             minMaxZoomPreference: const MinMaxZoomPreference(15, 16),
                zoomControlsEnabled: false,

                    markers: Set<Marker>.of(controller.markers),
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController cont) {
                      controller.mapController = cont;
                      controller.updateCameraPosition();
                    },
                  );
                },
              ),
              Positioned(
                top: 20,
                left: 10,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width ,
                      child: GetX<GoogleMapServicers>(
                        builder: (controller) {
                          return CustomTextField(
                            controller: controller.searchPlace.value,
                            hintText: controller.fullAddress.value.isNotEmpty?controller.fullAddress.value:"Pick Place",
                            onchanged: (p0) {
                            //  controller.updateLocation(p0);
                            },
                            validator: (p0) {
                              return null;
                            },
                            obscureValue: false,
                            suffixIcon: const Icon(Icons.search),
                          );
                        },
                      )),
                ),
              ),
              Positioned(
                top: 20,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 15),
                  child: GetX<GoogleMapServicers>(
                    builder: (controller) {
                      if (controller.placePredictions.isNotEmpty) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.white,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  controller.getLatAndLong(
                                      controller
                                          .placePredictions[index].placeId!,
                                      controller.placePredictions[index]
                                          .description!);
                                  controller.updateMarkers();
                                  controller.updateCameraPosition();
                                  controller.placePredictions.value = [];
                                },
                                child: ListTile(
                                  title: Text(
                                    "${controller.placePredictions[index].description}",
                                    style:
                                        TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                            itemCount: controller.placePredictions.length,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Positioned(
                  right: 20,
                  bottom: 60,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                    
                    backgroundColor: Constants.btnColor,
                   shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
              
        ),
                          onPressed: ()async {
                            await controller.getCurrentLocation();
                          },
                          child: Row(
                            children:  [
                              Text("Locate Me".tr,style: const TextStyle(fontSize:14,fontWeight: FontWeight.w500 ,color: Colors.white),),
                              const Icon(FontAwesomeIcons.locationDot,color: Colors.white,),
                            ],
                          )),
                    ],
                  )),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: CustomElevatedButton(
                    onPressed: () {
                      controller.updateFirebaseLocation();
                      Get.off(()=>AddAddress());
                    },
                    text: "CONFIRM LOCATION".tr,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width ,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
