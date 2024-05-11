class APIConstant{
  // static const String ipaddress = "http://192.168.0.157:8000"; // klang home
  // static const String ipaddress = "http://10.131.74.132:8000"; // utem
  static const String ipaddress = "http://192.168.0.20:8000"; // melaka home
  
  static String get addGarmentURL => "${APIConstant.ipaddress}/garment/add/";
  static String get processImageURL => "${APIConstant.ipaddress}/garment/submitImage";
  static String get getAllGarmentsURL => "${APIConstant.ipaddress}/garment/getAll/";
  static String get getOneGarmentURL => "${APIConstant.ipaddress}/garment/getGarment/";
  static String get deleteGarmentURL => "${APIConstant.ipaddress}/garment/delete/";
  static String get updateGarmentURL => "${APIConstant.ipaddress}/garment/update/";
} 