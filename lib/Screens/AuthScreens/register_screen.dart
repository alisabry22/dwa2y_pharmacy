import 'dart:io';

import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../Controllers/location_controller.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../../Widgets/custom_text_field.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:const Color(0xffffffff),
      appBar: AppBar(
        title: Text("CreateAccount".tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
  backgroundColor: Colors.white,
  leading: BackButton(color: Colors.black,onPressed: () {Get.back();},),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: GetX<AuthController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    controller.profileImagePath.value != ""
                                        ? Image.file(File(controller
                                                .profileImagePath.value
                                                .toString()))
                                            .image
                                        : const AssetImage(
                                            "assets/images/pharmacy.png"),
                                radius: 30,
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                      onTap: () {
                                        controller.pickprofileImage();
                                      },
                                      child: const Icon(
                                          FontAwesomeIcons.circlePlus,
                                          color: Color.fromARGB(
                                              255, 1, 16, 43)))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          hintText: "username".tr,
                          controller: controller.usernameController.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter correct Username".tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            hintText: "email".tr,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return  "please enter Email".tr;
                              }
                              return null;
                            },
                            controller: controller.emailController.value),
                        const SizedBox(
                          height: 10,
                        ),
                        GetX<AuthController>(
                          builder: (controller) {
                            return IntlPhoneField(
                              controller: controller.phoneController.value,
                              initialCountryCode: controller.countrycode.value,
                              onCountryChanged: (value) {
                                controller.countrycode.value = value.dialCode;
                              },
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: "phone".tr,
                                hintStyle:const TextStyle(color: Colors.grey),
                                enabledBorder: const UnderlineInputBorder(),
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                filled: true,
                                focusColor: Colors.white,
                                border: const UnderlineInputBorder(),
                                ),
                              
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetX<AuthController>(builder: (controller) {
                          return CustomTextField(
                            obscureValue: controller.obscurepassword.value,
                            suffixIcon: controller.obscurepassword.value
                                ? InkWell(
                                    onTap: () {
                                      controller.obscurepassword.value =
                                          !controller.obscurepassword.value;
                                    },
                                    child: const Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.grey,
                                    ))
                                : InkWell(
                                    onTap: () {
                                      controller.obscurepassword.value =
                                          !controller.obscurepassword.value;
                                    },
                                    child: const Icon(FontAwesomeIcons.lockOpen,
                                        color:Colors.grey)),
                            hintText: "password".tr,
                            controller: controller.passwordController.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter correct password".tr;
                              }
                              return null;
                            },
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<AuthController>(
                          builder: (controller) {
                            return CustomTextField(
                              hintText: "confirmpassword".tr,
                              obscureValue: controller.obscurepassword.value,
                              controller:
                                  controller.confirmPasswordController.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter correct password".tr;
                                } else {
                                  if (controller.passwordController.value.text
                                          .toString() !=
                                      value) {
                                    return "passwords don't match".tr;
                                  }
                                  return null;
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                            width: width,
                            height: height * 0.4,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                bool locationEnabled=await controller.checkLocationNotEmpty();
                                if(locationEnabled){
                                  final response = await controller
                                    .signUpWithEmailandPassword();
                                if (response[0] == true) {
                                  await controller.saveWholeDataInDatabase();
                                 await controller. showAddressDialog();
                                } else {
                                  Get.snackbar(
                                      response[1]
                                          .toString()
                                          .replaceAll("-", " "),
                                      response[1]
                                          .toString()
                                          .replaceAll("-", " "),
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                                
                                } else {
                                  //show dialog to inform user that he is not able to sign up before turnning on gps
                                   
                                   await Get.find<LocationController>().checkLocationServices();
                                  
                                }
                                //sign up
        
                              }
                            },
                            text: "sign up".tr),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              "Already Have an Account?".tr,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.to(LoginScreen());
                                },
                                child:  Text(
                                  "login".tr,
                                  style: const TextStyle(
                                    color: Constants.btnColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                            
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
