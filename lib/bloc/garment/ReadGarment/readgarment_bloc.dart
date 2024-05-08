import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

class ReadGarmentBloc extends Bloc<ReadGarmentEvent,ReadGarmentState>{
  GarmentRepository repo;
  ReadGarmentBloc(ReadGarmentState initialState, this.repo):super(initialState){
    on<GetAllGarmentEvent>((event, emit) async {
      emit(ReadAllGarmentLoading());
      List<GarmentModel> garments = await repo.getAllGarment();
      if (garments.length > 0){
        emit(ReadAllGarmentSuccess(garmentss: garments));
      }
      else {
        print(garments.length);
        emit(ReadAllGarmentEmpty());
      }
    });
  }
}