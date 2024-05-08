import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class CreateGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class CreateGarmentInitState extends CreateGarmentState {}

class CreateGarmentLoadingState extends CreateGarmentState {}

class DetectGarmentLoadingState extends CreateGarmentState {}

class DetectGarmentSuccessState extends CreateGarmentState {
  final GarmentModel result;
  DetectGarmentSuccessState({required this.result});
}

class DetectGarmentFailState extends CreateGarmentState{
  final String message;
  DetectGarmentFailState({required this.message});
}

class CreateGarmentFailState extends CreateGarmentState {
  final String message;
  CreateGarmentFailState({required this.message});
}

class CreateGarmentSuccessState extends CreateGarmentState {} 