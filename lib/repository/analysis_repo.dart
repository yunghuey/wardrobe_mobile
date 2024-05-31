import 'package:wardrobe_mobile/repository/APIConstant.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisRepository{
  Future<int?> totalGarmentOfUser() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.totalGarmentURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          var value = json.decode(response.body)['totalGarment'];
          return value;
        }
      }
    } catch (e){
      print(e.toString());
      return Future.error(e);
    }
    return 0;
  }
}