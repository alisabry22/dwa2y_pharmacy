import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_details.dart';

class PendingOrders extends GetView<OrderController> {
  const PendingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.pendingOrders.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) {
              return 
                  InkWell(
                    onTap: () async {
              
                        final UserModel usercreatedOrder =
                            await controller.getUserCreatedOrder(
                                controller.pendingOrders[index].userMadeOrder!);
                        Get.to(() => OrderDetails(
                              orderid: controller.pendingOrders[index].orderid!,
                              usercreatedOrder: usercreatedOrder,
                            ));
                      
                    },
                    child: Ink(
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            controller.pendingOrders[index].orderDate!
                                .toString()
                                .substring(0, 11),
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            controller.pendingOrders[index].orderStatus!.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                          leading: controller
                                          .pendingOrders[index].pickedImages !=
                                      null &&
                                  controller.pendingOrders[index].pickedImages!
                                      .isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      controller.pendingOrders[index]
                                          .pickedImages!.first))
                              : const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/patient.png"),
                                ),
                        ),
                      ),
                    ),
                  );
                 
                
              
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15,
              );
            },
            itemCount: controller.pendingOrders.length,
          )
        : Center(
            child: Text("Invite Customers To the App".tr),
          ));
  }
}
