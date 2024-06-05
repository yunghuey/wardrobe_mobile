import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/repository/APIConstant.dart';

class GarmentRepository{
  Future<bool> createGarment(GarmentModel shirt) async {
      try{
        var pref = await SharedPreferences.getInstance();
        String? token = pref.getString('token') ;
        if (token != null){
          var url = Uri.parse(APIConstant.addGarmentURL);
          var body = json.encode({
            "name":shirt.name,
            "brand": shirt.brand,
            "country": shirt.country,
            "size": shirt.size,
            "colour": shirt.colour,
            "colour_name" : shirt.colour_name,
            "materialList": shirt.materialList?.map((material) => {
              "material_name": material.materialName,
              "percentage": material.percentage
            }).toList(),
            "status": true,
            "image": await _convertImageToBase64(shirt.garmentImage!),
            "material": await _convertImageToBase64(shirt.materialImage!),
          });
          print(body);
          var header = {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          };
          var response = await http.post(url, headers: header, body: body);
          print(response.statusCode);
          if (response.statusCode == 201) {
            return true;
          }
        }
        return false;
      } catch (e, stackTrace) {
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

  Future<List<GarmentModel>> getAllGarment() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){
        var url = Uri.parse(APIConstant.getAllGarmentsURL);
        var header = {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          List<dynamic> result = jsonDecode(response.body)['garments'];
          return result.map((e) => GarmentModel.allFromJson(e)).toList();
        } else {
          print(response.body);
          return [];
        }
      }
      return [];
    } catch (e) {
      print("error: " + e.toString());
      return [];
    }
  }

  Future<GarmentModel?> getOneGarment(String id) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){
        var url = Uri.parse(APIConstant.getOneGarmentURL + id);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          print(jsonDecode(response.body));

          var result = jsonDecode(response.body)['garments'];
          return GarmentModel.fromJson(result);
        }
      }
      return null;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future<bool> deleteGarment(String id) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){

        var url = Uri.parse(APIConstant.deleteGarmentURL);
        print(id);
        var body = json.encode({
          "id" : id,
        });
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        var response = await http.delete(url, headers: header, body:body);

        if (response.statusCode == 200){
          return true;
        }
      }
      return false;
    } catch(e){
      print(e.toString());
      return false;
    }

  }

  Future<bool> updateGarment(GarmentModel gmt) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){
        var url = Uri.parse(APIConstant.updateGarmentURL + gmt.id!);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        var body = json.encode({
          "brand": gmt.brand,
          "name": gmt.name,
          "colour": gmt.colour,
          "colour_name": gmt.colour_name,
          "country": gmt.country,
          "size" : gmt.size,
          "status": true,
          "materialList": gmt.materialList?.map((material) => {
              "material_name": material.materialName,
              "percentage": material.percentage
            }).toList(),
        });

        var response = await http.put(url, headers: header, body: body);
        if (response.statusCode == 200){
          return true;
        }
      }
      return false;
    } catch (e){
      return false;
    }
  }

  Future<List<MaterialModel>> getMaterialList(String materialImageByte) async {
    try{
      List<MaterialModel> materials = [];
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){
        var url = Uri.parse(APIConstant.detectMaterialURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        print(url);
        var body = json.encode({
          "image" : materialImageByte
        });

        var response = await http.post(url, headers: header, body: body);
        if (response.statusCode == 201){
          List<dynamic> value  = json.decode(response.body)['result'];
          print("material value ${value}");
          materials = value.map((e) => MaterialModel.fromJson(e)).toList();
          return materials;
        }
        else {
          return Future.error(json.decode(response.body)['error']);
        }
      
      }
      return materials;
    } catch (e, stackTrace){
      print(stackTrace.toString());
      print(e.toString());
      return Future.error(e);
    }
  }
}