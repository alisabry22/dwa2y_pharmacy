import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController{

 final language= GetStorage();
 
  Rx<Locale> locale=const Locale('en').obs;
 @override
  void onInit() {
    //
    super.onInit();
   // get local language of user 

    if(language.read("language")!=null){
       locale.value=Locale(language.read("language"));
       locale.refresh();
    }else{
      locale.value=Get.deviceLocale!;
        locale.refresh();
    }

       print("language.read ${language.read("language")}");
  }

 Future changeLanguage(String langcode)async{
  locale.value=Locale(langcode);
  Get.updateLocale(locale.value);
  await language.write("language", langcode);
  print("lnag controller write ${language.read("language")}");


 }

 Future updateLocaleDatabase(String lang)async{
  await FirebaseFirestore.instance.collection("pharmacies").doc(FirebaseAuth.instance.currentUser!.uid).update({"locale":lang});
 }
}