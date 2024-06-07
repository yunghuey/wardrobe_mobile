import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class RecommendationState extends Equatable{
  @override
  List<Object> get props => [];
}

class GetRecommendInitState extends RecommendationState{}

class GetRecommendationLoading extends RecommendationState {}

class RecommendationSuccess extends RecommendationState{
  List<GarmentModel> garmentList;
  RecommendationSuccess({required this.garmentList});
}

class RecommendationEmpty extends RecommendationState {}

class RecommendationError extends RecommendationState {
  final String message;
  RecommendationError({required this.message});
}