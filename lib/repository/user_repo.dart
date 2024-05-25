import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/model/user.dart';
import 'package:wardrobe_mobile/repository/APIConstant.dart';

class UserRepository{
  Future<int> loginUser(UserModel user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var url = Uri.parse(APIConstant.loginURL);
    var body = json.encode({
      "username": user.username,
      "password": user.password
    });
    var response = await http.post(url, headers: APIConstant.header, body: body);
    if (response.statusCode == 200){
        dynamic jsonValue = json.decode(response.body)['token'];
        pref.setString('key', jsonValue);
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
  }

  // Future<bool> registerUser(UserModel user) async {

  // }
}
