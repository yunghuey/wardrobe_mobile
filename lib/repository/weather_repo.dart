import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/weather.dart';
import 'package:wardrobe_mobile/repository/APIConstant.dart';

class WeatherRepository{
  Future<WeatherModel?> getWeatherByLngLat(double lng, double lat) async {
    try{
        var pref = await SharedPreferences.getInstance();
        String? token = pref.getString('token') ;
        if (token != null){
          var url = Uri.parse(APIConstant.getWeatherWithLocationURL);
          var header = {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          };
          var body = json.encode({
            "latitude": lat,
            "longitude": lng
          });

          var response = await http.post(url,headers: header,body: body);

          if (response.statusCode == 200){
            Map<String, dynamic> result = jsonDecode(response.body);
            return WeatherModel.fromJson(result);
          } 
        }
        return null;
      } catch (e, stackTrace){
        print(stackTrace.toString());
        print(e.toString());
        return Future.error(e);
      }

  }

  Future<List<GarmentModel>> getRecommendationByLngLat(double lng, double lat) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token') ;
      if (token != null){
        var url = Uri.parse(APIConstant.getRecommendationWithLocationURL);
        var header = {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
        };

        var body = json.encode({
          "latitude": lat,
          "longitude": lng
        });
        var response = await http.post(url, headers: header,body: body);
        if (response.statusCode == 200){
          List<dynamic> result = jsonDecode(response.body)['garments'];
          return result.map((e) => GarmentModel.allFromJson(e)).toList();
        } else {
          print(response.body);
          return [];
        }
      }
      return [];
    } catch (e, stackTrace){
      print(e.toString());
      print(stackTrace.toString());
      return Future.error(e);
    }
  }
}