import 'package:equatable/equatable.dart';
import 'package:wardrobe_mobile/model/user.dart';

class LoginEvent extends Equatable{
  @override
  List<Object> get props => []; 
}

class LoginButtonPressed extends LoginEvent{
  UserModel user;
  LoginButtonPressed({required this.user});
}

class LoginButtonReset extends LoginEvent{}