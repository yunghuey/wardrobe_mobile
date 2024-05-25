import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_state.dart';
import 'package:wardrobe_mobile/repository/user_repo.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  UserRepository repo;
  RegisterBloc(RegisterState initialState, this.repo): super(initialState){
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      int validRegister = await  repo.registerUser(event.user);
      if(validRegister == 1){
        emit(RegisterSuccess());
      }
      else if (validRegister == 2){
        emit(EmailFailState());
      }
      else if (validRegister == 3){
        emit(UsernameFailState());
      }
      else {
        emit(RegisterFailState(message: "Fail to register"));
      }
    });
  }

}