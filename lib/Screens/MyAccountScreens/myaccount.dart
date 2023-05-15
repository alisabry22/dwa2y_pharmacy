import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwa2y_pharmacy/Screens/MyAccountScreens/personal_information.dart';
import 'package:dwa2y_pharmacy/myaddress.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/myaccount_controller.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/custom_list_tile.dart';


class MyAccountPage extends GetView<MyAccountController> {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
           backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child:
               
    
                   CircleAvatar(
                    backgroundImage:controller.currentLoggedInPharmacy.value.profileImageLink!=null && controller.currentLoggedInPharmacy.value.profileImageLink!.isNotEmpty?
                        CachedNetworkImageProvider(
                               controller.currentLoggedInPharmacy.value.profileImageLink!)
                            as ImageProvider
                        : const AssetImage("assets/images/patient.png"),
                    radius: 20,
                  ),
               
              ),
            title:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(()=>    Text(controller.currentLoggedInPharmacy.value.username!=null?controller.currentLoggedInPharmacy.value.username!:"",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500,color: Constants.textColor)),),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("0${controller.currentLoggedInPharmacy.value.phone}",
                        style: GoogleFonts.poppins(fontSize: 16,color:Constants.textColor)),
                  ],
              
             
            ),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
           
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "My Account",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Constants.textColor,
                  ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const[ BoxShadow(blurRadius: 10,color: Colors.grey,spreadRadius: 0.5)],
                    ),
                    child:  SingleChildScrollView(
                      child: Column(
                        
                        children: [
                        
                         CustomListTile(
                          
                          onTap: (){
                          Get.to(()=>const PersonalInformation());
                         }, leading: const Icon(Icons.person,color: Constants.textColor, ),title: "Personal Information",),
                         const Divider(
                         thickness: 1,
                          ),
                        CustomListTile(onTap: (){
                        
                        }, leading:const  Icon(Icons.settings,color: Constants.textColor, ),title: "Account Setting",),
                         const Divider(
                         thickness: 1,
                          ),
                         CustomListTile(onTap: (){}, leading: const Icon(Icons.payment_outlined,color: Constants.textColor, ),title: "Payment methods",),
                        const Divider(
                         thickness: 1,
                          ),
                         
                           
                             CustomListTile(onTap: (){
                              Get.to(()=>const MyAddresses());
                            }, leading:const  Icon(Icons.home,color: Constants.textColor, ),title: "Billing Address" ),
                           
                          
                          
                       const Divider(
                         thickness: 1,
                          ),
                          CustomListTile(onTap: (){}, leading:const  Icon(Icons.help_center,color: Constants.textColor, ),title: "Help and Support",),
                        ],
                      ),
                    ),
                  ),
                   const SizedBox(height: 20,),
                     Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow:const [BoxShadow(blurRadius: 10,color: Colors.grey,spreadRadius: 0.6)],
                    ),
                    child: CustomListTile(title: "Logout",onTap: ()async{
                     await controller.accountController.logout();
                    },),
                  ),
                ],
              ),
            ),
          ),
        );

  }
}


