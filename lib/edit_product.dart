
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/product_controller.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_list_tile.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_update_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Models/product_model.dart';
import 'Widgets/custom_elevated_button.dart';

class EditProduct extends GetView<ProductController> {
  const EditProduct({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: GoogleFonts.poppins(color: Constants.textColor, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Constants.textColor),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 12,
                            spreadRadius: 0.5)
                      ]),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                productModel.productImage!))),
                  )),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 10, spreadRadius: 0.6)
                  ],
                ),
                child: StreamBuilder(
                  stream: controller.getCurrentDocument(productModel.prodcutId!),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.hasData){
                   ProductModel returnedProduct=ProductModel.fromDocumentSnapshot(snapshot.data!);
                   controller.productCategory.value=returnedProduct.productCategory!;
                   return  Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomListTile(
                                title: "Product Name",
                                onTap: () {
                                  Get.bottomSheet(
                                    CustomUpdateFieldBottomSheet(title: "Product Name",controller: controller.productName.value, onPressed: ()async{
                                          if(controller.productName.value.text.isNotEmpty){
                                          await controller.updateProductName(productModel.prodcutId!, controller.productName.value.text);
                                                  controller.productName.value.text="";
                                                  Get.back();
                                                } 
                                    }, hintText: "Type New Name")
                                  );
                                },
                                subtitile: returnedProduct.productName!,
                              ),
                              CustomListTile(
                                  title: "Product Price",
                                  onTap: () {
                                       Get.bottomSheet(
                                    CustomUpdateFieldBottomSheet(title: "Edit Price",textInputType: TextInputType.number,controller: controller.productPrice.value, onPressed: ()async{
                                          if(controller.productPrice.value.text.isNotEmpty){
                                          await controller.updateProductPrice(productModel.prodcutId!,int.parse(controller.productPrice.value.text));
                                                  controller.productPrice.value.text="";
                                                  Get.back();
                                                } 
                                    }, hintText: "Price")
                                  );
                                  },
                                  subtitile: returnedProduct.productPrice!.toString()),
                              CustomListTile(
                                  title: "Discount Percent",
                                  onTap: () async{
                                           Get.bottomSheet(
                                    CustomUpdateFieldBottomSheet(title: "Discount Percentage",textInputType: TextInputType.number,controller: controller.discountPercent.value, onPressed: ()async{
                                          if(controller.discountPercent.value.text.isNotEmpty){
                                          await controller.updateProductDiscount(productModel.prodcutId!,int.parse(controller.discountPercent.value.text),returnedProduct.productPrice!);
                                                  controller.discountPercent.value.text="";
                                                  Get.back();
                                                } 
                                    }, hintText: "Discount Percentage")
                                  );
                                  },
                                  subtitile: returnedProduct.discountPercent.toString()),
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
                                  Obx(()=> DropdownButton(
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
                            ],
                          ),
                        ),
                        Center(
                          child: CustomElevatedButton(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 50,
                              onPressed: () async {
                                await controller.updateProductCategory(returnedProduct.prodcutId!, controller.productCategory.value);
                                Get.back();
                              },
                              text: "Save"),
                        ),
                      ],
                                     ),
                   );
                      }else{
                        return Container();
                      }
                    }else{
                       return Container();
                    }
                   
                  },
                  
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
