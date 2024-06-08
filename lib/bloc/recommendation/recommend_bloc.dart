import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/recommendation/recommend_event.dart';
import 'package:wardrobe_mobile/bloc/recommendation/recommend_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/repository/weather_repo.dart';

class RecommendationBloc extends Bloc<RecommendationEvent,RecommendationState>{
  WeatherRepository repo;
  RecommendationBloc(RecommendationState initialState, this.repo):super(initialState){
    on<GetRecommendationEvent>((event,emit) async{
      try{
        emit(GetRecommendationLoading());
        List<GarmentModel> garmentlist = [];
        garmentlist = await repo.getRecommendationByLngLat(event.long, event.lat);
        print(garmentlist.length);
        if (garmentlist.length == 0){
          emit(RecommendationEmpty());
        }
        else {
          emit(RecommendationSuccess(garmentList: garmentlist));
        }
      }catch(e){
        emit(RecommendationError(message: e.toString()));
      }
    });
  }
}