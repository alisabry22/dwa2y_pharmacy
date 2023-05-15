


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/myaccount_controller.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../../Widgets/custom_list_tile.dart';
import '../../Widgets/custom_text_field.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Personal Information",
          style: GoogleFonts.poppins(color: Constants.textColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
          iconTheme:const IconThemeData(color: Constants.textColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration:const BoxDecoration(
          color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
      
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  boxShadow:const  [BoxShadow(color: Colors.grey,blurRadius: 10,spreadRadius: 0.6)],
                  ),
                  child: GetX<MyAccountController>(
                    builder: (controller) {
                      return Column(
                        children: [
                          Obx(()=>(
                             CustomListTile(
                              title: "Name",
                              onTap: () {
                                Get.defaultDialog(
                                  confirm: CustomElevatedButton(
                                      width: 120,
                                      height: 60,
                                      onPressed: () async {
                                        await controller.updateUserName(controller.usernameController.value.text.trim());
                                        Get.back();
                                      },
                                      text: "Confirm"),
                                  cancel: CustomElevatedButton(
                                      width: 120,
                                      height: 60,
                                      onPressed: () {
                                        Get.back();
                                      },
                                      text: "Cancel"),
                                  content: CustomTextField(
                                      hintText: "username",
                                      validator: (p0) {
                                        return null;
                                      },
                                      controller:
                                          controller.usernameController.value),
                                );
                              },
                              subtitile: controller.currentLoggedInPharmacy.value.username!,
                            )
                          )),
                          CustomListTile(
                            title: "Email",
                            subtitile:
                                controller.currentLoggedInPharmacy.value.email != null &&
                                        controller.currentLoggedInPharmacy.value.email!
                                            .isNotEmpty
                                    ? controller.currentLoggedInPharmacy.value.email!
                                    : "Tap to Set",
                            onTap: () {
                              Get.defaultDialog(
                                confirm: CustomElevatedButton(
                                    width: 120,
                                    height: 60,
                                    onPressed: () async {
                                      await controller.updateEmail(controller
                                          .emailController.value.text
                                          .trim());
                                      Get.back();
                                    },
                                    text: "Confirm"),
                                cancel: CustomElevatedButton(
                                    width: 120,
                                    height: 60,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    text: "Cancel"),
                                content: CustomTextField(
                                    hintText: "Email",
                                    validator: (p0) {
                                      return null;
                                    },
                                    controller: controller.emailController.value),
                              );
                            },
                          ),
                       
                      
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
