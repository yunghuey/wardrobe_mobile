import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_state.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';

class TotalGarmentBloc extends Bloc<TotalGarmentEvent,TotalGarmentState>{
  AnalysisRepository repo;
  TotalGarmentBloc(TotalGarmentState initialState, this.repo): super(initialState){
    on<GetTotalEvent>((event, emit) async {
      try{
        emit(FetchingDataState());
        int? numberOfGarment = await repo.totalGarmentOfUser();
        emit(TotalGarmentAnalysis(numberOfGarment: numberOfGarment ?? 0));      
        // can call many function to get value and put in same state
      } catch(e){
        emit(FailGarmentAnalysis(message: e.toString()));
      }
      
    });
  }
}