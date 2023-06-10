import 'package:cloud_firestore/cloud_firestore.dart';

class AllChatsModel {
  String? lastmessage;
  String? senderId;
  String? receiverId;
  String? sendername;
  String? receivername;
  DateTime? sentat;
  String? receiverProfileImage;
    String? senderProfileImage;
    String? chatId;
int? customerTotalUnRead;
int? pharmacyTotalUnRead;
  String ? duration;

  AllChatsModel({
    this.lastmessage,
    this.senderId,
    this.receiverId,
    this.receivername,
    this.receiverProfileImage,
    this.sentat,
    this.customerTotalUnRead,
    this.pharmacyTotalUnRead,
    this.sendername,
    this.duration,
  this.senderProfileImage,
  this.chatId,
  });

  factory AllChatsModel.fromsnapshot(DocumentSnapshot <Map<String,dynamic>> doc){
    return AllChatsModel(
     senderId:doc.get("senderId")!=null?doc.get("senderId"):"",
        customerTotalUnRead: doc.data().toString().contains("customerTotalUnRead")?doc.get("customerTotalUnRead"):null,
        pharmacyTotalUnRead:doc.data().toString().contains("pharmacyTotalUnRead")?doc.get("pharmacyTotalUnRead"):null ,
        chatId:doc.exists?doc.id:"",
        duration: doc.data().toString().contains("duration")?doc.get("duration"):"",
        senderProfileImage:doc.data().toString().contains("senderProfileImage")? doc.get("senderProfileImage"):"",
        receiverId:doc.data().toString().contains("receiverId") ?doc.get("receiverId"):"",
        sendername:doc.data().toString().contains("sendername")?doc.get("sendername"):"",
        receivername: doc.data().toString().contains("receivername")?doc.get("receivername"):"",
       receiverProfileImage:doc.data().toString().contains("receiverProfileImage")?doc.get("receiverProfileImage"):"",
       sentat:doc.data().toString().contains("sentat")? doc.get("sentat").toDate() :"",
       lastmessage:doc.data().toString().contains("lastmessage")?doc.get("lastmessage"):"",

    );
  
  } 
}