import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

class ReadOneGarmentBloc extends Bloc<GetOneGarmentEvent, OneGarmentState>{
  GarmentRepository repo;
  ReadOneGarmentBloc(OneGarmentState initialState, this.repo):super(initialState){
    on<GetOneGarmentEvent>((event, emit) async {
      emit(ReadOneGarmentLoading());
      GarmentModel? garment = await repo.getOneGarment(event.garmentID);
      if (garment != null){
        emit(ReadOneGarmentSuccess(garment: garment));
      }
      else {
        emit(ReadOneGarmentError(message: "Unable to get one garment data"));
      }
    });
  }
}