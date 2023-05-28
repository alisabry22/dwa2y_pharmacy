import 'package:cloud_firestore/cloud_firestore.dart';

class AllChatsModel {
  String? lastmessage;
  String? senderId;
  String? receiverId;
  String? sendername;
  String? receivername;
  String? sentat;
  String? receiverProfileImage;
    String? senderProfileImage;
    String? chatId;

  AllChatsModel({
    this.lastmessage,
    this.senderId,
    this.receiverId,
    this.receivername,
    this.receiverProfileImage,
    this.sentat,
    this.sendername,
  this.senderProfileImage,
  this.chatId,
  });

  factory AllChatsModel.fromsnapshot(DocumentSnapshot <Map<String,dynamic>> doc){
    return AllChatsModel(
        senderId:doc.get("senderId")!=null?doc.get("senderId"):"",
        chatId:doc.exists?doc.id:"",
        senderProfileImage: doc.get("senderProfileImage")!=null?doc.get("senderProfileImage"):"",
        receiverId: doc.get("receiverId")!=null?doc.get("receiverId"):"",
        sendername:  doc.get("sendername")!=null?doc.get("sendername"):"",
        receivername: doc.get("receivername")!=null?doc.get("receivername"):"",
       receiverProfileImage: doc.get("receiverProfileImage")!=null?doc.get("receiverProfileImage"):"",
       sentat: doc.get("sentat")!=null?doc.get("sentat"):"",
       lastmessage: doc.get("lastmessage")!=null?doc.get("lastmessage"):"",

    );
  
  } 
}