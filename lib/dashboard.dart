import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/dashboard_controller.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/Screens/ChatsPages/allchats.dart';
import 'package:dwa2y_pharmacy/Screens/ChatsPages/chatscreen.dart';
import 'package:dwa2y_pharmacy/home_screen.dart';
import 'package:dwa2y_pharmacy/myorders.dart';
import 'package:dwa2y_pharmacy/notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  setupInteractionTerminate();
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
        await  FirebaseFirestore.instance.collection("Chats").doc(doc).collection("messages").doc(element).get().then((val){
          if(val.exists &&val.get("delivered")!=true){
            val.reference.update({"delivered":true});
          }
        });
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

  Future setupInteractionTerminate()async
  {
    RemoteMessage? initialMessage=await FirebaseMessaging.instance.getInitialMessage();
  if(initialMessage!=null){
      if(initialMessage.data["status"]=="chat"){
        Get.to(()=>ChatScreen(customer:UserModel.fromJson(jsonDecode (initialMessage.data["customer"])) , chatid: initialMessage.data["chatid"]));
       
      } else if (initialMessage.data["status"]=="reject"){
      Get.to(MyOrders());
    }
      
      else{
          Get.to(()=>Notifications());
        }
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
        print(value);
        if(value==1){
          Get.find<HomeController>().badgeCounter.value=0;
           Get.find<HomeController>().unreadMessages.value=0;
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
            icon:  GetX<HomeController>(
                builder:(controller){
              
                  if(controller.unreadMessages.value!=0){
                      return Badge(
                     label: Text(controller.unreadMessages.value.toString()),
                      child: Icon(Icons.chat)  ,
                    );
                  }else{
                    return Icon(Icons.chat);
                  }
                },
                 
              ),
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
