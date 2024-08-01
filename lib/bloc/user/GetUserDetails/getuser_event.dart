import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/user.dart';

class UserProfileEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartLoadProfile extends UserProfileEvent {}


class UpdateButtonPressed extends UserProfileEvent {
  UserModel user;
  UpdateButtonPressed({ required this.user });
}

class UpdatePasswordEvent extends UserProfileEvent{
  String old_password;
  String new_password;
  UpdatePasswordEvent({required this.old_password, required this.new_password});
}