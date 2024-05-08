import 'package:equatable/equatable.dart';

class DeleteGarmentEvent extends Equatable{
  @override
  List<Object> get props => []; 
}

class DeleteButtonPressed extends DeleteGarmentEvent{
  String garmentID;
  DeleteButtonPressed({required this.garmentID});
}