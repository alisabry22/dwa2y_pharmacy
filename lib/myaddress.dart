


import 'dart:developer';

import 'package:dwa2y_pharmacy/Controllers/address_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/myaccount_controller.dart';
import 'package:dwa2y_pharmacy/Screens/edit_address.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/googlemap_page.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


import 'Widgets/custom_elevated_button.dart';

class MyAddresses extends GetView<MyAccountController> {
  const MyAddresses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(
          "My Address".tr,
          style: const TextStyle(
              color: Constants.textColor,
              fontSize: 14,
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
            log(controller.currentLoggedInPharmacy.value.address!.toString());
            if(controller.currentLoggedInPharmacy.value.address!=null && controller.currentLoggedInPharmacy.value.address!.googleAddress!=null){
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
                                               Text(
                                                  "Work".tr,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                               Container(
                                                        width: 70,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 10, 94, 168),
                                                        ),
                                                        child:  Center(
                                                            child: Text(
                                                          "Default".tr,
                                                          style: const TextStyle(
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
                                                    onPressed: () {
                                                    Get.to(()=>EditAddress(address:controller.currentLoggedInPharmacy.value.address! ));
                                                    },
                                                    child: Row(
                                                      children:  [
                                                        const Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "Edit".tr,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors.grey),
                                                        ),
                                                      ],
                                                    )),
                              
                                                       TextButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                        title: "Delete Address".tr,
                                                        content:  Text("Are you sure you want to delete this address".tr),
                                                        actions: [
                                                          TextButton(onPressed: (){
                                                            Get.back();
                                                          }, child:  Text("Cancel".tr)),
                                                          TextButton(onPressed: ()async{
                                                               Get.back();
                                                           await Get.find<AddressController>().removeAddress();
                                                        
                                                          }, child:  Text("Confirm".tr)),
                              
                                                        ],
                                                      );
                                                    },
                                                    child: Row(
                                                      children:  [
                                                        const Icon(
                                                          Icons.delete,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "Delete".tr,
                                                          style:
                                                              const TextStyle(
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
                                             Text("Name".tr,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 80),
                                              child: Text(
                                                "${controller.currentLoggedInPharmacy.value.username} ",style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
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
                                             Text("Address".tr,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 150),
                                                child: Text(
                                                  "${controller.currentLoggedInPharmacy.value.address!.street}",
                                                  maxLines: 4,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
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
                                             Text("Nearby".tr,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 100),
                                              child: Text(
                                                "${controller.currentLoggedInPharmacy.value.address!.nearby} ",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
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
                          Expanded(
                            
                              child:  Center(
                                child: Text(
                                    "Try to Add your Default Address For Delivery".tr),
                              )),
                              CustomElevatedButton(
                                height: 120,
                                onPressed: () {
                                  Get.to(()=>const GoogleMapPage());
                                },
                                width: MediaQuery.of(context).size.width,
                                text: "Add A New Address".tr,
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

