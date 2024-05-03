// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/creategarment_event.dart';
import 'package:wardrobe_mobile/bloc/creategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

class CreateGarmentBloc extends Bloc<CreateGarmentEvent,CreateGarmentState>{
  GarmentRepository repo;
  CreateGarmentBloc(CreateGarmentState initialState, this.repo): super(initialState){
    on<CreateButtonPressed>((event, emit) async {
      emit(CreateGarmentLoadingState());

      bool isCreated = await repo.createGarment(event.garment);
      print('back from create');
      if (isCreated){
        emit(CreateGarmentSuccessState());
        print('create garment success');
      }
      else{
        emit(CreateGarmentFailState(message: "Server error causing unable to detect. Please fill in the details yourself."));
      }
    }); 
    
    on<SubmitImageEvent>((event, emit) async {
      emit(DetectGarmentLoadingState());
      GarmentModel? hasResult = await repo.processGarment(event.imageBytes);
      print('bloc success');
      print(hasResult);
      // String? hasResult = await repo.processGarment(event.imageBytes);
      if (hasResult != null){
        emit(DetectGarmentSuccessState(result:hasResult));
        print('this is not null');
      } else{
        print('this is null');
        emit(DetectGarmentFailState(message: "Unable to detect image. Do you want to fill in yourself or retake?"));
      }
    });
  
    on<CreateGarmentInitEvent>((event, emit) {
      emit(CreateGarmentInitState());
    });
  }
}