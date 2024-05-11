import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_state.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

class UpdateGarmentBloc extends Bloc<UpdateGarmentEvent, UpdateGarmentState>{
  GarmentRepository repo;
  UpdateGarmentBloc(UpdateGarmentState initialState,this.repo):super(initialState){
    on<UpdateButtonPressed>((event, emit) async {
      emit(UpdateGarmentLoading());
      bool isUpdated = await repo.updateGarment(event.garment);
      if (isUpdated){
        emit(UpdateGarmentSuccess());
      }
      else {
        emit(UpdateGarmentFail(message: "Unable to update"));
      }
    });
  
  }

}