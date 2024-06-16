import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_event.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';
import 'package:wardrobe_mobile/model/user.dart';

class UserUpdateView extends StatefulWidget {
  const UserUpdateView({super.key});

  @override
  State<UserUpdateView> createState() => _UserUpdateViewState();
}

class _UserUpdateViewState extends State<UserUpdateView> {
  late UserProfileBloc userBloc;
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserProfileBloc>(context);
    userBloc.add(StartLoadProfile());
  }

  final load = BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state){
    if (state is UserProfileLoadingState){
      return CircularProgressIndicator();
    }
    return Container();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener:(context, state) 
        {
          if (state is UserProfileUpdated){
            final snackBar = SnackBar(content: Text("Successfully updated profile"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context, true);
          }
          else if (state is UserProfileErrorState){
            final snackBar = SnackBar(content: Text("Unable to update profile. Please try again later."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar); 
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: 
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state){
                // if (state is UserProfileErrorState){
                //   return Center(child: Text(state.message),);
                // }
                // else
                 if (state is UserProfileLoadedState){
                  user = state.user;
                  emailController.text=user.email!;
                  usernameController.text=user.username;
                  firstnameController.text=user.firstname! ?? "";
                  lastnameController.text = user.lastname! ?? "";
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _usernameField(),
                        const SizedBox(height: 10.0),
                        _emailField(),
                        const SizedBox(height: 10.0),
                        _firstnameField(),
                        const SizedBox(height: 10.0),
                        _lastnameField(),
                        const SizedBox(height: 10.0),
                        load,
                        _submitButton(),
                      ],
                    ),
                  );
                }
                return Container();
            }
          ),
          ),
        ),
      )
    );
  }

  Widget _usernameField(){
    return TextFormField(
      controller: usernameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter username";
        }
        if (value.trim().contains(' ')){
          List<String> words = value.split(' ');
          if (words.length > 1){
            return "Username cannot contain whitespace";
          }
        }
      },
      decoration: InputDecoration(
        hintText: 'Username',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _emailField(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter email";
        }
        if (!value.trim().contains('@')){
            return 'Email is not completed';
          }
          return null;
      },
      decoration: InputDecoration(
        hintText: 'Email',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _firstnameField(){
    return TextFormField(
      controller: firstnameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter first name";
        }
      },
      decoration: InputDecoration(
        hintText: 'First name',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  } 

  Widget _lastnameField(){
    return TextFormField(
      controller: lastnameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter last name";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Last name',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

    Widget _submitButton(){
    return Center(
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()){
              UserModel user = UserModel(
                username: usernameController.text.trim(),
                email: emailController.text.trim(),
                firstname: firstnameController.text.trim(),
                lastname: lastnameController.text.trim(),
              );
              userBloc.add(UpdateButtonPressed(user: user));
            }
          },
          child: Text('Update', style: TextStyle(color: Color.fromARGB(255, 93, 63, 184))),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
          ),
        ),
      ),
    );
  }
}