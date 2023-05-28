import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Controllers/home_controller.dart';

class GoogleMapsPage extends GetView<HomeController> {
  const GoogleMapsPage({super.key, required this.lat, required this.long,required this.username});
  final double lat, long;
  final String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$username's Loction",
          style: const TextStyle(color: Constants.textColor),
        ),
        iconTheme: const IconThemeData(color:Constants.textColor),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
        ),
        minMaxZoomPreference:const MinMaxZoomPreference(13, 17),
        markers: <Marker>{
             Marker(
            markerId: const MarkerId("My Position"),
            
            position: LatLng(controller.currentpharmacy.value.lat, controller.currentpharmacy.value.long),

          ),

          Marker(
            markerId: const MarkerId("Customer"),
            
            position: LatLng(lat, long),
          )
        
        },
      ),
    );
  }
}
