import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Models/prescription_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/order_details.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyOrders extends GetView<OrderController> {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Orders".tr,
                    style: const TextStyle(
                        color: Constants.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(onTap: (){},child:const Icon(Icons.search)),
                  ),
                ],
              ),
              StreamBuilder(
                stream: controller.getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      if(snapshot.data!.docs.isNotEmpty){
                             return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              PrescriptionOrder order =
                                  PrescriptionOrder.fromDocumentSnapshot(snapshot.data!.docs[index]);
                          if( order.orderStatus=="Pending"){
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
                                            order.orderDate!,
                                            style: const TextStyle(
                                                color: Colors.black,fontSize: 16),
                                          ),
                                          subtitle:  Text("Tap to Accept or refuse".tr,style: const TextStyle(fontSize:12,fontWeight: FontWeight.w400 )),
                                          trailing: Text(order.orderStatus!.tr, style:
                                                          const TextStyle(fontSize: 14),),
                                          leading:   order.pickedImages!=null && order.pickedImages!.isNotEmpty? CircleAvatar(
                                      
                                                 backgroundImage: CachedNetworkImageProvider(
                                                      order.pickedImages!
                                                          .first)):Container(width: 5,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          }else if (order.orderStatus=="Waiting For Delivery"){
                         
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
                                            order.orderDate!,
                                            style: const TextStyle(fontSize: 16)
                                          ),
                                          trailing: Text(order.orderStatus!.tr,style: const TextStyle(fontSize: 14)),
                                          subtitle:  Text("Tap to View Details".tr,style: const TextStyle(fontSize:12,fontWeight: FontWeight.w400 ),),
                                          leading:order.pickedImages!=null &&order.pickedImages!.isNotEmpty? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      order.pickedImages!
                                                          .first)):Container(width: 5,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          }else{
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
                                            order.orderDate!,
                                            style:  
                                              const TextStyle(fontSize: 16),
                                          ),
                                          trailing: Text(order.orderStatus!.tr,style: const TextStyle(fontSize: 14),),
                                          leading:order.pickedImages!=null && order.pickedImages!.isNotEmpty? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      order.pickedImages!
                                                          .first)): Container(width: 5,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          
                          }
                              
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: snapshot.data!.docs.length),
                      );
                      }else{

                        return  Expanded(
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
                   
                    } else {
                      return  Expanded(
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
                  } else if (snapshot.connectionState ==ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Center(
                            child: Text("Try to Get Some Orders".tr,style: const TextStyle(color: Constants.textColor,fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
