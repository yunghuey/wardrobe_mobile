import 'dart:io';

class GarmentModel{
  String? id;
  String? name;
  String country;
  String brand;
  String colour;
  String size;
  File? image;
  bool? status;

  GarmentModel({
    this.id,
    this.name,
    required this.country,
    required this.brand,
    required this.colour,
    required this.size,
    this.status,
    this.image
  });

  factory GarmentModel.fromJson(Map<String, dynamic> json){
    return GarmentModel(
      id: json["id"],
      name: json["name"],
      country: json["country"],
      brand: json["brand"],
      colour: json["colour"],
      size: json["size"],
      status: json["status"],
      image: json["image"]
    );
  }

  factory GarmentModel.imageResult(Map<String, dynamic> json){
    return GarmentModel(
      country: json["country"] ?? '',
      brand: json["brand"] ?? '',
      colour: json["colour"] ?? '',
      size: json["size"] ?? '',
    );
  }
  // to view GarmentModel instance to Json Object
  Map<String,dynamic> detectJson(){
    return{
      'country': country,
      'brand': brand,
      'size': size,
      'colour': colour,
    };
  }
}