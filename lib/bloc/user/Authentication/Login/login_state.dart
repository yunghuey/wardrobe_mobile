import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  @override
  List<Object> get props => [];
}

class LoginInitState extends LoginState{}

class LoginLoading extends LoginState {}

class LoginSuccessState extends LoginState {}

class UsernameErrorState extends LoginState {
  final String message;
  UsernameErrorState({required this.message});
}

class PasswordErrorState extends LoginState {
  final String message;
  PasswordErrorState({required this.message});
}

class LoginErrorState extends LoginState {
  final String message;
  LoginErrorState({required this.message});
}



