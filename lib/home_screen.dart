import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dwa2y_pharmacy/edit_product.dart';
import 'package:dwa2y_pharmacy/myproducts.dart';
import 'package:dwa2y_pharmacy/notification_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'Models/product_model.dart';
import 'Utils/Constants/constants.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: GetX<HomeController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: controller.currentpharmacy
                                                  .value.profileImageLink !=
                                              null &&
                                          controller.currentpharmacy.value
                                              .profileImageLink!.isNotEmpty
                                      ? CachedNetworkImageProvider(controller
                                          .currentpharmacy
                                          .value
                                          .profileImageLink!)
                                      : const AssetImage(
                                              "assets/images/patient.png")
                                          as ImageProvider,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Hello, ${controller.currentpharmacy.value.username}!",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Constants.textColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            GetX<HomeController>(
                              builder: (controller) {
                                return badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      top: -10, end: 0),
                                  badgeContent: Text(
                                    controller.badgeCounter.value.toString(),
                                    style:const TextStyle(color: Colors.white),
                                  ),
                                  showBadge: controller.badgeCounter.value==0?false:true,
                                  child:InkWell(
                                    onTap: (){
                                      controller.badgeCounter.value=0;
                                      Get.to(()=>const Notifications());
                                    },
                                    child: Ink(
                                      child: const Icon(
                                                        Icons.notifications,
                                                        color: Colors.white,
                                                        size: 30,
                                                        shadows: [
                                                          Shadow(
                                                              color: Colors.grey,
                                                              blurRadius: 10)
                                                        ],
                                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    //Top Customers with you 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Top Discounts",style: GoogleFonts.poppins(fontSize: 18, color: Constants.textColor),),
                         TextButton(onPressed: (){
                Get.to(()=>const MyProducts());
              }, child: Text("See All",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.29,
                      child: StreamBuilder(
                        stream: controller.getTopProducts(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState==ConnectionState.active){
                            if(snapshot.hasData){
                              if(snapshot.data!.docs.isNotEmpty){
                                return  ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                      ProductModel productModel =
                                  ProductModel.fromDocumentSnapshot(
                                      snapshot.data!.docs[index]);
                              return InkWell(
                                splashColor: Colors.grey,
                                onTap: (){
                                  Get.to(()=>EditProduct(productModel: productModel));
                                },
                                child: Ink(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width * 0.3,
                                          height: MediaQuery.of(context).size.height *  0.19,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: CachedNetworkImageProvider(
                                                    productModel.productImage!)),
                                          ),
                                        ),
                                        Text("${productModel.productName}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Constants.textColor)),
                                        productModel.afterDiscount != 0
                                            ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    " ${productModel.afterDiscount} L.E ",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: Constants.textColor)),
                                                         Row(
                                                           children: [
                                                             Text(
                                                    " ${productModel.productPrice}",
                                                    
                                                    style: GoogleFonts.poppins(
                                                        decoration: TextDecoration.lineThrough,
                                                        fontSize: 16,
                                                        color:  Colors.grey),),
                                                       const SizedBox(width: 10),
                                                         Text(
                                                    "${productModel.discountPercent}%OFF",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: Colors.grey)),
                                                           ],
                                                         ),
                                              ],
                                            )
                                            : Text(
                                                " ${productModel.productPrice} L.E ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Constants.textColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                      separatorBuilder: (context, index) {
                        return  const SizedBox(width: 10,);
                      }, itemCount: snapshot.data!.docs.length);
                              }return  Center(
                                child: Text("Add Some Products with Discount to get customers",style: GoogleFonts.poppins(color: Constants.textColor),),
                              );
                            }else{
                            return Center(
                                child: Text("Add Some Products with Discount to get customers",style: GoogleFonts.poppins(color: Constants.textColor),),
                              );
                          }
                          }else{
                            return const Center(child: CircularProgressIndicator(),);
                          }
                      },),
                    ),
                   

                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
