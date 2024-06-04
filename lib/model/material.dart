import 'package:flutter/material.dart';

class MaterialModel{
  String materialName;
  double percentage;

  MaterialModel({required this.materialName, required this.percentage});

  factory MaterialModel.fromJson(Map<String, dynamic> json){
    return MaterialModel(
      materialName: json["material"], 
      percentage: json["percentage"].toDouble()
    );
  }
}