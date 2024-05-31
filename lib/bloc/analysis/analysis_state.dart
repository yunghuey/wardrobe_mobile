import 'package:equatable/equatable.dart';

class DisplayAnalysisState extends Equatable{
  @override
  List<Object> get props => [];
}

class DisplayAnalysisInitState extends DisplayAnalysisState {}

class DisplayGarmentAnalysis extends DisplayAnalysisState {
  final int numberOfGarment;
  DisplayGarmentAnalysis({ required this.numberOfGarment});
}

class FailGarmentAnalysis extends DisplayAnalysisState{
  final String message;
  FailGarmentAnalysis({required this.message});
}

class FetchingDataState extends DisplayAnalysisState{}