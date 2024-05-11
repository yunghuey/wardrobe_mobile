import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class OneGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class ReadOneGarmentInitState extends OneGarmentState {}

class ReadOneGarmentLoading extends OneGarmentState {}

class ReadOneGarmentSuccess extends OneGarmentState {
  final GarmentModel garment;
  ReadOneGarmentSuccess({required this.garment});
}

class ReadOneGarmentError extends OneGarmentState {
  final String message;
   ReadOneGarmentError({required this.message});
}