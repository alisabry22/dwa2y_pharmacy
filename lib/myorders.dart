

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'Models/prescription_model.dart';
import 'Models/user_model.dart';
import 'Widgets/custom_elevated_button.dart';
import 'order_details.dart';


class MyOrders extends GetView<OrderController> {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          child: GetX<OrderController>(
            builder: (controller) {
              return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                 height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                              controller.pendingPicked.value=true;

                              },
                              child: Ink(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:controller.pendingPicked.value? Colors.white:Colors.grey.shade300,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Pending".tr,
                                    style:const TextStyle(fontSize: 14),
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            InkWell(
                              onTap: (){
                                controller.pendingPicked.value=false;
                              },
                              child: Ink(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: controller.pendingPicked.value? Colors.grey.shade300:Colors.white,
                                  ),
                                  child: Center(
                                      child: Text("Completed".tr,
                                          style: const TextStyle(fontSize: 14),)),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                 const SizedBox(height: 15,),
                       Obx(()=>
                       controller.longpressed.value == true? Material(
                                child: InkWell(
                                  onTap: () async {
                                     if (controller.selectedOrders.isNotEmpty) {
                                      
                                    
                                   await Get.defaultDialog(
                                    title: "Delete Orders".tr,
                                    content: Text("${"Are you sure to delete".tr} ${controller.selectedOrders.length}  ${"?".tr}",style: const TextStyle(fontSize: 14),),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomElevatedButton(width: 100,height: 40, onPressed: ()async{
                                            await controller.deleteOrders();
                                      controller.longpressed.value = false;
                                      controller.selectedOrders.clear();
                                      Get.back();
                                          }, text: "Yes".tr),
                                     CustomElevatedButton( width:100,height: 40, onPressed: (){}, text: "No".tr),
                                        ],
                                      ),
                                    ],
                                     
                                   );
                                     }
                                   
                                  },
                                  child: Ink(
                                    child: const Align(
                                      alignment: Alignment.topRight,
                                      child:  Icon(
                                        FontAwesomeIcons.trash,
                                        color: Constants.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                       ):Container(),),
                StreamBuilder(
                  stream: controller.getOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData&&snapshot.data!.docs.isNotEmpty) {
                         return Expanded(
                                 child: ListView.separated(
                                     itemBuilder: (context, index) {
                     PrescriptionOrder order =
                                    PrescriptionOrder.fromDocumentSnapshot(snapshot.data!.docs[index]);
                                       log(snapshot.data!.docs.length.toString());
                                      if( order.orderStatus!="Delivered"&&controller.pendingPicked.value==true){
                              return Material(
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: ()async{
                                      UserModel usercreatedOrder=UserModel(lat: 0.0, long: 0.0);
                                   usercreatedOrder=   await controller.getUserCreatedOrder(order.userMadeOrder!);
                                   
                                      Get.to(()=>OrderDetails(orderid: order.orderid!, usercreatedOrder:usercreatedOrder ));
                                    },
                                    child: Ink(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: Colors.grey,
                                          child: ListTile(
                                            title: Text(
                                                order.orderDate!.toString().substring(0,11),
                                              style: const TextStyle(
                                                  color: Colors.black,fontSize: 14),
                                            ),
                                            subtitle:  Text("Tap to View Details".tr.tr,style: const TextStyle(fontSize:12,fontWeight: FontWeight.w400 ,color: Colors.grey)),
                                            trailing: Text(order.orderStatus!.tr, style:
                                                            const TextStyle(fontSize: 12),),
                                            leading:    CircleAvatar(
                                                radius: 20,
                                                   backgroundImage:order.pickedImages!=null && order.pickedImages!.isNotEmpty? CachedNetworkImageProvider(
                                                        order.pickedImages!
                                                            .first)as ImageProvider:const AssetImage("assets/images/pharmacy.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                );
                            }
                            
                                
                            else if(controller.pendingPicked.value==false && order.orderStatus=="Delivered") {
                          
                              return Material(
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: ()async{
                                      UserModel usercreatedOrder=UserModel(lat: 0.0, long: 0.0);
                                   usercreatedOrder=   await controller.getUserCreatedOrder(order.userMadeOrder!);
                                      log(usercreatedOrder.toString());
                                      Get.to(()=>OrderDetails(orderid: order.orderid!, usercreatedOrder:usercreatedOrder));
                                    },
                                    child: Ink(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: Colors.grey,
                                          child: ListTile(
                                            title: Text(
                                              order.orderDate!.toString().substring(0,11),
                                              style: const TextStyle(fontSize: 14)
                                            ),
                                            trailing: Text(order.orderStatus!.tr,style: const TextStyle(fontSize: 12)),
                                            subtitle:  Text("Tap to View Details".tr.tr,style: const TextStyle(fontSize:12,fontWeight: FontWeight.w400 ,color: Colors.grey)),
                                            leading: CircleAvatar(
                                              radius: 15,
                                                backgroundImage:order.pickedImages!=null &&order.pickedImages!.isNotEmpty?
                                                    CachedNetworkImageProvider(
                                                        order.pickedImages!
                                                            .first)as ImageProvider:AssetImage("assets/images/pharmacy.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                );
                            }else{
                              return Container();
                            }
                                  
                                       
                                        
                                     },
                                       
                                     
                                     separatorBuilder: (context, index) {
                                       return const SizedBox(
                                         height: 10,
                                       );
                                     },
                                     itemCount: snapshot.data!.docs.length),
                               );


 
                                           
                        } else{
                      return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Center(
                                child: Text("Try to Get Some Orders".tr,style: const TextStyle(color: Constants.textColor,fontWeight: FontWeight.w500),),
                                                ),
                              ],
                            ),
                          );
                    }
                        
                        
                     
                     
                      }  else if (snapshot.connectionState ==ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{
                      return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Center(
                                child: Text("Try to Get Some Orders".tr,style: const TextStyle(color: Constants.textColor,fontWeight: FontWeight.w500),),
                                                ),
                              ],
                            ),
                          );
                    }
                  
                  },
                )
              ],
            );
            },
          
          ),
        ),
      ),
    );
  }
}
