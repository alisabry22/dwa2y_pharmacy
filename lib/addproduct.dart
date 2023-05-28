import 'dart:io';

import 'package:dwa2y_pharmacy/Controllers/product_controller.dart';

import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'Utils/Constants/constants.dart';

class AddProduct extends GetView<ProductController> {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Add Product".tr,
          style: const TextStyle(color: Constants.textColor, fontSize: 16),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Constants.textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 12, spreadRadius: 0.5)
              ]),
              child: Obx(() => controller.productImagePicked.value.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10,
                                      spreadRadius: 0.5)
                                ]),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Column(
                              children: [
                                CustomElevatedButton(
                                    width: 120,
                                    height: 50,
                                    onPressed: () {
                                      controller.pickProductImage();
                                      Get.back();
                                    },
                                    text: "Change".tr),
                                CustomElevatedButton(
                                    width: 120,
                                    height: 50,
                                    onPressed: () {
                                      controller.productImagePicked.value = "";
                                      Get.back();
                                    },
                                    text: "Delete".tr),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Ink(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(
                                      controller.productImagePicked.value)))),
                        ),
                      ),
                    )
                  : InkWell(
                      splashColor: Colors.grey,
                      onTap: () async {
                        await controller.pickProductImage();
                      },
                      child: Ink(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              const Icon(FontAwesomeIcons.photoFilm),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Add Product Image".tr,
                                  style: const TextStyle(
                                      color: Constants.textColor, fontSize: 16))
                            ]),
                      ),
                    )),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CustomTextField(
                      hintText: "Product Name".tr,
                      validator: (p0) {
                        return p0;
                      },
                      controller: controller.productName.value),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      hintText: "Product Price".tr,
                      keyboardType: TextInputType.number,
                      validator: (p0) {
                        return p0;
                      },
                      controller: controller.productPrice.value),
                  Row(
                    children: [
                       Text(
                        "Product Category".tr,
                        style: const TextStyle(
                            color: Constants.textColor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Obx(
                        () => DropdownButton(
                            style: const TextStyle(
                                color: Constants.textColor,
                                fontWeight: FontWeight.w500),
                            value: controller.productCategory.value.tr,
                            elevation: 8,
                            items:  [
                              DropdownMenuItem(

                                value: "Capsules".tr,
                                child: Text("Capsules".tr,style: const TextStyle(fontSize: 16),),
                              ),
                               DropdownMenuItem(
                                value: "Baby".tr,
                                child: Text("Baby".tr,style:const TextStyle(fontSize: 16)),
                              ),

                              DropdownMenuItem(
                                value: "Syurp".tr,
                                child: Text("Syurp".tr,style:const TextStyle(fontSize: 16)),
                              ),
                              DropdownMenuItem(
                                value: "Cosmatics".tr,
                                child: Text("Cosmatics".tr,style:const TextStyle(fontSize: 16)),
                              ),
                              DropdownMenuItem(
                                value: "Other".tr,
                                child: Text("Other".tr,style:const TextStyle(fontSize: 16)),
                              ),
                            ],
                            onChanged: (value) {
                              controller.productCategory.value = value!.tr;
                            }),
                      ),
                    ],
                  ),
                  CustomTextField(
                      hintText: "Discount Percentage (Optional)".tr,
                      keyboardType: TextInputType.number,
                      validator: (p0) {
                        return p0;
                      },
                      controller: controller.discountPercent.value),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomElevatedButton(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 50,
                      onPressed: () async {
                       await controller.addProduct();
                  
                      },
                      text: "Add Product".tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
