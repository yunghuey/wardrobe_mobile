class APIConstant{
  static const String ipaddress = "http://192.168.0.157:8000";
  static String get addGarmentURL => "${APIConstant.ipaddress}/garment/add/";
  static String get processImageURL => "${APIConstant.ipaddress}/garment/submitImage";
  static String get getAllGarmentURL => "${APIConstant.ipaddress}/garment/getAll";
} 