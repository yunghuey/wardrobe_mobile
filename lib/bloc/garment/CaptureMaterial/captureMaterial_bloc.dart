import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_state.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';


class CaptureMaterialBloc extends Bloc<CaptureMaterialEvent, CaptureMaterialState>{
  GarmentRepository repo;
  CaptureMaterialBloc(CaptureMaterialState initialState, this.repo):super(initialState){
    on<SubmitMaterialImage>((event, emit) async{
      try{
        emit(ReadingMaterialLoading());
  
        List<MaterialModel> materials = await repo.getMaterialList(event.imageBytes);
        if (materials != []){
          print("material list not null");
          emit(CaptureMaterialSuccess(materialList: materials));
        }
        else {
          emit(CaptureMaterialEmpty());
        }
      }
      catch (e){
        emit(CaptureMaterialFail(message: e.toString()));
      }
    });
  }

}