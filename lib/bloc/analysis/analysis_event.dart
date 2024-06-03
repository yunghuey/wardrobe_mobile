import 'package:equatable/equatable.dart';

class DisplayAnalysisEvent extends Equatable{
  @override
  List<Object> get props => []; 
} 

class GetBrandAnalysisEvent extends DisplayAnalysisEvent{}

class GetCountryAnalysisEvent extends DisplayAnalysisEvent{}

class GetColourAnalysisEvent extends DisplayAnalysisEvent{}

class GetSizeAnalysisEvent extends DisplayAnalysisEvent{}

// need to move to another 
class GetBrandDetailEvent extends DisplayAnalysisEvent{
  String brandName;
  GetBrandDetailEvent({required this.brandName});
}