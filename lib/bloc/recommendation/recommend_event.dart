import 'package:equatable/equatable.dart';

class RecommendationEvent extends Equatable{
  @override
  List<Object> get props => []; 
} 

class GetRecommendationEvent extends RecommendationEvent{
  final double lat;
  final double long;
  GetRecommendationEvent({required this.lat, required this.long});
}