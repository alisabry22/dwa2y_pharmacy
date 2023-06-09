import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/product_controller.dart';
import 'package:dwa2y_pharmacy/Models/product_model.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/addproduct.dart';
import 'package:dwa2y_pharmacy/edit_product.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MyProducts extends GetView<ProductController> {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.onLongPress.value == true) {
          controller.onLongPress.value == false;
          return true;
        } else {
          Get.back();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            "My Products".tr,
            style: const TextStyle(
                color: Constants.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Obx(() => controller.onLongPress.value == true
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.onLongPress.value = false;
                    controller.productsPicked.value=<ProductModel>[];
                  })
              : const BackButton()),
          iconTheme: const IconThemeData(color: Constants.textColor),
          actions: [
            Obx(
              () => controller.onLongPress.value == true
                  ?  Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: IconButton(icon:const Icon(Icons.delete),onPressed: ()async{
                        //delete selected products from database
                        if(controller.productsPicked.isNotEmpty){
                          final List< String >productsIds=[];
                          for (var element in controller.productsPicked) {
                              productsIds.add(element.prodcutId!);
                          }
                          await controller.removeProduct(productsIds);
                          controller.onLongPress.value=false;
                          controller.productsPicked.value=[];
                        }
                        
                      },),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => const AddProduct());
                          },
                          child:  Text("Add Product".tr)),
                    ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: controller.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.8,
                      children: snapshot.data!.docs.map((e) {
                        ProductModel productModel =
                            ProductModel.fromDocumentSnapshot(e);

                        return InkWell(
                          onTap: () async {
                            if (controller.onLongPress.value == true) {
                              if(controller.productsPicked.contains(productModel))
                              {
                                controller.productsPicked.remove(productModel);
                                if (controller.productsPicked.isEmpty){
                                  controller.onLongPress.value=false;
                                }
                                }
                              else{
                                controller.productsPicked.add(productModel);
                              }
                            
                            } else {
                              Get.to(() => EditProduct(
                                    productModel: productModel,
                                  ));
                            }
                          },
                          onLongPress: () {
                            controller.onLongPress.value =
                                !controller.onLongPress.value;
                                controller.productsPicked.add(productModel);
                          },
                          child: Ink(
                            child: Obx(
                              () => Container(
                                color: controller.productsPicked.contains(productModel)
                                    ? Colors.grey.shade300
                                    : Colors.transparent,
                                child: Card(
                                  elevation: 5,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        decoration: BoxDecoration(
                                          color: controller.onLongPress.value ==
                                                  true
                                              ? Colors.grey
                                              : Colors.transparent,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  productModel.productImage!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                border: BorderDirectional(
                                                    top: BorderSide(
                                                        color: Colors.grey)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Center(
                                                      child: Text(
                                                    "${productModel.productName}",
                                                    style: const TextStyle(
                                                        color:
                                                            Constants.textColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                            overflow: TextOverflow.ellipsis,
                                                  )),
                                                  Center(
                                                      child: productModel
                                                                  .afterDiscount !=
                                                              0
                                                          ? Text(
                                                              "${"Price".tr} : ${productModel.afterDiscount}",
                                                              style: const TextStyle(
                                                                  color: Constants
                                                                      .textColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              "${"Price".tr} : ${productModel.productPrice}",
                                                              style: const TextStyle(
                                                                  color: Constants
                                                                      .textColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                ],
                                              ))),
                                  productModel.discountPercent!=null&&productModel.discountPercent!=0? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                                    
                                                      width:50,
                                                      height: 50,
                                                      decoration:
                                                           BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.white),
                                                      ),
                                                      child: FittedBox(
                                                        
                                                        child: Text(
                                                          "${productModel.discountPercent}% OFF",
                                                          style:
                                                          const TextStyle(
                                                              color: Constants
                                                                  .textColor,
                                                                  
                                                            ),
                                                        ),
                                                      ),
                                                    ),
                                      ):Container(),   
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Obx(() =>controller.productsPicked.contains(productModel)  ?const  CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Constants.btnColor,
                                                      child:  Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      )))
                                              : Container())),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Try To Add Some Products ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text(
                    "Try To Add Some Products ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.grey),
              );
            } else {

              return const Center(
                child: Text(
                  "Try To Add Some Products ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
