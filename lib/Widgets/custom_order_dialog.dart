import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Controllers/notification_controller.dart';
import '../full_photo.dart';
import '../Models/prescription_model.dart';
import '../Models/user_model.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class CustomOrderDialog extends GetView<NotificationController> {
  final PrescriptionOrder prescriptionOrder;
  final UserModel userCreatedOrder;
  const CustomOrderDialog(
      {super.key,
      required this.prescriptionOrder,
      required this.userCreatedOrder});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:  controller.listenToOrder(controller.orderId.value),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container();
        }else if (snapshot.connectionState==ConnectionState.active){
          if(snapshot.hasData && snapshot.data!.exists){
            PrescriptionOrder order=PrescriptionOrder.fromDocumentSnapshot(snapshot.data!);
                  return AlertDialog(
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: 
        
                 SingleChildScrollView(
                  reverse: true,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      child: Center(
                          child: Icon(
                        Icons.delivery_dining,
                        size: 35,
                      )),
                    ),
                     Text(
                      "New Order For You".tr,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  prescriptionOrder.pickedImages!=null && prescriptionOrder.pickedImages!.isNotEmpty?  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Material(
                              child: InkWell(
                                splashColor: Colors.grey,
                                onTap: () {
                                  Get.to(() => EnlargePhoto(
                                    tag: index.toString(),
                                      photoUrl:
                                          prescriptionOrder.pickedImages![index]));
                                },
                                child: Ink(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    child: Hero(
                                      tag: index.toString(),
                                      child: CachedNetworkImage(
                                        imageUrl:prescriptionOrder.pickedImages![index],
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
                              width: 10,
                            );
                          },
                          itemCount: prescriptionOrder.pickedImages!.length)
                    ):Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          prescriptionOrder.text!=null && prescriptionOrder.text!.isNotEmpty? SizedBox(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.1,
                         
                            child: Text(
                              "${"Medicine".tr} ${prescriptionOrder.text} ",
                                              softWrap: true,
                                              style: const TextStyle(fontSize: 14,color: Constants.textColor),
                                              
                            ),
                          ):Container(),
                                 const SizedBox(
                      height: 15,
                    ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          color: Colors.blue,
                        ),
                        Expanded(
                          child: Text(
                            " ${prescriptionOrder.userAddress!.city} ${prescriptionOrder.userAddress!.street} ${prescriptionOrder.userAddress!.blocknumber} ",
                                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                      ],
                    ),
    
                 
                     
    
                  
                    Text(
                      "${"phone".tr} ${userCreatedOrder.phone!}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                        hintText: "Offer him a price".tr,
          
                        validator: (p0) {
                          return null;
                        },
                        controller: controller.priceController.value),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        hintText: " NOTE :".tr ,
          
                        validator: (p0) {
                          return null;
                        },
                        controller: controller.notestextController.value),
                         const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          CustomElevatedButton(
                              width: MediaQuery.of(context).size.width*0.32,
                              height: 50,
                              onPressed: () async {
                                if(order.orderStatus=="Waiting For Delivery"){
                                     Get.back();
                                 Get.snackbar("Too Late".tr, "Customer Accepted Another Pharmacy Offer".tr,snackPosition: SnackPosition.BOTTOM,duration: const Duration(milliseconds: 30));
                               
                                }else{
                                  if (controller.priceController.value.text.isNotEmpty && controller.priceController.value.text!="0") {
                                               
                                                  Get.back();
                                                  //send notification back to user with customized price
                                                  var data={
                                                        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                                           'status': 'done',
                                                           "orderid": order.orderid!,
                                                           "price":controller.priceController.value.text.trim(),
                                                           "pharmacyId":FirebaseAuth.instance .currentUser!.uid,
                                                           "pharmacyName": controller.currentLoggedInPharmacy.value.username!

                                                  };
                                                  if(userCreatedOrder.locale=="ar"){
                                                                      //send arabic notification
                                    await controller .sendNotificationback(userCreatedOrder.token!,data,
                                                          "عرض جديد لديك".tr, "${controller.currentLoggedInPharmacy.value.username} يعرض عليك  ${controller.priceController.value.text.trim()} للطلب الخاص بكم سارع بالرد عليه ");
                                                  }
                                  
                                                  else{
                                                    //send english notification
        await controller .sendNotificationback(userCreatedOrder.token!,data,
                                                          "New Offer For Your Order", "${controller.currentLoggedInPharmacy.value.username} Offers You ${controller.priceController.value.text.trim()}  Get Back Fast!!");
                                                  }
                                                  await controller
                                                      .addtoNotification(
                                                    order.orderid!,
                                                    userCreatedOrder.token!,
                                                    userCreatedOrder.userid!,
                                                    controller.priceController
                                                        .value.text
                                                        .trim(),
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    controller
                                                        .currentLoggedInPharmacy
                                                        .value
                                                        .username!,
                                                        
                                                  );
                
                                                
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
                          const Spacer(),
                          CustomElevatedButton(
                              width: MediaQuery.of(context).size.width*0.32,
                              height: 50,
                              onPressed: () async { 
                                 Get.back();
                                  var data={
                                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                    'status': 'reject',
                                    'order_id':controller.orderId.value,
                                   'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
                                    'pharmacyName':controller.currentLoggedInPharmacy.value.username
                                  };
                                 if(userCreatedOrder.locale=="ar"){
                                  //send arabic notification
                                      await controller.sendRejectNotification(userCreatedOrder.token!,data,"تم رفض طلبك",
                                      "${controller.currentLoggedInPharmacy.value.username},  رفضت الطلب المقدم منك ");
                                await controller.onRejectOrder(controller.orderId.value);
                                 }else{
                                  //send english notification
                                      await controller.sendRejectNotification( userCreatedOrder.token!,data,
                                          "Rejected your Order","${controller.currentLoggedInPharmacy.value.username!}, Rejected your Order");
                                await controller.onRejectOrder(controller.orderId.value);

                                 }
                            
                               
                              },
                              text: "Reject".tr),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
          }
          

          else 
        {
    
          if(Get.isDialogOpen!){

            Get.back();
             return Container();
          }else{
            return Container();
          }
         
        }
        }
  
        else 
        {

          if(Get.isDialogOpen!){
                

            Get.back();
             return Container();
          }else{
            return Container();
          }
         
        }
       
              
            },
              
          );
        
      }
    
  }

