import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Models/address_model.dart';

class PrescriptionOrder {
  String? userMadeOrder;
  List<String>? pickedImages;
  String? paymentMethod,orderDate,orderStatus,acceptedby,orderid,amount;
  AddressModel? userAddress;
  String?text;
 
  String? orderType;

  PrescriptionOrder({
     this.userMadeOrder,
     this.userAddress,
     this.pickedImages,
     this.paymentMethod,
     this.orderType,
     this.acceptedby,
     this.orderDate,
     this.orderStatus,
     this.orderid,
     this.text,
     this.amount,
  });

  factory PrescriptionOrder.fromDocumentSnapshot( DocumentSnapshot<Map<String,dynamic>> documentSnapshot) {
    return PrescriptionOrder(
        userMadeOrder:documentSnapshot.get("userMadeOrder")??"",
        orderid: documentSnapshot.id,
        userAddress:documentSnapshot.data().toString().contains("customerAddress")?AddressModel.fromJson(documentSnapshot.get("customerAddress")):AddressModel(),
        amount: documentSnapshot.get("amount")??"",
        pickedImages:documentSnapshot.data().toString().contains("Images")?(documentSnapshot.get("Images") as List).map((e) => e as String).toList():List.empty(),
        paymentMethod: documentSnapshot.get("paymentMethod") ?? "In Cash",
        acceptedby: documentSnapshot.get("Acceptedby")??"",
        orderDate: documentSnapshot.get("OrderDate")??"",
        text:documentSnapshot.data().toString().contains("text")?documentSnapshot.get("text"):"",
        orderStatus: documentSnapshot.get("OrderStatus")??"",
        orderType: documentSnapshot.get("OrderType") ?? "Delivery");
  }
}
