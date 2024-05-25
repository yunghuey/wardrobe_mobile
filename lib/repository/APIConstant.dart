import 'package:shared_preferences/shared_preferences.dart';

class APIConstant {
  static const String ipaddress = "http://192.168.0.20:8000"; // melaka home
  //  10.131.76.224
  static var header = { "Content-Type": "application/json", };

  // garment repo
  static String get addGarmentURL => "${APIConstant.ipaddress}/garment/add/";
  static String get processImageURL => "${APIConstant.ipaddress}/garment/submitImage";
  static String get getAllGarmentsURL => "${APIConstant.ipaddress}/garment/getAll/";
  static String get getOneGarmentURL => "${APIConstant.ipaddress}/garment/getGarment/";
  static String get deleteGarmentURL => "${APIConstant.ipaddress}/garment/delete/";
  static String get updateGarmentURL => "${APIConstant.ipaddress}/garment/update/";

  // user repo
  static String get loginURL => "${APIConstant.ipaddress}/account/login/";
  static String get logoutURL => "${APIConstant.ipaddress}/account/logout/";
  static String get registerURL => "${APIConstant.ipaddress}/account/add/";
  static String get refreshToken => "${APIConstant.ipaddress}/account/refreshToken/";
  static String get getOneUser => "${APIConstant.ipaddress}/account/";
  static String get updateUser => "${APIConstant.ipaddress}/account/update/";
} 