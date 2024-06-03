import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/barchart.dart';

class DisplayAnalysisState extends Equatable{
  @override
  List<Object> get props => [];
  List<BarChartModel> data = [];
  String message = "";
}

class DisplayAnalysisInitState extends DisplayAnalysisState {}

class FetchingAnaDataState extends DisplayAnalysisState {}

// total number of garment for each brand
class DataAndNumberBarChart extends DisplayAnalysisState {
  final List<BarChartModel> data;
  final double y;
  DataAndNumberBarChart({required this.data, required this.y});
}

class DataAndNumberError extends DisplayAnalysisState{
  final String message;
  DataAndNumberError({required this.message});
}

class DataAndNumberEmpty extends DisplayAnalysisState{}