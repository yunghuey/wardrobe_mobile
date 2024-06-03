class WeatherModel{
  String? weatherday;
  String? description;
  double? currentTemperature;
  double? humidityTemperature;

  WeatherModel({
    this.weatherday,
    this.description,
    this.currentTemperature,
    this.humidityTemperature
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
      weatherday: json["weathername"],
      description: json["description"],
      humidityTemperature: json["humidity"]?.toDouble(),
      currentTemperature: json["temperature"]?.toDouble(),
    );
  }
}