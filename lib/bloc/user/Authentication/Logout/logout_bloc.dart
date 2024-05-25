
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_state.dart';
import 'package:wardrobe_mobile/repository/user_repo.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState>{
  UserRepository repo;
  LogoutBloc(LogoutState initialState, this.repo): super(initialState){
    on<LogoutButtonPressed>((event, emit) async{
      bool isLogout = await repo.logoutUser();
      if(isLogout){
        emit(LogoutSuccessState());
      } else {
        emit(LogoutFailState());
      }
    });

    on<LogoutResetEvent>((event, emit) async {
      emit(LogoutInitState());
    });
  }
}