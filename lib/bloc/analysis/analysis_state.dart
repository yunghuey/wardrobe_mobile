import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/brand.dart';
import 'package:wardrobe_mobile/model/colour.dart';
import 'package:wardrobe_mobile/model/country.dart';
import 'package:wardrobe_mobile/model/size.dart';

class DisplayAnalysisState extends Equatable{
  @override
  List<Object> get props => [];
}

class DisplayAnalysisInitState extends DisplayAnalysisState {}
class FetchingAnaDataState extends DisplayAnalysisState {}
// total number of garment for each brand
class BrandAndNumberBarChart extends DisplayAnalysisState {
  final List<BrandModel> data;
  final double y;
  BrandAndNumberBarChart({required this.data, required this.y});
}

class BrandAndNumberError extends DisplayAnalysisState{
  final String message;
  BrandAndNumberError({required this.message});
}

// country
class CountryAndNumberBarChart extends DisplayAnalysisState {
  final List<CountryModel> data;
  final double y;
  CountryAndNumberBarChart({required this.data, required this.y});
}

class CountryAndNumberError extends DisplayAnalysisState{
  final String message;
  CountryAndNumberError({required this.message});
}

// colour
class ColourAndNumberBarChart extends DisplayAnalysisState {
  final List<ColourModel> data;
  final double y;
  ColourAndNumberBarChart({required this.data, required this.y});
}

class ColourAndNumberError extends DisplayAnalysisState{
  final String message;
  ColourAndNumberError({required this.message});
}

// size
class SizeAndNumberBarChart extends DisplayAnalysisState {
  final List<SizeModel> data;
  final double y;
  SizeAndNumberBarChart({required this.data, required this.y});
}

class SizeAndNumberError extends DisplayAnalysisState{
  final String message;
  SizeAndNumberError({required this.message});
}
