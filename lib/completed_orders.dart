import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controllers/order_controller.dart';
import 'Utils/Constants/constants.dart';
import 'order_details.dart';

class CompletedOrders extends GetView<OrderController> {
  const CompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.completedOrders.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) {
              return 
                
                Obx(()=>
                  Stack(
                    children:[
                      
                      InkWell(
                           onTap: () async{
                                              if (controller.longpressed.value == false) {
                                                final UserModel usercreatedOrder=await controller.getUserCreatedOrder(controller.pendingOrders[index].userMadeOrder!);

                                                Get.to(() => OrderDetails(
                                                                   orderid: controller.pendingOrders[index].orderid!,
                                                usercreatedOrder: usercreatedOrder,
                                                      ));
                                              } else {
                                                if (controller.selectedOrders .contains(controller.completedOrders[index])) {
                                                  controller.selectedOrders.remove(controller.completedOrders[index]);
                              
                                                  if (controller .selectedOrders.isEmpty) {
                                                    controller.longpressed.value =false;
                                                  }
                                                } else {
                                                  controller.selectedOrders
                                                      .add(controller.completedOrders[index]);
                                                }
                                              }
                                            },
                      onLongPress: () {
                       
                        if (controller.longpressed.value ==false) {
                                                controller.longpressed.value = true;
                                                controller.selectedOrders.add(controller.completedOrders[index]);
                                                controller.selectedOrders.refresh();
                                              }
                      },
                        child: Ink(
                          child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(
                              controller.completedOrders[index].orderDate!
                                  .toString()
                                  .substring(0, 11),
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              controller.completedOrders[index].orderStatus!.tr,
                              style: const TextStyle(fontSize: 14),
                            ),
                           
                            leading: controller.completedOrders[index].pickedImages !=
                                        null &&
                                    controller
                                        .completedOrders[index].pickedImages!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(controller
                                        .completedOrders[index].pickedImages!.first))
                                : const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/patient.png"),
                                  ),
                          ),
                                          ),
                        ),
                      ),
                
                   controller.selectedOrders.isNotEmpty&&   controller.selectedOrders.contains(controller.completedOrders[index])
                                                        ? const Positioned(
                                                            top: 10,
                                                            bottom: 10,
                                                            left: 2,
                                                            child: Icon(
                                                              Icons.check_circle,
                                                              color: Constants
                                                                  .primaryColor,
                                                            ))
                                                        : Container(),
                    
                    ] 
                  ),
                );
              
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15,
              );
            },
            itemCount: controller.completedOrders.length,
          )
        : Center(child: Text("Invite Customers To the App".tr)));
  }
}
