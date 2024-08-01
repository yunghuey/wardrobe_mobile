import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_event.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';
import 'package:wardrobe_mobile/model/user.dart';
import 'package:wardrobe_mobile/repository/user_repo.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState>{
  UserRepository repo;
    UserProfileBloc(UserProfileState initialState, this.repo):super(initialState){
      on<StartLoadProfile>((event, emit) async {
        emit(UserProfileLoadingState());
        UserModel? isFound = await repo.getUser();
        if (isFound != null){
          emit(UserProfileLoadedState(user: isFound));
        }
        else {
          UserProfileErrorState(message: "Fail to load user profile");
        }
      });

      on<UpdateButtonPressed>((event, emit) async {
        emit(UserProfileUpdating());
        int isUpdated = await repo.updateUser(event.user);
        if (isUpdated == 1){
          emit(UserProfileUpdated());
        } else if (isUpdated == 2){
          emit(UserProfileErrorState(message: "Email already existed."));
          UserModel? isFound = await repo.getUser();
          if (isFound != null){
            emit(UserProfileLoadedState(user: isFound));
          }
        } else if (isUpdated == 3){
          emit(UserProfileErrorState(message: "Username already existed."));
          UserModel? isFound = await repo.getUser();
          if (isFound != null){
            emit(UserProfileLoadedState(user: isFound));
          }
        }
         else if (isUpdated == 0){
          emit(UserProfileErrorState(message: "Error in updating"));
          UserModel? isFound = await repo.getUser();
          if (isFound != null){
            emit(UserProfileLoadedState(user: isFound));
          }
        }
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(UserProfileUpdating());
      int status = await repo.resetPassword(event.old_password, event.new_password);
      if (status == 1){
        emit(PasswordUpdated());
      }
      else if (status == 2){
        emit(PasswordFailed(message: "The current password is wrong. Please try again."));
      }
      else if (status == 0){
        emit(PasswordFailed(message: "Error occurred in reseting password. Please try again."));
      }
    });
    }

}
