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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
        title:  Text("Order Details".tr,
            style: const TextStyle(
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
                                  "${"Medicine Name".tr} ${order.text}",
                                  style: const TextStyle(fontSize: 14),
                                )
                              : Container(),
                          Text(
                            "${"Order Date".tr} : ${  order.orderDate!.toString().substring(0,11)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${"Customer Name:".tr} ${usercreatedOrder.username}",
                                style: const TextStyle(fontSize: 14),
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
                                            color: Colors.white,
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
                                      "${"Address".tr} :${usercreatedOrder.addresses![usercreatedOrder.defaultAddressIndex!].city}  ${usercreatedOrder.addresses![usercreatedOrder.defaultAddressIndex!].street} ${usercreatedOrder.addresses![usercreatedOrder.defaultAddressIndex!].blocknumber}  ${usercreatedOrder.addresses![usercreatedOrder.defaultAddressIndex!].floor}",
                                      softWrap: true,
                                      style: const TextStyle(
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
                            "${"Order Number:".tr} $orderid",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("${"Payment Method :".tr} ${"In Cash".tr}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14)),
                                   const SizedBox(
                            height: 10,
                          ),
                                  Text("${"Order Status :".tr} ${order.orderStatus!.tr} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                                       const SizedBox(
                            height: 10,
                          ),
                         
                          order.acceptedby != null &&
                                  order.acceptedby!.isNotEmpty
                              ? Text("${"Price :".tr} ${order.amount} ",
                                  style: const TextStyle(
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
                                          hintText: "Offer him a price".tr,
                                          validator: (p0) {
                                            return null;
                                          },
                                          controller:
                                              controller.priceController.value),
                                    ),
                                     Padding(
                                       padding: const EdgeInsets.all(15.0),
                                       child: CustomTextField(
                                                             hintText: " NOTE :".tr,
                                               
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
                                            width: 130,
                                            height: 50,
                                            onPressed: () async {
                                              if (order.orderStatus == "Waiting For Delivery") {
                                                Get.back();
                                                Get.snackbar("Too Late".tr,"Customer Accepted Another Pharmacy Offer".tr,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    duration: const Duration(
                                                        milliseconds: 30));
                                              } else {
                                                if (controller.priceController.value.text.isNotEmpty && controller.priceController.value.text!="0") {
                                                  //send notification back to user with customized price
                                                  var data={
                                                        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                                           'status': 'done',
                                                           "orderid": order.orderid!,
                                                           "price":controller.priceController.value.text.trim(),
                                                           "pharmacyId":FirebaseAuth.instance .currentUser!.uid,
                                                           "pharmacyName": notificationCont.currentLoggedInPharmacy.value.username!

                                                  };
                                                  if(usercreatedOrder.locale=="ar"){
                                                                      //send arabic notification
                                    await notificationCont .sendNotificationback(usercreatedOrder.token!,data,
                                                          "عرض جديد لديك".tr, "${notificationCont.currentLoggedInPharmacy.value.username} يعرض عليك  ${controller.priceController.value.text.trim()} للطلب الخاص بكم سارع بالرد عليه ");
                                                  }
                                  
                                                  else{
                                                    //send english notification
        await notificationCont .sendNotificationback(usercreatedOrder.token!,data,
                                                          "New Offer For Your Order", "${notificationCont.currentLoggedInPharmacy.value.username} Offers You ${controller.priceController.value.text.trim()}  Get Back Fast!!");
                                                  }
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
                                                      "Offer him a price".tr,
                                                      "Please Offer Him price for Prescription".tr,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                }
                                              }
                                            },
                                            text: "Accept".tr),
                                        CustomElevatedButton(
                                            width: 130,
                                            height: 50,
                                            onPressed: () async {
                                              Get.back();
                                  var data={
                                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                    'status': 'reject',
                                    'order_id':orderid,
                                   'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
                                    'pharmacyname':notificationCont.currentLoggedInPharmacy.value.username
                                  };
                                 if(usercreatedOrder.locale=="ar"){
                                  //send arabic notification
                                      await notificationCont.sendRejectNotification(usercreatedOrder.token!,data,"تم رفض طلبك",
                                      "${notificationCont.currentLoggedInPharmacy.value.username},  رفضت الطلب المقدم منك ");
                                await notificationCont.onRejectOrder(orderid);
                                 }else{
                                  //send english notification
                                      await notificationCont.sendRejectNotification( usercreatedOrder.token!,data,
                                          "Rejected your Order","${notificationCont.currentLoggedInPharmacy.value.username!}, Rejected your Order");
                                await notificationCont.onRejectOrder(orderid);

                                 }
                                            },
                                            text: "Reject".tr),
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
                                                .changeOrderStatusToDelivered(orderid,usercreatedOrder,"delivered");
                                                order.orderStatus="Delivered";
                                          },
                                          text: "Set to Delivered".tr),
                                    
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
