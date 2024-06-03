import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/weather.dart';

class GetWeatherState extends Equatable{
  @override
  List<Object> get props => [];
}

class GetWeatherInitState extends GetWeatherState {}

class GetWeatherSuccess extends GetWeatherState{
  WeatherModel weather;
  GetWeatherSuccess({required this.weather});
}

class GetWeatherFail extends GetWeatherState{
  String message;
  GetWeatherFail({required this.message});
}

class GettingWeatherState extends GetWeatherState {}