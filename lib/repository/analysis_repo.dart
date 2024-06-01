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

  Future<Map<String, dynamic>> brandAnalysis() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.brandAnalysisURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          var value = json.decode(response.body)['brandResult'];
          print(value);
          return value;
        }
      }
      return {};
    } catch (e){
      print(e.toString());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> countryAnalysis() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.countryAnalysisURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          var value = json.decode(response.body);
          print(value);
          return value;
        }
      }
      return {};
    } catch (e){
      print(e.toString());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> colourAnalysis() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.colourAnalysisURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          var value = json.decode(response.body);
          print(value);
          return value;
        }
      }
      return {};
    } catch (e){
      print(e.toString());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> sizeAnalysis() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.sizeAnalysisURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          var value = json.decode(response.body);
          print(value);
          return value;
        }
      }
      return {};
    } catch (e){
      print(e.toString());
      return Future.error(e);
    }
  }

}