import 'package:flutter/material.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_event.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';

class UserUpdateView extends StatefulWidget {
  const UserUpdateView({super.key});

  @override
  State<UserUpdateView> createState() => _UserUpdateViewState();
}

class _UserUpdateViewState extends State<UserUpdateView> {
  late UserProfileBloc userBloc;
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserProfileBloc>(context);
    userBloc.add(StartLoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit user')),
      body: Container(
        // child: BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state){}),
      )
    );
  }
}