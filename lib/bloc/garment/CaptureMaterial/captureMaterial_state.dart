import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:wardrobe_mobile/model/material.dart';

class CaptureMaterialState extends Equatable{
  @override
  List<Object> get props => [];
}

class CaptureMaterialInitState extends CaptureMaterialState{}

class ReadingMaterialLoading extends CaptureMaterialState {}

class CaptureMaterialSuccess extends CaptureMaterialState {
  final List<MaterialModel> materialList;
  CaptureMaterialSuccess({required this.materialList});
}

class CaptureMaterialFail extends CaptureMaterialState {
  final String message;
  CaptureMaterialFail({required this.message});
}

class CaptureMaterialEmpty extends CaptureMaterialState {}