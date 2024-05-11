import 'package:equatable/equatable.dart';

class DeleteGarmentState extends Equatable{
  @override
  List<Object> get props => [];
}

class DeleteGarmentInitState extends DeleteGarmentState {}

class DeleteGarmentLoading extends DeleteGarmentState {}

class DeleteGarmentSuccess extends DeleteGarmentState{}

class DeleteGarmentFail extends DeleteGarmentState{
  final String message;
  DeleteGarmentFail({required this.message});
}