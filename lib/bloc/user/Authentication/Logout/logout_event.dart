import 'package:equatable/equatable.dart';

class LogoutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LogoutResetEvent extends LogoutEvent { }

class LogoutButtonPressed extends LogoutEvent {
}