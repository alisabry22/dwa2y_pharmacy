import 'package:dwa2y_pharmacy/Models/product_model.dart';
import 'package:flutter/material.dart';


class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key,required this.product});
final ProductModel product;
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar: AppBar(title:const Text("Dwa2y",),),
    );
  }
}