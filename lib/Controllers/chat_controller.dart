import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/pharmacy_model.dart';
import 'package:dwa2y_pharmacy/Models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/chatmodel.dart';
import 'home_controller.dart';

class ChatController extends GetxController{
  Rx<PharmacyModel> currentpharmacy=Get.find<HomeController>().currentpharmacy.value.obs;
  Rx<TextEditingController> messageController=TextEditingController().obs;
    ScrollController scrollController=ScrollController();
    StreamSubscription? listener;
    Rx<UserModel> currentChatCustomer=UserModel(lat: 0.0, long: 0.0).obs;

  @override
  void onClose() {
  
    super.onClose();
    if(listener!=null){
      listener!.cancel();
    }
  }
  @override
  void onInit() {
    super.onInit();
    Get.find<HomeController>().currentpharmacy.listen((p0) {
      currentpharmacy.value=p0;
    });
    getAllChats();
  }

 Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats(){
 return  FirebaseFirestore.instance.collection("Chats").where("receiverId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  }

  //start conversation between me and specific pharmacy
  Future sendMessage(ChatMessage message,String chatid)async{
 
  await FirebaseFirestore.instance.collection("Chats").doc(chatid).update({"lastmessage":message.message , "sentat":message.sentat});
  await FirebaseFirestore.instance.collection("Chats").doc(chatid).collection("messages").add(message.toJson());
}

   

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId){
    return FirebaseFirestore.instance.collection("Chats").doc(chatId).collection("messages").orderBy("sentat",descending: true).snapshots();
  }

  Future getInitialUserDetails(String customerid)async{
    return FirebaseFirestore.instance.collection("users").doc(customerid).get().then((value)  {
      if(value.exists){
        return UserModel.fromDocumentSnapshot(value);
      }
    });
  }
    getCustomerStatusDetails(String customerid)  {

   listener=  FirebaseFirestore.instance
        .collection("users")
        .doc(customerid)
        .snapshots()
        .listen((event) {
          currentChatCustomer.value =
            UserModel.fromDocumentSnapshot(event);
           
        });
  }

 Future updateseenMessages()async{
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
        await  FirebaseFirestore.instance.collection("Chats").doc(doc).collection("messages").doc(element).update({"seen":true});
      }
  }
  }
  }


