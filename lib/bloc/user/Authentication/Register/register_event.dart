import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/user.dart';

class RegisterEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent{
  UserModel user;
  RegisterButtonPressed({required this.user});
}