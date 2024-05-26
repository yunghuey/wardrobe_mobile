import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_state.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_event.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';
import 'package:wardrobe_mobile/model/user.dart';
import 'package:wardrobe_mobile/pages/auth/splashScreen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late UserProfileBloc userBloc;
  late LogoutBloc logoutbloc;

  late UserModel user;
  @override
  void initState() {
    super.initState();
    logoutbloc = BlocProvider.of<LogoutBloc>(context);
    userBloc = BlocProvider.of<UserProfileBloc>(context);

    refreshPage();
  }

  Future<void> refreshPage() async {
    logoutbloc.add(LogoutResetEvent());
    userBloc.add(StartLoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LogoutBloc, LogoutState>(
            listener: ((context, state) {
              if (state is LogoutSuccessState) {
                logoutbloc.add(LogoutResetEvent());
              }
              else if (state is LogoutFailState){
                final snackbar = SnackBar(content: Text('fail to logout'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }          
            })
          )
        ],
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _displayUser(),
                  _logoutButton()
                ]
              ),
            ),
          ),
        ),
      )

    );
  }

  Widget _displayUser(){
    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
      if(state is UserProfileLoadingState){
        return Center(child: CircularProgressIndicator(),);
      }
      else if (state is UserProfileLoadedState){
        user = state.user;
         return Text("Hello ${user.firstname} ${user.lastname}");
      } else if(state is UserProfileErrorState){
        final snackBar = SnackBar(content: Text(state.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return Container();
    },);
  }

  Widget _logoutButton(){
    return ElevatedButton(
      onPressed: () {
        // bloc to update status in db
        logoutbloc.add(LogoutButtonPressed());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SplashScreen()), (route) => false);
      }, 
      child: Text('Logout')
    );
  }
}