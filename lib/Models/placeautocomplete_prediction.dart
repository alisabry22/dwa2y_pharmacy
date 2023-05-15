import 'package:google_maps_webservice/places.dart';

class PlaceAutoCompletePrediction{

  String? description;
   StructuredFormatting? structuredFormatting;
   final String? placeId;
   final String? reference;

   PlaceAutoCompletePrediction({

    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
   });

   factory PlaceAutoCompletePrediction.fromJson(Map<String,dynamic>json){
    return PlaceAutoCompletePrediction(
      description: json["description"]as String,
      placeId: json["place_id"]as String?,
      structuredFormatting: json["structured_formatting"]!=null?StructuredFormatting.fromJson(json["structured_formatting"]):null,
      reference: json["reference"] as String?,
    );
   }
}