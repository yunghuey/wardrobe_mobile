import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/brand.dart';

class TotalGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class TotalGarmentInitState extends TotalGarmentState {}

// total number of garment in a whole
class TotalGarmentAnalysis extends TotalGarmentState {
  final int numberOfGarment;
  TotalGarmentAnalysis({ required this.numberOfGarment});
}

class FailGarmentAnalysis extends TotalGarmentState{
  final String message;
  FailGarmentAnalysis({required this.message});
}

class FetchingDataState extends TotalGarmentState{}