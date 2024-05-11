import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class UpdateGarmentEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateButtonPressed extends UpdateGarmentEvent{
  final GarmentModel garment;
  UpdateButtonPressed({required this.garment});
}