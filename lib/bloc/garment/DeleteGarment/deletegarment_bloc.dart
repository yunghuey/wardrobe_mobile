import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_state.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

class DeleteGarmentBloc extends Bloc<DeleteGarmentEvent, DeleteGarmentState>{
  GarmentRepository repo;
  DeleteGarmentBloc(DeleteGarmentState initialState,this.repo):super(initialState){
    on<DeleteButtonPressed>((event, emit) async {
      emit(DeleteGarmentLoading());
      bool isDeleted = await repo.deleteGarment(event.garmentID);
      if (isDeleted){
        emit(DeleteGarmentSuccess());
      }
      else{
        emit(DeleteGarmentFail(message: 'Unable delete this garment'));
      }

    });
  }
}