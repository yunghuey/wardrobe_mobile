import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/barchart.dart';

class DisplayPieChartState extends Equatable{
  @override
  List<Object> get props => []; 
} 

class PieChartInitState extends DisplayPieChartState {}

class FetchingPieData extends DisplayPieChartState {}

class PieChartDataState extends DisplayPieChartState {
  final List<BarChartModel> pie1;
  final List<BarChartModel> pie2;
  final List<BarChartModel> pie3;
  final String indicator;
  final String pie1Type;
  final String pie2Type;
  final String pie3Type;
  final double y;
  PieChartDataState({
    required this.pie1, 
    required this.pie2, 
    required this.pie3, 
    required this.indicator,
    required this.pie1Type,
    required this.pie2Type,
    required this.pie3Type,
    required this.y,
  });
}

class PieChartEmpty extends DisplayPieChartState{}

class PieChartError extends DisplayPieChartState{
  final String error;
  PieChartError({required this.error});
}
