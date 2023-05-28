
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwa2y_pharmacy/Controllers/home_controller.dart';
import 'package:dwa2y_pharmacy/Models/product_model.dart';
import 'package:dwa2y_pharmacy/Utils/Constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



class ProductController extends GetxController{
Rx<TextEditingController> productName=TextEditingController().obs;
Rx<TextEditingController> productPrice=TextEditingController().obs;
Rx<TextEditingController> discountPercent=TextEditingController().obs;
final accountController=Get.find<HomeController>();
RxString productCategory="Capsules".tr.obs;
Rx<String> productImagePicked="".obs;
Rx<ProductModel> product=ProductModel().obs;
RxBool onLongPress=false.obs;
RxList <ProductModel>productsPicked=<ProductModel>[].obs;
RxString valueToUpdate="".obs;


  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentDocument(String productId){
    return FirebaseFirestore.instance.collection("Products").doc(productId).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts(){
    
         return  FirebaseFirestore.instance.collection("Products").where('pharmacyId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();

    
  
    
  }
  Future addProduct( )async{
     
  
    
    if(productName.value.text.isNotEmpty && productPrice.value.text.isNotEmpty &&productImagePicked.value.isNotEmpty){
       showCircleLoading();
        int equation=0;
        int afterDiscount=0;
         ProductModel productModel=ProductModel();
         
      final String url=await uploadattachmentToDatabase();
      if(discountPercent.value.text.isNotEmpty){
       equation=int.parse(productPrice.value.text)*int.parse(discountPercent.value.text);
       equation=equation~/100;
       afterDiscount=int.parse(productPrice.value.text.trim())-equation;
      }
        productModel=ProductModel(
      productName: productName.value.text.trim(),
      pharmacyName: accountController.currentpharmacy.value.username,
      productCategory: productCategory.value,
      productPrice: int.parse(productPrice.value.text.trim()),
      productImage: url,
      discountPercent:discountPercent.value.text.isNotEmpty?int.parse(discountPercent.value.text.trim()):0,
      afterDiscount: afterDiscount,
      pharmacyId: accountController.currentpharmacy.value.userid,
    
    );
     await FirebaseFirestore.instance.collection("Products").add(productModel.toMap());
    Get.back();
    Get.back();
       productName.value.text="";
     productImagePicked.value="";
     productPrice.value.text="";
     discountPercent.value.text="";
     return  Get.snackbar("Great".tr, "Succssefully Added Product".tr,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.grey);

   
     
    }else{
     return Get.snackbar("fill fields".tr, "Please Fill All Required Fields".tr,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.grey);
      
    }
   
   
  }
  Future removeProduct(List<String> productId)async{
    for(int i=0 ; i<productId.length ; i++){
          await FirebaseFirestore.instance.collection("Products").doc(productId[i]).delete();

    }
  }
  Future editProduct(String prodcutId)async{

    // await FirebaseFirestore.instance.collection("Products").doc(prodcutId).update(data);
  }
  Future updateProductName(String productId,String name)async{
    await FirebaseFirestore.instance.collection("Products").doc(productId).update({"productName":name});
  }
    Future updateProductPrice(String productId,int price)async{
    await FirebaseFirestore.instance.collection("Products").doc(productId).update({"productPrice":price});
  }
    Future updateProductDiscount(String productId,int percent,int productPrice)async{
            int equation=0;
        int afterDiscount=0;
            equation=productPrice*percent;
       equation=equation~/100;
       afterDiscount=productPrice-equation;
      var data={
        'discountPercent':percent,
        'afterDiscount':afterDiscount,
      };
    await FirebaseFirestore.instance.collection("Products").doc(productId).update(data);
  }
   Future updateProductCategory(String productId,String productCategory)async{
     
    await FirebaseFirestore.instance.collection("Products").doc(productId).update({"productCategory":productCategory});
  }


    Future pickProductImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      productImagePicked.value = file.path;
    } else {
      return null;
    }
  }

  Future uploadattachmentToDatabase() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;

    if (productImagePicked.value.isNotEmpty) {
     
        Reference storage = FirebaseStorage.instance
            .ref()
            .child("/products")
            .child(userid);

        File file = File(productImagePicked.value);
        String path=file.path.split(Platform.pathSeparator).last.toString();
        UploadTask uploadTask = storage.child(path).putFile(file);

        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final downloadurl = await snapshot.ref.getDownloadURL();

      return downloadurl;
      
    }
  }

   showCircleLoading(){
    Get.dialog(
     Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:  [const CircularProgressIndicator(color: Constants.btnColor,), const SizedBox(width: 10,),Text("Loading...".tr)],
          ),
        ),
      ),
    );
   
  }



}