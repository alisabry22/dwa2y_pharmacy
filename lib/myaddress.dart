

import 'dart:developer';

import 'package:dwa2y_pharmacy/Controllers/address_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/myaccount_controller.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/googlemap_page.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'Widgets/custom_elevated_button.dart';

class MyAddresses extends GetView<MyAccountController> {
  const MyAddresses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "My Address",
          style: GoogleFonts.poppins(
              color: Constants.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Constants.textColor),
        elevation: 0,
      ),
      body: Container(
               width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
       
        child: GetX<MyAccountController>(
          builder: (controller) {
            if(controller.currentLoggedInPharmacy.value.address!.street!=null){
             return  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                             controller.currentLoggedInPharmacy.value.address!.nearby!=null?   Text(
                                                  controller
                                                      .currentLoggedInPharmacy
                                                      .value
                                                      .address!
                                                      .nearby!,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ):Container(),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                               Container(
                                                        width: 60,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 10, 94, 168),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                          "Default",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                      )
                                              
                                              ],
                                            ),
                                            Row(
                                            
                                              children: [
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "Edit",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color:
                                                                      Colors.grey),
                                                        ),
                                                      ],
                                                    )),
                              
                                                       TextButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                        title: "Delete Address",
                                                        content: const Text("Are you sure you want to delete this address"),
                                                        actions: [
                                                          TextButton(onPressed: (){
                                                            Get.back();
                                                          }, child: const Text("CANCEL")),
                                                          TextButton(onPressed: ()async{
                                                           await Get.find<AddressController>().removeAddress();
                                                           Get.back();
                                                          }, child:const  Text("OK")),
                              
                                                        ],
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.delete,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "Delete",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                  color:
                                                                      Colors.grey),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Name",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 150),
                                              child: Text(
                                                "${controller.currentLoggedInPharmacy.value.username} ",style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w400),)
                                                
                                              ),
                                            
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Address",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 60),
                                                child: Text(
                                                  "${controller.currentLoggedInPharmacy.value.address!.street}",
                                                  maxLines: 4,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Mobile Number",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 80),
                                              child: Text(
                                                "${controller.currentLoggedInPharmacy.value.phone} ",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
            
                             
                             
                        
                          );
            }else{
             return   Column(
                        children: [
                        const  Expanded(
                            
                              child:  Center(
                                child: Text(
                                    "Try to Add your Default Address For Delivery"),
                              )),
                              CustomElevatedButton(
                                height: 120,
                                onPressed: () {
                                  Get.to(()=>const GoogleMapPage());
                                },
                                width: MediaQuery.of(context).size.width,
                                text: "Add Address",
                                                      ),
                        ],
                        );
            }
          },
        
        ),
      )
    );

    
  }
}

