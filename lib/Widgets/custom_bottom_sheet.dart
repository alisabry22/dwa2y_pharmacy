import 'package:dwa2y_pharmacy/Controllers/order_controller.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/myorders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_elevated_button.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet(
      {super.key, required this.orderid, required this.usercreatedOrder});
  final String orderid;
  final UserModel usercreatedOrder;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 0.5)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order id : $orderid",
              style: GoogleFonts.poppins(
                  fontSize: 16, color: Constants.textColor),
            ),
            Text(
                "Customer Name:  ${usercreatedOrder.username} accepted your offer",
                style: GoogleFonts.poppins(
                    fontSize: 18, color: Constants.textColor)),
            Center(
                child: CustomElevatedButton(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                    onPressed: () async{
                      await Get.find<OrderController>().getOrderDetails(orderid);
                      Get.off(() => const MyOrders());
                      
                    },
                    text: "View Order Details"))
          ],
        ),
      ),
    );
  }
}
