import 'package:equatable/equatable.dart';

class OneGarmentEvent extends Equatable{
  @override
  List<Object> get props => []; 
}

class GetOneGarmentEvent extends OneGarmentEvent {
  final String garmentID;
  GetOneGarmentEvent({required this.garmentID});
}