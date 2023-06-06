import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/Screens/ChatsPages/chatscreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chat_controller.dart';
import '../../Models/allchats_model.dart';
import 'package:badges/badges.dart' as badges;

class AllChats extends GetView<ChatController> {
  AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats".tr),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.getAllChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    AllChatsModel chatModel =
                        AllChatsModel.fromsnapshot(snapshot.data!.docs[index]);

                    return Material(
                      
                      child: InkWell(
                        onTap: ()async{
                    
                          UserModel userModel=await controller.getInitialUserDetails(chatModel.senderId!);
                         Get.to(()=>ChatScreen(customer: userModel,chatid: chatModel.chatId!,));
                        },
                        child:  Ink(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                             
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                backgroundImage: chatModel.senderProfileImage !=
                                                null &&
                                            chatModel.senderProfileImage!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                                chatModel.senderProfileImage!)
                                            as ImageProvider
                                        : AssetImage("assets/images/patient.png"),
                              ),
                              SizedBox(width: 15,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                      Text(
                                        chatModel.sendername!,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                       Text(chatModel.lastmessage!,
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey)),
                                       
                                ],
                              ),
                                    ],
                                  ),
                                       Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                         
                                           Text(
                                            int.parse(chatModel.sentat!
                                                        .toString()
                                                        .substring(11, 13)) >=
                                                    12
                                                ? "${int.parse(chatModel.sentat.toString().substring(11, 13)) - 12}:${chatModel.sentat.toString().substring(14, 16)}${"PM".tr}"
                                                : "${chatModel.sentat!.toString().substring(11, 16)}${"AM".tr}",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey),
                                      ),
                                       badges.Badge(
                                    badgeStyle:badges.BadgeStyle(badgeColor: Color(0xff4062BB)),
                                    badgeContent:chatModel.pharmacyTotalUnRead!=null && chatModel.pharmacyTotalUnRead!=0? Text(chatModel.pharmacyTotalUnRead.toString(),style: TextStyle(color: Colors.white),):Container(),
                                    showBadge: chatModel.pharmacyTotalUnRead!=null && chatModel.pharmacyTotalUnRead!=0?true:false,
                                  ),
                                   
                                         ],
                                       ),
                                ],
                              ),
                            ),
                          ),
                     
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 5,);
                  },
                  itemCount: snapshot.data!.docs.length);
            } else {
              return Center(child: Text("Try To Reach Some Pharmacy".tr));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text("Try To Reach Some Pharmacy".tr);
          }
        },
      ),
    );
  }
}
