import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class ReadGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class ReadGarmentInitState extends ReadGarmentState {}

class ReadAllGarmentLoading extends ReadGarmentState {}

class ReadAllGarmentSuccess extends ReadGarmentState{
  final List<GarmentModel> garmentss;
  ReadAllGarmentSuccess({required this.garmentss});
}

class ReadAllGarmentEmpty extends ReadGarmentState{}
