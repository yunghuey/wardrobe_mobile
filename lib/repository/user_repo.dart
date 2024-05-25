import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/model/user.dart';
import 'package:wardrobe_mobile/repository/APIConstant.dart';

class UserRepository{
  Future<int> loginUser(UserModel user) async{
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      var url = Uri.parse(APIConstant.loginURL);
      var body = json.encode({
        "username": user.username,
        "password": user.password
      });
      var response = await http.post(url, headers: APIConstant.header, body: body);
      if (response.statusCode == 200){
          dynamic jsonValue = json.decode(response.body)['token'];
          print(jsonValue);
          pref.setString('token', jsonValue);
          return 1;
      }
      else if(response.statusCode == 404){
        print("username error");
        return 2;
      }
      else if(json.decode(response.body)['error'][0] == 'p'){
        print("password error");
        return 3;
      }
      return 0;
    } catch (e) {
        return 0;
    }
  }

  Future<bool> logoutUser() async {
    var pref = await SharedPreferences.getInstance();
    try{  
      var url = Uri.parse(APIConstant.logoutURL);
      
      String? token = pref.getString('token');
      if (token != null){
        var header = {
          "Content-Type": "application/json",
          'Authorization' : 'Bearer $token',
        };
        print(url);
        var response = await http.put(url, headers: header);
        if (response.statusCode == 200) {
          pref.remove("token");
          return true;
        }
        print(json.decode(response.body));
      }
      return false;
    } catch (e) {
      print("logout fail");
      print(e.toString());
      return false;
    }
  }

  Future<bool> registerUser(UserModel user) async {
    try{
      var url = Uri.parse(APIConstant.registerURL);
      var body = json.encode({
        "email": user.email,
        "username": user.username,
        "password": user.password,
        "first_name": user.firstname,
        "last_name": user.lastname
      });

      var response = await http.post(url,headers: APIConstant.header, body: body);
      if (response.statusCode == 201){
        SharedPreferences pref = await SharedPreferences.getInstance();
        dynamic jsonValue = json.decode(response.body)['token'];
        pref.setString('token', jsonValue);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
