import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_state.dart';
import 'package:wardrobe_mobile/repository/user_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  UserRepository repo;
  LoginBloc(LoginState initialState, this.repo):super(initialState){
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      int result = await repo.loginUser(event.user);
      if(result == 1){
        emit(LoginSuccessState());
      }
      else if (result == 2){
        emit(UsernameErrorState(message: "Username is incorrect"));
      }
      else if (result == 3){
        emit(PasswordErrorState(message: "Password incorrect"));
      }
      else {
        emit(LoginErrorState(message: "Login fail"));
      }
    });
  }


}
