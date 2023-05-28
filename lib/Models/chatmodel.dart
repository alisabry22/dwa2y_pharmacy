
class ChatMessage {
  String sender;
  String receiver;
  String message;
  DateTime sentat;
  // Add additional properties like image URL, seen status, etc.

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentat,
  });
  
  factory ChatMessage.fromJson(Map<String,dynamic>json){
    return ChatMessage(sender: json["sender"], receiver: json["reciever"], message: json["message"], sentat: json["sentat"].toDate());


  }

   Map<String,dynamic> toJson()=>{
  "sender":sender,
  "reciever":receiver,
  "message":message,
  "sentat":sentat,

  
   };
}