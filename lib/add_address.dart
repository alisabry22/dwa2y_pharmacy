
import 'package:dwa2y_pharmacy/Controllers/address_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/googlemaps_controller.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_address_text_field.dart';
import 'package:dwa2y_pharmacy/googlemap_page.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Utils/Constants/constants.dart';
import 'Widgets/custom_elevated_button.dart';

class AddAddress extends GetView<AddressController> {

  AddAddress({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Dwa2y",
          style: GoogleFonts.poppins(
              color: Constants.textColor,
              fontSize: 16,
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
                            style: GoogleFonts.poppins(),
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
                                        "Edit",
                                        style: GoogleFonts.poppins(
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
                "Additional Address Details",
                style: GoogleFonts.poppins(
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
                    CustomAddressField(controller: controller.addressTitle.value, hintText: "Enter Full Address"),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "PERSONAL INFORMATION",
                      style: GoogleFonts.poppins(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                   CustomAddressField(keyboardType: TextInputType.phone,controller: controller.phone.value, hintText: "Phone Number"),
                    const SizedBox(
                      height: 20,
                    ),
                 
                  ],
                ),
              ),
              Text(
                "Address Label (Optional) ",
                style: GoogleFonts.poppins(
                    color: Constants.textColor, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: GetX<AddressController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: controller.selectedButton.value == 1
                                ? ElevatedButton.styleFrom(
                                    backgroundColor: Constants.btnColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  )
                                : ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                            onPressed: () {
                              controller.selectedButton.value = 1;
                              controller.label.value = "Home";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  FontAwesomeIcons.house,
                                  size: 14,
                                  color: controller.selectedButton.value == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Home",
                                  style: controller.selectedButton.value == 1
                                      ? GoogleFonts.poppins(color: Colors.white)
                                      : GoogleFonts.poppins(
                                          color: Colors.black),
                                ),
                              ],
                            )),
                        ElevatedButton(
                            style: controller.selectedButton.value == 2
                                ? ElevatedButton.styleFrom(
                                    backgroundColor: Constants.btnColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  )
                                : ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                            onPressed: () {
                              controller.selectedButton.value = 2;
                              controller.label.value = "Work";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  FontAwesomeIcons.house,
                                  size: 14,
                                  color: controller.selectedButton.value == 2
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Work",
                                  style: controller.selectedButton.value == 2
                                      ? GoogleFonts.poppins(color: Colors.white)
                                      : GoogleFonts.poppins(
                                          color: Colors.black),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  onPressed: ()async {
                    if(formKey.currentState!.validate()){
                    await  controller.saveAddress();
                    Get.back();
                    }
                    
                  },
                  text: "SAVE ADDRESS"),
            ]),
          ),
        ),
      ),
    );
  }
}
