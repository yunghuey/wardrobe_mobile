import 'package:equatable/equatable.dart';

class DisplayPieChartEvent extends Equatable{
  @override
  List<Object> get props => []; 
} 

class PieChartReset extends DisplayPieChartEvent {}

class BrandPieChart extends DisplayPieChartEvent {
  final String brandname;
  BrandPieChart({required this.brandname});
}

class CountryPieChart extends DisplayPieChartEvent {
  final String countryname;
  CountryPieChart({required this.countryname});
}

class ColourPieChart extends DisplayPieChartEvent {
  final String colourname;
  ColourPieChart({required this.colourname});
}

class SizePieChart extends DisplayPieChartEvent {
  final String sizename;
  SizePieChart({required this.sizename});
}