import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_event.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';

class UpdatePwdView extends StatefulWidget {
  const UpdatePwdView({super.key});

  @override
  State<UpdatePwdView> createState() => _UpdatePwdViewState();
}

class _UpdatePwdViewState extends State<UpdatePwdView> {
  late UserProfileBloc userBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

  bool viewCurrentPassword = true;
  bool viewNewPassword = true;
  bool viewRepeatPassword = true;
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserProfileBloc>(context);
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
      appBar: AppBar(title: Text('Reset Password')),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state){
          if (state is PasswordUpdated){
            final snackBar = SnackBar(content: Text("Successfully reset password"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context, true);
          }
          else if (state is PasswordFailed){
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                _currentPasswordField(),
                const SizedBox(height: 10.0),
                _newPasswordField(),
                const SizedBox(height: 10.0),
                _repeatPasswordField(),
                const SizedBox(height: 10.0),
                load,
                _submitButton(),
              ],),
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: currentController,
        obscureText: viewCurrentPassword,
        validator: (value){
          if (value == null || value.isEmpty){
            return "Please enter current password";
          }
          if (value.length < 8){
            return "Minimum 8 characters";
          }
          return null;
        },
        decoration: InputDecoration(
        hintText: 'Current password',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: Icon(viewCurrentPassword ? Icons.visibility_off_outlined :Icons.visibility),
          onPressed: ()=> setState(() {
            viewCurrentPassword = !viewCurrentPassword;
          }),
        )
      ),
      ),
    );
  }

  Widget _newPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: newController,
        obscureText: viewNewPassword,
        validator: (value){
          if (value == null || value.isEmpty){
            return "Please enter new password";
          }
          if (value.length < 8){
            return "Your password length needs to be minimum 8 characters.";
          }
          return null;
        },
        decoration: InputDecoration(
        hintText: 'New password',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: Icon(viewNewPassword ? Icons.visibility_off_outlined :Icons.visibility),
          onPressed: ()=> setState(() {
            viewNewPassword = !viewNewPassword;
          }),
      ),
      ),
    )
    );
  }

  Widget _repeatPasswordField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: repeatController,
        obscureText: viewRepeatPassword,
        validator: (value){
          if (value == null || value.isEmpty){
            return "Please enter new password again";
          }
          if (value.length < 8){
            return "Your password length needs to be minimum 8 characters.";
          }
          if (value != newController.text.trim()){
            return "The password needs to be same with confirm password";
          }
          return null;
        },
        decoration: InputDecoration(
        hintText: 'Reenter new password',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: IconButton(
          icon: Icon(viewRepeatPassword ? Icons.visibility_off_outlined : Icons.visibility),
          onPressed: ()=> setState(() {
            viewRepeatPassword = !viewRepeatPassword;
          }),
      ),
      ),
    )
    );
  }

  Widget _submitButton(){
    return Center(
      child: SizedBox(
        width: 400,
        height: 55,
        child: ElevatedButton(
          onPressed: () async{
            if(_formKey.currentState!.validate()){
              userBloc.add(UpdatePasswordEvent(old_password: currentController.text, new_password: newController.text));

            }
          },
          child: Text("Reset password",style: TextStyle(color: Color.fromARGB(255, 93, 63, 184))),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
          ),
        ),
      ),
    );
  }
}
