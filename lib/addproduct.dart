import 'dart:io';

import 'package:dwa2y_pharmacy/Controllers/product_controller.dart';

import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Utils/Constants/constants.dart';

class AddProduct extends GetView<ProductController> {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: GoogleFonts.poppins(color: Constants.textColor, fontSize: 16),
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
                                    text: "Change"),
                                CustomElevatedButton(
                                    width: 120,
                                    height: 50,
                                    onPressed: () {
                                      controller.productImagePicked.value = "";
                                      Get.back();
                                    },
                                    text: "Delete"),
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
                            children: [
                              const Icon(FontAwesomeIcons.photoFilm),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Add Product Image",
                                  style: GoogleFonts.poppins(
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
                      hintText: "Prodcut Name",
                      validator: (p0) {
                        return p0;
                      },
                      controller: controller.productName.value),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      hintText: "Product Price",
                      keyboardType: TextInputType.number,
                      validator: (p0) {
                        return p0;
                      },
                      controller: controller.productPrice.value),
                  Row(
                    children: [
                      Text(
                        "Product Category",
                        style: GoogleFonts.poppins(
                            color: Constants.textColor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Obx(
                        () => DropdownButton(
                            style: GoogleFonts.poppins(
                                color: Constants.textColor,
                                fontWeight: FontWeight.w500),
                            value: controller.productCategory.value,
                            elevation: 8,
                            items: const [
                              DropdownMenuItem(
                                value: "Capsules",
                                child: Text("Capsules"),
                              ),
                              DropdownMenuItem(
                                value: "Syurp",
                                child: Text("Syurp"),
                              ),
                              DropdownMenuItem(
                                value: "Skin Care",
                                child: Text("Skin Care"),
                              ),
                              DropdownMenuItem(
                                value: "Other",
                                child: Text("Other"),
                              ),
                            ],
                            onChanged: (value) {
                              controller.productCategory.value = value!;
                            }),
                      ),
                    ],
                  ),
                  CustomTextField(
                      hintText: "Discount Percentage (Optional)",
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
                      text: "Add Product"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
