import 'package:equatable/equatable.dart';

class CaptureMaterialEvent extends Equatable{
  @override
  List<Object> get props => []; 
} 

class SubmitMaterialImage extends CaptureMaterialEvent{
  String imageBytes;
  SubmitMaterialImage({required this.imageBytes});
}