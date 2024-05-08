// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/garment.dart';

class CreateGarmentEvent extends Equatable{
  @override
  List<Object> get props => []; 
}

class SubmitImageEvent extends CreateGarmentEvent{
  String imageBytes;
  SubmitImageEvent({required this.imageBytes});
}

class CreateButtonPressed extends CreateGarmentEvent{
    GarmentModel garment;
    CreateButtonPressed({required this.garment});
}