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
        bool isUpdated = await repo.updateUser(event.user);
        if (isUpdated){
          emit(UserProfileUpdated());
        } else{
          emit(UserProfileErrorState(message: "Error in updating"));
        }
    });
    }

}
