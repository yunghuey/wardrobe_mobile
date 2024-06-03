import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_event.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_state.dart';
import 'package:wardrobe_mobile/model/weather.dart';
import 'package:wardrobe_mobile/repository/weather_repo.dart';

class GetWeatherBloc extends Bloc<GetWeatherEvent, GetWeatherState>{
  WeatherRepository repo;
  GetWeatherBloc(GetWeatherState initialState, this.repo): super(initialState){
    on<FindWeatherPressed>((event, emit) async {
      print('hello weather');
      try{
        emit(GettingWeatherState());
        WeatherModel? weather = await repo.getWeatherByLngLat(event.long, event.lat);
        if (weather != null){
          emit(GetWeatherSuccess(weather: weather));
        }
        else{
          emit(GetWeatherFail(message: "Unable to receive weather information"));
        }
      } catch (e){
        emit(GetWeatherFail(message: e.toString()));
      }
    });
  }
}