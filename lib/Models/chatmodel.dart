class ChatMessage {
  String sender;
  String receiver;
  String message;
  DateTime sentat;
  bool? delivered;
  bool? seen;
   String messagetype;
  String? pictureMessage;
  // Add additional properties like image URL, seen status, etc.

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentat,
      required this.messagetype,
        this.pictureMessage,
    this.seen,
    this.delivered,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        sender: json["sender"],
        receiver: json["reciever"],
             messagetype:json["messagetype"],
      pictureMessage:json["pictureMessage"]!=null?json["pictureMessage"]:null,
               delivered: json["delivered"]!=null?json["delivered"]:false,
        seen: json["seen"]!=null?json["seen"]:false,
        message: json["message"],
        sentat: json["sentat"].toDate());
        
  }

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "reciever": receiver,
          "delivered":delivered,
        "seen":seen,
           "pictureMessage":pictureMessage,
        "messagetype":messagetype,
        "message": message,
        "sentat": sentat,
      };
}
