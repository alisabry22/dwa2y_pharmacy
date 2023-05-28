import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/register_screen.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_elevated_button.dart';
import 'package:dwa2y_pharmacy/Widgets/custom_text_field.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/localization_controller.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetX<LanguageController>(
                        builder: (controller) {
                          
                          return    Align(
                            alignment:controller.locale.value==const Locale('en')? Alignment.topRight:Alignment.topLeft,
                            child: TextButton(
                                                
                              onPressed: ()async {
                                if(controller.locale.value==const Locale('ar')){
                                 await controller.changeLanguage('en');
                                }else{
                                  await controller.changeLanguage('ar');
                                }
                              },
                              child:controller.locale.value==const Locale('ar')?   Text(
                                  "English",
                                    style: GoogleFonts.poppins(decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold)):          Text(
                                  "العربية",
                                    style: GoogleFonts.poppins(decoration: TextDecoration.underline,fontSize: 16,fontWeight: FontWeight.bold))
                                
                                
                                  
                                 
                            
                                  
                              
                                ),
                          );
                        },
                     
                      ),
                  Text(
                  "Pharmacy App".tr,
                  style: const TextStyle(
                      color:Color.fromARGB(255, 3, 72, 128),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                   const SizedBox(
                  height: 20,
                ),
                Container(
                  width: width ,
                  height: width * 0.6,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Prescription2.jpg")),
                  ),
                ),
               
               
                const SizedBox(
                  height: 20,
                ),
                GetX<AuthController>(
                  builder: (controller) {
                    return Center(
                      child: Form(
                        key: formKey,
                          child: Column(
                        children: [
                          CustomTextField(
                            prefixIcon: const Icon(FontAwesomeIcons.envelope,size: 20,color: Colors.grey,),
                              hintText: "email".tr,
                              
                              validator: (p0) {
                                  if(p0!=null &&p0.isNotEmpty ){
                                  return null;
                                }else{
                                  return "please enter Email".tr;
                                }
                              },
                              controller: controller.emailController.value),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            prefixIcon:const  Icon(FontAwesomeIcons.lock,size:20,color: Colors.grey,),
                              suffixIcon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              hintText: "password".tr,
                              validator: (p0) {
                                if(p0!=null &&p0.isNotEmpty ){
                                  return null;
                                }else{
                                  return "Please enter correct password".tr;
                                }
                              },
                              controller: controller.passwordController.value),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomElevatedButton(
                              width: width*0.8 ,
                              height: height*0.4,
                              onPressed: ()async {
                                 if (formKey.currentState!.validate()) {
                           
                            
                            final response = await controller.signInMethod();
          
                              if(response[0]==true){
                             Get.offAll(()=>const Dashboard());
          
                              }else{
          
                                Get.snackbar(response[1].toString().replaceAll("-"," "), response[1].toString().replaceAll("-", " "),snackPosition: SnackPosition.BOTTOM);
                              }
                        
                          }
                              },
                              text: "login".tr),
                        
                        Align(
                      alignment: Alignment.bottomRight,
                      
                        child: TextButton(
                          onHover: (value) {},
                          child: Text(
                            "Forgot Password?".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.btnColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Don't Have Account?".tr,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(()=> RegisterScreen());
                              },
                              child: Text(
                                "sign up".tr,
                                style: const TextStyle(
                                  color: Constants.btnColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,                                 
                                ),
                              ))
                        ],
                      ),
                        const  SizedBox(
                            height: 15,
                          ),
                        
                        ],
                      )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
