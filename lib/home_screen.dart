import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dwa2y_pharmacy/Models/product_model.dart';
import 'package:dwa2y_pharmacy/myproducts.dart';
import 'package:dwa2y_pharmacy/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/MyAccountScreens/myaccount.dart';
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: (){
                                            Get.to(()=>MyAccountPage());
                                          },
                                          child: Ink(
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: controller
                                                              .currentpharmacy
                                                              .value
                                                              .profileImageLink !=
                                                          null &&
                                                      controller.currentpharmacy.value
                                                          .profileImageLink!.isNotEmpty
                                                  ? CachedNetworkImageProvider(
                                                      controller.currentpharmacy.value
                                                          .profileImageLink!)
                                                  : const AssetImage(
                                                          "assets/images/patient.png")
                                                      as ImageProvider,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${"Hello,".tr} ${controller.currentpharmacy.value.username}!",
                                      style: const TextStyle(
                                          fontSize: 16,
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
                                        controller.badgeCounter.value
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      showBadge:
                                          controller.badgeCounter.value == 0
                                              ? false
                                              : true,
                                      child: InkWell(
                                        onTap: () {
                                          controller.badgeCounter.value = 0;
                                          Get.to(() => const Notifications());
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                "My Products".tr,
                                style: const TextStyle(
                                    fontSize: 18, color: Constants.textColor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => const MyProducts());
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffeaf4ff),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:  Center(
                                      child: Text(
                                        "See All".tr,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color:  Colors.black),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                stream: controller.getTopProducts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      return ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            ProductModel product =
                                                ProductModel.fromDocumentSnapshot(
                                                    snapshot.data!.docs[index]);
                        
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Card(
                                                elevation: 5,
                                                shadowColor: Colors.grey,
                                            
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.2,
                                                        decoration: BoxDecoration(
                                                         
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                  product
                                                                      .productImage!)),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${product.productName}",
                                                        style:
                                                            const TextStyle(
                                                                color: Constants
                                                                    .textColor),
                                                      ),
                                                     product.discountPercent!=null && product.discountPercent!=0?  RichText(
                                                          text:
                                                              TextSpan(
                                                                style: const TextStyle(color: Constants.textColor,fontWeight: FontWeight.bold),
                        
                                                                children: [
                                                        TextSpan(
                                                            text:
                                                                "${product.afterDiscount}${"L.E".tr}"),
                                                                const WidgetSpan(child: SizedBox(width: 10,)),
                                                        TextSpan(
                                                            text:
                                                                "${product.productPrice}",
                                                                style: const TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey)
                                                                ),
                                                      ])):Text("${product.productPrice}${"L.E".tr}",style:const TextStyle(color: Constants.textColor,fontWeight: FontWeight.bold) ,),
                                                    ],
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
                                          itemCount: snapshot.data!.docs.length);
                                    } else {
                                      return  Center(
                                        child: Text("Please Add More Products".tr),
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: Colors.grey,
                                    ));
                                  } else {
                                    return  Center(
                                      child: Text("Please Add More Products".tr),
                                    );
                                  }
                                }),
                          ),
                        )
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
