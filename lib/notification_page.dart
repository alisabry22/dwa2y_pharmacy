import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Models/prescription_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:dwa2y_pharmacy/order_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../Controllers/notification_controller.dart';
import 'Utils/Constants/constants.dart';

class Notifications extends GetView<NotificationController> {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifications ",
          style: GoogleFonts.poppins(color: Constants.textColor, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Constants.textColor),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey)],
        ),
        child: Column(
          children: [
            StreamBuilder(
              stream: controller.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            PrescriptionOrder order=PrescriptionOrder.fromDocumentSnapshot(snapshot.data!.docs[index]);
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              shadowColor: Colors.grey,
                              child: SizedBox(
                                child: InkWell(
                                  onTap: ()async{
                                 await controller.getUserCreatedOrder(order.userMadeOrder!);
                                    Get.to(()=>OrderDetails(orderid: order.orderid!, usercreatedOrder: controller.userCreatedOrder.value));
                                  },
                                  child: Ink(
                                    child: ListTile(
                                      leading:order.pickedImages!=null&&order.pickedImages!.isNotEmpty? CircleAvatar(backgroundImage: CachedNetworkImageProvider(order.pickedImages![0]),):const CircleAvatar(backgroundImage:  AssetImage("assets/images/patient.png"),),
                                      title: const Text("Order Request"),
                                      trailing: const Text("Tap To View"),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: snapshot.data!.docs.length),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
