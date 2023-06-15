

import 'package:dwa2y_pharmacy/completed_orders.dart';
import 'package:dwa2y_pharmacy/pending_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controllers/order_controller.dart';
import 'Utils/Constants/constants.dart';

class MyOrders extends GetView<OrderController> {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Orders".tr,
              style: TextStyle(color: Constants.textColor, fontSize: 18)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Obx(
                () => controller.selectedOrders.length > 0
                    ? IconButton(
                        onPressed: () {
                          controller.showDeleteDialog();
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
          bottom: TabBar(

              controller: controller.tabController,
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              dividerColor: Colors.white,
              tabs: [
                Tab(
                  text: "Pending".tr,
                ),
                Tab(
                  text: "Completed".tr,
                )
              ]),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(

            controller: controller.tabController,
            children: [
              PendingOrders(),
              CompletedOrders(),
            ],
          ),
        ),
      ),
    );
  }
}
