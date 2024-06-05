import 'dart:io';

import 'package:wardrobe_mobile/model/material.dart';

class GarmentModel{
  String? id;
  String? name;
  String country;
  String brand;
  String colour;
  String size;
  File? garmentImage;
  String? garmentImageURL;
  File? materialImage;
  String? materialImageURL;
  bool? status;
  String? created_date;
  String? colour_name;
  List<MaterialModel>? materialList;

  GarmentModel({
    this.id,
    this.name,
    required this.country,
    required this.brand,
    required this.colour,
    required this.size,
    this.status,
    this.garmentImageURL,
    this.garmentImage,
    this.materialImageURL,
    this.materialImage,
    this.created_date,
    this.colour_name,
    this.materialList,
  });

  factory GarmentModel.fromJson(Map<String, dynamic> json){
    return GarmentModel(
      id: json["id"],
      name: json["name"],
      country: json["country"],
      brand: json["brand"],
      colour: json["colour"],
      colour_name: json["colour_name"],
      size: json["size"],
      status: json["status"],
      garmentImageURL: json["image_url"],
      materialImageURL: json["material_url"],
      created_date: json["created_date"],
      materialList: json["materialList"] ?? [],
    );
  }

  factory GarmentModel.imageResult(Map<String, dynamic> json){
    return GarmentModel(
      country: json["country"] ?? 'Select Country',
      brand: json["brand"] ?? 'Select Brand',
      colour: json["colour"] ?? '#000000',
      colour_name: json["colour_name"] ?? 'NONE',
      size: json["size"] ?? 'Select Size',
    );
  }
  // to view GarmentModel instance to Json Object
  Map<String,dynamic> detectJson(){
    return{
      'country': country,
      'brand': brand,
      'size': size,
      'colour': colour,
      'colour_name': colour_name
    };
  }
}