import 'package:dwa2y_pharmacy/Controllers/dashboard_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Screens/MyAccountScreens/myaccount.dart';
import 'package:dwa2y_pharmacy/home_screen.dart';
import 'package:dwa2y_pharmacy/myorders.dart';
import 'package:dwa2y_pharmacy/myproducts.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: Colors.white,
      decoration: const NavBarDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 12,
          color: Colors.white,
          spreadRadius: 0.6,
        )
      ]),
      context,
      navBarStyle: NavBarStyle.simple,
          popAllScreensOnTapAnyTabs: false,
      popAllScreensOnTapOfSelectedTab: false,
      controller: controller.persistentTabController,
      onItemSelected: (value) {
        if(value==1){
          Get.find<HomeController>().badgeCounter.value=0;
        }
      },
      screens: const [
        HomeScreen(),
        MyProducts(),
        MyOrders(),
        MyAccountPage(),
      ],
      items: [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Home",
            textStyle: GoogleFonts.poppins(fontSize: 12)),
             PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.productHunt),
            textStyle: GoogleFonts.poppins(fontSize: 12),
            title: "My Products"),
        PersistentBottomNavBarItem(
     
        
                                  icon:const Icon(
                                                    FontAwesomeIcons.cartShopping,
                                                    
                                                  
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.grey,
                                                          blurRadius: 10)
                                                    ],
                                                  ),
                                
          
                     
            
            title: "Orders",
            textStyle: GoogleFonts.poppins(fontSize: 12)),
        PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.solidUser),
            textStyle: GoogleFonts.poppins(fontSize: 12),
            title: "MyAccount"),
            
            
      ],
    );
  }
}
