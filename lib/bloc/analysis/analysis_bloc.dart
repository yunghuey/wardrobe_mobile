import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';

class DisplayAnalysisBloc extends Bloc<DisplayAnalysisEvent,DisplayAnalysisState>{
  AnalysisRepository repo;
  DisplayAnalysisBloc(DisplayAnalysisState initialState, this.repo): super(initialState){
    on<GetTotalGarmentEvent>((event, emit) async {
      try{
        emit(FetchingDataState());
        int? numberOfGarment = await repo.totalGarmentOfUser();
        emit(DisplayGarmentAnalysis(numberOfGarment: numberOfGarment ?? 0));      
        // can call many function to get value and put in same state
      } catch(e){
        emit(FailGarmentAnalysis(message: e.toString()));
      }
      
    });
  }
}