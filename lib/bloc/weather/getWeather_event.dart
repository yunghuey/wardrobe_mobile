import 'package:equatable/equatable.dart';
class GetWeatherEvent extends Equatable{
  @override
  List<Object> get props => []; 
} 

class FindWeatherPressed extends GetWeatherEvent{
  final double long;
  final double lat;
  FindWeatherPressed({ required this.long, required this.lat});
}