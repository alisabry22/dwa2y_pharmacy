import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/dashboard_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Screens/ChatsPages/allchats.dart';
import 'package:dwa2y_pharmacy/home_screen.dart';
import 'package:dwa2y_pharmacy/myorders.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  
  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  updateDeliveredmessages();
  }
  //once i open the app if there are any messages that is sent only change it to delviered
 Future updateDeliveredmessages()async{
List<String> chatsIamIn=[];
//get chats first 
  await FirebaseFirestore.instance.collection("Chats").where("receiverId",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  .get().then((value) {
    if(value.docs.isNotEmpty){
      value.docs.forEach((element) {
        chatsIamIn.add(element.id);
      });
    }
  }); 

List<String>   messagesIds=[];
//get messages 
  for(var doc in chatsIamIn){
      await FirebaseFirestore.instance.collection("Chats").doc(doc).collection("messages").get().then((value) {
        if(value.docs.isNotEmpty){
          value.docs.forEach((element) {
            messagesIds.add(element.id);
          });
        }
      });
      for (var element in messagesIds){
        await  FirebaseFirestore.instance.collection("Chats").doc(doc).collection("messages").doc(element).update({"delivered":true});
      }
  }

  //update 

  }
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    print("heelooooo");
    if(state==AppLifecycleState.resumed){
     await updateUserStatus("online");
    }else{
await updateUserStatus("offline");
    }
    super.didChangeAppLifecycleState(state);
  }

  
  Future updateUserStatus(String status)async{
    if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"status":status});
    }else{
      print("user is null ");
    }
  }

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
      controller: Get.find<DashboardController>().persistentTabController,
      onItemSelected: (value) {
        if(value==1){
          Get.find<HomeController>().badgeCounter.value=0;
        }
      },
      screens:  [
        HomeScreen(),
        AllChats(),
        MyOrders(),
    
      ],
      items: [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Home ".tr,
            textStyle: const TextStyle(fontSize: 10)),
             PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Chats".tr,
            textStyle: const TextStyle(fontSize: 10)),
   
        PersistentBottomNavBarItem(
     
        
                                  icon:const Icon(FontAwesomeIcons.cartPlus,  ),

            title: "Orders".tr,
            textStyle: const TextStyle(fontSize: 10)),
     
            
            
      ],
    );
  }
}
