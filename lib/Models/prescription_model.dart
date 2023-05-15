import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionOrder {
  String? userMadeOrder;
  List<String>? pickedImages;
  String? paymentMethod,orderDate,orderStatus,acceptedby,orderid,amount;

 
  String? orderType;

  PrescriptionOrder({
     this.userMadeOrder,
     this.pickedImages,
     this.paymentMethod,
     this.orderType,
     this.acceptedby,
     this.orderDate,
     this.orderStatus,
     this.orderid,
     this.amount,
  });

  factory PrescriptionOrder.fromDocumentSnapshot( DocumentSnapshot<Map<String,dynamic>> documentSnapshot) {
    return PrescriptionOrder(
        userMadeOrder:documentSnapshot.get("userMadeOrder")??"",
        orderid: documentSnapshot.id,
        amount: documentSnapshot.get("amount")??"",
        pickedImages:(documentSnapshot.get("Images") as List).map((e) => e as String).toList(),
        paymentMethod: documentSnapshot.get("paymentMethod") ?? "In Cash",
        acceptedby: documentSnapshot.get("Acceptedby")??"",
        orderDate: documentSnapshot.get("OrderDate")??"",
        orderStatus: documentSnapshot.get("OrderStatus")??"",
        orderType: documentSnapshot.get("OrderType") ?? "Delivery");
  }
}
