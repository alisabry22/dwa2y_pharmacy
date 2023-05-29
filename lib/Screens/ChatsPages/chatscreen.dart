import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/chat_controller.dart';
import '../../Models/chatmodel.dart';
import '../../Utils/Constants/constants.dart';
import '../../Widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key, required this.customer,required this.chatid});
  final UserModel customer;
  final String chatid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller=Get.find<ChatController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updateseenMessages();

  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.username!,
              style: TextStyle(color: Constants.textColor, fontSize: 16),
            ),
            Obx(()=>
               Text(
                controller.currentChatCustomer.value.status!=null?controller.currentChatCustomer.value.status=="online"?"online":"":"",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.getChatMessages(widget.chatid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      controller.getCustomerStatusDetails(widget.customer.userid!);
                    
                      return ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                          
                            ChatMessage message = ChatMessage.fromJson(
                                snapshot.data!.docs[index].data());
                                
                                  return ChatBubble(
                                     delivered: message.delivered!=null?message.delivered!:false,

                              seen: message.seen!=null?message.seen!:false,
                              isSender: message.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? false
                                  : true,
                              color: message.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Color(0xff4062BB)
                                  : Colors.grey.shade300,
                              message: message.message,
                              
                              textStyle: TextStyle(
                                  color: message.sender ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.white
                                      : Colors.black),
                              sentat: int.parse(message.sentat
                                          .toString()
                                          .substring(11, 13)) >=
                                      12
                                  ? "${message.sentat.toString().substring(11, 16)}PM"
                                  : "${message.sentat.toString().substring(11, 16)}AM",
                                  );
                             
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: snapshot.data!.docs.length);
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Start Your Chat With Him now",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Start Your Chat With Him now",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                }),
          ),
          MessageBar(
            onSend: (value) async {
              ChatMessage message = ChatMessage(
                  sender: FirebaseAuth.instance.currentUser!.uid,
                  receiver: widget.customer.userid!,
                  message: value,
                  sentat: DateTime.now());
              await controller.sendMessage(message,widget.chatid );
            },
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
