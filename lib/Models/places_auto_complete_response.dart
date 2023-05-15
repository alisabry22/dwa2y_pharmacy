import 'dart:convert';

import 'package:dwa2y_pharmacy/Models/placeautocomplete_prediction.dart';


class PlacesAutoCompleteResponse {
  final String? status;
  final List<PlaceAutoCompletePrediction>? predictions;

  PlacesAutoCompleteResponse({this.status, this.predictions});

  factory PlacesAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlacesAutoCompleteResponse(
      status: json["status"] as String?,
      predictions: json["predictions"] 
          ?? json["predictions"].map<PlaceAutoCompletePrediction>(
              (json) => PlaceAutoCompletePrediction.fromJson(json)).toList()
          ,
    );
  }

  static PlacesAutoCompleteResponse parseAutoCompleteResult(String responsebody){

    final parse=json.decode(responsebody) as Map<String,dynamic>;
    return PlacesAutoCompleteResponse.fromJson(parse);
  }
}
