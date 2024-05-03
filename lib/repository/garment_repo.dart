import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/repository/APIConstant.dart';

class GarmentRepository{
  Future<bool> createGarment(GarmentModel shirt) async {
      try{
        var url = Uri.parse(APIConstant.addGarmentURL);
        print(url);
        var body = json.encode({
          "name":shirt.name,
          "brand": shirt.brand,
          "country": shirt.country,
          "size": shirt.size,
          "colour": shirt.colour,
          "status": true,
          "image": await _convertImageToBase64(shirt.image!),
          // "image": shirt.image,
        });
        print(body);
        var header = {
          "Content-Type": "application/json",
        };
        var response = await http.post(url, headers: header, body: body);
        print(response.statusCode);
        if (response.statusCode == 201) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
  }

  Future<String> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<GarmentModel?> processGarment(String base64) async{
      try{
        var url = Uri.parse(APIConstant.processImageURL);
        print(url);
        var body = json.encode({
          "image": base64
        });
        var header = {
          "Content-Type": "application/json",
        };
        var response = await http.post(url, body: body, headers: header);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          dynamic jsonValue = json.decode(response.body);
          Map<String, dynamic> resultJson =jsonValue['result'];
          print(resultJson);
          return GarmentModel.imageResult(resultJson);
        } else {
          return null;
        }
      } catch (e){
        return null;
      }
  }
}