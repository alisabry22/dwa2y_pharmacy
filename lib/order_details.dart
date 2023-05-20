import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/notification_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Models/prescription_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:dwa2y_pharmacy/full_photo.dart';
import 'package:dwa2y_pharmacy/googlemaps_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends GetView<OrderController> {
  const OrderDetails(
      {super.key,
      required this.orderid,
      required this.usercreatedOrder,
    });
  final UserModel usercreatedOrder;
  final String orderid;
  @override
  Widget build(BuildContext context) {
    final notificationCont = Get.find<NotificationController>();
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
        return Scaffold(
      appBar: AppBar(
        title: Text("Order Details",
            style: GoogleFonts.poppins(
                color: Constants.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Constants.primaryColor),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width:width ,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(

                  stream: controller.getOrderDetails(orderid),
                  builder: (context, snapshot) {
                  
                    if(snapshot.hasData && snapshot.data!.exists){
                        PrescriptionOrder order=PrescriptionOrder.fromDocumentSnapshot(snapshot.data!);
                      return Column(
                        children: [
                           SizedBox(
                            height: height*0.25,
                            width: width,
                             child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Material(
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      Get.to(() => EnlargePhoto(
                                            photoUrl: order.pickedImages![index],
                                            tag: index.toString(),
                                          ));
                                    },
                                    child: Ink(
                                      child: Center(
                                        child: Hero(
                                          tag: index.toString(),
                                          child: CachedNetworkImage(
                                            imageUrl: order.pickedImages![index],
                                            width: 150,
                                            height: MediaQuery.of(context).size.height *
                                                0.2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 30,
                                );
                              },
                               itemCount: order.pickedImages!.length,
                             ),
                           ),
   const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 15,
                            spreadRadius: 0.5)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          order.text != null && order.text!.isNotEmpty
                              ? Text(
                                  "Medicine Needed : ${order.text}",
                                  style: GoogleFonts.poppins(fontSize: 14),
                                )
                              : Container(),
                          Text(
                            "Order Date : ${order.orderDate}",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Customer Name : ${usercreatedOrder.username}",
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Material(
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      final Uri phoneuri = Uri.parse(
                                          "tel:${usercreatedOrder.phone}");
                                      launchUrl(phoneuri);
                                    },
                                    child: Ink(
                                      child: const CircleAvatar(
                                          backgroundColor: Constants.btnColor,
                                          radius: 15,
                                          child: Icon(
                                            FontAwesomeIcons.phone,
                                            size: 15,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              Get.to(() => GoogleMapsPage(
                                  username: usercreatedOrder.username!,
                                  lat: usercreatedOrder.lat,
                                  long: usercreatedOrder.long));
                            },
                            child: Ink(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "Address : ${usercreatedOrder.addresses![usercreatedOrder.defaultAddressIndex!].street} ",
                                      softWrap: true,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.locationDot,
                                    color: Constants.btnColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Serial : $orderid",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Payment Method : ${order.paymentMethod}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400, fontSize: 14)),
                                   const SizedBox(
                            height: 10,
                          ),
                                  Text("Order Status :${order.orderStatus} ",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                                       const SizedBox(
                            height: 10,
                          ),
                         
                          order.acceptedby != null &&
                                  order.acceptedby!.isNotEmpty
                              ? Text("Price :${order.amount} ",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14))
                              : Container(),
                          order.orderStatus != null &&
                                  order.orderStatus == "Pending"
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CustomTextField(
                                        keyboardType: TextInputType.number,
                                          hintText: "Offer him a price",
                                          validator: (p0) {
                                            return null;
                                          },
                                          controller:
                                              controller.priceController.value),
                                    ),
                                     Padding(
                                       padding: const EdgeInsets.all(15.0),
                                       child: CustomTextField(
                                                             hintText: "Notes (like free delivery)",
                                               
                                                             validator: (p0) {
                                                               return null;
                                                             },
                                                             controller: notificationCont.notestextController.value),
                                     ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomElevatedButton(
                                            width: 100,
                                            height: 50,
                                            onPressed: () async {
                                              if (order.orderStatus == "Waiting For Delivery") {
                                                Get.back();
                                                Get.snackbar("Too Late","Maybe user got another offer from some one else",
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    duration: const Duration(
                                                        milliseconds: 30));
                                              } else {
                                                if (controller.priceController
                                                    .value.text.isNotEmpty) {
                                                  //send notification back to user with customized price
                                                  await notificationCont
                                                      .sendNotificationback(
                                                          order.orderid!,
                                                          usercreatedOrder
                                                              .token!,
                                                          controller
                                                              .priceController
                                                              .value
                                                              .text
                                                              .trim(),
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          notificationCont
                                                              .currentLoggedInPharmacy
                                                              .value
                                                              .username!,
                                                          "Pharmacy Offer",
                                                          "${notificationCont.currentLoggedInPharmacy.value.username} offer you ${controller.priceController.value.text.trim()} For Your Order Get back and accept");
                                                  await notificationCont
                                                      .addtoNotification(
                                                    order.orderid!,
                                                    usercreatedOrder.token!,
                                                    usercreatedOrder.userid!,
                                                    controller.priceController
                                                        .value.text
                                                        .trim(),
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    notificationCont
                                                        .currentLoggedInPharmacy
                                                        .value
                                                        .username!,
                                                        
                                                  );
                
                                                  Get.back();
                                                } else {
                                                  Get.snackbar(
                                                      "Offer Him Price",
                                                      "Please Offer Him price for Prescription",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                }
                                              }
                                            },
                                            text: "Accept"),
                                        CustomElevatedButton(
                                            width: 100,
                                            height: 50,
                                            onPressed: () async {
                                              await notificationCont
                                                  .sendRejectNotification(
                                                      order.orderid!,
                                                      usercreatedOrder.token!,
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      controller.currentPharmacy
                                                          .value.username!,
                                                      "Order Rejected",
                                                      "${controller.currentPharmacy.value.username!}, rejected Your Order");
                                              await notificationCont
                                                  .onRejectOrder(
                                                      order.orderid!);
                                              Get.back();
                                            },
                                            text: "Reject"),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          order.orderStatus != null &&
                                  order.orderStatus == "Waiting For Delivery"&&order.orderStatus!="Delivered"
                              ?
                               Center(
                                    child: 
                                       CustomElevatedButton(
                                          width: 250,
                                          height: 5,
                                                                  
                                          onPressed: () async {
                                            await controller
                                                .changeOrderStatusToDelivered(orderid);
                                                order.orderStatus="Delivered";
                                          },
                                          text: "Set to Delivered"),
                                    
                                  )
                              
                              : Container(),

                        ],
                      )
                    
                    ),
                  ),
                ),
                        ]
                      );

                     
                         
                  }else{
                    return Container();
                  }
                  },

                           ),
          )
        )
      ),   

                  
                  );
              
              
        
  }
}
