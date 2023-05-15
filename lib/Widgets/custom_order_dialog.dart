import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return AlertDialog(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: StreamBuilder(
        stream: controller.listenToOrder(controller.orderId.value),
        builder: (context, snapshot) {
          if(snapshot.hasData){
           PrescriptionOrder order=PrescriptionOrder.fromDocumentSnapshot(snapshot.data!);
            return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
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
                  "New Order For You",
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(
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
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: Hero(
                                  tag: index.toString(),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        prescriptionOrder.pickedImages![index],
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
                      itemCount: prescriptionOrder.pickedImages!.length),
                ),
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
                        " ${userCreatedOrder.addresses![userCreatedOrder.defaultAddressIndex!].addressTitle} ",
                                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Phone Number: ${userCreatedOrder.addresses![userCreatedOrder.defaultAddressIndex!].phone.toString()}",
                  style: GoogleFonts.openSans(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    hintText: "Offer him a price",
      
                    validator: (p0) {
                      return null;
                    },
                    controller: controller.priceController.value),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      CustomElevatedButton(
                          width: 100,
                          height: 50,
                          onPressed: () async {
                            if(order.orderStatus=="Waiting For Delivery"){
                                 Get.back();
                             Get.snackbar("Too Late", "Maybe user got another offer from some one else",snackPosition: SnackPosition.BOTTOM,duration: const Duration(milliseconds: 30));
                           
                            }else{
                              if (controller.priceController.value.text.isNotEmpty ) {
      
                                  //send notification back to user with customized price
                              await controller.sendNotificationback(
                                  controller.orderId.value,
                                  userCreatedOrder.token!,
                                  controller.priceController.value.text.trim(),
                                  FirebaseAuth.instance.currentUser!.uid,
                                  controller
                                      .currentLoggedInPharmacy.value.username!,"Offer For Your Order","${controller.currentLoggedInPharmacy.value.username} offers you ${controller.priceController.value}");
                              await controller.addtoNotification(
                                  controller.orderId.value,
                                  userCreatedOrder.token!,
                                  userCreatedOrder.userid!,
                                  controller.priceController.value.text.trim(),
                                  FirebaseAuth.instance.currentUser!.uid,
                                  controller
                                      .currentLoggedInPharmacy.value.username!);
                                      
                            Get.back();
                            }else{
                              Get.snackbar("Offer Him Price", "Please Offer Him price for Prescription",snackPosition: SnackPosition.BOTTOM);
                            }
                            }
                            
      
                          },
                          text: "Accept"),
                      const Spacer(),
                      CustomElevatedButton(
                          width: 100,
                          height: 50,
                          onPressed: () async {
                            await controller.sendRejectNotification(controller.orderId.value,  userCreatedOrder.token!,FirebaseAuth.instance.currentUser!.uid,controller
                                      .currentLoggedInPharmacy.value.username!,"Order Rejected","${controller
                                      .currentLoggedInPharmacy.value.username!}, rejected Your Order");
                            await controller.onRejectOrder(controller.orderId.value);
                            Get.back();
                          },
                          text: "Reject"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
          }else{
            return Container();
          }
        },
          
      ),
    );
  }
}
