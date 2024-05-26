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