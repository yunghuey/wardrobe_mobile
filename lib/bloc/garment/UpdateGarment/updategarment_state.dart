import 'package:equatable/equatable.dart';

class UpdateGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateGarmentInitState extends UpdateGarmentState {}

class UpdateGarmentLoading extends UpdateGarmentState {}

class UpdateGarmentSuccess extends UpdateGarmentState {}

class UpdateGarmentFail extends UpdateGarmentState{
  final String message;
  UpdateGarmentFail({required this.message});
}