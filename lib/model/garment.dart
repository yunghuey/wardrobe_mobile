import 'dart:io';

class GarmentModel{
  String? id;
  String? name;
  String country;
  String brand;
  String colour;
  String size;
  File? image;
  String? imageURL;
  bool? status;
  String? created_date;

  GarmentModel({
    this.id,
    this.name,
    required this.country,
    required this.brand,
    required this.colour,
    required this.size,
    this.status,
    this.imageURL,
    this.image,
    this.created_date,
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
      imageURL: json["image_url"],
      created_date: json["created_date"]
    );
  }

  factory GarmentModel.imageResult(Map<String, dynamic> json){
    return GarmentModel(
      country: json["country"] ?? 'Select Country',
      brand: json["brand"] ?? 'Select Brand',
      colour: json["colour"] ?? '#000000',
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
    };
  }
}