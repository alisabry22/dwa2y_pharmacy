

import 'package:dwa2y_pharmacy/Widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/localization_controller.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/custom_elevated_button.dart';

class AccountSettings extends GetView<LanguageController> {
  const AccountSettings({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Constants.textColor),
        title: Text(
          "Account Setting".tr,
          style: const TextStyle(color: Constants.textColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Obx(()=>
        CustomListTile(
              onTap: () async {
                await Get.defaultDialog(
                    title: "Change Language".tr,
                    content:   Text("Change Default App Language".tr),
                    actions: [
                      controller.locale.value == const Locale('ar')
                          ? CustomElevatedButton(
                              width: 150,
                              height: 60,
                              onPressed: () async{
                                Get.back();
                              await  controller.changeLanguage('en');
                              await controller.updateLocaleDatabase('en');
                              },
                              text: "English")
                          : CustomElevatedButton(
                              width: 100,
                              height: 60,
                              onPressed: ()async {
                                 Get.back();
                                    await  controller.changeLanguage('ar');
                                   
                                     await controller.updateLocaleDatabase('ar');

                              },
                              text: "العربية"),
                    ]);
              },
              leading: const Icon(Icons.language),
              title: "Default Language".tr,
              subtitile: controller.locale.value == const Locale('ar')
                  ? "العربية"
                  : "English",
            ),
          ),
        ]),
      ),
    );
  }
}