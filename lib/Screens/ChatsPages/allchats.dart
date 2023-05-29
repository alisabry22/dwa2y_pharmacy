import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';
import 'package:dwa2y_pharmacy/Screens/ChatsPages/chatscreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chat_controller.dart';
import '../../Models/allchats_model.dart';

class AllChats extends GetView<ChatController> {
  AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats"),
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
                        child: Ink(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  chatModel.senderProfileImage != null &&
                                          chatModel.senderProfileImage!.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          chatModel.senderProfileImage!)as ImageProvider
                                      : AssetImage("assets/images/pharmacy.png"),
                        
                            ),
                            title: Text(chatModel.sendername!,style: TextStyle(fontSize:14 ),),
                            subtitle: Text(chatModel.lastmessage!,style: TextStyle(fontSize:12,color: Colors.grey )),
                            trailing: Text(chatModel.sentat!.toString().substring(11,16),style: TextStyle(fontSize:12,color: Colors.grey ),),
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
              return Center(child: Text("Try To Reach Some Pharmacy"));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text("Try To Reach Some Pharmacy");
          }
        },
      ),
    );
  }
}
